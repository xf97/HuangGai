/**
 *Submitted for verification at Etherscan.io on 2020-05-10
*/

pragma solidity 0.5.14;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IToken { // brief ERC-20 interface
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract LXCHAT is Ownable { // perma post with lexDAO legal engineers & apprentices
    address public accessToken = 0xAF0348b2A3818BD6Bc1f12bd2a9f73F1B725448F;
    address public leethToken = 0x4D9D9a22458dD84dB8B0D074470f5d9536116eC5;
    IToken private token = IToken(accessToken);
    IToken private leeth = IToken(leethToken);
    uint256 public posts;
    string public redemptionOffer;
    
    mapping (uint256 => post) public postings; 
    
    event LexPosting(uint256 indexed index, string indexed details);
    event Offering(string indexed details);
    event Posting(uint256 indexed index, string indexed details);
    event Redemption(string indexed details, string indexed redemptionOffer);
    
    struct post {
        address poster;
        uint256 index;
        string details;
        string response;
    }
    
    // accessToken holder functions
    function newPost(string memory details) public { // accessToken holder (>= 1) can always write to contract
        require(token.balanceOf(_msgSender()) >= 1000000000000000000, "accessToken balance insufficient");
            uint256 index = posts + 1; 
            posts = posts + 1;
            
            postings[index] = post(
                _msgSender(),
                index,
                details,
                "");
        
        emit Posting(index, details);
    } 
    
    function redeemOffer(string memory details) public { // accessToken holder can deposit (1) to redeem current offer 
        token.transferFrom(_msgSender(), address(this), 1000000000000000000);
        emit Redemption(details, redemptionOffer);
    }
    
    function updatePost(uint256 index, string memory details) public { // accessToken holder can always update posts
        post storage p = postings[index];
        require(_msgSender() == p.poster, "must be indexed poster");
        p.details = details;
        emit Posting(index, details);
    }

    // lexDAO functions
    function lexPost(uint256 index, string memory details) public { // leethToken holder (5) can always write responses to posts
        require(leeth.balanceOf(_msgSender()) >= 5000000000000000000, "leeth balance insufficient");
        post storage p = postings[index];
        p.response = details;
        emit LexPosting(index, details);
    }
    
    function updateRedemptionOffer(string memory details) public onlyOwner { // owner can update redemption offer for accessToken
        redemptionOffer = details;
        emit Offering(details);
    }
    
    function withdraw() public onlyOwner { // owner can withdraw redeemed accessToken
        token.transfer(_msgSender(), token.balanceOf(address(this)));
    }
}