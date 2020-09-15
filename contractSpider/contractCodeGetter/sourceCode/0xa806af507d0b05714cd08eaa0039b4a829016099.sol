/**
 *Submitted for verification at Etherscan.io on 2020-07-19
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.11;
pragma experimental ABIEncoderV2;

// ERC20 Interface
interface ERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address, uint) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
}
interface POOLS {
    function stakeForMember(uint inputVether, uint inputAsset, address pool, address member) external payable returns (uint units);
}
// Safe Math
library SafeMath {
    function sub(uint a, uint b) internal pure returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function add(uint a, uint b) internal pure returns (uint)   {
        uint c = a + b;
        assert(c >= a);
        return c;
    }

    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }
        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint a, uint b) internal pure returns (uint) {
        require(b > 0, "SafeMath: division by zero");
        uint c = a / b;
        return c;
    }
}

contract VetherPools {
    using SafeMath for uint;

    address public VETHER;
    uint public one = 10**18;
    uint public ETHCAP = 10 * one;
    uint public DAY = 86400;
    uint public DAYCAP = 30*DAY;

    address[] public arrayPools;
    uint public poolCount;
    mapping(address => address[]) public mapPoolStakers;
    mapping(address => PoolData) public poolData;
    struct PoolData {
        bool listed;
        uint genesis;
        uint vether;
        uint asset;
        uint vetherStaked;
        uint assetStaked;
        uint stakerCount;
        uint poolUnits;
        uint fees;
        uint volume;
        uint txCount;
    }
    
    address[] public arrayMembers;
    uint public memberCount;
    mapping(address => MemberData) public memberData;
    struct MemberData {
        address[] arrayPools;
        uint poolCount;
        mapping(address => StakeData) stakeData;
    }

    struct StakeData {
        uint vether;
        uint asset;
        uint stakeUnits;
    }
   
    event Staked(address pool, address member, uint inputAsset, uint inputVether, uint unitsIssued);
    event Unstaked(address pool, address member, uint outputAsset, uint outputVether, uint unitsClaimed);
    event Swapped(address assetFrom, address assetTo, uint inputAmount, uint transferAmount, uint outPutAmount, uint fee, address recipient);

    constructor () public payable {
        VETHER = 0x4Ba6dDd7b89ed838FEd25d208D4f644106E34279;
    }

    receive() external payable {
        buyAsset(address(0), msg.value);
    }

    //==================================================================================//
    // Staking functions

    function stake(uint inputVether, uint inputAsset, address pool) public payable returns (uint units) {
        units = stakeForMember(inputVether, inputAsset, pool, msg.sender);
        return units;
    }

    function stakeForMember(uint inputVether, uint inputAsset, address pool, address member) public payable returns (uint units) {
        require(pool == address(0), "Must be Eth");
        if (!poolData[pool].listed) { 
            require((inputAsset > 0 && inputVether > 0), "Must get both assets for new pool");
            _createNewPool(pool);
        }
        require((poolData[pool].asset + inputAsset <= ETHCAP), "Must not exceed ETH CAP");
        uint actualInputAsset = _handleTransferIn(pool, inputAsset);
        uint actualInputVether = _handleTransferIn(VETHER, inputVether);
        units = _stake(actualInputVether, actualInputAsset, pool, member);
        return units;
    }

    function _createNewPool(address _pool) internal {
        arrayPools.push(_pool);
        poolCount += 1;
        poolData[_pool].listed = true;
        poolData[_pool].genesis = now;
    }

    function _stake(uint _vether, uint _asset, address _pool, address _member) internal returns (uint _units) {
        uint _V = poolData[_pool].vether.add(_vether);
        uint _A = poolData[_pool].asset.add(_asset);
        _units = calcStakeUnits(_asset, _A, _vether, _V);   
        _incrementPoolBalances(_units, _vether, _asset, _pool);                                                  
        _addDataForMember(_member, _units, _vether, _asset, _pool);
        emit Staked(_pool, _member, _asset, _vether, _units);
        return _units;
    }

    //==================================================================================//
    // Unstaking functions

    // Unstake % for self
    function unstake(uint basisPoints, address pool) public returns (bool success) {
        _unstakeToExact(msg.sender, basisPoints, pool);
        return true;
    }
    // Internal - Convert to Exact with Checks
    function _unstakeToExact(address payable member, uint basisPoints, address pool) internal returns (bool success) {
        require(pool == address(0), "Must be Eth");
        require(poolData[pool].listed, "Must be listed");
        require((basisPoints > 0 && basisPoints <= 10000), "Must be valid BasisPoints");
        uint _units = calcPart(basisPoints, memberData[member].stakeData[pool].stakeUnits);
        _unstake(msg.sender, _units, pool);
        return true;
    }
    // Unstake an exact qty of units
    function unstakeExact(uint units, address pool) public returns (bool success) {
        _unstake(msg.sender, units, pool);
        return true;
    }
    // Internal - Unstake function
    function _unstake(address payable member, uint units, address pool) internal returns (bool success) {
        require(pool == address(0), "Must be Eth");
        require(memberData[msg.sender].stakeData[pool].stakeUnits >= units);
        uint _outputVether = calcShare(units, poolData[pool].poolUnits, poolData[pool].vether);
        uint _outputAsset = calcShare(units, poolData[pool].poolUnits, poolData[pool].asset);
        _handleUnstake(units, _outputVether, _outputAsset, member, pool);
        return true;
    }

    // Unstake % Asymmetrically
    function unstakeAsymmetric(uint basisPoints, address pool, bool toVether) public returns (uint outputAmount){
        require(pool == address(0), "Must be Eth");
        uint _units = calcPart(basisPoints, memberData[msg.sender].stakeData[pool].stakeUnits);
        outputAmount = unstakeExactAsymmetric(_units, pool, toVether);
        return outputAmount;
    }
    // Unstake Exact Asymmetrically
    function unstakeExactAsymmetric(uint units, address pool, bool toVether) public returns (uint outputAmount){
        require(pool == address(0), "Must be Eth");
        require((memberData[msg.sender].stakeData[pool].stakeUnits >= units), "Must own the units");
        uint poolUnits = poolData[pool].poolUnits;
        require(units < poolUnits, "Must not be last staker");
        uint _outputVether; uint _outputAsset; 
        if(toVether){
            _outputVether = calcAsymmetricShare(units, poolUnits, poolData[pool].vether);
            _outputAsset = 0;
            outputAmount = _outputVether;
        } else {
            _outputVether = 0;
            _outputAsset = calcAsymmetricShare(units, poolUnits, poolData[pool].asset);
            outputAmount = _outputAsset;
        }
        _handleUnstake(units, _outputVether, _outputAsset, msg.sender, pool);
        return outputAmount;
    }

    // Internal - handle Unstake
    function _handleUnstake(uint _units, uint _outputVether, uint _outputAsset, address payable _member, address _pool) internal {
        _decrementPoolBalances(_units, _outputVether, _outputAsset, _pool);
        _removeDataForMember(_member, _units, _pool);
        emit Unstaked(_pool, _member, _outputAsset, _outputVether, _units);
        _handleTransferOut(_pool, _outputAsset, _member);
        _handleTransferOut(VETHER, _outputVether, _member);
    } 

    //==================================================================================//
    // Upgrade functions

    // Upgrade from this contract to a new one - opt in
    function upgrade(address payable newContract) public {
        address pool = address(0);
        uint _units = memberData[msg.sender].stakeData[pool].stakeUnits;
        uint _outputVether = calcShare(_units, poolData[pool].poolUnits, poolData[pool].vether);
        uint _outputAsset = calcShare(_units, poolData[pool].poolUnits, poolData[pool].asset);
        _decrementPoolBalances(_units, _outputVether, _outputAsset, pool);
        _removeDataForMember(msg.sender, _units, pool);
        emit Unstaked(pool, msg.sender, _outputAsset, _outputVether, _units);
        ERC20(VETHER).approve(newContract, _outputVether);
        POOLS(newContract).stakeForMember{value:_outputAsset}(_outputVether, _outputAsset, pool, msg.sender);
    }

    // Unstake for member after Day Cap
    function unstakeForMember(address payable member, address pool) public returns (bool success) {
        require(now > poolData[pool].genesis + DAYCAP, "Must be after Day Cap");
        _unstakeToExact(member, 10000, pool);
        return true;
    }

    //==================================================================================//
    // Swapping functions

    function buyAsset(address pool, uint amount) public payable returns (uint outputAmount) {
        require(pool == address(0), "Must be Eth");
        require(now < poolData[pool].genesis + DAYCAP, "Must not be after Day Cap");
        uint actualAmount = _handleTransferIn(VETHER, amount);
        outputAmount = _swapVetherToAsset(actualAmount, address(0));
        _handleTransferOut(address(0), outputAmount, msg.sender);
        return outputAmount;
    }

    function sellAsset(address pool, uint amount) public payable returns (uint outputAmount) {
        require(pool == address(0), "Must be Eth");
        require(now < poolData[pool].genesis + DAYCAP, "Must not be after Day Cap");
        uint actualAmount = _handleTransferIn(address(0), amount);
        outputAmount = _swapAssetToVether(actualAmount, address(0));
        _handleTransferOut(VETHER, outputAmount, msg.sender);
        return outputAmount;
    }

    function _swapVetherToAsset(uint _x, address _pool) internal returns (uint _y){
        uint _X = poolData[_pool].vether;
        uint _Y = poolData[_pool].asset;
        _y =  calcSwapOutput(_x, _X, _Y);
        uint _fee = calcSwapFee(_x, _X, _Y);
        poolData[_pool].vether = poolData[_pool].vether.add(_x);
        poolData[_pool].asset = poolData[_pool].asset.sub(_y);
        _updatePoolMetrics(_y+_fee, _fee, _pool, false);
        emit Swapped(VETHER, _pool, _x, 0, _y, _fee, msg.sender);
        return _y;
    }

    function _swapAssetToVether(uint _x, address _pool) internal returns (uint _y){
        uint _X = poolData[_pool].asset;
        uint _Y = poolData[_pool].vether;
        _y =  calcSwapOutput(_x, _X, _Y);
        uint _fee = calcSwapFee(_x, _X, _Y);
        poolData[_pool].asset = poolData[_pool].asset.add(_x);
        poolData[_pool].vether = poolData[_pool].vether.sub(_y);
        _updatePoolMetrics(_y+_fee, _fee, _pool, true);
        emit Swapped(_pool, VETHER, _x, 0, _y, _fee, msg.sender);
        return _y;
    }

    //==================================================================================//
    // Data Model

    function _incrementPoolBalances(uint _units, uint _vether, uint _asset, address _pool) internal {
        poolData[_pool].poolUnits = poolData[_pool].poolUnits.add(_units);
        poolData[_pool].vether = poolData[_pool].vether.add(_vether);
        poolData[_pool].asset = poolData[_pool].asset.add(_asset); 
        poolData[_pool].vetherStaked = poolData[_pool].vetherStaked.add(_vether);
        poolData[_pool].assetStaked = poolData[_pool].assetStaked.add(_asset); 
    }

    function _decrementPoolBalances(uint _units, uint _vether, uint _asset, address _pool) internal {
        poolData[_pool].vether = poolData[_pool].vether.sub(_vether);
        poolData[_pool].asset = poolData[_pool].asset.sub(_asset); 
        uint _unstakedVether = calcShare(_units, poolData[_pool].poolUnits, poolData[_pool].vetherStaked);
        uint _unstakedAsset = calcShare(_units, poolData[_pool].poolUnits, poolData[_pool].assetStaked);
        poolData[_pool].vetherStaked = poolData[_pool].vetherStaked.sub(_unstakedVether);
        poolData[_pool].assetStaked = poolData[_pool].assetStaked.sub(_unstakedAsset); 
        poolData[_pool].poolUnits = poolData[_pool].poolUnits.sub(_units);
    }

    function _addDataForMember(address _member, uint _units, uint _vether, uint _asset, address _pool) internal {
        if(memberData[_member].poolCount == 0){
            memberCount += 1;
            arrayMembers.push(_member);
        }
        if( memberData[_member].stakeData[_pool].stakeUnits == 0){
            mapPoolStakers[_pool].push(_member);
            memberData[_member].arrayPools.push(_pool);
            memberData[_member].poolCount +=1;
            poolData[_pool].stakerCount += 1;
        }
        memberData[_member].stakeData[_pool].stakeUnits = memberData[_member].stakeData[_pool].stakeUnits.add(_units);
        memberData[_member].stakeData[_pool].vether = memberData[_member].stakeData[_pool].vether.add(_vether);
        memberData[_member].stakeData[_pool].asset = memberData[_member].stakeData[_pool].asset.add(_asset);
    }

    function _removeDataForMember(address _member, uint _units, address _pool) internal{
        uint stakeUnits = memberData[_member].stakeData[_pool].stakeUnits;
        uint _vether = calcShare(_units, stakeUnits, memberData[_member].stakeData[_pool].vether);
        uint _asset = calcShare(_units, stakeUnits, memberData[_member].stakeData[_pool].asset);
        memberData[_member].stakeData[_pool].stakeUnits = memberData[_member].stakeData[_pool].stakeUnits.sub(_units);
        memberData[_member].stakeData[_pool].vether = memberData[_member].stakeData[_pool].vether.sub(_vether);
        memberData[_member].stakeData[_pool].asset = memberData[_member].stakeData[_pool].asset.sub(_asset);
        if( memberData[_member].stakeData[_pool].stakeUnits == 0){
            poolData[_pool].stakerCount = poolData[_pool].stakerCount.sub(1);
        }
    }

    function _updatePoolMetrics(uint _tx, uint _fee, address _pool, bool _toVether) internal {
        poolData[_pool].txCount += 1;
        uint _volume = poolData[_pool].volume;
        uint _fees = poolData[_pool].fees;
        if(_toVether){
            poolData[_pool].volume = _tx.add(_volume); 
            poolData[_pool].fees = _fee.add(_fees); 
        } else {
            uint _txVether = calcValueInVether(_tx, _pool);
            uint _feeVether = calcValueInVether(_fee, _pool);
            poolData[_pool].volume = _volume.add(_txVether); 
            poolData[_pool].fees = _fees.add(_feeVether); 
        }
    }

    //==================================================================================//
    // Asset Transfer Functions

    function _handleTransferIn(address _asset, uint _amount) internal returns(uint actual){
        if(_amount > 0) {
            if(_asset == address(0)){
                require((_amount == msg.value), "Must get Eth");
                actual = _amount;
            } else {
                uint startBal = ERC20(_asset).balanceOf(address(this)); 
                ERC20(_asset).transferFrom(msg.sender, address(this), _amount); 
                actual = ERC20(_asset).balanceOf(address(this)).sub(startBal);
            }
        }
    }

    function _handleTransferOut(address _asset, uint _amount, address payable _recipient) internal {
        if(_amount > 0) {
            if (_asset == address(0)) {
                _recipient.call{value:_amount}(""); 
            } else {
                ERC20(_asset).transfer(_recipient, _amount);
            }
        }
    }

    function sync(address pool) public {
        if (pool == address(0)) {
            poolData[pool].asset = address(this).balance;
        } else {
            poolData[pool].asset = ERC20(pool).balanceOf(address(this));
        }
    }

    //==================================================================================//
    // Helper functions

    function getStakerUnits(address member, address pool) public view returns(uint stakerUnits){
        return (memberData[member].stakeData[pool].stakeUnits);
    }
    function getStakerShareVether(address member, address pool) public view returns(uint vether){
        uint _units = memberData[member].stakeData[pool].stakeUnits;
        vether = calcShare(_units, poolData[pool].poolUnits, poolData[pool].vether);
        return vether;
    }
    function getStakerShareAsset(address member, address pool) public view returns(uint asset){
        uint _units = memberData[member].stakeData[pool].stakeUnits;
        asset = calcShare(_units, poolData[pool].poolUnits, poolData[pool].asset);
        return asset;
    }

    function getPoolStaker(address pool, uint index) public view returns(address staker){
        return(mapPoolStakers[pool][index]);
    }

    function getMemberPool(address member, uint index) public view returns(address staker){
        return(memberData[member].arrayPools[index]);
    }
    function getMemberPoolCount(address member) public view returns(uint){
        return(memberData[member].poolCount);
    }

    function getMemberStakeData(address member, address pool) public view returns(StakeData memory){
        return(memberData[member].stakeData[pool]);
    }

    function getPoolROI(address pool) public view returns (uint roi){
        uint _assetStakedInVether = calcValueInVether(poolData[pool].assetStaked, pool);
        uint _vetherStart = poolData[pool].vetherStaked.add(_assetStakedInVether);
        uint _assetInVether = calcValueInVether(poolData[pool].asset, pool);
        uint _vetherEnd = poolData[pool].vether.add(_assetInVether);
        if (_vetherStart == 0){
            roi = 0;
        } else {
            roi = (_vetherEnd.mul(10000)).div(_vetherStart);
        }
        // uint secondsPassed = now.sub(poolData[pool].genesis);
        // dayROI*365 + 100000
        // minus 365*10000
        return roi;
   }

    function getMemberROI(address member, address pool) public view returns (uint roi){
        // TODO: ensure staked updates when unstaking
        uint _assetStakedInVether = calcValueInVether(memberData[member].stakeData[pool].asset, pool);
        uint _vetherStart = memberData[member].stakeData[pool].vether.add(_assetStakedInVether);
        uint _stakerUnits = memberData[msg.sender].stakeData[pool].stakeUnits;
        uint _memberVether = calcShare(_stakerUnits, poolData[pool].poolUnits, poolData[pool].vether);
        uint _memberAsset = calcShare(_stakerUnits, poolData[pool].poolUnits, poolData[pool].asset);
        uint _assetInVether = calcValueInVether(_memberAsset, pool);
        uint _vetherEnd = _memberVether.add(_assetInVether);
        if (_vetherStart == 0){
            roi = 0;
        } else {
            roi = (_vetherEnd.mul(10000)).div(_vetherStart);
        }
        return roi;
   }

   function calcValueInVether(uint amount, address pool) public view returns (uint price){
       uint _asset = poolData[pool].asset;
       uint _vether = poolData[pool].vether;
       return (amount.mul(_vether)).div(_asset);
   }

    function calcValueInAsset(uint amount, address pool) public view returns (uint price){
       uint _asset = poolData[pool].asset;
       uint _vether = poolData[pool].vether;
       return (amount.mul(_asset)).div(_vether);
   }

   function calcAssetPPinVether(uint amount, address pool) public view returns (uint _output){
        uint _asset = poolData[pool].asset;
        uint _vether = poolData[pool].vether;
        return  calcSwapOutput(amount, _asset, _vether);
   }

    function calcVetherPPinAsset(uint amount, address pool) public view returns (uint _output){
        uint _asset = poolData[pool].asset;
        uint _vether = poolData[pool].vether;
        return  calcSwapOutput(amount, _vether, _asset);
   }

   //==================================================================================//
   // Core Math

    function calcPart(uint bp, uint total) public pure returns (uint part){
        // 10,000 basis points = 100.00%
        require((bp <= 10000) && (bp > 0));
        return calcShare(bp, 10000, total);
    }

    function calcShare(uint part, uint total, uint amount) public pure returns (uint share){
        // share = amount * part/total
        return(amount.mul(part)).div(total);
    }

    function  calcSwapOutput(uint x, uint X, uint Y) public pure returns (uint output){
        // y = (x * X * Y )/(x + X)^2
        uint numerator = x.mul(X.mul(Y));
        uint denominator = (x.add(X)).mul(x.add(X));
        return numerator.div(denominator);
    }

    function  calcSwapFee(uint x, uint X, uint Y) public pure returns (uint output){
        // y = (x * x * Y) / (x + X)^2
        uint numerator = x.mul(x.mul(Y));
        uint denominator = (x.add(X)).mul(x.add(X));
        return numerator.div(denominator);
    }

    function calcStakeUnits(uint a, uint A, uint v, uint V) public pure returns (uint units){
        // units = ((V + A) * (v * A + V * a))/(4 * V * A)
        // (part1 * (part2 + part3)) / part4
        uint part1 = V.add(A);
        uint part2 = v.mul(A);
        uint part3 = V.mul(a);
        uint numerator = part1.mul((part2.add(part3)));
        uint part4 = 4 * (V.mul(A));
        return numerator.div(part4);
    }

    function calcAsymmetricShare(uint s, uint T, uint A) public pure returns (uint share){
        // share = (s * A * (2 * T^2 - 2 * T * s + s^2))/T^3
        // (part1 * (part2 - part3 + part4)) / part5
        uint part1 = s.mul(A);
        uint part2 = T.mul(T).mul(2);
        uint part3 = T.mul(s).mul(2);
        uint part4 = s.mul(s);
        uint numerator = part1.mul(part2.sub(part3).add(part4));
        uint part5 = T.mul(T).mul(T);
        return numerator.div(part5);
    }
}