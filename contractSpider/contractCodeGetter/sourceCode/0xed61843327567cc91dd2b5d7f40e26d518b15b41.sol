/**
 *Submitted for verification at Etherscan.io on 2020-04-30
*/

pragma solidity ^0.5.0;

contract InterestRate {
    function calculateInterestRates(
        address _reserve,
        uint256 _availableLiquidity,
        uint256 _totalBorrowsStable,
        uint256 _totalBorrowsVariable,
        uint256 _averageStableBorrowRate
    )
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );
}

contract AaveCore {
    function getReserveInterestRateStrategyAddress(address) public view returns (address);
    function getReserveTotalBorrowsStable(address) public view returns (uint);
    function getReserveTotalBorrowsVariable(address) public view returns (uint);
    function getReserveCurrentAverageStableBorrowRate(address) public view returns (uint);
    function getReserveAvailableLiquidity (address) public view returns (uint);
}

contract AaveRate {
    
    AaveCore public aaveCore = AaveCore(0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3);
    
    function getNewRate(address _token, uint _amountAdded) external view returns (uint newVariableRate) {
        address intrestRateAddr = aaveCore.getReserveInterestRateStrategyAddress(_token);
        
        uint availableLiquidity = aaveCore.getReserveAvailableLiquidity(_token);
        availableLiquidity += _amountAdded;
        
        (newVariableRate , , ) = InterestRate(intrestRateAddr).calculateInterestRates(
            _token,
            availableLiquidity,
            aaveCore.getReserveTotalBorrowsStable(_token),
            aaveCore.getReserveTotalBorrowsVariable(_token),
            aaveCore.getReserveCurrentAverageStableBorrowRate(_token)
            );
    }
}