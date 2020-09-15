
# @title KULAP Maker Pool V1
# @notice Source code derive from https://github.com/uniswap
# @notice To remove whitelist feature, need to implement re-entrancy guard on every state change public functions
# @notice To remove whitelist feature, need to handle transferFrom properly (checking success / result)

contract ERC20_2():
    def balanceOf(_owner : address) -> uint256: constant
    def transfer(_to : address, _value : uint256): modifying
    def transferFrom(_from : address, _to : address, _value : uint256): modifying

TokenPurchase: event({buyer: indexed(address), eth_sold: indexed(uint256(wei)), tokens_bought: indexed(uint256)})
EthPurchase: event({buyer: indexed(address), tokens_sold: indexed(uint256), eth_bought: indexed(uint256(wei))})
AddLiquidity: event({provider: indexed(address), eth_amount: indexed(uint256(wei)), token_amount: indexed(uint256)})
RemoveLiquidity: event({provider: indexed(address), eth_amount: indexed(uint256(wei)), token_amount: indexed(uint256)})
Transfer: event({_from: indexed(address), _to: indexed(address), _value: uint256})
Approval: event({_owner: indexed(address), _spender: indexed(address), _value: uint256})

UpdateProtocolWallet: event({wallet: indexed(address)})
CollectFee: event({ethFee: uint256(wei), token1Fee: uint256})
UpdateOwner: event({owner: indexed(address)})
AddLiquidityProvider: event({provider: indexed(address)})
RemoveLiquidityProvider: event({provider: indexed(address)})
UpdateFee: event({poolFee: indexed(uint256), protocolFee: indexed(uint256)})
AddTrader: event({trader: indexed(address)})
RemoveTrader: event({trader: indexed(address)})
Shutdown: event({eth: uint256(wei), token1: uint256})
DisableShutdown: event({})

# Governance
owner: public(address)                            # Owner of the system
providers: public(bool[address])                  # Liquidity providers
providerCount: public(uint256)                    # Number of providers
poolFee: public(uint256)                          # Total fee In bps
protocolFee: public(uint256)                      # Protocol fee In bps
protocolWallet: public(address)                   # Protocol wallet address for fee collection
ethFeeBalance: public(uint256(wei))               # eth fee balance
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
token: ERC20_2                                    # address of the ERC20 token traded on this contract

# @dev This function acts as a contract constructor which is not currently supported in contracts deployed
@public
def setup(token_addr: address, _owner: address):
    assert self.token == ZERO_ADDRESS and token_addr != ZERO_ADDRESS
    self.token = token_addr
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
    send(self.protocolWallet, self.ethFeeBalance)
    self.token.transfer(self.protocolWallet, self.token1FeeBalance)
    log.CollectFee(self.ethFeeBalance, self.token1FeeBalance)
    self.ethFeeBalance = 0
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
    eth_balance: uint256(wei) = self.balance
    token1_balance: uint256 = self.token.balanceOf(self)
    send(msg.sender, eth_balance)
    self.token.transfer(msg.sender, token1_balance)
    log.Shutdown(eth_balance, token1_balance)

# @dev Permanently disable shutdown feature.
@public
def disableEmergencyShutdown():
    assert msg.sender == self.owner
    assert self.allowShutdown
    self.allowShutdown = False
    log.DisableShutdown()

# @notice Deposit ETH and Tokens (self.token) at current ratio to mint UNI tokens.
# @dev min_liquidity does nothing when total UNI supply is 0.
# @param min_liquidity Minimum number of UNI sender will mint if total UNI supply is greater than 0.
# @param max_tokens Maximum number of tokens deposited. Deposits max amount if total UNI supply is 0.
# @param deadline Time after which this transaction can no longer be executed.
# @return The amount of UNI minted.
@public
@payable
def addLiquidity(min_liquidity: uint256, max_tokens: uint256, deadline: timestamp) -> uint256:
    assert self.providers[msg.sender]
    assert deadline > block.timestamp and (max_tokens > 0 and msg.value > 0)
    total_liquidity: uint256 = self.totalSupply
    if total_liquidity > 0:
        assert min_liquidity > 0
        eth_reserve: uint256(wei) = self.balance - msg.value - self.ethFeeBalance
        token_reserve: uint256 = self.token.balanceOf(self) - self.token1FeeBalance
        token_amount: uint256 = msg.value * token_reserve / eth_reserve + 1
        liquidity_minted: uint256 = msg.value * total_liquidity / eth_reserve
        assert max_tokens >= token_amount and liquidity_minted >= min_liquidity
        self.balances[msg.sender] += liquidity_minted
        self.totalSupply = total_liquidity + liquidity_minted
        self.token.transferFrom(msg.sender, self, token_amount)
        log.AddLiquidity(msg.sender, msg.value, token_amount)
        log.Transfer(ZERO_ADDRESS, msg.sender, liquidity_minted)
        return liquidity_minted
    else:
        assert self.token != ZERO_ADDRESS and msg.value >= 1000000000
        token_amount: uint256 = max_tokens
        initial_liquidity: uint256 = as_unitless_number(self.balance)
        self.totalSupply = initial_liquidity
        self.balances[msg.sender] = initial_liquidity
        self.token.transferFrom(msg.sender, self, token_amount)
        log.AddLiquidity(msg.sender, msg.value, token_amount)
        log.Transfer(ZERO_ADDRESS, msg.sender, initial_liquidity)
        return initial_liquidity

# @dev Burn UNI tokens to withdraw ETH and Tokens at current ratio.
# @param amount Amount of UNI burned.
# @param min_eth Minimum ETH withdrawn.
# @param min_tokens Minimum Tokens withdrawn.
# @param deadline Time after which this transaction can no longer be executed.
# @return The amount of ETH and Tokens withdrawn.
@public
def removeLiquidity(amount: uint256, min_eth: uint256(wei), min_tokens: uint256, deadline: timestamp) -> (uint256(wei), uint256):
    assert self.providers[msg.sender]
    assert (amount > 0 and deadline > block.timestamp) and (min_eth > 0 and min_tokens > 0)
    total_liquidity: uint256 = self.totalSupply
    assert total_liquidity > 0
    eth_reserve: uint256(wei) = self.balance - self.ethFeeBalance
    token_reserve: uint256 = self.token.balanceOf(self) - self.token1FeeBalance
    eth_amount: uint256(wei) = amount * eth_reserve / total_liquidity
    token_amount: uint256 = amount * token_reserve / total_liquidity
    assert eth_amount >= min_eth and token_amount >= min_tokens
    self.balances[msg.sender] -= amount
    self.totalSupply = total_liquidity - amount
    send(msg.sender, eth_amount)
    self.token.transfer(msg.sender, token_amount)
    log.RemoveLiquidity(msg.sender, eth_amount, token_amount)
    log.Transfer(msg.sender, ZERO_ADDRESS, amount)
    return eth_amount, token_amount

# @dev Pricing function for converting between ETH and Tokens.
# @param input_amount Amount of ETH or Tokens being sold.
# @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
# @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
# @return Amount of ETH or Tokens bought.
@private
@constant
def getInputPrice(input_amount: uint256, input_reserve: uint256, output_reserve: uint256) -> uint256:
    assert input_reserve > 0 and output_reserve > 0
    input_amount_with_fee: uint256 = input_amount * (10000 - self.poolFee)
    numerator: uint256 = input_amount_with_fee * output_reserve
    denominator: uint256 = (input_reserve * 10000) + input_amount_with_fee
    return numerator / denominator

# @dev Pricing function for converting between ETH and Tokens.
# @param output_amount Amount of ETH or Tokens being bought.
# @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
# @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
# @return Amount of ETH or Tokens sold.
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
            self.ethFeeBalance += as_wei_value(fee, 'wei')
        else:
            self.token1FeeBalance += fee

@private
def ethToTokenInput(eth_sold: uint256(wei), min_tokens: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
    assert deadline >= block.timestamp and (eth_sold > 0 and min_tokens > 0)
    eth_reserve: uint256(wei) = self.balance - eth_sold - self.ethFeeBalance
    token_reserve: uint256 = self.token.balanceOf(self) - self.token1FeeBalance
    tokens_bought: uint256 = self.getInputPrice(as_unitless_number(eth_sold), as_unitless_number(eth_reserve), token_reserve)
    assert tokens_bought >= min_tokens
    self.token.transfer(recipient, tokens_bought)
    self.accountProtocolFee(as_unitless_number(eth_sold), True)
    log.TokenPurchase(buyer, eth_sold, tokens_bought)
    return tokens_bought

# @notice Convert ETH to Tokens.
# @dev User specifies exact input (msg.value).
# @dev User cannot specify minimum output or deadline.
@public
@payable
def __default__():
    assert self.traders[msg.sender]
    self.ethToTokenInput(msg.value, 1, block.timestamp, msg.sender, msg.sender)

# @notice Convert ETH to Tokens.
# @dev User specifies exact input (msg.value) and minimum output.
# @param min_tokens Minimum Tokens bought.
# @param deadline Time after which this transaction can no longer be executed.
# @return Amount of Tokens bought.
@public
@payable
def ethToTokenSwapInput(min_tokens: uint256, deadline: timestamp) -> uint256:
    assert self.traders[msg.sender]
    return self.ethToTokenInput(msg.value, min_tokens, deadline, msg.sender, msg.sender)

# @notice Convert ETH to Tokens and transfers Tokens to recipient.
# @dev User specifies exact input (msg.value) and minimum output
# @param min_tokens Minimum Tokens bought.
# @param deadline Time after which this transaction can no longer be executed.
# @param recipient The address that receives output Tokens.
# @return Amount of Tokens bought.
@public
@payable
def ethToTokenTransferInput(min_tokens: uint256, deadline: timestamp, recipient: address) -> uint256:
    assert self.traders[msg.sender]
    assert recipient != self and recipient != ZERO_ADDRESS
    return self.ethToTokenInput(msg.value, min_tokens, deadline, msg.sender, recipient)

@private
def ethToTokenOutput(tokens_bought: uint256, max_eth: uint256(wei), deadline: timestamp, buyer: address, recipient: address) -> uint256(wei):
    assert deadline >= block.timestamp and (tokens_bought > 0 and max_eth > 0)
    eth_reserve: uint256(wei) = self.balance - max_eth - self.ethFeeBalance
    token_reserve: uint256 = self.token.balanceOf(self) - self.token1FeeBalance
    eth_sold: uint256 = self.getOutputPrice(tokens_bought, as_unitless_number(eth_reserve), token_reserve)
    # Throws if eth_sold > max_eth
    eth_refund: uint256(wei) = max_eth - as_wei_value(eth_sold, 'wei')
    if eth_refund > 0:
        send(buyer, eth_refund)
    self.token.transfer(recipient, tokens_bought)
    self.accountProtocolFee(eth_sold, True)
    log.TokenPurchase(buyer, as_wei_value(eth_sold, 'wei'), tokens_bought)
    return as_wei_value(eth_sold, 'wei')

# @notice Convert ETH to Tokens.
# @dev User specifies maximum input (msg.value) and exact output.
# @param tokens_bought Amount of tokens bought.
# @param deadline Time after which this transaction can no longer be executed.
# @return Amount of ETH sold.
@public
@payable
def ethToTokenSwapOutput(tokens_bought: uint256, deadline: timestamp) -> uint256(wei):
    assert self.traders[msg.sender]
    return self.ethToTokenOutput(tokens_bought, msg.value, deadline, msg.sender, msg.sender)

# @notice Convert ETH to Tokens and transfers Tokens to recipient.
# @dev User specifies maximum input (msg.value) and exact output.
# @param tokens_bought Amount of tokens bought.
# @param deadline Time after which this transaction can no longer be executed.
# @param recipient The address that receives output Tokens.
# @return Amount of ETH sold.
@public
@payable
def ethToTokenTransferOutput(tokens_bought: uint256, deadline: timestamp, recipient: address) -> uint256(wei):
    assert self.traders[msg.sender]
    assert recipient != self and recipient != ZERO_ADDRESS
    return self.ethToTokenOutput(tokens_bought, msg.value, deadline, msg.sender, recipient)

@private
def tokenToEthInput(tokens_sold: uint256, min_eth: uint256(wei), deadline: timestamp, buyer: address, recipient: address) -> uint256(wei):
    assert deadline >= block.timestamp and (tokens_sold > 0 and min_eth > 0)
    eth_reserve: uint256(wei) = self.balance - self.ethFeeBalance
    token_reserve: uint256 = self.token.balanceOf(self) - self.token1FeeBalance
    eth_bought: uint256 = self.getInputPrice(tokens_sold, token_reserve, as_unitless_number(eth_reserve))
    wei_bought: uint256(wei) = as_wei_value(eth_bought, 'wei')
    assert wei_bought >= min_eth
    send(recipient, wei_bought)
    self.token.transferFrom(buyer, self, tokens_sold)
    self.accountProtocolFee(tokens_sold, False)
    log.EthPurchase(buyer, tokens_sold, wei_bought)
    return wei_bought


# @notice Convert Tokens to ETH.
# @dev User specifies exact input and minimum output.
# @param tokens_sold Amount of Tokens sold.
# @param min_eth Minimum ETH purchased.
# @param deadline Time after which this transaction can no longer be executed.
# @return Amount of ETH bought.
@public
def tokenToEthSwapInput(tokens_sold: uint256, min_eth: uint256(wei), deadline: timestamp) -> uint256(wei):
    assert self.traders[msg.sender]
    return self.tokenToEthInput(tokens_sold, min_eth, deadline, msg.sender, msg.sender)

# @notice Convert Tokens to ETH and transfers ETH to recipient.
# @dev User specifies exact input and minimum output.
# @param tokens_sold Amount of Tokens sold.
# @param min_eth Minimum ETH purchased.
# @param deadline Time after which this transaction can no longer be executed.
# @param recipient The address that receives output ETH.
# @return Amount of ETH bought.
@public
def tokenToEthTransferInput(tokens_sold: uint256, min_eth: uint256(wei), deadline: timestamp, recipient: address) -> uint256(wei):
    assert self.traders[msg.sender]
    assert recipient != self and recipient != ZERO_ADDRESS
    return self.tokenToEthInput(tokens_sold, min_eth, deadline, msg.sender, recipient)

@private
def tokenToEthOutput(eth_bought: uint256(wei), max_tokens: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
    assert deadline >= block.timestamp and eth_bought > 0
    eth_reserve: uint256(wei) = self.balance - self.ethFeeBalance
    token_reserve: uint256 = self.token.balanceOf(self) - self.token1FeeBalance
    tokens_sold: uint256 = self.getOutputPrice(as_unitless_number(eth_bought), token_reserve, as_unitless_number(eth_reserve))
    # tokens sold is always > 0
    assert max_tokens >= tokens_sold
    send(recipient, eth_bought)
    self.token.transferFrom(buyer, self, tokens_sold)
    self.accountProtocolFee(tokens_sold, False)
    log.EthPurchase(buyer, tokens_sold, eth_bought)
    return tokens_sold

# @notice Convert Tokens to ETH.
# @dev User specifies maximum input and exact output.
# @param eth_bought Amount of ETH purchased.
# @param max_tokens Maximum Tokens sold.
# @param deadline Time after which this transaction can no longer be executed.
# @return Amount of Tokens sold.
@public
def tokenToEthSwapOutput(eth_bought: uint256(wei), max_tokens: uint256, deadline: timestamp) -> uint256:
    assert self.traders[msg.sender]
    return self.tokenToEthOutput(eth_bought, max_tokens, deadline, msg.sender, msg.sender)

# @notice Convert Tokens to ETH and transfers ETH to recipient.
# @dev User specifies maximum input and exact output.
# @param eth_bought Amount of ETH purchased.
# @param max_tokens Maximum Tokens sold.
# @param deadline Time after which this transaction can no longer be executed.
# @param recipient The address that receives output ETH.
# @return Amount of Tokens sold.
@public
def tokenToEthTransferOutput(eth_bought: uint256(wei), max_tokens: uint256, deadline: timestamp, recipient: address) -> uint256:
    assert self.traders[msg.sender]
    assert recipient != self and recipient != ZERO_ADDRESS
    return self.tokenToEthOutput(eth_bought, max_tokens, deadline, msg.sender, recipient)

# @notice Public price function for ETH to Token trades with an exact input.
# @param eth_sold Amount of ETH sold.
# @return Amount of Tokens that can be bought with input ETH.
@public
@constant
def getEthToTokenInputPrice(eth_sold: uint256(wei)) -> uint256:
    assert eth_sold > 0
    eth_reserve: uint256(wei) = self.balance - self.ethFeeBalance
    token_reserve: uint256 = self.token.balanceOf(self) - self.token1FeeBalance
    return self.getInputPrice(as_unitless_number(eth_sold), as_unitless_number(eth_reserve), token_reserve)

# @notice Public price function for ETH to Token trades with an exact output.
# @param tokens_bought Amount of Tokens bought.
# @return Amount of ETH needed to buy output Tokens.
@public
@constant
def getEthToTokenOutputPrice(tokens_bought: uint256) -> uint256(wei):
    assert tokens_bought > 0
    eth_reserve: uint256(wei) = self.balance - self.ethFeeBalance
    token_reserve: uint256 = self.token.balanceOf(self) - self.token1FeeBalance
    eth_sold: uint256 = self.getOutputPrice(tokens_bought, as_unitless_number(eth_reserve), token_reserve)
    return as_wei_value(eth_sold, 'wei')

# @notice Public price function for Token to ETH trades with an exact input.
# @param tokens_sold Amount of Tokens sold.
# @return Amount of ETH that can be bought with input Tokens.
@public
@constant
def getTokenToEthInputPrice(tokens_sold: uint256) -> uint256(wei):
    assert tokens_sold > 0
    eth_reserve: uint256(wei) = self.balance - self.ethFeeBalance
    token_reserve: uint256 = self.token.balanceOf(self) - self.token1FeeBalance
    eth_bought: uint256 = self.getInputPrice(tokens_sold, token_reserve, as_unitless_number(eth_reserve))
    return as_wei_value(eth_bought, 'wei')

# @notice Public price function for Token to ETH trades with an exact output.
# @param eth_bought Amount of output ETH.
# @return Amount of Tokens needed to buy output ETH.
@public
@constant
def getTokenToEthOutputPrice(eth_bought: uint256(wei)) -> uint256:
    assert eth_bought > 0
    eth_reserve: uint256(wei) = self.balance - self.ethFeeBalance
    token_reserve: uint256 = self.token.balanceOf(self) - self.token1FeeBalance
    return self.getOutputPrice(as_unitless_number(eth_bought), token_reserve, as_unitless_number(eth_reserve))

# @return Address of Token that is sold on this exchange.
@public
@constant
def tokenAddress() -> address(ERC20_2):
    return self.token

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