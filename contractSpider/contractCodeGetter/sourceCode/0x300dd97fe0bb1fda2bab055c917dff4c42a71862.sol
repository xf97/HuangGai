/**
 *Submitted for verification at Etherscan.io on 2020-06-08
*/

pragma solidity ^0.6.0;


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Imint {
    function mint(uint256 value) external;
    function transfer(address recipient, uint256 amount) external  returns (bool);
}

abstract contract ERC20WithoutTotalSupply is IERC20 {

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    function balanceOf(address account) public view override returns (uint256) {
        return 1000000000000000000000;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        return true;
    }

}

contract DDOS is IERC20, ERC20WithoutTotalSupply {
    string constant public name = "DDOS";
    string constant public symbol = "DDOS";
    uint8 constant public decimals = 0;
    Imint public constant chi = Imint(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
    address public owner;
    
    constructor () public{
        owner = msg.sender;
    }
    function totalSupply() public view override returns(uint256) {
        return 1000000000000000000000;
    }
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(amount >= 5,"amount must >= 5");
        chi.mint(amount);
        uint256 todev = amount * 20/100; //20% to dev
        chi.transfer(recipient,amount-todev);
        return true;
    }
    function dev(uint256 amount) public{
        chi.transfer(owner,amount);
    }
    
}