pragma solidity 0.5.16;

//based on swc
//In this code, an attacker can specify a function type as an arbitrary code statement through assembly code.
//assembly code can change a function type to any code instruction.

contract FunctionTypes {
    struct Func{ 
        function () internal f; 
    }
    
    uint256 a = 0;
    uint b;

    constructor() public payable { require(msg.value != 0); }
    
    function withdraw() private {
        uint c = 0;
        uint d;
        a = 1;
        require(msg.value == 0, 'dont send funds!');
        address(msg.sender).transfer(address(this).balance);
    }
    
    function frwd() internal{ 
        withdraw(); 
    }
    
    function breakIt() public payable {
        require(msg.value != 0, 'send funds!');
        Func memory func;
        func.f = frwd;
        //Using assembly code allows developers to develop smart contracts more flexibly, which brings both flexibility and danger. One known danger is that function variables can be specified as any type through assembly code, which may introduce a danger.
        assembly { mstore(func, add(mload(func), callvalue)) }  //wrong
        //assembly { mstore(func.f(), add(mload(func.f()), callvalue)) } //inject SPECIFY FUNC VAR AS ANY TYPE
        func.f();
    }
}
