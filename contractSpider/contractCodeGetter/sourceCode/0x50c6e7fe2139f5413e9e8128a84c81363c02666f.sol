/**
 *Submitted for verification at Etherscan.io on 2020-07-09
*/

/**
 *Submitted for verification at Etherscan.io on 2020-06-25
*/

pragma solidity ^0.5.0;



contract ZrxAllowlist {
    function setAllowlistAddr(address _zrxAddr, bool _state) public;

    function isZrxAddr(address _zrxAddr) public view returns (bool);
}



interface ERC20 {
    function totalSupply() external view returns (uint supply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    function decimals() external view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

interface ExchangeInterface {
    function swapEtherToToken (uint _ethAmount, address _tokenAddress, uint _maxAmount) payable external returns(uint, uint);
    function swapTokenToEther (address _tokenAddress, uint _amount, uint _maxAmount) external returns(uint);
    function swapTokenToToken(address _src, address _dest, uint _amount) external payable returns(uint);

    function getExpectedRate(address src, address dest, uint srcQty) external view
        returns (uint expectedRate);
}

contract TokenInterface {
    function allowance(address, address) public returns (uint);
    function balanceOf(address) public returns (uint);
    function approve(address, uint) public;
    function transfer(address, uint) public returns (bool);
    function transferFrom(address, address, uint) public returns (bool);
    function deposit() public payable;
    function withdraw(uint) public;
}

contract DSMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }
    function div(uint x, uint y) internal pure returns (uint z) {
        return x / y;
    }

    function min(uint x, uint y) internal pure returns (uint z) {
        return x <= y ? x : y;
    }
    function max(uint x, uint y) internal pure returns (uint z) {
        return x >= y ? x : y;
    }
    function imin(int x, int y) internal pure returns (int z) {
        return x <= y ? x : y;
    }
    function imax(int x, int y) internal pure returns (int z) {
        return x >= y ? x : y;
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    function rpow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

contract SaverExchangeConstantAddresses {
    address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
    address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;

    address public constant KYBER_WRAPPER = 0x173ef10a2739bd7aF34b4FBC0cB0Af58B079e2B0;
    address public constant UNISWAP_WRAPPER = 0xac996670326402FA1042Eb0C57f19a9d1A586FF1;
    address public constant OASIS_WRAPPER = 0x27152454462aaad2555e4B70DEAa00782F23213d;

    
    address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
}

contract Discount {

    address public owner;
    mapping (address => CustomServiceFee) public serviceFees;

    uint constant MAX_SERVICE_FEE = 400;

    struct CustomServiceFee {
        bool active;
        uint amount;
    }

    constructor() public {
        owner = msg.sender;
    }

    function isCustomFeeSet(address _user) public view returns (bool) {
        return serviceFees[_user].active;
    }

    function getCustomServiceFee(address _user) public view returns (uint) {
        return serviceFees[_user].amount;
    }

    function setServiceFee(address _user, uint _fee) public {
        require(msg.sender == owner, "Only owner");
        require(_fee >= MAX_SERVICE_FEE || _fee == 0);

        serviceFees[_user] = CustomServiceFee({
            active: true,
            amount: _fee
        });
    }

    function disableServiceFee(address _user) public {
        require(msg.sender == owner, "Only owner");

        serviceFees[_user] = CustomServiceFee({
            active: false,
            amount: 0
        });
    }
}

contract SaverExchange is DSMath, SaverExchangeConstantAddresses {

    uint public constant SERVICE_FEE = 800; 
    address public constant ZRX_ALLOWLIST_ADDR = 0x019739e288973F92bDD3c1d87178E206E51fd911;


    event Swap(address src, address dest, uint amountSold, uint amountBought, address wrapper);

    function swapTokenToToken(address _src, address _dest, uint _amount, uint _minPrice, uint _exchangeType, address _exchangeAddress, bytes memory _callData, uint _0xPrice) public payable {
        if (_src == KYBER_ETH_ADDRESS) {
            require(msg.value >= _amount, "msg.value smaller than amount");
        } else {
            require(ERC20(_src).transferFrom(msg.sender, address(this), _amount), "Not able to withdraw wanted amount");
        }

        uint fee = takeFee(_amount, _src);
        _amount = sub(_amount, fee);
        uint tokensReturned;
        address wrapper;
        uint price;
        bool success;

        if (_exchangeType == 4) {
            if (_src != KYBER_ETH_ADDRESS) {
                ERC20(_src).approve(address(ERC20_PROXY_0X), _amount);
            }

            (success, tokensReturned) = takeOrder(_exchangeAddress, _callData, address(this).balance, _dest);
            
            require(success && tokensReturned > 0, "0x transaction failed");
            wrapper = address(_exchangeAddress);
        }

        if (tokensReturned == 0) {
            (wrapper, price) = getBestPrice(_amount, _src, _dest, _exchangeType);

            require(price > _minPrice || _0xPrice > _minPrice, "Slippage hit");

            
            if (_0xPrice >= price) {
                if (_src != KYBER_ETH_ADDRESS) {
                    ERC20(_src).approve(address(ERC20_PROXY_0X), _amount);
                }
                (success, tokensReturned) = takeOrder(_exchangeAddress, _callData, address(this).balance, _dest);
                
                if (success && tokensReturned > 0) {
                    wrapper = address(_exchangeAddress);
                }
            }

            if (tokensReturned == 0) {
                
                require(price > _minPrice, "Slippage hit onchain price");
                if (_src == KYBER_ETH_ADDRESS) {
                    (tokensReturned,) = ExchangeInterface(wrapper).swapEtherToToken.value(_amount)(_amount, _dest, uint(-1));
                } else {
                    ERC20(_src).transfer(wrapper, _amount);

                    if (_dest == KYBER_ETH_ADDRESS) {
                        tokensReturned = ExchangeInterface(wrapper).swapTokenToEther(_src, _amount, uint(-1));
                    } else {
                        tokensReturned = ExchangeInterface(wrapper).swapTokenToToken(_src, _dest, _amount);
                    }
                }
            }
        }

        
        if (address(this).balance > 0) {
            msg.sender.transfer(address(this).balance);
        }

        
        if (_dest != KYBER_ETH_ADDRESS) {
            if (ERC20(_dest).balanceOf(address(this)) > 0) {
                ERC20(_dest).transfer(msg.sender, ERC20(_dest).balanceOf(address(this)));
            }
        }

        if (_src != KYBER_ETH_ADDRESS) {
            if (ERC20(_src).balanceOf(address(this)) > 0) {
                ERC20(_src).transfer(msg.sender, ERC20(_src).balanceOf(address(this)));
            }
        }

        emit Swap(_src, _dest, _amount, tokensReturned, wrapper);
    }

    
    
    
    
    
    function takeOrder(address _exchange, bytes memory _data, uint _value, address _dest) private returns(bool, uint) {
        bool success;

        if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isZrxAddr(_exchange)) {
            (success, ) = _exchange.call.value(_value)(_data);
        } else {
            success = false;
        }

        uint tokensReturned = 0;
        if (success){
            if (_dest == KYBER_ETH_ADDRESS) {
                TokenInterface(WETH_ADDRESS).withdraw(TokenInterface(WETH_ADDRESS).balanceOf(address(this)));
                tokensReturned = address(this).balance;
            } else {
                tokensReturned = ERC20(_dest).balanceOf(address(this));
            }
        }

        return (success, tokensReturned);
    }

    
    
    
    
    
    function getBestPrice(uint _amount, address _srcToken, address _destToken, uint _exchangeType) public returns (address, uint) {
        uint expectedRateKyber;
        uint expectedRateUniswap;
        uint expectedRateOasis;


        if (_exchangeType == 1) {
            return (OASIS_WRAPPER, getExpectedRate(OASIS_WRAPPER, _srcToken, _destToken, _amount));
        }

        if (_exchangeType == 2) {
            return (KYBER_WRAPPER, getExpectedRate(KYBER_WRAPPER, _srcToken, _destToken, _amount));
        }

        if (_exchangeType == 3) {
            expectedRateUniswap = getExpectedRate(UNISWAP_WRAPPER, _srcToken, _destToken, _amount);
            expectedRateUniswap = expectedRateUniswap * (10 ** (18 - getDecimals(_destToken)));
            return (UNISWAP_WRAPPER, expectedRateUniswap);
        }

        if (_exchangeType != 5) {
            expectedRateKyber = getExpectedRate(KYBER_WRAPPER, _srcToken, _destToken, _amount);
        }
        expectedRateUniswap = getExpectedRate(UNISWAP_WRAPPER, _srcToken, _destToken, _amount);
        expectedRateUniswap = expectedRateUniswap * (10 ** (18 - getDecimals(_destToken)));
        expectedRateOasis = getExpectedRate(OASIS_WRAPPER, _srcToken, _destToken, _amount);
        expectedRateOasis = expectedRateOasis * (10 ** (18 - getDecimals(_destToken)));

        if ((expectedRateKyber >= expectedRateUniswap) && (expectedRateKyber >= expectedRateOasis)) {
            return (KYBER_WRAPPER, expectedRateKyber);
        }

        if ((expectedRateOasis >= expectedRateKyber) && (expectedRateOasis >= expectedRateUniswap)) {
            return (OASIS_WRAPPER, expectedRateOasis);
        }

        if ((expectedRateUniswap >= expectedRateKyber) && (expectedRateUniswap >= expectedRateOasis)) {
            return (UNISWAP_WRAPPER, expectedRateUniswap);
        }
    }

    function getExpectedRate(address _wrapper, address _srcToken, address _destToken, uint _amount) public returns(uint) {
        bool success;
        bytes memory result;

        (success, result) = _wrapper.call(abi.encodeWithSignature("getExpectedRate(address,address,uint256)", _srcToken, _destToken, _amount));

        if (success) {
            return sliceUint(result, 0);
        } else {
            return 0;
        }
    }

    
    
    
    function takeFee(uint _amount, address _token) internal returns (uint feeAmount) {
        uint fee = SERVICE_FEE;

        if (Discount(DISCOUNT_ADDRESS).isCustomFeeSet(msg.sender)) {
            fee = Discount(DISCOUNT_ADDRESS).getCustomServiceFee(msg.sender);
        }

        if (fee == 0) {
            feeAmount = 0;
        } else {
            feeAmount = _amount / SERVICE_FEE;
            if (_token == KYBER_ETH_ADDRESS) {
                WALLET_ID.transfer(feeAmount);
            } else {
                ERC20(_token).transfer(WALLET_ID, feeAmount);
            }
        }
    }


    function getDecimals(address _token) internal view returns(uint) {
        
        if (_token == address(0xE0B7927c4aF23765Cb51314A0E0521A9645F0E2A)) {
            return 9;
        }
        
        if (_token == address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)) {
            return 6;
        }
        
        if (_token == address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599)) {
            return 8;
        }

        return 18;
    }

    function sliceUint(bytes memory bs, uint start) internal pure returns (uint) {
        require(bs.length >= start + 32, "slicing out of range");

        uint x;
        assembly {
            x := mload(add(bs, add(0x20, start)))
        }

        return x;
    }

    
    function() external payable {}
}