/**
 *Submitted for verification at Etherscan.io on 2020-05-21
*/

pragma solidity >=0.4.25 <0.7.0;
/**
*
*       ╔═══╦═╗╔═╦═══╦════╗╔╗╔═══╗
*       ║╔═╗║║╚╝║║╔═╗║╔╗╔╗╠╝║║╔══╝
*       ║╚══╣╔╗╔╗║╚═╝╠╝║║╚╩╗║║╚══╗
*       ╚══╗║║║║║║╔╗╔╝█║║██║║║╔═╗║
*       ║╚═╝║║║║║║║║╚╗█║║█╔╝╚╣╚═╝║
*       ╚═══╩╝╚╝╚╩╝╚═╝█╚╝█╚══╩═══╝
*  
*   Copyright 2020, Maxim Vasilkov
*
*   This program is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*
*   SMRT16 is a practical implementation of the idea of Decentralized Unmanaged Organization (DUO). 
*   The DUO is about that there are possible businesses which operate on-chain only and make profit absolutely without any external management.
*   
*   SMRT16 project consists of this smart contract "SMRT16Ext" (this file) and two another:
*    1) PROFIT SHARING "ProfitSharingSMRT16"
*    2) PROFIT ACCUMULATOR "ProfitAccamulatorSMRT16"
*   These two are dependent and working together with the SMRT16Ext, covering the minimum of the functionality needed to create a fully operational business.
*   
*   SMRT16Ext first of all describes SMRT16 Token, which is a MiniMe Token (from Jordi Baylina) and which implements the ERC20 interface as well. 
*   As soon it is ERC20, it can be freely transferred, sold, bought and exchanged.  
*   As soon it is MiniMe token, SMRT16 has the feature to remember users' stakes at any Ethereum block.
*   The last needed to make this token to work like shares, so our DUO can pay dividends. 
*   
*   The dividends need to be claimed and are not paid automatically. 
*   It accrued and paid in ETH cryptocurrency, monthly, proportionally to the stakes holded on the end of a month.
*   
*   The dividends at least once per year, otherwise it's recycled. Recycled amount treated as profit and comes to the next period for all shareholders.
*   
*   The big thing about SMRT16 is decentralization of marketing which is built in the token sale. 
*   Unlike other projects, SMRT16 is not going to raise any funds for the development. The funds from the token sale are instantly paid back 
*   to the project participants as marketing bonuses. 
*   The goal of the project is to raise the people's attention which later will be monetized for the long lasting profit again back for investors of the project.
*   Token sale has a multi level referral program, which is that decentralized marketing mentioned above.
*   It works the following way: every project participant has his own "PersonalSMRT16" Smart Contract address, which was created for him during the first token purchase. 
*   With this address the user becomes an agent of the project and now he can invite other people to buy SMRT16 tokens by paying ETH to his personal address.
*   In this case the agent gets up to half of every sale transaction of his 1st level referrals. 
*   There are four levels of referrals. Every next level of referrals has the half of the previous level. 
*   This looks like 1/2, 1/4, 1/8 and 1/16 of the original transaction amount.
*   All together it makes that 15/16 of the token price are spent to pay for the marketing efforts of the project investors. 
*   Note: everything paid in ETH instantly. 
*   The remaining 1/16 of the token price, together with any other incomes goes to "ProfitAccamulatorSMRT16" address and paid out as dividends at the end of every month.
*   
*   What after the token sale the project is going to make money with a number of coming soon Smart contracts. Let's like slots and so on. 
*   Which are supposed to get traffic by the efforts of all the big number of investors involved during the token sale and referral marketing campaign.
*   
*   
*   Contact details of the author and some more details you can find on smrt16.com
*
*
*/
// ------------------------------------------------------------------------
/*
    Copyright 2016, Jordi Baylina

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
// ------------------------------------------------------------------------
/** 
*  @dev The actual token contract, the default controller is the msg.sender
*  that deploys the contract, so usually this token will be deployed by a
*  token controller contract, which Giveth will call a "Campaign"
*/
contract MiniMeToken {

    string public name;                   //The Token's name: e.g. DigixDAO Tokens
    uint8 public decimals;                //Number of decimals of the smallest unit
    string public symbol;                 //An identifier: e.g. REP
    string public version = 'SMRT16_1.0'; //An arbitrary versioning scheme

    /// @dev `Checkpoint` is the structure that attaches a block number to a
    ///  given value, the block number attached is the one that last changed the
    ///  value
    struct  Checkpoint {

        // `fromBlock` is the block number that the value was generated from
        uint128 fromBlock;

        // `value` is the amount of tokens at a specific block number
        uint128 value;
    }

    // `parentToken` is the Token address that was cloned to produce this token;
    //  it will be 0x0 for a token that was not cloned
    MiniMeToken public parentToken;

    // `parentSnapShotBlock` is the block number from the Parent Token that was
    //  used to determine the initial distribution of the Clone Token
    uint public parentSnapShotBlock;

    // `creationBlock` is the block number that the Clone Token was created
    uint public creationBlock;

    // `balances` is the map that tracks the balance of each address, in this
    //  contract when the balance changes the block number that the change
    //  occurred is also included in the map
    mapping (address => Checkpoint[]) balances;

    // `allowed` tracks any extra transfer rights as in all ERC20 tokens
    mapping (address => mapping (address => uint256)) allowed;

    // Tracks the history of the `totalSupply` of the token
    Checkpoint[] totalSupplyHistory;


    // The factory used to create new clone tokens
    MiniMeTokenFactory public tokenFactory;

    /// @notice Constructor to create a MiniMeToken
    /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
    ///  will create the Clone token contracts, the token factory needs to be
    ///  deployed first
    /// @param _parentToken Address of the parent token, set to 0x0 if it is a
    ///  new token
    /// @param _parentSnapShotBlock Block of the parent token that will
    ///  determine the initial distribution of the clone token, set to 0 if it
    ///  is a new token
    /// @param _tokenName Name of the new token
    /// @param _decimalUnits Number of decimals of the new token
    /// @param _tokenSymbol Token Symbol for the new token
    constructor(
        address _tokenFactory,
        address _parentToken,
        uint _parentSnapShotBlock,
        string memory _tokenName,
        uint8  _decimalUnits,
        string memory _tokenSymbol
    ) public {
        tokenFactory = MiniMeTokenFactory(_tokenFactory);
        name = _tokenName;                                 // Set the name
        decimals = _decimalUnits;                          // Set the decimals
        symbol = _tokenSymbol;                             // Set the symbol
        parentToken = MiniMeToken(_parentToken);
        parentSnapShotBlock = _parentSnapShotBlock;
        creationBlock = block.number;
    }


    /// @notice Send `_amount` tokens to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _amount) public returns (bool success) {
        return doTransfer(msg.sender, _to, _amount);
    }

    /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
    ///  is approved by `_from`
    /// @param _from The address holding the tokens being transferred
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to be transferred
    /// @return True if the transfer was successful
    function transferFrom(address _from, address _to, uint256 _amount
    ) public returns (bool success) {
        require(allowed[_from][msg.sender] >= _amount);
        allowed[_from][msg.sender] -= _amount;
        
        return doTransfer(_from, _to, _amount);
    }

    /// @dev This is the actual transfer function in the token contract, it can
    ///  only be called by other functions in this contract.
    /// @param _from The address holding the tokens being transferred
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to be transferred
    /// @return True if the transfer was successful
    function doTransfer(address _from, address _to, uint _amount
    ) internal returns(bool) {
            // Do nothin if amount to trnasfer is 0
           if (_amount == 0) {
               return true;
           }
           // cant be the same block
           require (parentSnapShotBlock <= block.number);

           // Do not allow transfer to 0x0 or the token contract itself
           require ((_to != address(0)) && (_to != address(this)));

           // If the amount being transfered is more than the balance of the
           //  account the transfer returns false
           uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
           if (previousBalanceFrom < _amount) {
               return false;
           }


           // First update the balance array with the new value for the address
           //  sending the tokens
           updateValueAtNow(balances[_from], previousBalanceFrom - _amount);

           // Then update the balance array with the new value for the address
           //  receiving the tokens
           uint256 previousBalanceTo = balanceOfAt(_to, block.number);
           require (previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
           updateValueAtNow(balances[_to], previousBalanceTo + _amount);

           // An event to make the transfer easy to find on the blockchain
           emit Transfer(_from, _to, _amount);

           return true;
    }

    /// @param _owner The address that's balance is being requested
    /// @return The balance of `_owner` at the current block
    function balanceOf(address _owner) public view returns  (uint256 balance) {
        return balanceOfAt(_owner, block.number);
    }

    /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
    ///  its behalf. This is a modified version of the ERC20 approve function
    ///  to be a little bit safer
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _amount The amount of tokens to be approved for transfer
    /// @return True if the approval was successful
    function approve(address _spender, uint256 _amount) public returns (bool success) {

        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender,0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));


        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    /// @dev This function makes it easy to read the `allowed[]` map
    /// @param _owner The address of the account that owns the token
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens of _owner that _spender is allowed
    ///  to spend
    function allowance(address _owner, address _spender
    ) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }



    /// @dev This function makes it easy to get the total number of tokens
    /// @return The total number of tokens
    function totalSupply() public view returns (uint) {
        return totalSupplyAt(block.number);
    }

    /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
    /// @param _owner The address from which the balance will be retrieved
    /// @param _blockNumber The block number when the balance is queried
    /// @return The balance at `_blockNumber`
    function balanceOfAt(address _owner, uint _blockNumber) public view
        returns (uint) {

        // These next few lines are used when the balance of the token is
        //  requested before a check point was ever created for this token, it
        //  requires that the `parentToken.balanceOfAt` be queried at the
        //  genesis block for that token as this contains initial balance of
        //  this token
        if ((balances[_owner].length == 0)
            || (balances[_owner][0].fromBlock > _blockNumber)) {
            if (address(parentToken) != address(0)) {
                return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
            } else {
                // Has no parent
                return 0;
            }

        // This will return the expected balance during normal situations
        } else {
            return getValueAt(balances[_owner], _blockNumber);
        }
    }

    /// @notice Total amount of tokens at a specific `_blockNumber`.
    /// @param _blockNumber The block number when the totalSupply is queried
    /// @return The total amount of tokens at `_blockNumber`
    function totalSupplyAt(uint _blockNumber) public view returns(uint) {

        // These next few lines are used when the totalSupply of the token is
        //  requested before a check point was ever created for this token, it
        //  requires that the `parentToken.totalSupplyAt` be queried at the
        //  genesis block for this token as that contains totalSupply of this
        //  token at this block number.
        if ((totalSupplyHistory.length == 0)
            || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
            if (address(parentToken) != address(0)) {
                return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
            } else {
                return 0;
            }

        // This will return the expected totalSupply during normal situations
        } else {
            return getValueAt(totalSupplyHistory, _blockNumber);
        }
    }

    /// @notice Creates a new clone token with the initial distribution being
    ///  this token at `_snapshotBlock`
    /// @param _cloneTokenName Name of the clone token
    /// @param _cloneDecimalUnits Number of decimals of the smallest unit
    /// @param _cloneTokenSymbol Symbol of the clone token
    /// @param _snapshotBlock Block when the distribution of the parent token is
    ///  copied to set the initial distribution of the new clone token;
    ///  if the block is zero than the actual block, the current block is used
    /// @return The address of the new MiniMeToken Contract
    function createCloneToken(
        string memory _cloneTokenName,
        uint8 _cloneDecimalUnits,
        string memory _cloneTokenSymbol,
        uint _snapshotBlock
        ) public returns(address) {
        if (_snapshotBlock == uint256(0)) _snapshotBlock = block.number;
        MiniMeToken cloneToken = tokenFactory.createCloneToken(
            address(this),
            _snapshotBlock,
            _cloneTokenName,
            _cloneDecimalUnits,
            _cloneTokenSymbol
            );


        // An event to make the token easy to find on the blockchain
        emit NewCloneToken(address(cloneToken), _snapshotBlock);
        return address(cloneToken);
    }


    /// @dev `getValueAt` retrieves the number of tokens at a given block number
    /// @param checkpoints The history of values being queried
    /// @param _block The block number to retrieve the value at
    /// @return The number of tokens being queried
    function getValueAt(Checkpoint[] storage checkpoints, uint _block
    ) view internal returns (uint) {
        if (checkpoints.length == 0) return 0;

        // Shortcut for the actual value
        if (_block >= checkpoints[checkpoints.length-1].fromBlock)
            return checkpoints[checkpoints.length-1].value;
        if (_block < checkpoints[0].fromBlock) return 0;

        // Binary search of the value in the array
        uint min = 0;
        uint max = checkpoints.length-1;
        while (max > min) {
            uint mid = (max + min + 1)/ 2;
            if (checkpoints[mid].fromBlock<=_block) {
                min = mid;
            } else {
                max = mid-1;
            }
        }
        return checkpoints[min].value;
    }

    /// @dev `updateValueAtNow` used to update the `balances` map and the
    ///  `totalSupplyHistory`
    /// @param checkpoints The history of data being updated
    /// @param _value The new number of tokens
    function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
    ) internal   {
        if ((checkpoints.length == 0)
        || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
               Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
               newCheckPoint.fromBlock =  uint128(block.number);
               newCheckPoint.value = uint128(_value);
           } else {
               Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
               oldCheckPoint.value = uint128(_value);
           }
    }

    /// @dev Internal function to determine if an address is a contract
    /// @param _addr The address being queried
    /// @return True if `_addr` is a contract
    function isContract(address _addr) internal view returns(bool) {
        uint size;
        if (_addr == address(0)) return false;
        assembly {
            size := extcodesize(_addr)
        }
        return size>0;
    }

    /// @dev Helper function to return a min betwen the two uints
    function min(uint a, uint b) private pure returns (uint) {
        return a < b ? a : b;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _amount);
    event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _amount
        );
}


/// @dev This contract is used to generate clone contracts from a contract.
///  In solidity this is the way to create a contract from a contract of the
///  same class
contract MiniMeTokenFactory {

    /// @notice Update the DApp by creating a new token with new functionalities
    ///  the msg.sender becomes the controller of this clone token
    /// @param _parentToken Address of the token being cloned
    /// @param _snapshotBlock Block of the parent token that will
    ///  determine the initial distribution of the clone token
    /// @param _tokenName Name of the new token
    /// @param _decimalUnits Number of decimals of the new token
    /// @param _tokenSymbol Token Symbol for the new token
    /// @return The address of the new token contract
    function createCloneToken(
        address _parentToken,
        uint _snapshotBlock,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) public returns (MiniMeToken) {
        MiniMeToken newToken = new MiniMeToken(
            address(this),
            _parentToken,
            _snapshotBlock,
            _tokenName,
            _decimalUnits,
            _tokenSymbol
            );

        return newToken;
    }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() internal {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
  }

  /**
   * @return the address of the owner.
   */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
   * @return true if `msg.sender` is the owner of the contract.
   */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}


/**
 * The MiniMeSMRT16Token is MiniMeToken ERC20 contract
 */
contract MiniMeSMRT16Token is MiniMeToken, MiniMeTokenFactory {

  constructor() MiniMeToken(address(this),address(0),uint256(0),"SMRT16",18,"S16")  public {
    
  }
  
}


/**
* @dev This contract creates PersonalSMRT16 contracts
*/
contract SMRT16Factory {

  // ref wallet => contract
  mapping(address => address) private contracts;

  // contract => ref wallet
  mapping(address => address) private wallets;

  // Event about a Referral bonus sent successfully
  event PersonalSMRT16(address indexed referrer, address indexed smrt16contract);

  function _createPersonalContract (address payable referrer, address payable smrt16) internal {
      if (contracts[referrer] == address(0)) {
        SMRT16Personal newContract = new SMRT16Personal(referrer, smrt16);
        emit PersonalSMRT16(referrer, smrt16);
        contracts[referrer] = address(newContract);
        wallets[address(newContract)] = referrer;
      }
  }

  function getPersonalContractAddress() external view returns (address) {
    return contracts[msg.sender];
  }


  function getPersonalContractAddressOf(address wallet) external view returns (address) {
    return contracts[wallet];
  }

  function getWalletOf(address contractAddres) external view returns (address) {
    return wallets[contractAddres];
  }

}


/**
* @dev main proxy smart contract
*/
contract SMRT16Ext is MiniMeSMRT16Token, Ownable, SMRT16Factory {

    
    // limit possible Supply of this token, 160 millions tokens
    uint constant internal _maxSupply = 160 * 10**6 * 10**18; 

    //  The price is constant untill the end of the token offering: 100 Tokens x 1 ETH
    uint constant internal _price = 100;

    //  Remember all the referrers
    mapping(address => address payable) private referrers;

    // Event about a Referral bonus sent successfully
    event Bonus(address indexed from, address indexed to, uint256 value);

    // the smrt16 companies address for bonuses
    address payable private _root;


    /**
    * @dev Constructor accept addresses of other smart contracts of the project
    * It could not be cteated striaght here due to amount of gas needed
    */
    constructor ()  public {
        _root = msg.sender;
    }

    /**
     * @dev Getter for the token price.
     */
    function price() pure public returns(uint) {
        return _price;
    }

    /**
     * @dev Getter for the token maxSupply.
     */
    function maxSupply() pure public returns(uint) {
        return _maxSupply;
    }  

 


    /*
    * @dev this function will be called after the SMRT16 smart contract deployed 
    * to pass its address here
    */
    function setProfitAddress (address payable _profitAddress) onlyOwner public {
        _root = _profitAddress;
    }
    
    /**
    * @dev Getter to check the profit gathering address
    */
    function profitAddress() view public returns (address) {
        return _root;
    }


    /**
     * @dev because the situation with empty referrer will cause a crash during giving bonuses
     * by default the address of the wallet will be used.
     * @param query the address to get referrer of
     **/
    function getReferrer(address query) public view returns (address payable) {
      if (referrers[query]==address(0)) {
          // cant have no referrer
          return _root;
      }
      return referrers[query];
    }


    /**
    * @dev fallback function
    * You supposed to put the referrer address into msg.data
    * Avoid to use this function for it's complexity, easier to use the Personal smart contracts
    * But if referrer is there from previous purchase, it is safe to use without msg.data
    */
    function () external payable {
        buyTokens(msg.sender, _bytesToAddress(bytes(msg.data)));
    }

    /**
    * @dev Token sales function
    */
    function buyTokens(address payable buyer, address payable referrer) public payable {
        require(buyer != address(0));

        uint _tokenAmount = msg.value*_price;

        _setReferrer(referrer);
        _createPersonalContract(buyer, address(this));
        _applyBonuses();
        _mint(buyer, _tokenAmount);

    }

    /**
    * @dev owner access to _mint
    */
    function mint(address _beneficiary, uint _tokenAmount) onlyOwner public {
        _mint(_beneficiary, _tokenAmount);
    }

    
    /**
    * @dev Minting the tokens
    */
    function _mint(address _owner, uint _amount)  internal {
        uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
        require (curTotalSupply + _amount <= _maxSupply); // Check for maxSupply
        updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
        uint previousBalanceTo = balanceOf(_owner);
        require (previousBalanceTo + _amount > previousBalanceTo); // Check for overflow
        updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
        emit Transfer(address(0), _owner, _amount);
    }

    /**
    * @dev simple routine function, returns minimum between two given uint256 numbers
    */
    function _min(uint256 a, uint256 b) internal pure returns(uint256) {
        if(a>b) return b;
        return a;
    }

    /**
     * @dev sets the referrer who will receive the bonus
     * @param _referrer where address must have non zero balance
     **/
    function _setReferrer(address payable _referrer) internal returns (address) {
      // let it set but not change
      if(referrers[msg.sender]==address(0)) {
        // referrer should be already a one who has non-zero balance
        if(balanceOf(_referrer)>uint(0)) {
            referrers[msg.sender] = _referrer;
        }
      }
      return referrers[msg.sender];
    }

    
    
    /**
    * @dev The function which does the actual referrals payments 
    * Logic: 1st receives 50%, 2nd - 25%, 3rd - 12.5%, 4th - 6.125%
    * Emits Bonus event, notifiying about bonuses payed
    **/
    function _applyBonuses() internal {
        // Amount of tokens to be sent for the price
        uint256 d16 = msg.value*_price;

        // The amount is too small to generate any bonuses (less than 16 Weis)
        if(d16<16) return;

        uint256 d8 = d16 / 2; 
        uint256 d4 = d8 / 2;
        uint256 d2 = d4 / 2;
        uint256 d1 = d2 / 2;


        address payable r1 = getReferrer(msg.sender);
        uint r1d8 = _min(d8, balanceOf(r1)/2)/_price;  
        if(r1.send(r1d8)==true) {
            emit Bonus(address(this), r1, r1d8);
        }
        address payable r2 = getReferrer(r1);
        uint r2d4 = _min(d4, balanceOf(r2)/4)/_price;
        if(r2.send(r2d4)==true) {
            emit Bonus(address(this), r2, r2d4);
        }
        address payable r3 = getReferrer(r2);
        uint r3d2 = _min(d2, balanceOf(r3)/8)/_price;
        if(r3.send(r3d2)==true) {
            emit Bonus(address(this), r3, r3d2);
        }
        address payable r4 = getReferrer(r3);
        uint r4d1 = _min(d1, balanceOf(r4)/16)/_price;
        if(r4.send(r4d1)==true) {
            emit Bonus(address(this), r4, r4d1);
        }
    }

    /**
    * @dev transfer to profit gathering account, for the case if something remain
    * to perform a manual clearence 
    */
    function withdraw(uint256 amount) onlyOwner public returns(bool) {
      _root.transfer(amount);
      return true;
    }


    /**
    * @dev converts string in bytes of the address to address data type
    * @param b is a string in bytes to be converted
    **/
    function _bytesToAddress(bytes memory b) internal pure returns (address payable) {
      uint result = 0;
      for (uint i = b.length-1; i+1 > 0; i--) {
        uint c = uint(uint8(b[i]));
        uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
        result += to_inc;
      }
      return address(result);
    }
  
}


/**
* @dev the main bone which makes referral program easy 
*/
contract SMRT16Personal {
  // address of the guy who invated you
  address payable private _referrer;

  // reference to the parent smart contract
  SMRT16Ext private _smrt16;

  // Event which notifies about new Personal Smart contract created
  event CreatedSMRT16Personal(address indexed addr);

  /**
  * @dev every participant of the project will have his own smart contract
  * which he will be able to share to his referrals
  * this smart contract does proxy sales of the tokens 
  * and unsure that the referrals structure is right
  */
  constructor(address payable referrer, address payable smrt16) public {
    _referrer = referrer;
    _smrt16 = SMRT16Ext(smrt16);
    emit CreatedSMRT16Personal(address(this));
  }

  

  /**
  * @dev fallback function
  */
  function () external payable {
      _smrt16.buyTokens.value(msg.value)(msg.sender, _referrer);
  }
    
}