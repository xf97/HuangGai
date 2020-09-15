/**
 *Submitted for verification at Etherscan.io on 2020-05-28
*/

pragma solidity ^0.6.0; interface ERC20 {
    function totalSupply() external view returns (uint256 supply);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value)
        external
        returns (bool success);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function decimals() external view returns (uint256 digits);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
} abstract contract GasTokenInterface is ERC20 {
    function free(uint256 value) public virtual returns (bool success);

    function freeUpTo(uint256 value) public virtual returns (uint256 freed);

    function freeFrom(address from, uint256 value) public virtual returns (bool success);

    function freeFromUpTo(address from, uint256 value) public virtual returns (uint256 freed);
} contract GasBurner {
    // solhint-disable-next-line const-name-snakecase
    GasTokenInterface public constant gasToken = GasTokenInterface(0x0000000000b3F879cb30FE243b4Dfee438691c04);

    modifier burnGas(uint _amount) {
        uint gst2Amount = _amount;

        if (_amount == 0) {
            gst2Amount = (gasleft() + 14154) / (2 * 24000 - 6870);
            gst2Amount = gst2Amount - (gst2Amount / 8); // 12.5% less because of gaslimit != gas_used
        }

        if (gasToken.balanceOf(address(this)) >= gst2Amount) {
            gasToken.free(gst2Amount);
        }

        _;
    }
} abstract contract CTokenInterface is ERC20 {
    function mint(uint256 mintAmount) external virtual returns (uint256);

    function mint() external virtual payable;

    function redeem(uint256 redeemTokens) external virtual returns (uint256);

    function redeemUnderlying(uint256 redeemAmount) external virtual returns (uint256);

    function borrow(uint256 borrowAmount) external virtual returns (uint256);

    function repayBorrow(uint256 repayAmount) external virtual returns (uint256);

    function repayBorrow() external virtual payable;

    function repayBorrowBehalf(address borrower, uint256 repayAmount) external virtual returns (uint256);

    function repayBorrowBehalf(address borrower) external virtual payable;

    function liquidateBorrow(address borrower, uint256 repayAmount, address cTokenCollateral)
        external virtual
        returns (uint256);

    function liquidateBorrow(address borrower, address cTokenCollateral) external virtual payable;

    function exchangeRateCurrent() external virtual returns (uint256);

    function supplyRatePerBlock() external virtual returns (uint256);

    function borrowRatePerBlock() external virtual returns (uint256);

    function totalReserves() external virtual returns (uint256);

    function reserveFactorMantissa() external virtual returns (uint256);

    function borrowBalanceCurrent(address account) external virtual returns (uint256);

    function totalBorrowsCurrent() external virtual returns (uint256);

    function getCash() external virtual returns (uint256);

    function balanceOfUnderlying(address owner) external virtual returns (uint256);

    function underlying() external virtual returns (address);

    function getAccountSnapshot(address account) external virtual view returns (uint, uint, uint, uint);
} abstract contract CEtherInterface {
    function mint() external virtual payable;
    function repayBorrow() external virtual payable;
} abstract contract ComptrollerInterface {
    function enterMarkets(address[] calldata cTokens) external virtual returns (uint256[] memory);

    function exitMarket(address cToken) external virtual returns (uint256);

    function getAssetsIn(address account) external virtual view returns (address[] memory);

    function markets(address account) public virtual view returns (bool, uint256);

    function getAccountLiquidity(address account) external virtual view returns (uint256, uint256, uint256);
} /// @title Basic compound interactions through the DSProxy
contract CompoundBasicProxy is GasBurner {

    address public constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant COMPTROLLER_ADDR = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;

    /// @notice User deposits tokens to the Compound protocol
    /// @dev User needs to approve the DSProxy to pull the _tokenAddr tokens
    /// @param _tokenAddr The address of the token to be deposited
    /// @param _cTokenAddr CTokens to be deposited
    /// @param _amount Amount of tokens to be deposited
    /// @param _inMarket True if the tokend is already in market for that address
    function deposit(address _tokenAddr, address _cTokenAddr, uint _amount, bool _inMarket) public burnGas(0) payable {
        if (_tokenAddr != ETH_ADDR) {
            ERC20(_tokenAddr).transferFrom(msg.sender, address(this), _amount);
        }

        approveToken(_tokenAddr, _cTokenAddr);

        if (!_inMarket) {
            enterMarket(_cTokenAddr);
        }

        if (_tokenAddr != ETH_ADDR) {
            require(CTokenInterface(_cTokenAddr).mint(_amount) == 0);
        } else {
            CEtherInterface(_cTokenAddr).mint{value: msg.value}(); // reverts on fail
        }
    }

    /// @notice User withdraws tokens to the Compound protocol
    /// @param _tokenAddr The address of the token to be withdrawn
    /// @param _cTokenAddr CTokens to be withdrawn
    /// @param _amount Amount of tokens to be withdrawn
    /// @param _isCAmount If true _amount is cTokens if falls _amount is underlying tokens
    function withdraw(address _tokenAddr, address _cTokenAddr, uint _amount, bool _isCAmount) public burnGas(0) {

        if (_isCAmount) {
            require(CTokenInterface(_cTokenAddr).redeem(_amount) == 0);
        } else {
            require(CTokenInterface(_cTokenAddr).redeemUnderlying(_amount) == 0);
        }

        // withdraw funds to msg.sender
        if (_tokenAddr != ETH_ADDR) {
            ERC20(_tokenAddr).transfer(msg.sender, ERC20(_tokenAddr).balanceOf(address(this)));
        } else {
            msg.sender.transfer(address(this).balance);
        }

    }

    /// @notice User borrows tokens to the Compound protocol
    /// @param _tokenAddr The address of the token to be borrowed
    /// @param _cTokenAddr CTokens to be borrowed
    /// @param _amount Amount of tokens to be borrowed
    /// @param _inMarket True if the tokend is already in market for that address
    function borrow(address _tokenAddr, address _cTokenAddr, uint _amount, bool _inMarket) public burnGas(0) {
        if (!_inMarket) {
            enterMarket(_cTokenAddr);
        }

        require(CTokenInterface(_cTokenAddr).borrow(_amount) == 0);

        // withdraw funds to msg.sender
        if (_tokenAddr != ETH_ADDR) {
            ERC20(_tokenAddr).transfer(msg.sender, ERC20(_tokenAddr).balanceOf(address(this)));
        } else {
            msg.sender.transfer(address(this).balance);
        }
    }

    /// @dev User needs to approve the DSProxy to pull the _tokenAddr tokens
    /// @notice User paybacks tokens to the Compound protocol
    /// @param _tokenAddr The address of the token to be paybacked
    /// @param _cTokenAddr CTokens to be paybacked
    /// @param _amount Amount of tokens to be payedback
    /// @param _wholeDebt If true the _amount will be set to the whole amount of the debt
    function payback(address _tokenAddr, address _cTokenAddr, uint _amount, bool _wholeDebt) public burnGas(0) payable {
        approveToken(_tokenAddr, _cTokenAddr);

        if (_wholeDebt) {
            _amount = CTokenInterface(_cTokenAddr).borrowBalanceCurrent(address(this));
        }

        if (_tokenAddr != ETH_ADDR) {
            ERC20(_tokenAddr).transferFrom(msg.sender, address(this), _amount);

            require(CTokenInterface(_cTokenAddr).repayBorrow(_amount) == 0);
        } else {
            CEtherInterface(_cTokenAddr).repayBorrow{value: msg.value}();
            msg.sender.transfer(address(this).balance); // send back the extra eth
        }
    }

    /// @notice Helper method to withdraw tokens from the DSProxy
    /// @param _tokenAddr Address of the token to be withdrawn
    function withdrawTokens(address _tokenAddr) public {
        if (_tokenAddr != ETH_ADDR) {
            ERC20(_tokenAddr).transfer(msg.sender, ERC20(_tokenAddr).balanceOf(address(this)));
        } else {
            msg.sender.transfer(address(this).balance);
        }
    }

    /// @notice Enters the Compound market so it can be deposited/borrowed
    /// @param _cTokenAddr CToken address of the token
    function enterMarket(address _cTokenAddr) public {
        address[] memory markets = new address[](1);
        markets[0] = _cTokenAddr;

        ComptrollerInterface(COMPTROLLER_ADDR).enterMarkets(markets);
    }

    /// @notice Exits the Compound market so it can't be deposited/borrowed
    /// @param _cTokenAddr CToken address of the token
    function exitMarket(address _cTokenAddr) public {
        ComptrollerInterface(COMPTROLLER_ADDR).exitMarket(_cTokenAddr);
    }

    /// @notice Approves CToken contract to pull underlying tokens from the DSProxy
    /// @param _tokenAddr Token we are trying to approve
    /// @param _cTokenAddr Address which will gain the approval
    function approveToken(address _tokenAddr, address _cTokenAddr) internal {
        if (_tokenAddr != ETH_ADDR) {
            ERC20(_tokenAddr).approve(_cTokenAddr, uint(-1));
        }
    }
}