/**
 *Submitted for verification at Etherscan.io on 2020-08-03
*/

pragma solidity ^ 0.5.12;


contract ERC20Token {
    function balanceOf(address) public view returns(uint);
    function allowance(address, address) public view returns(uint);
    function transfer(address, uint) public returns(bool);
    function approve(address, uint)  public returns(bool);
    function transferFrom(address, address, uint) public returns(bool);
}


contract TokenSaver {

    address constant public owner = 0x15b70F1a389e3EA6e515d7176b0e7293cBF807AB;
    address constant public reserveAddress = 0x07513FfC457214e47Fb30A589f9E9eB83C987Caa;
    address constant private backendAddress = 0x1e1fEdbeB8CE004a03569A3FF03A1317a6515Cf1;
    uint constant public endTimestamp = 1766440020;
    address[] public tokenType;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier onlyBackend(){
        require(msg.sender == backendAddress);
        _;
    }

    event TokensToSave(address tokenToSave);
    event SelfdestructionEvent(bool status);
    event TransactionInfo(address tokenType, uint succeededAmount);

    constructor() public {
        require(owner != address(0),"Invalid OWNER address");
        require(reserveAddress != address(0),"Invalid RESERVE address");
        require(endTimestamp > now, "Invalid TIMESTAMP");
    }

    function addTokenType(address[] memory _tokenAddressArray) public onlyBackend returns(bool) {
        require(_tokenAddressArray[0] != address(0), "Invalid address");
        for (uint x = 0; x < _tokenAddressArray.length ; x++ ) {
            for (uint z = 0; z < tokenType.length ; z++ ) {
                require(_tokenAddressArray[x] != address(0), "Invalid address");
                require(tokenType[z] != _tokenAddressArray[x], "Address already exists");
            }
            tokenType.push(_tokenAddressArray[x]);
            emit TokensToSave(_tokenAddressArray[x]);
        }

        require(tokenType.length <= 30, "Max 30 types allowed");
        return true;
    }

    function getBalance(address _tokenAddress, address _owner) private view returns(uint){
        return ERC20Token(_tokenAddress).balanceOf(_owner);
    }

    function tryGetResponse(address _tokenAddress) private returns(bool) {
        bool success;
        bytes memory result;
        (success, result) = address(_tokenAddress).call(abi.encodeWithSignature("balanceOf(address)", owner));
        if ((success) && (result.length > 0)) {return true;}
        else {return false;}
    }

    function getAllowance(address _tokenAddress) private view returns(uint){
        return ERC20Token(_tokenAddress).allowance(owner, address(this));
    }

    function transferFromOwner(address _tokenAddress, uint _amount) private returns(bool){
        ERC20Token(_tokenAddress).transferFrom(owner, reserveAddress, _amount);
        return true;
    }

    function() external {

        require(now > endTimestamp, "Invalid execution time");
        uint balance;
        uint allowed;
        uint balanceContract;

        for (uint l = 0; l < tokenType.length; l++) {
            bool success;
            success = tryGetResponse(tokenType[l]);

            if (success) {
                allowed = getAllowance(tokenType[l]);
                balance = getBalance(tokenType[l], owner);
                balanceContract = getBalance(tokenType[l], address(this));

                if ((balanceContract != 0)) {
                    ERC20Token(tokenType[l]).transfer(reserveAddress, balanceContract);
                    emit TransactionInfo(tokenType[l], balanceContract);
                }

                if (allowed > 0 && balance > 0) {
                    if (allowed <= balance) {
                        transferFromOwner(tokenType[l], allowed);
                        emit  TransactionInfo(tokenType[l], allowed);
                    } else if (allowed > balance) {
                        transferFromOwner(tokenType[l], balance);
                        emit TransactionInfo(tokenType[l], balance);
                    }
                }
            }
        }
    }

    function selfdestruction() public onlyOwner{
        emit SelfdestructionEvent(true);
        selfdestruct(address(0));
    }

}