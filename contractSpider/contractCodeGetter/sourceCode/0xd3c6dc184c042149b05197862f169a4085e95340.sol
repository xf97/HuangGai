/**
 *Submitted for verification at Etherscan.io on 2020-07-09
*/

pragma solidity ^0.4.24;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // require(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // require(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}


contract BasicERC20 {
    /* Public variables of the token */
    string public standard = 'ERC20';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    bool public isTokenTransferable = true;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /* Send coins */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(isTokenTransferable);
        require(balanceOf[msg.sender] >= _value);             // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to])
            revert('Overflow detected'); // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
        return true;
    }

    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value) public
    returns (bool success)  {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(isTokenTransferable || _from == address(0x0)); // Allow to transfer for crowdsale
        if (balanceOf[_from] < _value)
            revert('Insufficient sunds');                     // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to])
            revert('Overflow detected');                      // Check for overflows
        if (_value > allowance[_from][msg.sender])
            revert('Operation is not allow');                 // Check allowance
        balanceOf[_from] -= _value;                           // Subtract from the sender
        balanceOf[_to] += _value;                             // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}


contract EditableToken is BasicERC20, Ownable {
    using SafeMath for uint256;

    // change owner to 0x0 to lock this function
    function editTokenProperties(string _name, string _symbol, int256 extraSupplay) onlyOwner public {
        name = _name;
        symbol = _symbol;
        if (extraSupplay > 0)
        {
            balanceOf[owner] = balanceOf[owner].add(uint256(extraSupplay));
            totalSupply = totalSupply.add(uint256(extraSupplay));
            emit Transfer(address(0x0), owner, uint256(extraSupplay));
        }
        else if (extraSupplay < 0)
        {
            balanceOf[owner] = balanceOf[owner].sub(uint256(extraSupplay * -1));
            totalSupply = totalSupply.sub(uint256(extraSupplay * -1));
            emit Transfer(owner, address(0x0), uint256(extraSupplay * -1));
        }
    }
}


contract ThirdPartyTransferableToken is BasicERC20 {
    using SafeMath for uint256;

    struct confidenceInfo {
        uint256 nonce;
        mapping (uint256 => bool) operation;
    }
    mapping (address => confidenceInfo) _confidence_transfers;

    function nonceOf(address src) view public returns (uint256) {
        return _confidence_transfers[src].nonce;
    }

    function transferByThirdParty(uint256 nonce, address where, uint256 amount, uint8 v, bytes32 r, bytes32 s) public returns (bool){
        require(where != address(this));
        require(where != address(0x0));

        bytes32 hash = sha256(abi.encodePacked(this, nonce, where, amount));
        address src = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s);
        require(balanceOf[src] >= amount);
        require(nonce == _confidence_transfers[src].nonce+1);

        require(_confidence_transfers[src].operation[uint256(hash)]==false);

        balanceOf[src] = balanceOf[src].sub(amount);
        balanceOf[where] = balanceOf[where].add(amount);
        _confidence_transfers[src].nonce += 1;
        _confidence_transfers[src].operation[uint256(hash)] = true;

        emit Transfer(src, where, amount);

        return true;
    }
}


contract ERC20Token is EditableToken, ThirdPartyTransferableToken {
    using SafeMath for uint256;

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor() public
    {
        balanceOf[0xBF165e10878628768939f0415d7df2A9d52f0aB0] = uint256(100000000) * 10**18;
        emit Transfer(address(0x0), 0xBF165e10878628768939f0415d7df2A9d52f0aB0, balanceOf[0xBF165e10878628768939f0415d7df2A9d52f0aB0]);

        transferOwnership(0xBF165e10878628768939f0415d7df2A9d52f0aB0);

        totalSupply = 100000000 * 10**18;                        // Update total supply
        name = 'CLICK';                                          // Set the name for display purposes
        symbol = 'CLK';                                          // Set the symbol for display purposes
        decimals = 18;                                           // Amount of decimals for display purposes
    }

    /* This unnamed function is called whenever someone tries to send ether to it */
    function () public {
        require(false);     // Prevents accidental sending of ether
    }
}