/**
 *Submitted for verification at Etherscan.io on 2020-05-20
*/

pragma solidity ^0.4.26;


contract LockMapping {

  Receipt[] public receipts;
  uint256 public receiptCount;

	struct Receipt {

		address asset;
	    address owner;		//owner of this receipt
	    string targetAddress;
	    uint256 amount;
	    uint256 startTime;
	    uint256 endTime;
	    bool finished;

  	}
}

contract Owned {
    address public owner;
    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public{
        owner = msg.sender;
    }

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}


contract MerkleTreeGenerator is Owned {

    using SafeMath for uint256;
	event Log(bytes data);

	LockMapping candyReceipt = LockMapping(0x91517330816D4727EDc7C3F5Ae4CC5beF02Ec70f);

	uint256 constant pathMaximalLength = 7;
	uint256 constant public MerkleTreeMaximalLeafCount = 1 << pathMaximalLength;
	uint256 constant treeMaximalSize = MerkleTreeMaximalLeafCount * 2;
	uint256 public MerkleTreeCount = 0;
	uint256 public ReceiptCountInTree = 0;
	mapping (uint256 => MerkleTree) indexToMerkleTree;

	struct MerkleTree {
		bytes32 root;
		uint256 leaf_count;
        uint256 first_recipt_id;
        uint256 size;
  	}

  	struct MerkleNode {

		bytes32 hash;
		bool is_left_child_node;

  	}

  	struct MerklePath {
  	    MerkleNode[] merkle_path_nodes;
  	}

  	struct Receipt {

		  address asset;		
	    address owner;		
	    string targetAddress;
	    uint256 amount;
	    uint256 startTime;
	    uint256 endTime;
	    bool finished;

  	}



  	//fetch receipts
  	function ReceiptsToLeaves(uint256 _start, uint256 _leafCount, bool _event) internal returns (bytes32[]){
  	    bytes32[] memory leaves = new bytes32[](_leafCount);

		for(uint256 i = _start; i< _start + _leafCount; i++) {
            (
    		    ,
    		    ,
    		    string memory targetAddress,
    		    uint256 amount,
    		    ,
    		    ,
    		    bool finished
		    ) = candyReceipt.receipts(i);


		    bytes32 amountHash = sha256(amount);
		    bytes32 targetAddressHash = sha256(targetAddress);
		    bytes32 receiptIdHash = sha256(i);

		    leaves[i - _start] = (sha256(amountHash, targetAddressHash, receiptIdHash));

		    if(_event)
		        Log(abi.encodePacked(amountHash, targetAddressHash, receiptIdHash));
        }

        return leaves;
  	}

  	 	//create new receipt
	function GenerateMerkleTree() external onlyOwner {

        uint256 receiptCount = candyReceipt.receiptCount() - ReceiptCountInTree;

		require(receiptCount > 0);

		uint256 leafCount = receiptCount < MerkleTreeMaximalLeafCount ? receiptCount : MerkleTreeMaximalLeafCount;
        bytes32[] memory leafNodes = ReceiptsToLeaves(ReceiptCountInTree, leafCount, true);


        bytes32[treeMaximalSize] memory allNodes;
  	    uint256 nodeCount;

  	    (allNodes, nodeCount) = LeavesToTree(leafNodes);

		MerkleTree memory merkleTree = MerkleTree(allNodes[nodeCount - 1], leafCount, ReceiptCountInTree, nodeCount);

		indexToMerkleTree[MerkleTreeCount] = merkleTree;
		ReceiptCountInTree = ReceiptCountInTree + leafCount;
		MerkleTreeCount = MerkleTreeCount + 1;
  	}

  	//get users merkle tree path
  	function GenerateMerklePath(uint256 receiptId) public view returns(uint256, uint256, bytes32[pathMaximalLength], bool[pathMaximalLength]) {

  	    require(receiptId < ReceiptCountInTree);
  	    uint256 treeIndex = MerkleTreeCount - 1;
  	    for (; treeIndex >= 0 ; treeIndex--){

  	        if (receiptId >= indexToMerkleTree[treeIndex].first_recipt_id)
  	            break;
  	    }

  	    bytes32[pathMaximalLength] memory neighbors;
  	    bool[pathMaximalLength] memory isLeftNeighbors;
  	    uint256 pathLength;

  	    MerkleTree merkleTree = indexToMerkleTree[treeIndex];
  	    uint256 index = receiptId - merkleTree.first_recipt_id;
  	    (pathLength, neighbors, isLeftNeighbors) = GetPath(merkleTree, index);
  	    return (treeIndex, pathLength, neighbors, isLeftNeighbors);

  	}

  	function LeavesToTree(bytes32[] _leaves) internal returns (bytes32[treeMaximalSize], uint256){
        uint256 leafCount = _leaves.length;
		bytes32 left;
		bytes32 right;

        uint256 newAdded = 0;
		uint256 i = 0;

		bytes32[treeMaximalSize] memory nodes;

		for (uint256 t = 0; t < leafCount ; t++)
		{
		    nodes[t] = _leaves[t];
		}

		uint256 nodeCount = leafCount;
        if(_leaves.length % 2 == 1) {
            nodes[leafCount] = (_leaves[leafCount - 1]);
            nodeCount = nodeCount + 1;
        }


        // uint256 nodeToAdd = nodes.length / 2;
        uint256 nodeToAdd = nodeCount / 2;

		while( i < nodeCount - 1) {

		    left = nodes[i++];
            right = nodes[i++];
            nodes[nodeCount++] = sha256(left,right);
            if (++newAdded != nodeToAdd)
                continue;

            if (nodeToAdd % 2 == 1 && nodeToAdd != 1)
            {
                nodeToAdd++;
                nodes[nodeCount] = nodes[nodeCount - 1];
                nodeCount++;
            }

            nodeToAdd /= 2;
            newAdded = 0;
		}

		return (nodes, nodeCount);
  	}

  	function GetPath(MerkleTree _merkleTree, uint256 _index) internal returns(uint256, bytes32[pathMaximalLength],bool[pathMaximalLength]){

  	    bytes32[] memory leaves = ReceiptsToLeaves(_merkleTree.first_recipt_id, _merkleTree.leaf_count, false);
  	    bytes32[treeMaximalSize] memory allNodes;
  	    uint256 nodeCount;

  	    (allNodes, nodeCount)= LeavesToTree(leaves);
  	    require(nodeCount == _merkleTree.size);

  	    bytes32[] memory nodes = new bytes32[](_merkleTree.size);
  	    for (uint256 t = 0; t < _merkleTree.size; t++){
  	        nodes[t] = allNodes[t];
  	    }

  	    return GeneratePath(nodes, _merkleTree.leaf_count, _index);
  	}

  	function GeneratePath(bytes32[] _nodes, uint256 _leafCount, uint256 _index) internal returns(uint256, bytes32[pathMaximalLength],bool[pathMaximalLength]){
  	    bytes32[pathMaximalLength] memory neighbors;
  	    bool[pathMaximalLength] memory isLeftNeighbors;
  	    uint256 indexOfFirstNodeInRow = 0;
  	    uint256 nodeCountInRow = _leafCount;
  	    bytes32 neighbor;
  	    bool isLeftNeighbor;
  	    uint256 shift;
  	    uint256 i = 0;

  	    while (_index < _nodes.length - 1) {

            if (_index % 2 == 0)
            {
                // add right neighbor node
                neighbor = _nodes[_index + 1];
                isLeftNeighbor = false;
            }
            else
            {
                // add left neighbor node
                neighbor = _nodes[_index - 1];
                isLeftNeighbor = true;
            }

            neighbors[i] = neighbor;
            isLeftNeighbors[i++] = isLeftNeighbor;

            nodeCountInRow = nodeCountInRow % 2 == 0 ? nodeCountInRow : nodeCountInRow + 1;
            shift = (_index - indexOfFirstNodeInRow) / 2;
            indexOfFirstNodeInRow += nodeCountInRow;
            _index = indexOfFirstNodeInRow + shift;
            nodeCountInRow /= 2;

  	    }

  	    return (i, neighbors,isLeftNeighbors);
  	}

    function GetMerkleTreeNodes(uint256 treeIndex) public view returns (bytes32[], uint256){
        MerkleTree merkleTree = indexToMerkleTree[treeIndex];
  	    bytes32[] memory leaves = ReceiptsToLeaves(merkleTree.first_recipt_id, merkleTree.leaf_count, false);
  	    bytes32[treeMaximalSize] memory allNodes;
  	    uint256 nodeCount;

  	    (allNodes, nodeCount)= LeavesToTree(leaves);
  	    require(nodeCount == merkleTree.size);

  	    bytes32[] memory nodes = new bytes32[](merkleTree.size);
  	    for (uint256 t = 0; t < merkleTree.size; t++){
  	        nodes[t] = allNodes[t];
  	    }
        return (nodes, merkleTree.leaf_count);
    }

    function GetMerkleTree(uint256 treeIndex) public view returns (bytes32, uint256, uint256, uint256){
        require(treeIndex < MerkleTreeCount);
        MerkleTree merkleTree = indexToMerkleTree[treeIndex];
        return (merkleTree.root, merkleTree.first_recipt_id, merkleTree.leaf_count, merkleTree.size);
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}