// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "./SafeMath.sol";

contract OSnap {
    using SafeMath for uint256;

    // IPFS / Filecoin Reference
    struct Multihash {
        bytes32 digest;
        uint8 hashFunction;
        uint8 size;
    }

    // Emits when a new post is added
    event Post(
        uint256 indexed postID,
        address indexed postedBy,
        uint256 tipAPostID,
        uint256 tipAAmt,
        uint256 tipBPostID,
        uint256 tipBAmt,
        bytes32 digest,
        uint8 hashFunction,
        uint8 size
    );

    // Internal datastore.
    mapping(uint256 => Multihash) private posts;
    mapping(uint256 => address payable) private payableByPostID;
    mapping(address => uint256[]) private postsByAddress;

    // Global postID increments after each posting.
    uint256 private postID = 0;

    // Used to bootstap tangle.
    address payable private _bootstapAddr;

    constructor() public {
        _bootstapAddr = msg.sender;
    }

    /* Returns the current postID */
    function getPostID() public view returns (uint256 id) {
        return postID;
    }

    /* Returns a post multihash by postID reference. */
    function getPostById(uint256 _id)
        public
        view
        returns (
            bytes32 digest,
            uint8 hashFunction,
            uint8 size
        )
    {
        // Require valid post identifier.
        require(_id < postID, "Post not found.");

        // Return post multihash.
        Multihash storage post = posts[_id];
        return (post.digest, post.hashFunction, post.size);
    }

    /* Returns a post ID by address:idx reference. */
    function getPostIDByAddressIdx(address _addr, uint256 _idx)
        public
        view
        returns (uint256 id)
    {
        // Require valid post address & index.
        require(postsByAddress[_addr].length > 0, "Address not found.");
        require(_idx < postsByAddress[_addr].length, "Post not found.");

        // Return post ID.
        return postsByAddress[_addr][_idx];
    }

    /* Returns the number of multihashes posted by an address. */
    function getTotalPostsByAddress(address _addr)
        public
        view
        returns (uint256 length)
    {
        return postsByAddress[_addr].length;
    }

    /* Returns the original poster by postID */
    function getOPByID(uint256 _postID)
        public
        view
        returns (address payable poster)
    {
        return payableByPostID[_postID];
    }

    function _addTip(uint256 _postID, uint256 _tip) private {
        // Validate tip transaction.
        require(_tip > 0, "Missing tip value.");
        require(
            msg.sender == _bootstapAddr || (_postID < postID),
            "Post not found."
        );
        require(
            msg.sender == _bootstapAddr ||
                (payableByPostID[_postID] != msg.sender),
            "Self-tipping is discouraged."
        );

        // Process tip.
        payableByPostID[_postID].transfer(_tip);
    }

    /* Adds a tip. */
    function addTip(uint256 _postID) public payable {
        _addTip(_postID, msg.value);
    }

    /* Adds a new post to the tangle. */
    function addPost(
        uint256 _tipAPostId,
        uint256 _tipAAmt,
        uint256 _tipBPostId,
        uint256 _tipBAmt,
        bytes32 _digest,
        uint8 _hashFunction,
        uint8 _size
    ) public payable returns (uint256 id) {
        // Validate tip tangle amounts.
        require(
            _tipAAmt + _tipBAmt == msg.value,
            "Tips should equal message value."
        );

        // Add tips to tangle.
        _addTip(_tipAPostId, _tipAAmt);
        _addTip(_tipBPostId, _tipBAmt);

        // Construct the multihash object.
        Multihash memory post = Multihash(_digest, _hashFunction, _size);

        // Assign the postID and append it to the postsByAddress list.
        posts[postID] = post;
        postsByAddress[msg.sender].push(postID);
        payableByPostID[postID] = msg.sender;

        // Emit the Post event.
        emit Post(
            postID,
            msg.sender,
            _tipAPostId,
            _tipAAmt,
            _tipBPostId,
            _tipBAmt,
            _digest,
            _hashFunction,
            _size
        );

        // Increment the postID and return its value.
        return postID++;
    }
}
