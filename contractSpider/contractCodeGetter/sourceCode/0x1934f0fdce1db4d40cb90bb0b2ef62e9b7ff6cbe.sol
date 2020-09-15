
# @title KULAP Maker Pool V1
# @notice Source code derive from https://github.com/uniswap
# @notice To remove whitelist feature, need to implement re-entrancy guard on every state change public functions
# @notice To remove whitelist feature, need to handle transferFrom properly (checking success / result)

contract ERC20_2():
    def balanceOf(_owner : address) -> uint256: constant
    def transfer(_to : address, _value : uint256): modifying
    def transferFrom(_from : address, _to : address, _value : uint256): modifying


TokenPurchase: event({buyer: indexed(address), base_sold: indexed(uint256), tokens_bought: indexed(uint256)})
BasePurchase: event({buyer: indexed(address), tokens_sold: indexed(uint256), base_bought: indexed(uint256)})
AddLiquidity: event({provider: indexed(address), base_amount: indexed(uint256), token_amount: indexed(uint256)})
RemoveLiquidity: event({provider: indexed(address), base_amount: indexed(uint256), token_amount: indexed(uint256)})
Transfer: event({_from: indexed(address), _to: indexed(address), _value: uint256})
Approval: event({_owner: indexed(address), _spender: indexed(address), _value: uint256})

UpdateProtocolWallet: event({wallet: indexed(address)})
CollectFee: event({token0Fee: uint256, token1Fee: uint256})
UpdateOwner: event({owner: indexed(address)})
AddLiquidityProvider: event({provider: indexed(address)})
RemoveLiquidityProvider: event({provider: indexed(address)})
UpdateFee: event({poolFee: indexed(uint256), protocolFee: indexed(uint256)})
AddTrader: event({trader: indexed(address)})
RemoveTrader: event({trader: indexed(address)})
Shutdown: event({token0: uint256, token1: uint256})
DisableShutdown: event({})

# Governance
owner: public(address)                            # Owner of the system
providers: public(bool[address])                  # Liquidity providers
providerCount: public(uint256)                    # Number of providers
poolFee: public(uint256)                          # Total fee In bps
protocolFee: public(uint256)                      # Protocol fee In bps
protocolWallet: public(address)                   # Protocol wallet address for fee collection
token0FeeBalance: public(uint256)                 # token0 (base) fee balance
token1FeeBalance: public(uint256)                 # Token1 fee balance
traders: public(bool[address])                    # Trader whitelist
traderCount: public(uint256)                      # Number of traders
allowShutdown: public(bool)                       # Can shutdown

name: public(bytes[64])                           # KULAP Maker Pool V1
symbol: public(bytes[32])                         # KMP1
decimals: public(uint256)                         # 18
totalSupply: public(uint256)                      # total number of UNI in existence
balances: uint256[address]                        # UNI balance of an address
allowances: (uint256[address])[address]           # UNI allowance of one address on another
token0: ERC20_2                                   # address of the ERC20 token traded on this contract
token1: ERC20_2                                   # address of the ERC20 token traded on this contract

# @dev This function acts as a contract constructor which is not currently supported in contracts deployed
@public
def setup(token0_addr: address, token1_addr: address, _owner: address):
    assert self.token0 == ZERO_ADDRESS and token0_addr != ZERO_ADDRESS
    assert self.token1 == ZERO_ADDRESS and token1_addr != ZERO_ADDRESS
    self.token0 = token0_addr
    self.token1 = token1_addr
    self.name = 'KULAP Maker Pool V1'
    self.symbol = 'KMP1'
    self.decimals = 18
    self.owner = _owner
    self.poolFee = 30
    self.protocolFee = 15
    self.protocolWallet = _owner
    self.allowShutdown = True

# @dev whitelist Liquidity Providers.
# @param provider a provider to be whitelisted.
@public
def addLiquidityProvider(provider: address):
    assert msg.sender == self.owner and provider != ZERO_ADDRESS
    assert False == self.providers[provider]
    self.providers[provider] = True
    self.providerCount += 1
    log.AddLiquidityProvider(provider)

# @dev de-whitelist Liquidity Providers.
# @param provider a provider to be removed from whitelists.
@public
def removeLiquidityProvider(provider: address):
    assert msg.sender == self.owner and provider != ZERO_ADDRESS
    assert True == self.providers[provider]
    self.providers[provider] = False
    self.providerCount -= 1
    log.RemoveLiquidityProvider(provider)

# @dev whitelist Traders.
# @param trader a trader to be whitelisted.
@public
def addTrader(trader: address):
    assert msg.sender == self.owner and trader != ZERO_ADDRESS
    assert False == self.traders[trader]
    self.traders[trader] = True
    self.traderCount += 1
    log.AddTrader(trader)

# @dev de-whitelist Traders.
# @param trader a trader to be removed from whitelists.
@public
def removeTrader(trader: address):
    assert msg.sender == self.owner and trader != ZERO_ADDRESS
    assert True == self.traders[trader]
    self.traders[trader] = False
    self.traderCount -= 1
    log.RemoveTrader(trader)

# @notice Liquidity Provider fee = _poolFee - _protocolFee.
# @dev Configure system fees.
# @param _poolFee a fee in bps for overall fee.
# @param _protocolFee a fee in bps for protocol fee.
@public
def setFee(_poolFee: uint256, _protocolFee: uint256):
    assert msg.sender == self.owner
    assert _poolFee <= 1000 # no more than 10%
    assert _protocolFee <= 1000 # no more than 10%
    assert _protocolFee <= _poolFee
    self.poolFee = _poolFee
    self.protocolFee = _protocolFee
    log.UpdateFee(_poolFee, _protocolFee)

# @dev Configure a wallet for protocol fee.
# @param wallet a wallet address for receiving protocol fee.
@public
def setProtocolWallet(wallet: address):
    assert msg.sender == self.owner and wallet != ZERO_ADDRESS
    self.protocolWallet = wallet
    log.UpdateProtocolWallet(wallet)

# @dev Call to collect protocol fees.
@public
def collectProtocolFee():
    self.token0.transfer(self.protocolWallet, self.token0FeeBalance)
    self.token1.transfer(self.protocolWallet, self.token1FeeBalance)
    log.CollectFee(self.token0FeeBalance, self.token1FeeBalance)
    self.token0FeeBalance = 0
    self.token1FeeBalance = 0

# @dev Change owner address.
# @param newOwner new owner address.
@public
def updateOwner(newOwner: address):
    assert msg.sender == self.owner and newOwner != ZERO_ADDRESS
    self.owner = newOwner
    log.UpdateOwner(newOwner)

# @dev Call only once when system need to be shutdown.
@public
def emergencyShutdown():
    assert msg.sender == self.owner
    assert self.allowShutdown
    token0_balance: uint256 = self.token0.balanceOf(self)
    token1_balance: uint256 = self.token1.balanceOf(self)
    self.token0.transfer(msg.sender, token0_balance)
    self.token1.transfer(msg.sender, token1_balance)
    log.Shutdown(token0_balance, token1_balance)

# @dev Permanently disable shutdown feature.
@public
def disableEmergencyShutdown():
    assert msg.sender == self.owner
    assert self.allowShutdown
    self.allowShutdown = False
    log.DisableShutdown()

# @notice Deposit Base and Tokens at current ratio to mint UNI tokens.
# @dev min_liquidity does nothing when total UNI supply is 0.
# @param token0_amount Specific number of token0 deposited.
# @param min_liquidity Minimum number of UNI sender will mint if total UNI supply is greater than 0.
# @param max_tokens Maximum number of token1 deposited. Deposits max amount if total UNI supply is 0.
# @param deadline Time after which this transaction can no longer be executed.
# @return The amount of UNI minted.
@public
def addLiquidity(token0_amount: uint256, min_liquidity: uint256, max_tokens: uint256, deadline: timestamp) -> uint256:
    assert self.providers[msg.sender]
    assert deadline > block.timestamp and (max_tokens > 0 and token0_amount > 0)
    total_liquidity: uint256 = self.totalSupply
    if total_liquidity > 0:
        assert min_liquidity > 0
        token0_reserve: uint256 = self.token0.balanceOf(self) - self.token0FeeBalance
        token1_reserve: uint256 = self.token1.balanceOf(self) - self.token1FeeBalance
        token1_amount: uint256 = token0_amount * token1_reserve / token0_reserve + 1
        liquidity_minted: uint256 = token0_amount * total_liquidity / token0_reserve
        assert max_tokens >= token1_amount and liquidity_minted >= min_liquidity
        self.balances[msg.sender] += liquidity_minted
        self.totalSupply = total_liquidity + liquidity_minted
        self.token0.transferFrom(msg.sender, self, token0_amount)
        self.token1.transferFrom(msg.sender, self, token1_amount)
        log.AddLiquidity(msg.sender, token0_amount, token1_amount)
        log.Transfer(ZERO_ADDRESS, msg.sender, liquidity_minted)
        return liquidity_minted
    else:
        assert (self.token1 != ZERO_ADDRESS) and token0_amount >= 1
        token1_amount: uint256 = max_tokens
        initial_liquidity: uint256 = token0_amount
        self.totalSupply = initial_liquidity
        self.balances[msg.sender] = initial_liquidity
        self.token0.transferFrom(msg.sender, self, token0_amount)
        self.token1.transferFrom(msg.sender, self, token1_amount)
        log.AddLiquidity(msg.sender, token0_amount, token1_amount)
        log.Transfer(ZERO_ADDRESS, msg.sender, initial_liquidity)
        return initial_liquidity

# @dev Burn UNI tokens to withdraw Base and Tokens at current ratio.
# @param amount Amount of UNI burned.
# @param min_tokens_0 Minimum Base withdrawn.
# @param min_tokens_1 Minimum Tokens withdrawn.
# @param deadline Time after which this transaction can no longer be executed.
# @return The amount of Base and Tokens withdrawn.
@public
def removeLiquidity(amount: uint256, min_tokens_0: uint256, min_tokens_1: uint256, deadline: timestamp) -> (uint256, uint256):
    assert self.providers[msg.sender]
    assert (amount > 0 and deadline > block.timestamp) and (min_tokens_0 > 0 and min_tokens_1 > 0)
    total_liquidity: uint256 = self.totalSupply
    assert total_liquidity > 0
    token0_reserve: uint256 = self.token0.balanceOf(self) - self.token0FeeBalance
    token1_reserve: uint256 = self.token1.balanceOf(self) - self.token1FeeBalance
    token0_amount: uint256 = amount * token0_reserve / total_liquidity
    token1_amount: uint256 = amount * token1_reserve / total_liquidity
    assert token0_amount >= min_tokens_0 and token1_amount >= min_tokens_1
    self.balances[msg.sender] -= amount
    self.totalSupply = total_liquidity - amount
    self.token0.transfer(msg.sender, token0_amount)
    self.token1.transfer(msg.sender, token1_amount)
    log.RemoveLiquidity(msg.sender, token0_amount, token1_amount)
    log.Transfer(msg.sender, ZERO_ADDRESS, amount)
    return token0_amount, token1_amount

# @dev Pricing function for converting between Base and Tokens.
# @param input_amount Amount of Base or Tokens being sold.
# @param input_reserve Amount of Base or Tokens (input type) in exchange reserves.
# @param output_reserve Amount of Base or Tokens (output type) in exchange reserves.
# @return Amount of Base or Tokens bought.
@private
@constant
def getInputPrice(input_amount: uint256, input_reserve: uint256, output_reserve: uint256) -> uint256:
    assert input_reserve > 0 and output_reserve > 0
    input_amount_with_fee: uint256 = input_amount * (10000 - self.poolFee)
    numerator: uint256 = input_amount_with_fee * output_reserve
    denominator: uint256 = (input_reserve * 10000) + input_amount_with_fee
    return numerator / denominator

# @dev Pricing function for converting between Base and Tokens.
# @param output_amount Amount of Base or Tokens being bought.
# @param input_reserve Amount of Base or Tokens (input type) in exchange reserves.
# @param output_reserve Amount of Base or Tokens (output type) in exchange reserves.
# @return Amount of Base or Tokens sold.
@private
@constant
def getOutputPrice(output_amount: uint256, input_reserve: uint256, output_reserve: uint256) -> uint256:
    assert input_reserve > 0 and output_reserve > 0
    numerator: uint256 = input_reserve * output_amount * 10000
    denominator: uint256 = (output_reserve - output_amount) * (10000 - self.poolFee)
    return numerator / denominator + 1

@private
def accountProtocolFee(input_amount: uint256, is_base: bool):
    if self.protocolFee > 0:
        fee: uint256 = input_amount * self.protocolFee / 10000
        if is_base:
            self.token0FeeBalance += fee
        else:
            self.token1FeeBalance += fee

@private
def baseToTokenInput(base_sold: uint256, min_tokens: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
    assert deadline >= block.timestamp and (base_sold > 0 and min_tokens > 0)
    token0_reserve: uint256 = self.token0.balanceOf(self) - self.token0FeeBalance
    token1_reserve: uint256 = self.token1.balanceOf(self) - self.token1FeeBalance
    tokens_bought: uint256 = self.getInputPrice(base_sold, token0_reserve, token1_reserve)
    assert tokens_bought >= min_tokens
    self.token0.transferFrom(buyer, self, base_sold)
    self.token1.transfer(recipient, tokens_bought)
    self.accountProtocolFee(base_sold, True)
    log.TokenPurchase(buyer, base_sold, tokens_bought)
    return tokens_bought

# @notice Convert Base to Tokens.
# @param base_sold specifies exact base input.
# @param min_tokens Minimum Tokens bought.
# @param deadline Time after which this transaction can no longer be executed.
# @return Amount of Tokens bought.
@public
def baseToTokenSwapInput(base_sold: uint256, min_tokens: uint256, deadline: timestamp) -> uint256:
    assert self.traders[msg.sender]
    return self.baseToTokenInput(base_sold, min_tokens, deadline, msg.sender, msg.sender)

# @notice Convert Base to Tokens and transfers Tokens to recipient.
# @param base_sold specifies exact base input.
# @param min_tokens Minimum Tokens bought.
# @param deadline Time after which this transaction can no longer be executed.
# @param recipient The address that receives output Tokens.
# @return Amount of Tokens bought.
@public
def baseToTokenTransferInput(base_sold: uint256, min_tokens: uint256, deadline: timestamp, recipient: address) -> uint256:
    assert self.traders[msg.sender]
    assert recipient != self and recipient != ZERO_ADDRESS
    return self.baseToTokenInput(base_sold, min_tokens, deadline, msg.sender, recipient)

@private
def baseToTokenOutput(tokens_bought: uint256, max_base: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
    assert deadline >= block.timestamp and (tokens_bought > 0 and max_base > 0)
    token0_reserve: uint256 = self.token0.balanceOf(self) - self.token0FeeBalance
    token1_reserve: uint256 = self.token1.balanceOf(self) - self.token1FeeBalance
    base_sold: uint256 = self.getOutputPrice(tokens_bought, token0_reserve, token1_reserve)
    assert max_base >= base_sold
    self.token0.transferFrom(buyer, self, base_sold)
    self.token1.transfer(recipient, tokens_bought)
    self.accountProtocolFee(base_sold, True)
    log.TokenPurchase(buyer, base_sold, tokens_bought)
    return base_sold

# @notice Convert Base to Tokens.
# @param tokens_bought Amount of tokens bought.
# @param max_base specifies the max base input.
# @param deadline Time after which this transaction can no longer be executed.
# @return Amount of Base sold.
@public
def baseToTokenSwapOutput(tokens_bought: uint256, max_base: uint256, deadline: timestamp) -> uint256:
    assert self.traders[msg.sender]
    return self.baseToTokenOutput(tokens_bought, max_base, deadline, msg.sender, msg.sender)

# @notice Convert Base to Tokens and transfers Tokens to recipient.
# @param tokens_bought Amount of tokens bought.
# @param max_base specifies the max base input.
# @param deadline Time after which this transaction can no longer be executed.
# @param recipient The address that receives output Tokens.
# @return Amount of Base sold.
@public
def baseToTokenTransferOutput(tokens_bought: uint256, max_base: uint256, deadline: timestamp, recipient: address) -> uint256:
    assert self.traders[msg.sender]
    assert recipient != self and recipient != ZERO_ADDRESS
    return self.baseToTokenOutput(tokens_bought, max_base, deadline, msg.sender, recipient)

@private
def tokenToBaseInput(tokens_sold: uint256, min_base: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
    assert deadline >= block.timestamp and (tokens_sold > 0 and min_base > 0)
    token0_reserve: uint256 = self.token0.balanceOf(self) - self.token0FeeBalance
    token1_reserve: uint256 = self.token1.balanceOf(self) - self.token1FeeBalance
    base_bought: uint256 = self.getInputPrice(tokens_sold, token1_reserve, token0_reserve)
    assert base_bought >= min_base
    self.token0.transfer(recipient, base_bought)
    self.token1.transferFrom(buyer, self, tokens_sold)
    self.accountProtocolFee(tokens_sold, False)
    log.BasePurchase(buyer, tokens_sold, base_bought)
    return base_bought


# @notice Convert Tokens to Base.
# @dev User specifies exact input and minimum output.
# @param tokens_sold Amount of Tokens sold.
# @param min_base Minimum Base purchased.
# @param deadline Time after which this transaction can no longer be executed.
# @return Amount of Base bought.
@public
def tokenToBaseSwapInput(tokens_sold: uint256, min_base: uint256, deadline: timestamp) -> uint256:
    assert self.traders[msg.sender]
    return self.tokenToBaseInput(tokens_sold, min_base, deadline, msg.sender, msg.sender)

# @notice Convert Tokens to Base and transfers Base to recipient.
# @dev User specifies exact input and minimum output.
# @param tokens_sold Amount of Tokens sold.
# @param min_base Minimum Base purchased.
# @param deadline Time after which this transaction can no longer be executed.
# @param recipient The address that receives output Base.
# @return Amount of Base bought.
@public
def tokenToBaseTransferInput(tokens_sold: uint256, min_base: uint256, deadline: timestamp, recipient: address) -> uint256:
    assert self.traders[msg.sender]
    assert recipient != self and recipient != ZERO_ADDRESS
    return self.tokenToBaseInput(tokens_sold, min_base, deadline, msg.sender, recipient)

@private
def tokenToBaseOutput(base_bought: uint256, max_tokens: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
    assert deadline >= block.timestamp and base_bought > 0
    token0_reserve: uint256 = self.token0.balanceOf(self) - self.token0FeeBalance
    token1_reserve: uint256 = self.token1.balanceOf(self) - self.token1FeeBalance
    tokens_sold: uint256 = self.getOutputPrice(base_bought, token1_reserve, token0_reserve)
    # tokens sold is always > 0
    assert max_tokens >= tokens_sold
    self.token0.transfer(recipient, base_bought)
    self.token1.transferFrom(buyer, self, tokens_sold)
    self.accountProtocolFee(tokens_sold, False)
    log.BasePurchase(buyer, tokens_sold, base_bought)
    return tokens_sold

# @notice Convert Tokens to Base.
# @dev User specifies maximum input and exact output.
# @param base_bought Amount of Base purchased.
# @param max_tokens Maximum Tokens sold.
# @param deadline Time after which this transaction can no longer be executed.
# @return Amount of Tokens sold.
@public
def tokenToBaseSwapOutput(base_bought: uint256, max_tokens: uint256, deadline: timestamp) -> uint256:
    assert self.traders[msg.sender]
    return self.tokenToBaseOutput(base_bought, max_tokens, deadline, msg.sender, msg.sender)

# @notice Convert Tokens to Base and transfers Base to recipient.
# @dev User specifies maximum input and exact output.
# @param base_bought Amount of Base purchased.
# @param max_tokens Maximum Tokens sold.
# @param deadline Time after which this transaction can no longer be executed.
# @param recipient The address that receives output Base.
# @return Amount of Tokens sold.
@public
def tokenToBaseTransferOutput(base_bought: uint256, max_tokens: uint256, deadline: timestamp, recipient: address) -> uint256:
    assert self.traders[msg.sender]
    assert recipient != self and recipient != ZERO_ADDRESS
    return self.tokenToBaseOutput(base_bought, max_tokens, deadline, msg.sender, recipient)

# @notice Public price function for Base to Token trades with an exact input.
# @param base_sold Amount of Base sold.
# @return Amount of Tokens that can be bought with input Base.
@public
@constant
def getBaseToTokenInputPrice(base_sold: uint256) -> uint256:
    assert base_sold > 0
    token0_reserve: uint256 = self.token0.balanceOf(self) - self.token0FeeBalance
    token1_reserve: uint256 = self.token1.balanceOf(self) - self.token1FeeBalance
    return self.getInputPrice(base_sold, token0_reserve, token1_reserve)

# @notice Public price function for Base to Token trades with an exact output.
# @param tokens_bought Amount of Tokens bought.
# @return Amount of Base needed to buy output Tokens.
@public
@constant
def getBaseToTokenOutputPrice(tokens_bought: uint256) -> uint256:
    assert tokens_bought > 0
    token0_reserve: uint256 = self.token0.balanceOf(self) - self.token0FeeBalance
    token1_reserve: uint256 = self.token1.balanceOf(self) - self.token1FeeBalance
    base_sold: uint256 = self.getOutputPrice(tokens_bought, token0_reserve, token1_reserve)
    return base_sold

# @notice Public price function for Token to Base trades with an exact input.
# @param tokens_sold Amount of Tokens sold.
# @return Amount of Base that can be bought with input Tokens.
@public
@constant
def getTokenToBaseInputPrice(tokens_sold: uint256) -> uint256:
    assert tokens_sold > 0
    token0_reserve: uint256 = self.token0.balanceOf(self) - self.token0FeeBalance
    token1_reserve: uint256 = self.token1.balanceOf(self) - self.token1FeeBalance
    base_bought: uint256 = self.getInputPrice(tokens_sold, token1_reserve, token0_reserve)
    return base_bought

# @notice Public price function for Token to Base trades with an exact output.
# @param base_bought Amount of output Base.
# @return Amount of Tokens needed to buy output Base.
@public
@constant
def getTokenToBaseOutputPrice(base_bought: uint256) -> uint256:
    assert base_bought > 0
    token0_reserve: uint256 = self.token0.balanceOf(self) - self.token0FeeBalance
    token1_reserve: uint256 = self.token1.balanceOf(self) - self.token1FeeBalance
    return self.getOutputPrice(base_bought, token1_reserve, token0_reserve)

# @return Address of Token0 that is sold on this exchange.
@public
@constant
def token0Address() -> address(ERC20_2):
    return self.token0

# @return Address of Token1 that is sold on this exchange.
@public
@constant
def token1Address() -> address(ERC20_2):
    return self.token1

# ERC20 compatibility for exchange liquidity modified from
# https://github.com/ethereum/vyper/blob/master/examples/tokens/ERC20.vy
@public
@constant
def balanceOf(_owner : address) -> uint256:
    return self.balances[_owner]

@public
def transfer(_to : address, _value : uint256) -> bool:
    self.balances[msg.sender] -= _value
    self.balances[_to] += _value
    log.Transfer(msg.sender, _to, _value)
    return True

@public
def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
    self.balances[_from] -= _value
    self.balances[_to] += _value
    self.allowances[_from][msg.sender] -= _value
    log.Transfer(_from, _to, _value)
    return True

@public
def approve(_spender : address, _value : uint256) -> bool:
    self.allowances[msg.sender][_spender] = _value
    log.Approval(msg.sender, _spender, _value)
    return True

@public
@constant
def allowance(_owner : address, _spender : address) -> uint256:
    return self.allowances[_owner][_spender]