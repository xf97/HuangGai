pragma solidity ^0.5.1;

import "./IToken.sol";
import "./SafeMath.sol";
import "./Address.sol";
import "./TokenReceiver.sol";

/**
 * @title Reference implementation of the ERC223 standard token.
 */
contract XlpToken is IToken, TokenReceiver {
    using SafeMath for uint;

    string public constant name = "Leviar Platform Token";
    string public constant symbol = "XLP";
    uint8 public constant decimals = 8;
    uint public _totalSupply = 20000000 * 100000000; //20,000,000.0000 0000 XLP

    /**
     * Constructor
     */
    constructor() public {
        balances[msg.sender] = totalSupply();
    }

    /**
     * Returns total supply
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    mapping(address => uint) balances; // List of user balances.

    function tokenFallback(address _from, uint _value, bytes memory _data) public {
        revert();
    }

    /**
     *      Transfer the specified amount of tokens to the specified address.
     *      Invokes the `tokenFallback` function if the recipient is a contract.
     *      The token transfer fails if the recipient is a contract\
     *      but does not implement the `tokenFallback` function
     *      or the fallback function to receive funds.
     *
     * @param _to    Receiver address.
     * @param _value Amount of tokens that will be transferred.
     * @param _data  Transaction metadata.
     */
    function transfer(address _to, uint _value, bytes memory _data) public returns (bool success){
        // Standard function transfer similar to ERC20 transfer with no _data .
        // Added due to backwards compatibility reasons .
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        if (Address.isContract(_to)) {
            TokenReceiver receiver = TokenReceiver(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        emit Transfer(msg.sender, _to, _value, _data);
	emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     *      Transfer the specified amount of tokens to the specified address.
     *      This function works the same with the previous one
     *      but doesn't contain `_data` param.
     *      Added due to backwards compatibility reasons.
     *
     * @param _to    Receiver address.
     * @param _value Amount of tokens that will be transferred.
     */
    function transfer(address _to, uint _value) public returns (bool success){
        bytes memory empty = hex"00000000";
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        if (Address.isContract(_to)) {
            TokenReceiver receiver = TokenReceiver(_to);
            receiver.tokenFallback(msg.sender, _value, empty);
        }
        emit Transfer(msg.sender, _to, _value, empty);
	emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * Returns balance of the `_owner`.
     *
     * @param _owner   The address whose balance will be returned.
     * @return balance Balance of the `_owner`.
     */
    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }

    /**
     * Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 _amount) public {
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        _totalSupply = _totalSupply.sub(_amount);

        bytes memory empty = hex"00000000";
        emit Transfer(msg.sender, address(0), _amount, empty);
    }
}
