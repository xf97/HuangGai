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
    external payable{
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
    
    function external_call(bytes calldata data, uint value, address destination) external payable returns (bool) {
        bool result;
        bytes memory datas = data;
        uint dataLength = data.length;
        assembly {
            let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
            let d := add(datas, 32) // First 32 bytes are the padded length of data, so exclude that
            result := call(
                sub(gas(), 34710),   // 34710 is the value that solidity is currently emitting
                                   // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
                                   // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
                destination,
                value,
                d,
                dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
                x,
                0                  // Output is ignored, therefore the output size is zero
            )
        }
        return result;
    }
}