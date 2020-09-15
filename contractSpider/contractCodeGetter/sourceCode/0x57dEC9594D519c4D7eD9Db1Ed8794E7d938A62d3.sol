/**
 *Submitted for verification at Etherscan.io on 2020-05-21
*/

// hevm: flattened sources of src/LoihiExchange.sol
pragma solidity >0.4.13 >=0.4.23 >=0.5.0 <0.6.0 >=0.5.6 <0.6.0 >=0.5.12 <0.6.0 >=0.5.15 <0.6.0;

////// lib/openzeppelin-contracts/src/contracts/token/ERC20/IERC20.sol
/* pragma solidity ^0.5.0; */

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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

////// src/LoihiDelegators.sol
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.5.15; */

contract LoihiDelegators {

    function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
        (bool success, bytes memory returnData) = callee.delegatecall(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
        return returnData;
    }

    function staticTo(address callee, bytes memory data) internal view returns (bytes memory) {
        (bool success, bytes memory returnData) = callee.staticcall(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
        return returnData;
    }

    function dViewRawAmount (address addr, uint256 amount) internal view returns (uint256) {
        bytes memory result = staticTo(addr, abi.encodeWithSignature("viewRawAmount(uint256)", amount)); // encoded selector of "getNumeraireAmount(uint256");
        return abi.decode(result, (uint256));
    }

    function dViewNumeraireAmount (address addr, uint256 amount) internal view returns (uint256) {
        bytes memory result = staticTo(addr, abi.encodeWithSignature("viewNumeraireAmount(uint256)", amount)); // encoded selector of "getNumeraireAmount(uint256");
        return abi.decode(result, (uint256));
    }

    function dViewNumeraireBalance (address addr, address _this) internal view returns (uint256) {
        bytes memory result = staticTo(addr, abi.encodeWithSignature("viewNumeraireBalance(address)", _this)); // encoded selector of "getNumeraireAmount(uint256");
        return abi.decode(result, (uint256));
    }

    function dIntakeRaw (address addr, uint256 amount) internal returns (uint256) {
        bytes memory result = delegateTo(addr, abi.encodeWithSignature("intakeRaw(uint256)", amount)); // encoded selector of "intakeRaw(uint256)";
        return abi.decode(result, (uint256));
    }

    function dIntakeNumeraire (address addr, uint256 amount) internal returns (uint256) {
        bytes memory result = delegateTo(addr, abi.encodeWithSignature("intakeNumeraire(uint256)", amount)); // encoded selector of "intakeNumeraire(uint256)";
        return abi.decode(result, (uint256));
    }

    function dOutputRaw (address addr, address dst, uint256 amount) internal returns (uint256) {
        bytes memory result = delegateTo(addr, abi.encodeWithSignature("outputRaw(address,uint256)", dst, amount)); // encoded selector of "outputRaw(address,uint256)";
        return abi.decode(result, (uint256));
    }

    function dOutputNumeraire (address addr, address dst, uint256 amount) internal returns (uint256) {
        bytes memory result = delegateTo(addr, abi.encodeWithSignature("outputNumeraire(address,uint256)", dst, amount)); // encoded selector of "outputNumeraire(address,uint256)";
        return abi.decode(result, (uint256));
    }
}
////// src/LoihiMath.sol
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity >0.4.13; */

contract LoihiMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "loihi-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "loihi-math-sub-underflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "loihi-math-mul-overflow");
    }

    uint constant OCTOPUS = 10 ** 18;

    function omul(uint x, uint y) internal pure returns (uint z) {
        z = ((x*y) + (OCTOPUS/2)) / OCTOPUS;
    }

    function odiv(uint x, uint y) internal pure returns (uint z) {
        z = ((x*OCTOPUS) + (y/2)) / y;
    }

    function somul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), OCTOPUS / 2) / OCTOPUS;
    }

    function sodiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, OCTOPUS), y / 2) / y;
    }

}

////// src/interfaces/IAToken.sol
/* pragma solidity ^0.5.15; */

interface IAToken {

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function redirectInterestStream(address _to) external;
    function redirectInterestStreamOf(address _from, address _to) external;
    function allowInterestRedirectionTo(address _to) external;
    function redeem(uint256 _amount) external;
    function balanceOf(address _user) external view returns(uint256);
    function principalBalanceOf(address _user) external view returns(uint256);
    function totalSupply() external view returns(uint256);
    function isTransferAllowed(address _user, uint256 _amount) external view returns (bool);
    function getUserIndex(address _user) external view returns(uint256);
    function getInterestRedirectionAddress(address _user) external view returns(address);
    function getRedirectedBalance(address _user) external view returns(uint256);
    function decimals () external view returns (uint256);
    function deposit(uint256 _amount) external;

}
////// src/interfaces/ICToken.sol
/* pragma solidity ^0.5.15; */

interface ICToken {
    function mint(uint mintAmount) external returns (uint);
    function redeem(uint redeemTokens) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function repayBorrow(uint repayAmount) external returns (uint);
    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
    function getCash() external view returns (uint);
    function exchangeRateCurrent() external returns (uint);
    function exchangeRateStored() external view returns (uint);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function balanceOfUnderlying(address account) external returns (uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address minter, uint mintAmount, uint mintTokens);
    event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);
    event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
    event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);


}
////// src/interfaces/IChai.sol
/* pragma solidity ^0.5.12; */

interface IChai {
    function draw(address src, uint wad) external;
    function exit(address src, uint wad) external;
    function join(address dst, uint wad) external;
    function dai(address usr) external returns (uint wad);
    function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;
    function approve(address usr, uint wad) external returns (bool);
    function move(address src, address dst, uint wad) external returns (bool);
    function transfer(address dst, uint wad) external returns (bool);
    function transferFrom(address src, address dst, uint wad) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
}
////// src/interfaces/IPot.sol
/* pragma solidity ^0.5.15; */

interface IPot {
    function rho () external returns (uint256);
    function drip () external returns (uint256);
    function chi () external view returns (uint256);
}
////// src/LoihiRoot.sol
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.5.15; */


/* import "./LoihiMath.sol"; */
/* import "./interfaces/ICToken.sol"; */
/* import "./interfaces/IAToken.sol"; */
/* import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
/* import "./interfaces/IChai.sol"; */
/* import "./interfaces/IPot.sol"; */

contract LoihiRoot is LoihiMath {

    string  public constant name = "Shells";
    string  public constant symbol = "SHL";
    uint8   public constant decimals = 18;

    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowances;
    uint256 public totalSupply;

    struct Flavor { address adapter; address reserve; }
    mapping(address => Flavor) public flavors;

    address[] public reserves;
    address[] public numeraires;
    uint256[] public weights;

    address public owner;
    bool internal notEntered = true;
    bool public frozen = false;

    uint256 public alpha;
    uint256 public beta;
    uint256 public delta;
    uint256 public epsilon;
    uint256 public lambda;
    uint256 internal omega;

    bytes4 constant internal ERC20ID = 0x36372b07;
    bytes4 constant internal ERC165ID = 0x01ffc9a7;

    // mainnet
    address constant exchange = 0xfb8443545771E2BB15bB7cAdDa43A16a1Ab69c0B;
    address constant liquidity = 0xA3f4A860eFa4a60279E6E50f2169FDD080aAb655;
    address constant views = 0x81dBd2ec823cB2691f34c7b5391c9439ec5c80E3;
    address constant erc20 = 0x7DB32869056647532f80f482E5bB1fcb311493cD;

    // kovan
    // address constant exchange = 0xcF90c859b5cD63bfac65A34016ab6da442C74433;
    // address constant liquidity = 0x1F2d802b10bc8226aEf4433E02D60876446AFB86;
    // address constant views = 0xfA923BC1D005dbF1A3C9E377ac02Ba65D3994054;
    // address constant erc20 = 0x5194f53237beF18741A0dD6B0D0049CBA581C5FD;

    event ShellsMinted(address indexed minter, uint256 amount, address[] indexed coins, uint256[] amounts);
    event ShellsBurned(address indexed burner, uint256 amount, address[] indexed coins, uint256[] amounts);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    modifier nonReentrant() {
        require(notEntered, "re-entered");
        notEntered = false;
        _;
        notEntered = true;
    }

    modifier notFrozen () {
        require(!frozen, "swaps, selective deposits and selective withdraws have been frozen.");
        _;
    }

}
////// src/LoihiExchange.sol
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.5.15; */

/* import "./LoihiRoot.sol"; */
/* import "./LoihiDelegators.sol"; */

contract LoihiExchange is LoihiRoot, LoihiDelegators {

    /// @dev executes the origin trade. refer to Loihi.bin swapByOrigin and transferByOrigin for detailed explanation of paramters
    /// @return tAmt_ the target amount
    function executeOriginTrade (uint256 _deadline, uint256 _minTAmt, address _recipient, address _origin, address _target, uint256 _oAmt) external returns (uint256) {
        require(_deadline >= now, "deadline has passed for this trade");

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        require(_o.adapter != address(0), "origin flavor not supported");
        require(_t.adapter != address(0), "target flavor not supported");

        if (_o.reserve == _t.reserve) {
            uint256 _oNAmt = dIntakeRaw(_o.adapter, _oAmt);
            uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _oNAmt);
            emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);
            return tAmt_;
        }

        uint256[] memory _weights = weights;
        address[] memory _reserves = reserves;

        (uint256[] memory _balances, uint256 _grossLiq) = getBalancesAndGrossLiq(_reserves);

        uint256 _oNAmt = dViewNumeraireAmount(_o.adapter, _oAmt);
        uint256 _tNAmt = getTargetAmount(_grossLiq, _o.reserve, _t.reserve, _oNAmt, _balances, _weights, _reserves);

        require(dViewRawAmount(_t.adapter, _tNAmt) >= _minTAmt, "target amount is less than min target amount");

        dIntakeRaw(_o.adapter, _oAmt);
        uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _tNAmt);
        emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);

        return tAmt_;

    }

    /// @dev executes the target trade. refer to Loihi.bin swapByTarget and transferByTarget for detailed explanation of parameters
    /// @return oAmt_ origin amount
    function executeTargetTrade (uint256 _deadline, address _origin, address _target, uint256 _maxOAmt, uint256 _tAmt, address _recipient) external returns (uint256) {
        require(_deadline >= now, "deadline has passed for this trade");

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        require(_o.adapter != address(0), "origin flavor not supported");
        require(_t.adapter != address(0), "target flavor not supported");

        if (_o.reserve == _t.reserve) {
            uint256 _tNAmt = dOutputRaw(_t.adapter, _recipient, _tAmt);
            uint256 oAmt_ = dIntakeNumeraire(_o.adapter, _tNAmt);
            emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);
            return oAmt_;
        }

        uint256 _tNAmt;
        uint256 _oNAmt;

        {
            uint256[] memory _weights = weights;
            address[] memory _reserves = reserves;

            (uint256[] memory _balances, uint256 _grossLiq) = getBalancesAndGrossLiq(_reserves);

            _tNAmt = dViewNumeraireAmount(_t.adapter, _tAmt);
            _oNAmt = getOriginAmount(_grossLiq, _o.reserve, _t.reserve, _tNAmt, _balances, _weights, _reserves);
        }

        require(dViewRawAmount(_o.adapter, _oNAmt) <= _maxOAmt, "origin amount is greater than max origin amount");

        dOutputRaw(_t.adapter, _recipient, _tAmt);
        uint256 oAmt_ = dIntakeNumeraire(_o.adapter, _oNAmt);

        emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);

        return oAmt_;

    }

    /// @dev this function figures out the origin amount
    /// @return tNAmt_ target amount
    function getTargetAmount (uint256 _grossLiq, address _oRsrv, address _tRsrv, uint256 _oNAmt, uint256[] memory _balances, uint256[] memory _weights, address[] memory _reserves) internal returns (uint256 tNAmt_) {

        tNAmt_ = somul(_oNAmt, OCTOPUS-epsilon);
        
        uint256 _oNFAmt = tNAmt_;
        uint256 _psi;
        uint256 _nGLiq;
        uint256 _omega = omega; // 1787 gas savings
        uint256 _lambda = lambda;
        for (uint j = 0; j < 10; j++) {

            _psi = 0;
            _nGLiq = sub(add(_grossLiq, _oNAmt), tNAmt_);

            for (uint i = 0; i < _reserves.length; i++) {
                address _rsrv = _reserves[i];
                if (_rsrv == _oRsrv) {
                    uint256 _nBal = add(_balances[i], _oNAmt);
                    _psi += makeFee(_nBal, somul(_nGLiq, _weights[i]));
                } else if (_rsrv == _tRsrv) {
                    uint256 _nBal = sub(_balances[i], tNAmt_);
                    _psi += makeFee(_nBal, somul(_nGLiq, _weights[i]));
                } else _psi += makeFee(_balances[i], somul(_nGLiq, _weights[i]));
            }

            if (_omega < _psi) { // 32.7k gas savings against 10^13/10^14 vs 10^10
                if ((tNAmt_ = sub(add(_oNFAmt,  _omega), _psi)) / 100000000000000 == tNAmt_ / 100000000000000) break;
            } else {
                if ((tNAmt_ = add(_oNFAmt, somul(_lambda, sub(_omega, _psi)))) / 100000000000000 == tNAmt_ / 100000000000000) break;
            }
        }

        omega = _psi;

        {
            uint256 _alpha = alpha; // 400-800 gas savings
            for (uint i = 0; i < _balances.length; i++) {
                uint256 _nIdeal = somul(_nGLiq, _weights[i]);
                if (_reserves[i] == _oRsrv) {
                    require(add(_balances[i], _oNAmt) < somul(_nIdeal, OCTOPUS + _alpha), "origin halt check");
                } else if (_reserves[i] == _tRsrv) {
                    require(sub(_balances[i], tNAmt_) > somul(_nIdeal, OCTOPUS - _alpha), "target halt check");
                } else if (_balances[i] < _nIdeal) {
                    require(_balances[i] > somul(_nIdeal, OCTOPUS - _alpha), "lower-halt-check");
                } else {
                    require(_balances[i] < somul(_nIdeal, OCTOPUS + _alpha), "upper-halt-check");
                }

            }
        }

        tNAmt_ = somul(tNAmt_, OCTOPUS-epsilon);

    }

    /// @dev this function figures out the origin amount
    /// @return oNAmt_ origin amount
    function getOriginAmount (uint256 _grossLiq, address _oRsrv, address _tRsrv, uint256 _tNAmt, uint256[] memory _balances, uint256[] memory _weights, address[] memory _reserves) internal returns (uint256 oNAmt_) {

        oNAmt_ = somul(_tNAmt, OCTOPUS+epsilon);

        uint256 _tNFAmt = oNAmt_;
        uint256 _psi;
        uint256 _nGLiq;
        uint256 _omega = omega;
        uint256 _lambda = lambda;
        for (uint j = 0; j < 10; j++) {

            _psi = 0;
            _nGLiq = sub(add(_grossLiq, oNAmt_), _tNAmt);

            for (uint i = 0; i < _reserves.length; i++) {
                address _rsrv = _reserves[i];
                if (_rsrv == _oRsrv) {
                    uint256 _nBal = add(_balances[i], oNAmt_);
                    _psi += makeFee(_nBal, somul(_nGLiq, _weights[i]));
                }
                else if (_rsrv == _tRsrv) {
                    uint256 _nBal = sub(_balances[i], _tNAmt);
                    _psi += makeFee(_nBal, somul(_nGLiq, _weights[i]));
                }
                else {
                    _psi += makeFee(_balances[i], somul(_nGLiq, _weights[i]));
                }
            }

            if (_omega < _psi) {
                if ((oNAmt_ = sub(add(_tNFAmt, _psi), _omega)) / 100000000000000 == oNAmt_ / 100000000000000) break;
            } else {
                if ((oNAmt_ = sub(_tNFAmt, somul(_lambda, sub(_omega, _psi)))) / 100000000000000 == oNAmt_ / 100000000000000) break;
            }
        }

        omega = _psi;

        uint256 _alpha = alpha;
        for (uint i = 0; i < _balances.length; i++) {

            uint256 _nIdeal = somul(_nGLiq, _weights[i]);
            if (_reserves[i] == _oRsrv) {
                require(add(_balances[i], oNAmt_) < somul(_nIdeal, OCTOPUS + _alpha), "origin-halt-check");
            } else if (_reserves[i] == _tRsrv) {
                require(sub(_balances[i], _tNAmt) > somul(_nIdeal, OCTOPUS - _alpha), "target-halt-check");
            } else if (_balances[i] > _nIdeal) {
                require(_balances[i] < somul(_nIdeal, OCTOPUS + _alpha), "upper-halt-check");
            } else {
                require(_balances[i] > somul(_nIdeal, OCTOPUS - _alpha), "lower-halt-check");
            }

        }

        oNAmt_ = somul(oNAmt_, OCTOPUS+epsilon);

    }

    /// @notice this function makes our fees!
    /// @return fee_ the fee.
    function makeFee (uint256 _bal, uint256 _ideal) internal view returns (uint256 fee_) {

        uint256 _threshold;
        uint256 _beta = beta;
        uint256 _delta = delta;
        if (_bal < (_threshold = somul(_ideal, OCTOPUS-_beta))) {
            fee_ = sodiv(_delta, _ideal);
            fee_ = somul(fee_, (_threshold = sub(_threshold, _bal)));
            fee_ = somul(fee_, _threshold);
        } else if (_bal > (_threshold = somul(_ideal, OCTOPUS+_beta))) {
            fee_ = sodiv(_delta, _ideal);
            fee_ = somul(fee_, (_threshold = sub(_bal, _threshold)));
            fee_ = somul(fee_, _threshold);
        } else fee_ = 0;

    }

    function getBalancesAndGrossLiq (address[] memory _reserves) internal returns (uint256[] memory, uint256 grossLiq_) {
        uint256[] memory balances_ = new uint256[](_reserves.length);
        for (uint i = 0; i < _reserves.length; i++) {
            address _rsrv = _reserves[i];
            balances_[i] = dViewNumeraireBalance(_rsrv, address(this));
            grossLiq_ = add(grossLiq_, balances_[i]);
        }
        return (balances_, grossLiq_);
    }

}