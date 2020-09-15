/**
 *Submitted for verification at Etherscan.io on 2020-05-31
*/

pragma solidity ^0.5.15;

interface ERC20 {
  function totalSupply()  external view returns (uint supply);
  function balanceOf(address _owner)  external view returns (uint balance);
  function transfer(address _to, uint _value)  external returns (bool success);
  function transferFrom(address _from, address _to, uint _value)  external returns (bool success);
  function approve(address _spender, uint _value)  external returns (bool success);
  function allowance(address _owner, address _spender) external view returns (uint remaining);
  function decimals() external view returns(uint digits);
  event Approval(address indexed _owner, address indexed _spender, uint _value);

}

contract HexDex {
  /*=================================
  =            MODIFIERS            =
  =================================*/
  // only people with tokens
  modifier onlyBagholders() {
      require(myTokens() > 0);
      _;
  }

  // only people with profits
  modifier onlyStronghands() {
      require(myDividends(true) > 0);
      _;
  }

  modifier onlyAdmin(){
      require(msg.sender == administrator);
      _;
  }


  /*==============================
  =            EVENTS            =
  ==============================*/
  event onTokenPurchase(
      address indexed customerAddress,
      bytes32 customerName,
      uint256 incomingEthereum,
      uint256 tokensMinted,
      address indexed referredBy,
      bool isReinvest
  );

  event onTokenSell(
      address indexed customerAddress,
      bytes32 customerName,
      uint256 tokensBurned,
      uint256 ethereumEarned
  );

  event onWithdraw(
      address indexed customerAddress,
      bytes32 customerName,
      uint256 ethereumWithdrawn
  );

  // ERC20
  event Transfer(
      address indexed from,
      address indexed to,
      uint256 tokens
  );


  /*=====================================
  =            CONFIGURABLES            =
  =====================================*/
  string public name = "HexDex";
  string public symbol = "H3D";
  uint8 constant public decimals = 8;
  uint8 constant internal dividendFee_ = 10; // 10%
  uint256 constant internal HEX_CENT = 1e6;
  uint256 constant internal HEX = 1e8;
  uint256 constant internal tokenPriceInitial_ = 1 * HEX;
  uint256 constant internal tokenPriceIncremental_ = 10 * HEX_CENT;
  uint256 constant internal magnitude = 2**64;
  address constant internal tokenAddress = address(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39);
  uint256 internal cubeStartTime = now;

  // admin for premine lock
  address internal administrator;

      // ambassadors
      bool ambassadorClosed;
      uint256 firstBuyTokens;
      uint256 firstBuyAmount;
      uint256 ambassadorLimit = HEX * 20000; // 20k hex per ambassador
      uint256 devLimit = HEX * 100000;
      mapping(address => bool) public ambassadors; // who the ambassadors are
      mapping(address => bool) public dev;

      address[33] ambassadorList = [
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000,
         0x0000000000000000000000000000000000000000
         ];

      address[9] devList = [
          0x0000000000000000000000000000000000000000,
          0x0000000000000000000000000000000000000000,
          0x0000000000000000000000000000000000000000,
          0x0000000000000000000000000000000000000000,
          0x0000000000000000000000000000000000000000,
          0x0000000000000000000000000000000000000000,
          0x0000000000000000000000000000000000000000,
          0x0000000000000000000000000000000000000000,
          0x0000000000000000000000000000000000000000
      ];

      uint256 numAmbassadorsDeposited;

      function depositPremine() public {
          // Will be removed for launch
          revert("This contract is for review/audit purposes only. Do not do stuff with it...");
          
          require(ambassadors[msg.sender]); // require them to be an ambassador
          ambassadors[msg.sender] = false;  // make them not an ambassador after this transaction! so they can't buy in twice
          ERC20 Hex = ERC20(tokenAddress);

          // you must deposit EXACTLY 20k
          Hex.transferFrom(msg.sender, address(this), ambassadorLimit);
          numAmbassadorsDeposited++;
      }

      uint256 numDevDeposited;

      function depositDevPremine() public {
          require(dev[msg.sender]);
          require(ambassadorClosed);
          dev[msg.sender] = false;
          ERC20 Hex = ERC20(tokenAddress);

          Hex.transferFrom(msg.sender, address(this), devLimit);
          numDevDeposited++;
      }

      function executePremineBuy() onlyAdmin() public {
        require(now < cubeStartTime);
        ERC20 Hex = ERC20(tokenAddress);

        // first buy in with 1 hex so that we don't black hole a bunch of stuff
        Hex.transferFrom(msg.sender, address(this), 1 * HEX);
        purchaseTokens(1*HEX, address(0x0), false);

        // then buy in the full amount with the amount of hex in the contract minus 1
        purchaseTokens(Hex.balanceOf(address(this))-(1*HEX), address(0x0), false);

        // now that we have a bunch of tokens, transfer them out to each ambassador fairly!
        uint256 premineTokenShare = tokenSupply_ / numAmbassadorsDeposited;

        for(uint i=0; i<33; i++) {
          // if this call returns false, it means the person is NO LONGER an ambassador - which means they HAVE deposited
          // which means we SHOULD give them their token share!
          if (ambassadors[ambassadorList[i]] == false) {
            transfer(ambassadorList[i], premineTokenShare);
          }
        }
      ambassadorClosed = true;
      firstBuyAmount = Hex.balanceOf(address(this))-(1*HEX);
      firstBuyTokens = tokenSupply_;
      }

      function executeDevBuy() onlyAdmin() public {
        require(now < cubeStartTime);
        require(ambassadorClosed);
        ERC20 Hex = ERC20(tokenAddress);

        // first buy in with 1 hex so that we don't black hole a bunch of stuff
        Hex.transferFrom(msg.sender, address(this), 1 * HEX);
        purchaseTokens(1*HEX, address(0x0), false);

        // then buy in the full amount with the amount of hex in the contract minus premine buy
        purchaseTokens(Hex.balanceOf(address(this))-firstBuyAmount-(1*HEX), address(0x0), false);

        // now that we have a bunch of tokens, transfer them out to each ambassador fairly!
        uint256 premineTokenShare = (tokenSupply_ - firstBuyTokens) / numDevDeposited;
        
        for(uint i=0; i<9; i++) {
          // if this call returns false, it means the person is NO LONGER an ambassador - which means they HAVE deposited
          // which means we SHOULD give them their token share!
          if (dev[devList[i]] == false) {
            transfer(devList[i], premineTokenShare);
          }
        }
      }

      function restart() onlyAdmin() public{
        require(now < cubeStartTime);
        // Only called if something goes wrong during premine
        ERC20 Hex = ERC20(tokenAddress);
        Hex.transfer(administrator, Hex.balanceOf(address(this)));
      }

  // username interface
  UsernameInterface private username;

 /*================================
  =            DATASETS            =
  ================================*/
  // amount of shares for each address (scaled number)
  mapping(address => uint256) internal tokenBalanceLedger_;
  mapping(address => uint256) internal referralBalance_;
  mapping(address => int256) internal payoutsTo_;
  mapping(address => bool) internal approvedDistributors;
  uint256 internal tokenSupply_ = 0;
  uint256 internal profitPerShare_;

  /*=======================================
  =            PUBLIC FUNCTIONS            =
  =======================================*/
  /*
  * -- APPLICATION ENTRY POINTS --
  */
  constructor(address usernameAddress, uint256 when_start)
      public
  {
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;
     ambassadors[0x0000000000000000000000000000000000000000] = true;


     dev[0x0000000000000000000000000000000000000000] = true;
     dev[0x0000000000000000000000000000000000000000] = true;
     dev[0x0000000000000000000000000000000000000000] = true;
     dev[0x0000000000000000000000000000000000000000] = true;
     dev[0x0000000000000000000000000000000000000000] = true;
     dev[0x0000000000000000000000000000000000000000] = true;
     dev[0x0000000000000000000000000000000000000000] = true;
     dev[0x0000000000000000000000000000000000000000] = true;
     dev[0x0000000000000000000000000000000000000000] = true;


    username = UsernameInterface(usernameAddress);
    cubeStartTime = when_start;
    administrator = msg.sender;
  }

  function startTime() public view returns(uint256 _startTime){
    _startTime = cubeStartTime;
  }
  function approveDistributor(address newDistributor)
      onlyAdmin()
      public
  {
      approvedDistributors[newDistributor] = true;
  }

  /**
   * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
   */
  function buy(address _referredBy, uint256 amount)
      public
      returns(uint256)
  {
      // Will be removed for launch
      revert("This contract is for review/audit purposes only. Do not do stuff with it...");
      
      ERC20 Hex = ERC20(tokenAddress);
      Hex.transferFrom(msg.sender,address(this),amount);
      purchaseTokens(amount, _referredBy, false);
  }

  /**
   * refuse to receive any tokens directly sent
   *
   */
  function()
      external
      payable
  {
      revert();
  }

  function distribute(uint256 amount)
      external
      payable
  {
      require(approvedDistributors[msg.sender] == true);
      ERC20 Hex = ERC20(tokenAddress);
      Hex.transferFrom(msg.sender,address(this),amount);
      profitPerShare_ = SafeMath.add(profitPerShare_, (amount * magnitude) / tokenSupply_);
  }

  /**
   * Converts all of caller's dividends to tokens.
   */
  function reinvest()
      onlyStronghands()
      public
  {
      // fetch dividends
      uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code

      // pay out the dividends virtually
      address _customerAddress = msg.sender;
      payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);

      // retrieve ref. bonus
      _dividends += referralBalance_[_customerAddress];
      referralBalance_[_customerAddress] = 0;

      // dispatch a buy order with the virtualized "withdrawn dividends"
      purchaseTokens(_dividends, address(0x0), true);
  }

  /**
   * Alias of sell() and withdraw().
   */
  function exit()
      public
  {
      // get token count for caller & sell them all
      address _customerAddress = msg.sender;
      uint256 _tokens = tokenBalanceLedger_[_customerAddress];
      if(_tokens > 0) sell(_tokens);

      withdraw();
  }

  /**
   * Withdraws all of the callers earnings.
   */
  function withdraw()
      onlyStronghands()
      public
  {
      // setup data
      address _customerAddress = msg.sender;
      uint256 _dividends = myDividends(false); // get ref. bonus later in the code

      // update dividend tracker
      payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);

      // add ref. bonus
      _dividends += referralBalance_[_customerAddress];
      referralBalance_[_customerAddress] = 0;

      // lambo delivery service
      ERC20 Hex = ERC20(tokenAddress);
      Hex.transfer(_customerAddress,_dividends);

      // fire event
      emit onWithdraw(_customerAddress, username.getNameByAddress(msg.sender), _dividends);
  }

  /**
   * Liquifies tokens to ethereum.
   */
  function sell(uint256 _amountOfTokens)
      onlyBagholders()
      public
  {
      // Will be removed for launch
      revert("This contract is for review/audit purposes only. Do not do stuff with it...");
          
      // setup data
      address _customerAddress = msg.sender;
      require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
      uint256 _tokens = _amountOfTokens;
      uint256 _ethereum = tokensToEthereum_(_tokens);
      uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
      uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);

      // burn the sold tokens
      tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
      tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);

      // update dividends tracker
      int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
      payoutsTo_[_customerAddress] -= _updatedPayouts;

      // dividing by zero is a bad idea
      if (tokenSupply_ > 0) {
          // update the amount of dividends per token
          profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
      }

      // fire event
      emit onTokenSell(_customerAddress, username.getNameByAddress(msg.sender), _tokens, _taxedEthereum);
  }


  /**
   * To heck with the transfer fee
   * Who needs it
   */
  function transfer(address _toAddress, uint256 _amountOfTokens)
      onlyBagholders()
      public
      returns(bool)
  {
      // setup
      address _customerAddress = msg.sender;

      // make sure we have the requested tokens
      require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);

      // withdraw all outstanding dividends first
      if(myDividends(true) > 0) withdraw();

      // exchange tokens
      tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
      tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);

      // update dividend trackers
      payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
      payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);

      // fire event
      emit Transfer(_customerAddress, _toAddress, _amountOfTokens);

      // ERC20
      return true;
  }

  /*----------  HELPERS AND CALCULATORS  ----------*/
  /**
   * Method to view the current Ethereum stored in the contract
   * Example: totalEthereumBalance()
   */
  function totalEthereumBalance()
      public
      view
      returns(uint)
  {
      return address(this).balance;
  }

  /**
   * Retrieve the total token supply.
   */
  function totalSupply()
      public
      view
      returns(uint256)
  {
      return tokenSupply_;
  }
  
  /**
   * Retrieve the number of aambassadors deposited.
   */
  function numAmbassadorsDep()
      public
      view
      returns(uint256)
  {
      return numAmbassadorsDeposited;
  }
  
  /**
   * Retrieve the number of developers deposited.
   */
  function numDevDep()
      public
      view
      returns(uint256)
  {
      return numDevDeposited;
  }
  
  /**
   * Retruns the ammbassadorClosed.
   */
  function ambassClosed()
      public
      view
      returns(bool)
  {
      return ambassadorClosed;
  }

  /**
   * Retrieve the tokens owned by the caller.
   */
  function myTokens()
      public
      view
      returns(uint256)
  {
      address _customerAddress = msg.sender;
      return balanceOf(_customerAddress);
  }

  /**
   * Retrieve the dividends owned by the caller.
   * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
   * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
   * But in the internal calculations, we want them separate.
   */
  function myDividends(bool _includeReferralBonus)
      public
      view
      returns(uint256)
  {
      address _customerAddress = msg.sender;
      return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
  }

  /**
   * Retrieve the token balance of any single address.
   */
  function balanceOf(address _customerAddress)
      view
      public
      returns(uint256)
  {
      return tokenBalanceLedger_[_customerAddress];
  }

  /**
   * Retrieve the dividend balance of any single address.
   */
  function dividendsOf(address _customerAddress)
      view
      public
      returns(uint256)
  {
      return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
  }

  /**
   * Return the sell price of 1 individual token.
   */
  function sellPrice()
      public
      view
      returns(uint256)
  {
      // our calculation relies on the token supply, so we need supply.
      if(tokenSupply_ == 0){
          return tokenPriceInitial_ - tokenPriceIncremental_;
      } else {
          uint256 _ethereum = tokensToEthereum_(1e8);
          uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
          uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
          return _taxedEthereum;
      }
  }

  /**
   * Return the buy price of 1 individual token.
   */
  function buyPrice()
        public
        view
        returns(uint256)
    {
        if(tokenSupply_ == 0){
            return tokenPriceInitial_ + tokenPriceIncremental_;
        } else {
            uint256 _ethereum = tokensToEthereum_(1e8);
            uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
            uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
            return _taxedEthereum;
        }
    }

  /**
   * Function for the frontend to dynamically retrieve the price scaling of buy orders.
   */
  function calculateTokensReceived(uint256 _ethereumToSpend)
      public
      view
      returns(uint256)
  {
      uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
      uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
      uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);

      return _amountOfTokens;
  }

  /**
   * Function for the frontend to dynamically retrieve the price scaling of sell orders.
   */
  function calculateEthereumReceived(uint256 _tokensToSell)
      public
      view
      returns(uint256)
  {
      require(_tokensToSell <= tokenSupply_);
      uint256 _ethereum = tokensToEthereum_(_tokensToSell);
      uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
      uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
      return _taxedEthereum;
  }


  /*==========================================
  =            INTERNAL FUNCTIONS            =
  ==========================================*/
  function purchaseTokens(uint256 _incomingEthereum, address _referredBy, bool isReinvest)
      internal
      returns(uint256)
  {
              if (now < startTime()) { require(msg.sender == administrator); }

      // data setup
      uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
      uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
      uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
      uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
      uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
      uint256 _fee = _dividends * magnitude;

      require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));

      // is the user referred by a masternode?
      if(
          // is this a referred purchase?
          _referredBy != 0x0000000000000000000000000000000000000000 &&

          // no cheating!
          _referredBy != msg.sender
      ){
          // wealth redistribution
          referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
      } else {
          // no ref purchase
          // add the referral bonus back to the global dividends
          _dividends = SafeMath.add(_dividends, _referralBonus);
          _fee = _dividends * magnitude;
      }

      // we can't give people infinite ethereum
      if(tokenSupply_ > 0){

          // add tokens to the pool
          tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);

          // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
          profitPerShare_ += (_dividends * magnitude / (tokenSupply_));

          // calculate the amount of tokens the customer receives over his purchase
          _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));

      } else {
          // add tokens to the pool
          tokenSupply_ = _amountOfTokens;
      }

      // update circulating supply & the ledger address for the customer
      tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);

      // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
      //really i know you think you do but you don't
      int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
      payoutsTo_[msg.sender] += _updatedPayouts;

      // fire event
      emit onTokenPurchase(msg.sender, username.getNameByAddress(msg.sender), _incomingEthereum, _amountOfTokens, _referredBy, isReinvest);

      return _amountOfTokens;
  }

  /**
   * Calculate Token price based on an amount of incoming ethereum
   * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
   * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
   */
  function ethereumToTokens_(uint256 _ethereum)
      internal
      view
      returns(uint256)
  {
      uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e8;
      uint256 _tokensReceived =
       (
          (
              SafeMath.sub(
                  (sqrt
                      (
                          (_tokenPriceInitial**2)
                          +
                          (2*(tokenPriceIncremental_ * 1e8)*(_ethereum * 1e8))
                          +
                          (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
                          +
                          (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
                      )
                  ), _tokenPriceInitial
              )
          )/(tokenPriceIncremental_)
      )-(tokenSupply_)
      ;

      return _tokensReceived;
  }

  /**
   * Calculate token sell value.
   * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
   * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
   */
   function tokensToEthereum_(uint256 _tokens)
      internal
      view
      returns(uint256)
  {

      uint256 tokens_ = (_tokens + 1e8);
      uint256 _tokenSupply = (tokenSupply_ + 1e8);
      uint256 _etherReceived =
      (
          SafeMath.sub(
              (
                  (
                      (
                          tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e8))
                      )-tokenPriceIncremental_
                  )*(tokens_ - 1e8)
              ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e8))/2
          )
      /1e8);
      return _etherReceived;
  }


  //This is where all your gas goes apparently
  function sqrt(uint x) internal pure returns (uint y) {
      uint z = (x + 1) / 2;
      y = x;
      while (z < y) {
          y = z;
          z = (x / z + z) / 2;
      }
  }
}

interface UsernameInterface {
  function getNameByAddress(address _addr) external view returns (bytes32);
}

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
      uint256 c = a / b;
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