/**
 *Submitted for verification at Etherscan.io on 2020-05-11
*/

// File: contracts/DkargoPrefix.sol

pragma solidity >=0.5.0 <0.6.0;

/// @title DkargoPrefix
/// @notice 디카르고 컨트랙트 여부 식별용 prefix 컨트랙트 정의
/// @author jhhong
contract DkargoPrefix {
    
    string internal _dkargoPrefix; // 디카르고-프리픽스
    
    /// @author jhhong
    /// @notice 디카르고 프리픽스를 반환한다.
    /// @return 디카르고 프리픽스 (string)
    function getDkargoPrefix() public view returns(string memory) {
        return _dkargoPrefix;
    }

    /// @author jhhong
    /// @notice 디카르고 프리픽스를 설정한다.
    /// @param prefix 설정할 프리픽스
    function _setDkargoPrefix(string memory prefix) internal {
        _dkargoPrefix = prefix;
    }
}

// File: contracts/authority/Ownership.sol

pragma solidity >=0.5.0 <0.6.0;

/// @title Onwership
/// @dev 오너 확인 및 소유권 이전 처리
/// @author jhhong
contract Ownership {
    address private _owner;

    event OwnershipTransferred(address indexed old, address indexed expected);

    /// @author jhhong
    /// @notice 소유자만 접근할 수 있음을 명시한다.
    modifier onlyOwner() {
        require(isOwner() == true, "Ownership: only the owner can call");
        _;
    }

    /// @author jhhong
    /// @notice 컨트랙트 생성자이다.
    constructor() internal {
        emit OwnershipTransferred(_owner, msg.sender);
        _owner = msg.sender;
    }

    /// @author jhhong
    /// @notice 소유권을 넘겨준다.
    /// @param expected 새로운 오너 계정
    function transferOwnership(address expected) public onlyOwner {
        require(expected != address(0), "Ownership: new owner is the zero address");
        emit OwnershipTransferred(_owner, expected);
        _owner = expected;
    }

    /// @author jhhong
    /// @notice 오너 주소를 반환한다.
    /// @return 오너 주소
    function owner() public view returns (address) {
        return _owner;
    }

    /// @author jhhong
    /// @notice 소유자인지 확인한다.
    /// @return 확인 결과 (boolean)
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }
}

// File: contracts/libs/SafeMath64.sol

pragma solidity >=0.5.0 <0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath64 {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint64 a, uint64 b) internal pure returns (uint64) {
        uint64 c = a + b;
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
    function sub(uint64 a, uint64 b) internal pure returns (uint64) {
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
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function sub(uint64 a, uint64 b, string memory errorMessage) internal pure returns (uint64) {
        require(b <= a, errorMessage);
        uint64 c = a - b;

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
    function mul(uint64 a, uint64 b) internal pure returns (uint64) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint64 c = a * b;
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
     * Requirements:uint64
     * - The divisor cannot be zero.
     */
    function div(uint64 a, uint64 b) internal pure returns (uint64) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint64 c = a / b;
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
    function mod(uint64 a, uint64 b) internal pure returns (uint64) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: contracts/chain/Uint64Chain.sol

pragma solidity >=0.5.0 <0.6.0;


/// @title Uint64Chain
/// @notice Uint64 Type 체인 정의 및 관리
/// @dev 시간대 별 이벤트와 같은 TIME-BASE 인덱스 리스트 관리에 쓰인다.
/// @author jhhong
contract Uint64Chain {
    using SafeMath64 for uint64;

    // 구조체 : 노드 정보
    struct NodeInfo {
        uint64 prev; // 이전 노드
        uint64 next; // 다음 노드
    }
    // 구조체 : 노드 체인
    struct NodeList {
        uint64 count; // 노드의 총 개수
        uint64 head; // 체인의 머리
        uint64 tail; // 체인의 꼬리
        mapping(uint64 => NodeInfo) map; // 계정에 대한 노드 정보 매핑
    }

    // 변수 선언
    NodeList private _slist; // 노드 체인 (싱글리스트)

    // 이벤트 선언
    event Uint64ChainLinked(uint64 indexed node); // 이벤트: 체인에 추가됨
    event Uint64ChainUnlinked(uint64 indexed node); // 이벤트: 체인에서 빠짐

    /// @author jhhong
    /// @notice 체인에 연결된 원소의 개수를 반환한다.
    /// @return 체인에 연결된 원소의 개수
    function count() public view returns(uint64) {
        return _slist.count;
    }

    /// @author jhhong
    /// @notice 체인 헤드 정보를 반환한다.
    /// @return 체인 헤드 정보
    function head() public view returns(uint64) {
        return _slist.head;
    }

    /// @author jhhong
    /// @notice 체인 꼬리 정보를 반환한다.
    /// @return 체인 꼬리 정보
    function tail() public view returns(uint64) {
        return _slist.tail;
    }

    /// @author jhhong
    /// @notice node의 다음 노드 정보를 반환한다.
    /// @param node 노드 정보 (체인에 연결되어 있을 수도 있고 아닐 수도 있음)
    /// @return node의 다음 노드 정보
    function nextOf(uint64 node) public view returns(uint64) {
        return _slist.map[node].next;
    }

    /// @author jhhong
    /// @notice node의 이전 노드 정보를 반환한다.
    /// @param node 노드 정보 (체인에 연결되어 있을 수도 있고 아닐 수도 있음)
    /// @return node의 이전 노드 정보
    function prevOf(uint64 node) public view returns(uint64) {
        return _slist.map[node].prev;
    }

    /// @author jhhong
    /// @notice node가 체인에 연결된 상태인지를 확인한다.
    /// @param node 체인 연결 여부를 확인할 노드 주소
    /// @return 연결 여부 (boolean), true: 연결됨(linked), false: 연결되지 않음(unlinked)
    function isLinked(uint64 node) public view returns (bool) {
        if(_slist.count == 1 && _slist.head == node && _slist.tail == node) {
            return true;
        } else {
            return (_slist.map[node].prev == uint64(0) && _slist.map[node].next == uint64(0))? (false) :(true);
        }
    }

    /// @author jhhong
    /// @notice 새로운 노드 정보를 노드 체인에 연결한다.
    /// @param node 노드 체인에 연결할 노드 주소
    function _linkChain(uint64 node) internal {
        require(!isLinked(node), "Uint64Chain: the node is aleady linked");
        if(_slist.count == 0) {
            _slist.head = _slist.tail = node;
        } else {
            _slist.map[node].prev = _slist.tail;
            _slist.map[_slist.tail].next = node;
            _slist.tail = node;
        }
        _slist.count = _slist.count.add(1);
        emit Uint64ChainLinked(node);
    }

    /// @author jhhong
    /// @notice node 노드를 체인에서 연결 해제한다.
    /// @param node 노드 체인에서 연결 해제할 노드 주소
    function _unlinkChain(uint64 node) internal {
        require(isLinked(node), "Uint64Chain: the node is aleady unlinked");
        uint64 tempPrev = _slist.map[node].prev;
        uint64 tempNext = _slist.map[node].next;
        if (_slist.head == node) {
            _slist.head = tempNext;
        }
        if (_slist.tail == node) {
            _slist.tail = tempPrev;
        }
        if (tempPrev != uint64(0)) {
            _slist.map[tempPrev].next = tempNext;
            _slist.map[node].prev = uint64(0);
        }
        if (tempNext != uint64(0)) {
            _slist.map[tempNext].prev = tempPrev;
            _slist.map[node].next = uint64(0);
        }
        _slist.count = _slist.count.sub(1);
        emit Uint64ChainUnlinked(node);
    }
}

// File: contracts/introspection/ERC165/IERC165.sol

pragma solidity >=0.5.0 <0.6.0;

/// @title IERC165
/// @dev EIP165 interface 선언
/// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
/// @author jhhong
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: contracts/introspection/ERC165/ERC165.sol

pragma solidity >=0.5.0 <0.6.0;


/// @title ERC165
/// @dev EIP165 interface 구현
/// @author jhhong
contract ERC165 is IERC165 {
    
    mapping(bytes4 => bool) private _infcs; // INTERFACE ID별 지원여부를 저장하기 위한 매핑 변수

    /// @author jhhong
    /// @notice 컨트랙트 생성자이다.
    /// @dev bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
    constructor() internal {
        _registerInterface(0x01ffc9a7); // supportsInterface()의 INTERFACE ID 등록
    }

    /// @author jhhong
    /// @notice 컨트랙트가 INTERFACE ID를 지원하는지의 여부를 반환한다.
    /// @param infcid 지원여부를 확인할 INTERFACE ID (Function Selector)
    /// @return 지원여부 (boolean)
    function supportsInterface(bytes4 infcid) external view returns (bool) {
        return _infcs[infcid];
    }

    /// @author jhhong
    /// @notice INTERFACE ID를 등록한다.
    /// @param infcid 등록할 INTERFACE ID (Function Selector)
    function _registerInterface(bytes4 infcid) internal {
        require(infcid != 0xffffffff, "ERC165: invalid interface id");
        _infcs[infcid] = true;
    }
}

// File: contracts/libs/Address.sol

pragma solidity >=0.5.0 <0.6.0;

/**
 * @dev Collection of functions related to the address type,
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * > It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /// @dev jhhong add features
    /// add useful functions and modifier definitions
    /// date: 2020.02.24

    /// @author jhhong
    /// @notice call 방식의 간접 함수 호출을 수행한다.
    /// @param addr 함수 호출할 컨트랙트 주소
    /// @param rawdata Bytes타입의 로우데이터 (함수셀렉터 + 파라메터들)
    /// @return 처리 결과 (bytes type) => abi.decode로 디코딩해줘야 함
    function _call(address addr, bytes memory rawdata) internal returns(bytes memory) {
        (bool success, bytes memory data) = address(addr).call(rawdata);
        require(success == true, "Address: function(call) call failed");
        return data;
    }

    /// @author jhhong
    /// @notice delegatecall 방식의 간접 함수 호출을 수행한다.
    /// @param addr 함수 호출할 컨트랙트 주소
    /// @param rawdata Bytes타입의 로우데이터 (함수셀렉터 + 파라메터들)
    /// @return 처리 결과 (bytes type) => abi.decode로 디코딩해줘야 함
    function _dcall(address addr, bytes memory rawdata) internal returns(bytes memory) {
        (bool success, bytes memory data) = address(addr).delegatecall(rawdata);
        require(success == true, "Address: function(delegatecall) call failed");
        return data;
    }

    /// @author jhhong
    /// @notice staticcall 방식의 간접 함수 호출을 수행한다.
    /// @dev bool 타입 값을 반환하는 view / pure 함수 CALL 시 사용된다.
    /// @param addr 함수 호출할 컨트랙트 주소
    /// @param rawdata Bytes타입의 로우데이터 (함수셀렉터 + 파라메터들)
    /// @return 처리 결과 (bytes type) => abi.decode로 디코딩해줘야 함
    function _vcall(address addr, bytes memory rawdata) internal view returns(bytes memory) {
        (bool success, bytes memory data) = address(addr).staticcall(rawdata);
        require(success == true, "Address: function(staticcall) call failed");
        return data;
    }
}

// File: contracts/libs/refs/SafeMath.sol

pragma solidity >=0.5.0 <0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
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
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
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
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
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
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: contracts/DkargoFund.sol

pragma solidity >=0.5.0 <0.6.0;







/// @title DkargoFund
/// @notice 디카르고 펀드 컨트랙트 정의
/// @author jhhong
contract DkargoFund is Ownership, Uint64Chain, ERC165, DkargoPrefix {
    using Address for address;
    using SafeMath for uint256;

    mapping(uint64 => uint256) private _plans; // 인출 플랜
    address private _beneficier; // 수취인 주소
    address private _token; // 토큰 컨트랙트 주소
    uint256 private _totals; // 플랜에 기록된 총 인출량, 펀드의 보유 토큰량을 초과할 수 없다.
    
    event BeneficierUpdated(address indexed beneficier); // 이벤트: 수취인 변경
    event PlanSet(uint64 time, uint256 amount); // 이벤트: 인출플랜 설정 (amount=0이면 제거)
    event Withdraw(uint256 amount); // 이벤트: 인출

    /// @author jhhong
    /// @notice 컨트랙트 생성자이다.
    /// @param token 토큰 컨트랙트 주소
    /// @param beneficier 수취인 주소
    constructor(address token, address beneficier) public {
        require(token != address(0), "DkargoFund: token is null");
        require(beneficier != address(0), "DkargoFund: beneficier is null");
        _setDkargoPrefix("fund"); // 프리픽스 설정 (fund)
        _registerInterface(0x946edbed); // INTERFACE ID 등록 (getDkargoPrefix)
        _token = token;
        _beneficier = beneficier;
    }

    /// @author jhhong
    /// @notice 인출금액 수취인을 설정한다.
    /// @dev 수취인 주소로 EOA, CA 다 설정 가능하다.
    /// @param beneficier 설정할 수취인 주소 (address)
    function setBeneficier(address beneficier) onlyOwner public {
        require(beneficier != address(0), "DkargoFund: beneficier is null");
        require(beneficier != _beneficier, "DkargoFund: should be not equal");
        _beneficier = beneficier;
        emit BeneficierUpdated(beneficier);
    }

    /// @author jhhong
    /// @notice 인출 플랜을 추가한다.
    /// @dev amount!=0이면 새 플랜을 추가한다는 의미이다. linkChain 과정이 수행된다. 기존에 설정된 플랜이 있을 경우 덮어쓴다.
    /// amount=0이면 플랜을 삭제한다는 의미이다. unlinkChain 과정이 수행된다. 기존에 설정된 플랜이 없을 경우 revert된다.
    /// time은 현재 시각(block.timestamp)보다 큰 값이어야 한다.
    /// 설정된 플랜들의 모든 amount의 합은 balanceOf(fundCA)를 초과할 수 없다.
    /// @param time 인출 가능한 시각
    /// @param amount 인출 가능한 금액
    function setPlan(uint64 time, uint256 amount) onlyOwner public {
        require(time > block.timestamp, "DkargoFund: invalid time");
        _totals = _totals.add(amount); // 추가될 플랜 금액을 총 플랜금액에 합산
        _totals = _totals.sub(_plans[time]); // 총 플랜금액에서 기존 설정된 금액을 차감
        require(_totals <= fundAmount(), "DkargoFund: over the limit"); // 총 플랜금액 체크
        _plans[time] = amount; // 플랜 금액 갱신
        emit PlanSet(time, amount); // 이벤트 발생
        if(amount == 0) { // 체인정보 갱신
            _unlinkChain(time); // 기존에 설정되지 않았을 경우, revert("AddressChain: the node is aleady unlinked")
        } else if(isLinked(time) == false) { // 새 설정일 경우에만 체인추가, 기존 설정이 있을 경우, 값만 갱신하고 체인 정보는 갱신하지 않음
            _linkChain(time);
        }
    }

    /// @author jhhong
    /// @notice 토큰을 지정된 수취인에게로 인출한다.
    /// @dev 만료되지 않은 index는 인출 불가능하다. revert!
    /// 설정되지 않은 (혹은 해제된) 플랜 인덱스에 대해서는 revert!
    /// @param index 플랜 인덱스, setPlan에서 넣어줬던 인출 가능 시각이다.
    function withdraw(uint64 index) onlyOwner public {
        require(index <= block.timestamp, "DkargoFund: an unexpired plan");
        require(_plans[index] > 0, "DkargoFund: plan is not set");
        bytes memory cmd = abi.encodeWithSignature("transfer(address,uint256)", _beneficier, _plans[index]);
        bytes memory data = address(_token)._call(cmd);
        bool result = abi.decode(data, (bool));
        require(result == true, "DkargoFund: failed to proceed raw-data");
        _totals = _totals.sub(_plans[index]); // 총 플랜금액에서 기존 설정된 금액을 차감
        emit Withdraw(_plans[index]);
        _plans[index] = 0;
        _unlinkChain(index);
    }

    /// @author jhhong
    /// @notice Fund 컨트랙트의 밸런스를 확인한다.
    /// @return Fund 컨트랙트의 밸런스 (uint256)
    function fundAmount() public view returns(uint256) {
        bytes memory data = address(_token)._vcall(abi.encodeWithSignature("balanceOf(address)", address(this)));
        return abi.decode(data, (uint256));
    }

    /// @author jhhong
    /// @notice 플랜에 기록된 총 금액을 확인한다.
    /// @return 플랜에 기록된 총 금액 (uint256)
    function totalPlannedAmount() public view returns(uint256) {
        return _totals;
    }
    
    /// @author jhhong
    /// @notice 플랜 인덱스에 해당하는 인출 금액을 확인한다.
    /// @param index 플랜 인덱스, setPlan에서 넣어줬던 인출 가능 시각이다.
    /// @return 플랜 인덱스에 해당하는 인출 금액 (uint256)
    function plannedAmountOf(uint64 index) public view returns(uint256) {
        return _plans[index];
    }

    /// @author jhhong
    /// @notice 수취인 주소를 확인한다.
    /// @return 수취인 주소 (address)
    function beneficier() public view returns(address) {
        return _beneficier;
    }

    /// @author jhhong
    /// @notice 토큰(ERC-20) 주소를 확인한다.
    /// @return 토큰 주소 (address)
    function token() public view returns(address) {
        return _token;
    }
}