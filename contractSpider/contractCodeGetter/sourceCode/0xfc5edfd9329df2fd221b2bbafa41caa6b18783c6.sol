/**
 *Submitted for verification at Etherscan.io on 2020-06-09
*/

pragma solidity ^0.6.0;

interface ERC20 {
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
}


abstract contract ComptrollerInterface {
    function enterMarkets(address[] calldata cTokens) external virtual returns (uint256[] memory);

    function exitMarket(address cToken) external virtual returns (uint256);

    function getAssetsIn(address account) external virtual view returns (address[] memory);

    function markets(address account) public virtual view returns (bool, uint256);

    function getAccountLiquidity(address account) external virtual view returns (uint256, uint256, uint256);
}

// File: localhost/interfaces/CTokenInterface.sol

pragma solidity ^0.6.0;


abstract contract CTokenInterface is ERC20 {
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
}


// File: localhost/compound/import/CompoundBorrowProxy.sol

pragma solidity ^0.6.0;




contract CompoundBorrowProxy {

    address public constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant COMPTROLLER_ADDR = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;

    function borrow(address _cCollToken, address _cBorrowToken, address _borrowToken, uint _amount) public {
        address[] memory markets = new address[](2);
        markets[0] = _cCollToken;
        markets[1] = _cBorrowToken;

        ComptrollerInterface(COMPTROLLER_ADDR).enterMarkets(markets);

        require(CTokenInterface(_cBorrowToken).borrow(_amount) == 0);

        // withdraw funds to msg.sender
        if (_borrowToken != ETH_ADDR) {
            ERC20(_borrowToken).transfer(msg.sender, ERC20(_borrowToken).balanceOf(address(this)));
        } else {
            msg.sender.transfer(address(this).balance);
        }
    }
}