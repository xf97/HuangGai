/**
 *Submitted for verification at Etherscan.io on 2020-08-06
*/

pragma solidity ^0.7.0;

abstract contract IFreeUpTo {
    function freeUpTo(uint256 value) external virtual returns (uint256 freed);
}

abstract contract IClaimComp {
    function claimComp(address holder) public virtual;
}

abstract contract ITransferBalanceOf {
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function balanceOf(address _owner) public virtual view returns (uint256 balance);
}

contract ClaimerSender {
    address constant private ELARA = 0xBb4068bac37ef5975210fA0cf03C0984f2D1542c;
    address constant private COMPTROLLER = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
    address constant private COMP_TOKEN_ADDRESS = 0xc00e94Cb662C3520282E6f5717214004A7f26888;
    address constant private GST2_ADDRESS = 0x0000000000b3F879cb30FE243b4Dfee438691c04;
    
    modifier discount(uint256 amount) {
        _;
        IFreeUpTo(GST2_ADDRESS).freeUpTo(amount);
    }
    
    constructor() discount(10) {}
    
    function claim() discount(10) public {
        IClaimComp(COMPTROLLER).claimComp(address(this));
        ITransferBalanceOf comp = ITransferBalanceOf(COMP_TOKEN_ADDRESS);
        comp.transfer(ELARA, comp.balanceOf(address(this)));
    }
}