/**
 *Submitted for verification at Etherscan.io on 2020-07-06
*/

pragma solidity 0.5.2;


/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}



contract PaymentSplitter {
  using SafeMath for uint256;

 /**
  * Transfers ether to multiple recipients as specified by _recepients and _splits arrays
  *
  * @param _recipients Array of payment recipients
  * @param _splits Array of share amount to transfer to corresponding recipient. Values can be anything as long as ratio is correct — e.g. [5,5,5] will split the value equally. If you want to transfer specific amounts in wei, specify _splits in wei. The splits should sum up to the `msg.value` in this case. The remainder, if any, will be sent to the last recipient
  */
  function split(
    address payable[] memory _recipients,
    uint256[] memory _splits
  ) public payable {
    require(_recipients.length > 0, "no data for split");
    require(_recipients.length == _splits.length, "splits and recipients should be of the same length");

    uint256 sumShares = 0;
    for (uint i = 0; i < _recipients.length; i++) {
      sumShares = sumShares.add(_splits[i]);
    }

    for (uint i = 0; i < _recipients.length - 1; i++) {
      _recipients[i].transfer(msg.value.mul(_splits[i]).div(sumShares));
    }
    // flush the rest, so that we don't have rounding errors or stuck funds
    _recipients[_recipients.length - 1].transfer(address(this).balance);
  }


 /**
  * Transfers given token to multiple recipients as specified by _recepients and _splits arrays
  *
  * @dev This contract should have enough allowance of _tokenAddr from _payerAddr
  * @param _recipients Array of payment recipients
  * @param _splits Array of amounts for _tokenAddr ERC20 to transfer to corresponding recipient.
  * @param _tokenAddr ERC20 token used for payment unit
  */
  function splitERC20(
    address[] memory _recipients,
    uint256[] memory _splits,
    address _tokenAddr
  ) public {
    require(_recipients.length == _splits.length, "splits and recipients should be of the same length");
    IERC20 token = IERC20(_tokenAddr);
    for (uint i = 0; i < _recipients.length; i++) {
      token.transferFrom(msg.sender, _recipients[i], _splits[i]);
    }
  }

}