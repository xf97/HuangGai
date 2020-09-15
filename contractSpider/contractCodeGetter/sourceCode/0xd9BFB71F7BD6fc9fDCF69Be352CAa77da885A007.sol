/**
 *Submitted for verification at Etherscan.io on 2020-05-07
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract InstaAccount {

    // event LogCast(address indexed origin, address indexed sender, uint value);

    // receive() external payable {}

    //  /**
    //  * @dev Delegate the calls to Connector And this function is ran by cast().
    //  * @param _target Target to of Connector.
    //  * @param _data CallData of function in Connector.
    // */
    // function spell(address _target, bytes memory _data) internal {
    //     require(_target != address(0), "target-invalid");
    //     assembly {
    //         let succeeded := delegatecall(gas(), _target, add(_data, 0x20), mload(_data), 0, 0)

    //         switch iszero(succeeded)
    //             case 1 {
    //                 // throw if delegatecall failed
    //                 let size := returndatasize()
    //                 returndatacopy(0x00, 0x00, size)
    //                 revert(0x00, size)
    //             }
    //     }
    // }

    // /**
    //  * @dev This is the main function, Where all the different functions are called
    //  * from Smart Account.
    //  * @param _targets Array of Target(s) to of Connector.
    //  * @param _datas Array of Calldata(S) of function.
    // */
    // function cast(
    //     address[] calldata _targets,
    //     bytes[] calldata _datas,
    //     address _origin,
    //     address check
    // )
    // external
    // payable
    // {
    //     for (uint i = 0; i < _targets.length; i++) {
    //         spell(_targets[i], _datas[i]);
    //     }
    //     if (check != address(0)) require(CheckInterface(check).isOk(), "not-ok");
    //     emit LogCast(_origin, msg.sender, msg.value);
    // }
    
    // function decode(
    //     bytes calldata _datas
    // )
    // external pure
    //  returns (
    //     TokenInterface fromToken,
    //     TokenInterface toToken,
    //     uint256 fromTokenAmount,
    //     uint256 minReturnAmount,
    //     uint256 guaranteedAmount
    // )
    // {
    //     bytes memory _data = _datas;
    //     assembly {
    //         // data := calldatacopy(_datas, 0, 1)
    //         // sig := mload(add(_datas, add(0x20, 0)))
    //         fromToken := mload(add(_data, 36))
    //         toToken := mload(add(_data, 68))
    //         fromTokenAmount := mload(add(_data, 100))
    //         minReturnAmount := mload(add(_data, 132))
    //         guaranteedAmount := mload(add(_data, 164))
    //     }
        
    // }
    
    function callOneInch(
        bytes memory _callData,
        uint ethAmt,
        address _target
    )
    public {
        // solium-disable-next-line security/no-call-value
        // (bool success, bytes memory data) = address(getOneSplitAddress()).call.value(ethAmt)(_callData);
        // if (!success) revert("Failed");
        // address _target = getOneSplitAddress();
        assembly {
            let succeeded := call(gas(), _target, ethAmt, add(_callData, 0x20), mload(_callData), 0, 0)

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