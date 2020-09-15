/**
 *Submitted for verification at Etherscan.io on 2020-07-12
*/

// File: contracts/interfaces/IDeerfiV1SwapToken.sol

pragma solidity >=0.5.0;

interface IDeerfiV1SwapToken {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function mint(address to, uint value) external returns (bool);
    function burn(address from, uint value) external returns (bool);

    function transferOwnership(address _newOwner) external;
}

// File: contracts/libraries/SafeMath.sol

pragma solidity =0.5.16;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

// File: contracts/libraries/Ownable.sol

pragma solidity =0.5.16;

/**
 * @title Ownable contract
 * @dev The Ownable contract has an owner address, and provides basic authorization control functions.
 */
contract Ownable {
    address public owner;

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier validAddress(address _address) {
        require(_address != address(0));
        _;
    }

    // Events
    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);

    /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
    constructor(address _owner) public validAddress(_owner) {
        owner = _owner;
    }

    /// @dev Allows the current owner to transfer control of the contract to a newOwner.
    /// @param _newOwner The address to transfer ownership to.
    function transferOwnership(address _newOwner) public onlyOwner validAddress(_newOwner) {
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}

// File: contracts/DeerfiV1SwapToken.sol

pragma solidity =0.5.16;




contract DeerfiV1SwapToken is IDeerfiV1SwapToken, Ownable {
    using SafeMath for uint;

    string public constant name = 'Deerfi Swap Token';
    string public constant symbol = 'DFT-V1';
    uint8 public constant decimals = 18;
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    constructor() Ownable(msg.sender) public {
    }

    function _approve(address owner, address spender, uint value) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(address from, address to, uint value) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) external returns (bool) {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function mint(address to, uint value) external onlyOwner returns (bool) {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
        return true;
    }

    function burn(address from, uint value) external onlyOwner returns (bool){
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
        return true;
    }
}