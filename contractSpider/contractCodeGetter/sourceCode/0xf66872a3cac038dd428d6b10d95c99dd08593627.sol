/**
 *Submitted for verification at Etherscan.io on 2020-07-19
*/

pragma solidity ^0.4.21;
/***
 *    ,------.                             
 *    |  .---'  ,--,--. ,--.--. ,--,--,--. 
 *    |  `--,  ' ,-.  | |  .--' |        | 
 *    |  |`    \ '-'  | |  |    |  |  |  | 
 *    `--'      `--`--' `--'    `--`--`--' 
 * 
 *  v 1.1.0
 *  "With help, wealth grows..."
 *
 *  Ethereum Commonwealth.gg Farm(based on contract @ ETC:0x93123bA3781bc066e076D249479eEF760970aa32)
 *  Modifications: 
 *  -> reinvest Crop Function

 *  What?
 *  -> Maintains crops, so that farmers can reinvest on user's behalf. Farmers receieve a referral bonus.
 *  -> A crop contract is deployed for each holder, and holds custody of eWLTH.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
 * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 */

contract Hourglass {
  function() payable public;
  function buy(address) public payable returns(uint256) {}
  function sell(uint256) public;
  function withdraw() public returns(address);
  function dividendsOf(address,bool) public view returns(uint256);
  function balanceOf(address) public view returns(uint256);
  function transfer(address , uint256) public returns(bool);
  function myTokens() public view returns(uint256);
  function myDividends(bool) public view returns(uint256);
  function exit() public;
}

contract Farm {
  address public eWLTHAddress = 0x5833C959C3532dD5B3B6855D590D70b01D2d9fA6;
  
  // Mapping of owners to their crops.
  mapping (address => address) public crops;
  
  // event for creating a new crop
  event CropCreated(address indexed owner, address crop);

  /**
   * @dev Creates a crop with an optional payable value
   * @param _playerAddress referral address.
   */
  function createCrop(address _playerAddress, bool _selfBuy) public payable returns (address) {
      // we can't already have a crop
      require(crops[msg.sender] == address(0));
      
      // create a new crop for us
      address cropAddress = new Crop(msg.sender);
      // map the creator to the crop address
      crops[msg.sender] = cropAddress;
      emit CropCreated(msg.sender, cropAddress);

      // if we sent some value with the transaction, buy some eWLTH for the crop.
      if (msg.value != 0){
        if (_selfBuy){
            Crop(cropAddress).buy.value(msg.value)(cropAddress);
        } else {
            Crop(cropAddress).buy.value(msg.value)(_playerAddress);
        }
      }
      
      return cropAddress;
  }
  
  /**
   * @dev Returns my current crop.
   */
  function myCrop() public view returns (address) {
    return crops[msg.sender];
  }
  
  /**
   * @dev Get dividends of my crop.
   */
  function myCropDividends(bool _includeReferralBonus) external view returns (uint256) {
    return Hourglass(eWLTHAddress).dividendsOf(crops[msg.sender], _includeReferralBonus);
  }
  
  /**
   * @dev Get amount of tokens owned by my crop.
   */
  function myCropTokens() external view returns (uint256) {
    return Hourglass(eWLTHAddress).balanceOf(crops[msg.sender]);
  }
  
  /**
   * @dev Get whether or not your crop is disabled.
   */
  function myCropDisabled() external view returns (bool) {
    if (crops[msg.sender] != address(0)){
        return Crop(crops[msg.sender]).disabled();
    } else {
        return true;
    }
  }
}

contract Crop {
  address public owner;
  bool public disabled = false;

  address private eWLTHAddress = 0xDe6FB6a5adbe6415CDaF143F8d90Eb01883e42ac;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  
  function Crop(address newOwner) public {
      owner = newOwner;
  }
  
  /**
   * @dev Turn reinvest on / off
   * @param _disabled bool to determine state of reinvest.
   */
  function disable(bool _disabled) external onlyOwner() {
    // toggle disabled
    disabled = _disabled;
  }

  /**
   * @dev Enables anyone with a masternode to earn referral fees on eWLTH reinvestments.
   * @param _playerAddress referral address.
   */
  function reinvest(address _playerAddress) external {
    // reinvest must be enabled
    require(disabled == false);
    
    Hourglass eWLTH = Hourglass(eWLTHAddress);
    if (eWLTH.dividendsOf(address(this), true) > 0){
        eWLTH.withdraw();
        uint256 bal = address(this).balance;
        // reinvest with a referral fee for sender
        eWLTH.buy.value(bal)(_playerAddress);
    }
  }
  
  /**
   * @dev Default function if ETC sent to contract. Does nothing.
   */
  function() public payable {}

  /**
   * @dev Buy eWLTH tokens
   * @param _playerAddress referral address.
   */
  function buy(address _playerAddress) external payable {
    Hourglass(eWLTHAddress).buy.value(msg.value)(_playerAddress);
  }

  /**
   * @dev Sell eWLTH tokens and send balance to owner
   * @param _amountOfTokens amount of tokens to sell.
   */
  function sell(uint256 _amountOfTokens) external onlyOwner() {
    // sell tokens
    Hourglass(eWLTHAddress).sell(_amountOfTokens);
    // transfer the dividends back to the owner
    withdraw();
  }

  /**
   * @dev Withdraw eWLTH dividends and send balance to owner
   */
  function withdraw() public onlyOwner() {
    if (Hourglass(eWLTHAddress).myDividends(true) > 0){
        // withdraw dividends
        Hourglass(eWLTHAddress).withdraw();

        // transfer to owner
        owner.transfer(address(this).balance);
    }
  }
  
  /**
   * @dev Liquidate all eWLTH in crop and send to the owner.
   */
  function exit() external onlyOwner() {
    Hourglass(eWLTHAddress).exit();
    owner.transfer(address(this).balance);
  }
  
  /**
   * @dev Transfer eWLTH tokens
   * @param _toAddress address to send tokens to.
   * @param _amountOfTokens amount of tokens to send.
   */
  function transfer(address _toAddress, uint256 _amountOfTokens) external onlyOwner() returns (bool) {
    withdraw();
    return Hourglass(eWLTHAddress).transfer(_toAddress, _amountOfTokens);
  }

  /**
   * @dev Get dividends for this crop.
   * @param _includeReferralBonus for including referrals in dividends.
   */
  function cropDividends(bool _includeReferralBonus) external view returns (uint256) {
    return Hourglass(eWLTHAddress).myDividends(_includeReferralBonus);
  }
  
  /**
   * @dev Get number of tokens for this crop.
   */
  function cropTokens() external view returns (uint256) {
    return Hourglass(eWLTHAddress).myTokens();
  }
}