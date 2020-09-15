/**
 *Submitted for verification at Etherscan.io on 2020-05-07
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract InstaAccount {
    
    function callOneInch(
        bytes calldata _callData,
        uint ethAmt,
        address _target
    )
    external {
        // solium-disable-next-line security/no-call-value
        // (bool success, bytes memory data) = address(getOneSplitAddress()).call.value(ethAmt)(_callData);
        // if (!success) revert("Failed");
        // address _target = getOneSplitAddress();
        bytes memory datas = _callData;
        assembly {
            let succeeded := call(gas(), _target, ethAmt, add(datas, 0x20), mload(datas), 0, 0)

            switch iszero(succeeded)
                case 1 {
                    // throw if delegatecall failed
                    let size := returndatasize()
                    returndatacopy(0x00, 0x00, size)
                    revert(0x00, size)
                }
        }
        // buyAmt = data;
    }
}