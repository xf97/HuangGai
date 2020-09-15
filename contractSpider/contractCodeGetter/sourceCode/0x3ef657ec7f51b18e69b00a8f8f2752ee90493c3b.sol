/**
 *Submitted for verification at Etherscan.io on 2020-07-20
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

// SPDX-License-Identifier: MIT

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
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
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
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @title EIP1154 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-1154
 */
interface IOracleConsumer {
	function receiveResult(bytes32, bytes calldata)
		external;
}

interface IOracle {
	function resultFor(bytes32)
		external view returns (bytes memory);
}

interface IERC2362 {
  function valueFor(bytes32 _id) external view returns(int256,uint256,uint256);
}

interface IOwnable {
	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	function owner() external view returns (address);
	function renounceOwnership() external;
	function transferOwnership(address) external;
}

library IexecLibCore_v5 {
	/**
	* Tools
	*/
	struct Account
	{
		uint256 stake;
		uint256 locked;
	}
	struct Category
	{
		string  name;
		string  description;
		uint256 workClockTimeRef;
	}

	/**
	 * Clerk - Deals
	 */
	struct Resource
	{
		address pointer;
		address owner;
		uint256 price;
	}
	struct Deal
	{
		// Ressources
		Resource app;
		Resource dataset;
		Resource workerpool;
		uint256 trust;
		uint256 category;
		bytes32 tag;
		// execution details
		address requester;
		address beneficiary;
		address callback;
		string  params;
		// execution settings
		uint256 startTime;
		uint256 botFirst;
		uint256 botSize;
		// consistency
		uint256 workerStake;
		uint256 schedulerRewardRatio;
	}

	/**
	 * Tasks
	 */
	enum TaskStatusEnum
	{
		UNSET,     // Work order not yet initialized (invalid address)
		ACTIVE,    // Marketed → constributions are open
		REVEALING, // Starting consensus reveal
		COMPLETED, // Consensus achieved
		FAILED     // Failed consensus
	}
	struct Task
	{
		TaskStatusEnum status;
		bytes32   dealid;
		uint256   idx;
		uint256   timeref;
		uint256   contributionDeadline;
		uint256   revealDeadline;
		uint256   finalDeadline;
		bytes32   consensusValue;
		uint256   revealCounter;
		uint256   winnerCounter;
		address[] contributors;
		bytes32   resultDigest;
		bytes     results;
		uint256   resultsTimestamp;
		bytes     resultsCallback; // Expansion - result separation
	}

	/**
	 * Consensus
	 */
	struct Consensus
	{
		mapping(bytes32 => uint256) group;
		uint256                     total;
	}

	/**
	 * Consensus
	 */
	enum ContributionStatusEnum
	{
		UNSET,
		CONTRIBUTED,
		PROVED,
		REJECTED
	}
	struct Contribution
	{
		ContributionStatusEnum status;
		bytes32 resultHash;
		bytes32 resultSeal;
		address enclaveChallenge;
		uint256 weight;
	}

}

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
      * @dev Safely transfers `tokenId` token from `from` to `to`.
      *
      * Requirements:
      *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
      * - `tokenId` token must exist and be owned by `from`.
      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
      *
      * Emits a {Transfer} event.
      */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}


/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Enumerable is IERC721 {

    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256);
}

abstract contract IRegistry is IERC721Enumerable
{
	function isRegistered(address _entry) external virtual view returns (bool);
}

interface IexecAccessors is IOracle
{
	function name() external view returns (string memory);
	function symbol() external view returns (string memory);
	function decimals() external view returns (uint8);
	function totalSupply() external view returns (uint256);
	function balanceOf(address) external view returns (uint256);
	function frozenOf(address) external view returns (uint256);
	function allowance(address,address) external view returns (uint256);
	function viewAccount(address) external view returns (IexecLibCore_v5.Account memory);
	function token() external view returns (address);
	function viewDeal(bytes32) external view returns (IexecLibCore_v5.Deal memory);
	function viewConsumed(bytes32) external view returns (uint256);
	function viewPresigned(bytes32) external view returns (address);
	function viewTask(bytes32) external view returns (IexecLibCore_v5.Task memory);
	function viewContribution(bytes32,address) external view returns (IexecLibCore_v5.Contribution memory);
	function viewScore(address) external view returns (uint256);
	// function resultFor(bytes32) external view returns (bytes memory); // Already part of IOracle
	function viewCategory(uint256) external view returns (IexecLibCore_v5.Category memory);
	function countCategory() external view returns (uint256);

	function appregistry() external view returns (IRegistry);
	function datasetregistry() external view returns (IRegistry);
	function workerpoolregistry() external view returns (IRegistry);
	function teebroker() external view returns (address);
	function callbackgas() external view returns (uint256);

	function contribution_deadline_ratio() external view returns (uint256);
	function reveal_deadline_ratio() external view returns (uint256);
	function final_deadline_ratio() external view returns (uint256);
	function workerpool_stake_ratio() external view returns (uint256);
	function kitty_ratio() external view returns (uint256);
	function kitty_min() external view returns (uint256);
	function kitty_address() external view returns (address);
	function groupmember_purpose() external view returns (uint256);
	function eip712domain_separator() external view returns (bytes32);
}

interface IexecCategoryManager {
	event CreateCategory(uint256 catid, string  name, string  description, uint256 workClockTimeRef);

	function createCategory(string calldata,string calldata,uint256) external returns (uint256);
}

interface IexecERC20 {
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);

	function transfer(address,uint256) external returns (bool);
	function approve(address,uint256) external returns (bool);
	function transferFrom(address,address,uint256) external returns (bool);
	function increaseAllowance(address,uint256) external returns (bool);
	function decreaseAllowance(address,uint256) external returns (bool);
	function approveAndCall(address,uint256,bytes calldata) external returns (bool);
}

interface IexecEscrowToken {
	receive() external payable;
	function deposit(uint256) external returns (bool);
	function depositFor(uint256,address) external returns (bool);
	function depositForArray(uint256[] calldata,address[] calldata) external returns (bool);
	function withdraw(uint256) external returns (bool);
	function recover() external returns (uint256);
}

library IexecLibOrders_v5 {
	// bytes32 public constant             EIP712DOMAIN_TYPEHASH = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)');
	// bytes32 public constant                 APPORDER_TYPEHASH = keccak256('AppOrder(address app,uint256 appprice,uint256 volume,bytes32 tag,address datasetrestrict,address workerpoolrestrict,address requesterrestrict,bytes32 salt)');
	// bytes32 public constant             DATASETORDER_TYPEHASH = keccak256('DatasetOrder(address dataset,uint256 datasetprice,uint256 volume,bytes32 tag,address apprestrict,address workerpoolrestrict,address requesterrestrict,bytes32 salt)');
	// bytes32 public constant          WORKERPOOLORDER_TYPEHASH = keccak256('WorkerpoolOrder(address workerpool,uint256 workerpoolprice,uint256 volume,bytes32 tag,uint256 category,uint256 trust,address apprestrict,address datasetrestrict,address requesterrestrict,bytes32 salt)');
	// bytes32 public constant             REQUESTORDER_TYPEHASH = keccak256('RequestOrder(address app,uint256 appmaxprice,address dataset,uint256 datasetmaxprice,address workerpool,uint256 workerpoolmaxprice,address requester,uint256 volume,bytes32 tag,uint256 category,uint256 trust,address beneficiary,address callback,string params,bytes32 salt)');
	// bytes32 public constant        APPORDEROPERATION_TYPEHASH = keccak256('AppOrderOperation(AppOrder order,uint256 operation)AppOrder(address app,uint256 appprice,uint256 volume,bytes32 tag,address datasetrestrict,address workerpoolrestrict,address requesterrestrict,bytes32 salt)');
	// bytes32 public constant    DATASETORDEROPERATION_TYPEHASH = keccak256('DatasetOrderOperation(DatasetOrder order,uint256 operation)DatasetOrder(address dataset,uint256 datasetprice,uint256 volume,bytes32 tag,address apprestrict,address workerpoolrestrict,address requesterrestrict,bytes32 salt)');
	// bytes32 public constant WORKERPOOLORDEROPERATION_TYPEHASH = keccak256('WorkerpoolOrderOperation(WorkerpoolOrder order,uint256 operation)WorkerpoolOrder(address workerpool,uint256 workerpoolprice,uint256 volume,bytes32 tag,uint256 category,uint256 trust,address apprestrict,address datasetrestrict,address requesterrestrict,bytes32 salt)');
	// bytes32 public constant    REQUESTORDEROPERATION_TYPEHASH = keccak256('RequestOrderOperation(RequestOrder order,uint256 operation)RequestOrder(address app,uint256 appmaxprice,address dataset,uint256 datasetmaxprice,address workerpool,uint256 workerpoolmaxprice,address requester,uint256 volume,bytes32 tag,uint256 category,uint256 trust,address beneficiary,address callback,string params,bytes32 salt)');
	bytes32 public constant             EIP712DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
	bytes32 public constant                 APPORDER_TYPEHASH = 0x60815a0eeec47dddf1615fe53b31d016c31444e01b9d796db365443a6445d008;
	bytes32 public constant             DATASETORDER_TYPEHASH = 0x6cfc932a5a3d22c4359295b9f433edff52b60703fa47690a04a83e40933dd47c;
	bytes32 public constant          WORKERPOOLORDER_TYPEHASH = 0xaa3429fb281b34691803133d3d978a75bb77c617ed6bc9aa162b9b30920022bb;
	bytes32 public constant             REQUESTORDER_TYPEHASH = 0xf24e853034a3a450aba845a82914fbb564ad85accca6cf62be112a154520fae0;
	bytes32 public constant        APPORDEROPERATION_TYPEHASH = 0x0638bb0702457e2b4b01be8a202579b8bf97e587fb4f2cc4d4aad01f21a06ee0;
	bytes32 public constant    DATASETORDEROPERATION_TYPEHASH = 0x075eb6f7578ff4292c241bd2484cd5c1d5e6ecc2ddd3317e1d8176b5a45865ec;
	bytes32 public constant WORKERPOOLORDEROPERATION_TYPEHASH = 0x322d980b7d7a6a1f7c39ff0c5445da6ae1d8e0393ff0dd468c8be3e2c8644388;
	bytes32 public constant    REQUESTORDEROPERATION_TYPEHASH = 0x0ded7b52c2d77595a40d242eca751df172b18e686326dbbed3f4748828af77c7;

	enum OrderOperationEnum
	{
		SIGN,
		CLOSE
	}

	struct EIP712Domain
	{
		string  name;
		string  version;
		uint256 chainId;
		address verifyingContract;
	}

	struct AppOrder
	{
		address app;
		uint256 appprice;
		uint256 volume;
		bytes32 tag;
		address datasetrestrict;
		address workerpoolrestrict;
		address requesterrestrict;
		bytes32 salt;
		bytes   sign;
	}

	struct DatasetOrder
	{
		address dataset;
		uint256 datasetprice;
		uint256 volume;
		bytes32 tag;
		address apprestrict;
		address workerpoolrestrict;
		address requesterrestrict;
		bytes32 salt;
		bytes   sign;
	}

	struct WorkerpoolOrder
	{
		address workerpool;
		uint256 workerpoolprice;
		uint256 volume;
		bytes32 tag;
		uint256 category;
		uint256 trust;
		address apprestrict;
		address datasetrestrict;
		address requesterrestrict;
		bytes32 salt;
		bytes   sign;
	}

	struct RequestOrder
	{
		address app;
		uint256 appmaxprice;
		address dataset;
		uint256 datasetmaxprice;
		address workerpool;
		uint256 workerpoolmaxprice;
		address requester;
		uint256 volume;
		bytes32 tag;
		uint256 category;
		uint256 trust;
		address beneficiary;
		address callback;
		string  params;
		bytes32 salt;
		bytes   sign;
	}

	struct AppOrderOperation
	{
		AppOrder           order;
		OrderOperationEnum operation;
		bytes              sign;
	}

	struct DatasetOrderOperation
	{
		DatasetOrder       order;
		OrderOperationEnum operation;
		bytes              sign;
	}

	struct WorkerpoolOrderOperation
	{
		WorkerpoolOrder    order;
		OrderOperationEnum operation;
		bytes              sign;
	}

	struct RequestOrderOperation
	{
		RequestOrder       order;
		OrderOperationEnum operation;
		bytes              sign;
	}

	function hash(EIP712Domain memory _domain)
	public pure returns (bytes32 domainhash)
	{
		/**
		 * Readeable but expensive
		 */
		return keccak256(abi.encode(
			EIP712DOMAIN_TYPEHASH
		,	keccak256(bytes(_domain.name))
		,	keccak256(bytes(_domain.version))
		,	_domain.chainId
		,	_domain.verifyingContract
		));
	}

	function hash(AppOrder memory _apporder)
	public pure returns (bytes32 apphash)
	{
		/**
		 * Readeable but expensive
		 */
		return keccak256(abi.encode(
			APPORDER_TYPEHASH
		,	_apporder.app
		,	_apporder.appprice
		,	_apporder.volume
		,	_apporder.tag
		,	_apporder.datasetrestrict
		,	_apporder.workerpoolrestrict
		,	_apporder.requesterrestrict
		,	_apporder.salt
		));
	}

	function hash(DatasetOrder memory _datasetorder)
	public pure returns (bytes32 datasethash)
	{
		/**
		 * Readeable but expensive
		 */
		return keccak256(abi.encode(
			DATASETORDER_TYPEHASH
		,	_datasetorder.dataset
		,	_datasetorder.datasetprice
		,	_datasetorder.volume
		,	_datasetorder.tag
		,	_datasetorder.apprestrict
		,	_datasetorder.workerpoolrestrict
		,	_datasetorder.requesterrestrict
		,	_datasetorder.salt
		));
	}

	function hash(WorkerpoolOrder memory _workerpoolorder)
	public pure returns (bytes32 workerpoolhash)
	{
		/**
		 * Readeable but expensive
		 */
		return keccak256(abi.encode(
			WORKERPOOLORDER_TYPEHASH
		,	_workerpoolorder.workerpool
		,	_workerpoolorder.workerpoolprice
		,	_workerpoolorder.volume
		,	_workerpoolorder.tag
		,	_workerpoolorder.category
		,	_workerpoolorder.trust
		,	_workerpoolorder.apprestrict
		,	_workerpoolorder.datasetrestrict
		,	_workerpoolorder.requesterrestrict
		,	_workerpoolorder.salt
		));
	}

	function hash(RequestOrder memory _requestorder)
	public pure returns (bytes32 requesthash)
	{
		/**
		 * Readeable but expensive
		 */
		return keccak256(abi.encodePacked(
			abi.encode(
				REQUESTORDER_TYPEHASH
			,	_requestorder.app
			,	_requestorder.appmaxprice
			,	_requestorder.dataset
			,	_requestorder.datasetmaxprice
			,	_requestorder.workerpool
			,	_requestorder.workerpoolmaxprice
			),
			abi.encode(
				_requestorder.requester
			,	_requestorder.volume
			,	_requestorder.tag
			,	_requestorder.category
			,	_requestorder.trust
			,	_requestorder.beneficiary
			,	_requestorder.callback
			,	keccak256(bytes(_requestorder.params))
			,	_requestorder.salt
			)
		));
	}

	function hash(AppOrderOperation memory _apporderoperation)
	public pure returns (bytes32)
	{
		return keccak256(abi.encode(
			APPORDEROPERATION_TYPEHASH
		,	hash(_apporderoperation.order)
		,	_apporderoperation.operation
		));
	}

	function hash(DatasetOrderOperation memory _datasetorderoperation)
	public pure returns (bytes32)
	{
		return keccak256(abi.encode(
			DATASETORDEROPERATION_TYPEHASH
		,	hash(_datasetorderoperation.order)
		,	_datasetorderoperation.operation
		));
	}

	function hash(WorkerpoolOrderOperation memory _workerpoolorderoperation)
	public pure returns (bytes32)
	{
		return keccak256(abi.encode(
			WORKERPOOLORDEROPERATION_TYPEHASH
		,	hash(_workerpoolorderoperation.order)
		,	_workerpoolorderoperation.operation
		));
	}

	function hash(RequestOrderOperation memory _requestorderoperation)
	public pure returns (bytes32)
	{
		return keccak256(abi.encode(
			REQUESTORDEROPERATION_TYPEHASH
		,	hash(_requestorderoperation.order)
		,	_requestorderoperation.operation
		));
	}
}

interface IexecMaintenance {
	function configure(address,string calldata,string calldata,uint8,address,address,address,address) external;
	function domain() external view returns (IexecLibOrders_v5.EIP712Domain memory);
	function updateDomainSeparator() external;
	function importScore(address) external;
	function setTeeBroker(address) external;
	function setCallbackGas(uint256) external;
}

interface IexecOrderManagement {
	event SignedAppOrder       (bytes32 appHash);
	event SignedDatasetOrder   (bytes32 datasetHash);
	event SignedWorkerpoolOrder(bytes32 workerpoolHash);
	event SignedRequestOrder   (bytes32 requestHash);
	event ClosedAppOrder       (bytes32 appHash);
	event ClosedDatasetOrder   (bytes32 datasetHash);
	event ClosedWorkerpoolOrder(bytes32 workerpoolHash);
	event ClosedRequestOrder   (bytes32 requestHash);

	function manageAppOrder       (IexecLibOrders_v5.AppOrderOperation        calldata) external;
	function manageDatasetOrder   (IexecLibOrders_v5.DatasetOrderOperation    calldata) external;
	function manageWorkerpoolOrder(IexecLibOrders_v5.WorkerpoolOrderOperation calldata) external;
	function manageRequestOrder   (IexecLibOrders_v5.RequestOrderOperation    calldata) external;
}

interface IexecPoco {
	event Reward  (address owner, uint256 amount, bytes32 ref);
	event Seize   (address owner, uint256 amount, bytes32 ref);
	event Lock    (address owner, uint256 amount);
	event Unlock  (address owner, uint256 amount);

	event OrdersMatched  (bytes32 dealid, bytes32 appHash, bytes32 datasetHash, bytes32 workerpoolHash, bytes32 requestHash, uint256 volume);
	event SchedulerNotice(address indexed workerpool, bytes32 dealid);

	event TaskInitialize(bytes32 indexed taskid, address indexed workerpool);
	event TaskContribute(bytes32 indexed taskid, address indexed worker, bytes32 hash);
	event TaskConsensus (bytes32 indexed taskid, bytes32 consensus);
	event TaskReveal    (bytes32 indexed taskid, address indexed worker, bytes32 digest);
	event TaskReopen    (bytes32 indexed taskid);
	event TaskFinalize  (bytes32 indexed taskid, bytes results);
	event TaskClaimed   (bytes32 indexed taskid);

	event AccurateContribution(address indexed worker, bytes32 indexed taskid);
	event FaultyContribution  (address indexed worker, bytes32 indexed taskid);

	function verifySignature(address,bytes32,bytes calldata) external view returns (bool);
	function verifyPresignature(address,bytes32) external view returns (bool);
	function verifyPresignatureOrSignature(address,bytes32,bytes calldata) external view returns (bool);
	function matchOrders(IexecLibOrders_v5.AppOrder calldata,IexecLibOrders_v5.DatasetOrder calldata,IexecLibOrders_v5.WorkerpoolOrder calldata,IexecLibOrders_v5.RequestOrder calldata) external returns (bytes32);
	function initialize(bytes32,uint256) external returns (bytes32);
	function contribute(bytes32,bytes32,bytes32,address,bytes calldata,bytes calldata) external;
	function reveal(bytes32,bytes32) external;
	function reopen(bytes32) external;
	function finalize(bytes32,bytes calldata,bytes calldata) external; // Expansion - result separation
	function claim(bytes32) external;
	function contributeAndFinalize(bytes32,bytes32,bytes calldata,bytes calldata,address,bytes calldata,bytes calldata) external; // Expansion - result separation
	function initializeArray(bytes32[] calldata,uint256[] calldata) external returns (bool);
	function claimArray(bytes32[] calldata) external returns (bool);
	function initializeAndClaimArray(bytes32[] calldata,uint256[] calldata) external returns (bool);
}

interface IexecRelay {
	event BroadcastAppOrder       (IexecLibOrders_v5.AppOrder        apporder       );
	event BroadcastDatasetOrder   (IexecLibOrders_v5.DatasetOrder    datasetorder   );
	event BroadcastWorkerpoolOrder(IexecLibOrders_v5.WorkerpoolOrder workerpoolorder);
	event BroadcastRequestOrder   (IexecLibOrders_v5.RequestOrder    requestorder   );

	function broadcastAppOrder       (IexecLibOrders_v5.AppOrder        calldata) external;
	function broadcastDatasetOrder   (IexecLibOrders_v5.DatasetOrder    calldata) external;
	function broadcastWorkerpoolOrder(IexecLibOrders_v5.WorkerpoolOrder calldata) external;
	function broadcastRequestOrder   (IexecLibOrders_v5.RequestOrder    calldata) external;
}

interface IexecTokenSpender {
	function receiveApproval(address,uint256,address,bytes calldata) external returns (bool);
}

interface ENSIntegration {
	function setName(address ens, string calldata name) external;
}

interface IexecInterfaceToken is IOwnable, IexecAccessors, IexecCategoryManager, IexecERC20, IexecEscrowToken, IexecMaintenance, IexecOrderManagement, IexecPoco, IexecRelay, IexecTokenSpender, ENSIntegration
{
}

contract WithIexecToken {
	address constant IEXECPROXY = 0x3eca1B216A7DF1C7689aEb259fFB83ADFB894E7f;

	IexecInterfaceToken public iexecproxy;

	constructor(address _iexecproxy)
	public
	{
		if      (_isContract(_iexecproxy)) { iexecproxy = IexecInterfaceToken(payable(_iexecproxy)); }
		else if (_isContract(IEXECPROXY )) { iexecproxy = IexecInterfaceToken(payable(IEXECPROXY )); }
		else                               { revert("invalid-iexecproxy-address");                   }
	}

	function _isContract(address _addr)
	internal view returns (bool)
	{
		uint32 size;
		assembly { size := extcodesize(_addr) }
		return size > 0;
	}
}

abstract contract IERC734 {
	// 1: MANAGEMENT keys, which can manage the identity
	uint256 public constant MANAGEMENT_KEY = 1;
	// 2: ACTION keys, which perform actions in this identities name (signing, logins, transactions, etc.)
	uint256 public constant ACTION_KEY = 2;
	// 3: CLAIM signer keys, used to sign claims on other identities which need to be revokable.
	uint256 public constant CLAIM_SIGNER_KEY = 3;
	// 4: ENCRYPTION keys, used to encrypt data e.g. hold in claims.
	uint256 public constant ENCRYPTION_KEY = 4;

	// KeyType
	uint256 public constant ECDSA_TYPE = 1;
	// https://medium.com/@alexberegszaszi/lets-bring-the-70s-to-ethereum-48daa16a4b51
	uint256 public constant RSA_TYPE = 2;

	// Events
	event KeyAdded          (bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
	event KeyRemoved        (bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
	event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
	event Executed          (uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
	event ExecutionFailed   (uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
	event Approved          (uint256 indexed executionId, bool approved);

	// Functions
	function getKey          (bytes32 _key                                     ) external virtual view returns (uint256[] memory purposes, uint256 keyType, bytes32 key);
	function keyHasPurpose   (bytes32 _key, uint256 purpose                    ) external virtual view returns (bool exists);
	function getKeysByPurpose(uint256 _purpose                                 ) external virtual view returns (bytes32[] memory keys);
	function addKey          (bytes32 _key, uint256 _purpose, uint256 _keyType ) external virtual      returns (bool success);
	function removeKey       (bytes32 _key, uint256 _purpose                   ) external virtual      returns (bool success);
	function execute         (address _to, uint256 _value, bytes calldata _data) external virtual      returns (uint256 executionId);
	function approve         (uint256 _id, bool _approve                       ) external virtual      returns (bool success);
}

contract IexecDoracle is WithIexecToken
{
	address public m_authorizedApp;
	address public m_authorizedDataset;
	address public m_authorizedWorkerpool;
	bytes32 public m_requiredtag;
	uint256 public m_requiredtrust;

	constructor(address _iexecproxy)
	public WithIexecToken(_iexecproxy)
	{}

	function _iexecDoracleUpdateSettings(
		address _authorizedApp,
		address _authorizedDataset,
		address _authorizedWorkerpool,
		bytes32 _requiredtag,
		uint256 _requiredtrust)
	internal
	{
		m_authorizedApp        = _authorizedApp;
		m_authorizedDataset    = _authorizedDataset;
		m_authorizedWorkerpool = _authorizedWorkerpool;
		m_requiredtag          = _requiredtag;
		m_requiredtrust        = _requiredtrust;
	}

	function _iexecDoracleGetResults(bytes32 _doracleCallId)
	internal view returns (bool, bytes memory)
	{
		IexecLibCore_v5.Task memory task = iexecproxy.viewTask(_doracleCallId);
		IexecLibCore_v5.Deal memory deal = iexecproxy.viewDeal(task.dealid);

		if (task.status   != IexecLibCore_v5.TaskStatusEnum.COMPLETED                                                  ) { return (false, bytes("result-not-available"             ));  }
		if (deal.callback != address(this)                                                                             ) { return (false, bytes("result-not-validated-for-callback"));  }
		if (m_authorizedApp        != address(0) && !_checkIdentity(m_authorizedApp,        deal.app.pointer,        4)) { return (false, bytes("unauthorized-app"                 ));  }
		if (m_authorizedDataset    != address(0) && !_checkIdentity(m_authorizedDataset,    deal.dataset.pointer,    4)) { return (false, bytes("unauthorized-dataset"             ));  }
		if (m_authorizedWorkerpool != address(0) && !_checkIdentity(m_authorizedWorkerpool, deal.workerpool.pointer, 4)) { return (false, bytes("unauthorized-workerpool"          ));  }
		if (m_requiredtag & ~deal.tag != bytes32(0)                                                                    ) { return (false, bytes("invalid-tag"                      ));  }
		if (m_requiredtrust > deal.trust                                                                               ) { return (false, bytes("invalid-trust"                    ));  }
		return (true, task.resultsCallback);
	}

	function _iexecDoracleGetVerifiedResult(bytes32 _doracleCallId)
	internal view returns (bytes memory)
	{
		(bool success, bytes memory results) = _iexecDoracleGetResults(_doracleCallId);
		require(success, string(results));
		return results;
	}

	function _checkIdentity(address _identity, address _candidate, uint256 _purpose)
	internal view returns (bool valid)
	{
		return _identity == _candidate || IERC734(_identity).keyHasPurpose(bytes32(uint256(_candidate)), _purpose); // Simple address || ERC 734 identity contract
	}
}


contract PriceOracle is IexecDoracle, Ownable, IOracleConsumer, IERC2362
{
	// Data storage
	struct TimedValue
	{
		bytes32 oracleCallID;
		uint256 date;
		int256  value;
		string  details;
	}

	mapping(bytes32 => TimedValue) public values;

	// Event
	event ValueUpdated(bytes32 indexed id, bytes32 indexed oracleCallID, uint256 date, int256 value);

	constructor()
	public IexecDoracle(address(0))
	{}

	function updateEnv(
	  address _authorizedApp
	, address _authorizedDataset
	, address _authorizedWorkerpool
	, bytes32 _requiredtag
	, uint256 _requiredtrust
	)
	public onlyOwner
	{
		_iexecDoracleUpdateSettings(_authorizedApp, _authorizedDataset, _authorizedWorkerpool, _requiredtag, _requiredtrust);
	}

	// ERC1154 - Callback processing
	function receiveResult(bytes32 _callID, bytes calldata)
	external override
	{
		// Parse results
		(uint256 date, string memory details, int256 value) = abi.decode(_iexecDoracleGetVerifiedResult(_callID), (uint256, string, int256));

		// Process results
		bytes32 id = keccak256(bytes(details));
		require(values[id].date < date, "new-value-is-too-old");
		values[id].oracleCallID = _callID;
		values[id].date         = date;
		values[id].value        = value;
		values[id].details      = details;

		emit ValueUpdated(id, _callID, date, value);
	}

	// ERC2362 - ADO result viewer
	function valueFor(bytes32 _id)
	external override view returns (int256, uint256, uint256)
	{
		if (values[_id].oracleCallID == bytes32(0))
		{
			return (0, 0, 404);
		}
		else
		{
			return (values[_id].value, values[_id].date, 200);
		}
	}
}