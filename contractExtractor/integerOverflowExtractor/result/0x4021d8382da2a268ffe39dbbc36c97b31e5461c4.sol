/**
 *Submitted for verification at Etherscan.io on 2020-06-06
*/

pragma solidity ^0.5.17;


library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


contract tERC20 {
    function transferFrom(address _from, address _to, uint256 _value) public;
}


contract Pcontract {
    function () payable external {}
    function callContract(address _contract, uint256 _EthAmount, bytes calldata _data) external;
    function approve(address _contract, uint256 _amount) external;
}


contract Owned {
    address public owner;
    address public newOwner;
    
    event OwnershipTransferred(address indexed _from, address indexed _to);
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "Sender Must be Owner");
        _;
    }
    
    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
    
    
}

contract Signs {
    
    constructor() public {}
    
    
    function getSigner(string memory _func, address _to, uint256 _EthAmount, uint256 _amount, string memory _ticker, string memory _feeTicker, uint256 _nonce, bool _parent, bytes memory _cdata, bytes memory _sign) public view returns (address){
        bytes32 typedData = keccak256(
            abi.encodePacked( byte(0x19), byte(0x01), 
                keccak256(abi.encode(
                    keccak256(abi.encodePacked("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")),
                    keccak256("MetaTransact"), //dappName
                    keccak256("1.2"), //version
                    1, // network
                    this, 
                    0x6572776572776c48385a7978356c7430556b5554324c47664b6331756b364e53
                )),
                keccak256(abi.encode( keccak256(abi.encodePacked("MetaTransact(string Method,address Address,uint256 EthAmount,uint256 Amount,string Ticker,string FeeTicker,uint256 Nonce,bool IsParent,bytes InputData)")) ,
                    keccak256(bytes(_func)), _to, _EthAmount, _amount, keccak256(bytes(_ticker)), keccak256(bytes(_feeTicker)), _nonce, _parent, keccak256(_cdata)
                ))
            )
        );
        
        return recover(typedData, _sign);
    }
    
    
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address){
        bytes32 r;
        bytes32 s;
        uint8 v;

        (v, r, s) = splitSignature(signature);

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            // solium-disable-next-line arg-overflow
            return ecrecover(hash, v, r, s);
        }
    }
    
    
    function splitSignature(bytes memory sig) internal pure returns (uint8, bytes32, bytes32){
        require(sig.length == 65);

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }
        return (v, r, s);
    }
}


contract metaTransact is Owned, Signs {
    using SafeMath for uint256;
    
    
    address public proxyContract;
    
    mapping(string  => address) public tickers;
    mapping(address => uint256) public tickerFee;
    
    mapping(address => uint256) public currentNonce;
    mapping(address => address payable) public userProxy;
    mapping(address => address) public parantAddress;
    
    mapping(address => addressMeta) metaAddresses;
    
    
    struct addressMeta {
        uint currIndex;
        mapping(uint => address) childAddresses;
        mapping(address => mapping(address => uint256)) allowances;
    }
    
    
    
    
    constructor() public {}
    
    
    function interactDappUProxy(address _dapp, uint256 _EthAmount, uint256 _amount, string calldata _feeTicker, uint256 _nonce, bytes calldata _sign, bytes calldata _calldata, address _relayer) external {
        require(tickers[_feeTicker] != address(0x0));
        
        address cAddress = getSigner("interactDappUProxy", _dapp, _EthAmount, _amount, "", _feeTicker, _nonce, false, _calldata, _sign);
        address payable cpAddress = userProxy[cAddress];
        
        require(cpAddress != address(0x0));
        require(currentNonce[cpAddress] == _nonce);
        currentNonce[cpAddress] = currentNonce[cpAddress].add(1);
        
        internalTransfer(cpAddress, _relayer, _amount, false, tickers[_feeTicker], address(0x0), address(0x0));
        Pcontract(cpAddress).callContract(_dapp, _EthAmount, _calldata);
    }
    
    
    function interactDapp(address _dapp, uint256 _EthAmount, uint256 _amount, string calldata _feeTicker, uint256 _nonce, bytes calldata _sign, bytes calldata _calldata, address _relayer) external {
        require(tickers[_feeTicker] != address(0x0));
        
        address cAddress = getSigner("interactDapp", _dapp, _EthAmount, _amount, "", _feeTicker, _nonce, false, _calldata, _sign);
        address payable cpAddress = userProxy[cAddress];
        
        require(cpAddress != address(0x0));
        require(currentNonce[cAddress] == _nonce);
        currentNonce[cAddress] = currentNonce[cAddress].add(1);
        
        internalTransfer(cAddress, _relayer, _amount, false, tickers[_feeTicker], address(0x0), address(0x0));
        Pcontract(cpAddress).callContract(_dapp, _EthAmount, _calldata);
    }
    
    
    function processTxn(address _to, uint256 _amount, string calldata _ticker, string calldata _feeTicker, uint256 _nonce, bool _isParent, bytes calldata _sign, address _relayer) external {
        address cAddress = getSigner("processTxn", _to, 0, _amount, _ticker, _feeTicker, _nonce, _isParent, bytes(""), _sign);
        address tickerAddress = tickers[_ticker];
        address feeTickerAddress;
        
        if(keccak256(abi.encodePacked(_ticker)) == keccak256(abi.encodePacked(_feeTicker))){
            feeTickerAddress = tickerAddress;
            require(tickerAddress != address(0x0));
        } else {
            feeTickerAddress = tickers[_feeTicker];
            require(tickerAddress != address(0x0) && feeTickerAddress != address(0x0));
        }
        
        
        if(_isParent){
            address pAddress = parantAddress[cAddress];
            require(pAddress != address(0x0));
            
            addressMeta storage am = metaAddresses[pAddress];
            
            require(am.allowances[cAddress][tickerAddress] >= _amount);
            am.allowances[cAddress][tickerAddress] = am.allowances[cAddress][tickerAddress].sub(_amount);
            
            if(tickerAddress != feeTickerAddress){
                uint256 _fee = tickerFee[feeTickerAddress];
                require(am.allowances[cAddress][feeTickerAddress] >= _fee);
                am.allowances[cAddress][feeTickerAddress] = am.allowances[cAddress][feeTickerAddress].sub(_fee);
            }
            
            cAddress = pAddress;
        } 
        
        require(currentNonce[cAddress] == _nonce);
        currentNonce[cAddress] = currentNonce[cAddress].add(1);
        
        internalTransfer(cAddress, _to, _amount, true, tickerAddress, feeTickerAddress, _relayer);
    }
    
    
    
    
    
    function internalTransfer(address _from, address _to, uint256 _amount, bool _payfee, address _tickerAddress, address _feeTickerAddress, address _relayer) internal {
        if(_payfee){
            uint256 _fee = tickerFee[_feeTickerAddress];
            if(_fee > 0){
                if(_tickerAddress == _feeTickerAddress){
                    require(_amount > _fee);
                    _amount = _amount.sub(_fee);
                }
                
                tERC20(_feeTickerAddress).transferFrom(_from, _relayer, _fee);
            }
        }
        
        if(_amount > 0){
            tERC20(_tickerAddress).transferFrom(_from, _to, _amount);
        }
    }
    
    
    
    
    
    
    
    
    function createProxy(address _address) external {
        require(proxyContract != address(0x0));
        require(userProxy[_address] == address(0x0));
        
        address payable _proxyAddress;
        bytes20 targetBytes = bytes20(proxyContract);
        
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            _proxyAddress := create(0, clone, 0x37)
        }
        
        userProxy[_address] = address(_proxyAddress);
    }
    
    
    function createProxyUT(address _address, uint256 _amount, string calldata _feeTicker, uint256 _nonce, bytes calldata _sign, address _relayer) external {
        address cAddress = getSigner("createProxyUT", _address, 0, _amount, "", _feeTicker, _nonce, false, bytes(""), _sign);
        
        require(proxyContract != address(0x0));
        require(userProxy[_address] == address(0x0));
        require(tickers[_feeTicker] != address(0x0));
        
        require(currentNonce[cAddress] == _nonce);
        currentNonce[cAddress] = currentNonce[cAddress].add(1);
        
        internalTransfer(cAddress, _relayer, _amount, false, tickers[_feeTicker], address(0x0), address(0x0));
        
        address payable _proxyAddress;
        bytes20 targetBytes = bytes20(proxyContract);
        
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            _proxyAddress := create(0, clone, 0x37)
        }
        
        userProxy[_address] = address(_proxyAddress);
    }
    
    
    
    function pApprove(address _address, string calldata _ticker, uint256 _amount) external {
        require(tickers[_ticker] != address(0x0));
        require(userProxy[_address] != address(0x0));
        
        Pcontract(userProxy[_address]).approve(tickers[_ticker], _amount);
    }
    
    
    
    
    //  ----------------------------------------------------------------------------
    
    
    function getTotalChild(address _address) public view returns (uint) {
        addressMeta storage am = metaAddresses[_address];
        return am.currIndex;
    }
    
    
    function getChildAddressAtIndex(address _parent, uint _index) public view returns (address) {
        addressMeta storage am = metaAddresses[_parent];
        return am.childAddresses[_index];
    }
    
    
    function getChildAllowance(address _parent, address _childAddress, string memory _ticker) public view returns (uint) {
        addressMeta storage am = metaAddresses[_parent];
        return am.allowances[_childAddress][tickers[_ticker]];
    }
    
    
    // ----------------------------------------------------------------------------
    
    function addChildAddress(address _child) external {
        require(parantAddress[_child] == address(0x0));
        
        addressMeta storage am = metaAddresses[msg.sender];
        am.childAddresses[am.currIndex] = _child;
        am.currIndex = (am.currIndex).add(1);
        
        parantAddress[_child] = msg.sender;
    }
    
    
    function addChildAddressUT(address _child, string calldata _feeTicker, uint256 _nonce, bytes calldata _sign, address _relayer) external {
        require(parantAddress[_child] == address(0x0));
        address cAddress = getSigner("addChildAddressUT", _child, 0, 0, "", _feeTicker, _nonce, false, bytes(""), _sign);
        
        
        require(currentNonce[cAddress] == _nonce);
        currentNonce[cAddress] = currentNonce[cAddress].add(1);
        
        address feeTickerAddress = tickers[_feeTicker];
        require(feeTickerAddress != address(0x0));
        
        internalTransfer(cAddress, _relayer, tickerFee[feeTickerAddress], false, feeTickerAddress, address(0x0), address(0x0));
        
        
        addressMeta storage am = metaAddresses[cAddress];
        am.childAddresses[am.currIndex] = _child;
        am.currIndex = (am.currIndex).add(1);
        
        parantAddress[_child] = cAddress;
    }
    
    
    // -------------------------------
    
    
    function _childAllowance(address _parent, address _child, address _tickerAddress, uint256 _allowance) internal {
        addressMeta storage am = metaAddresses[_parent];
        am.allowances[_child][_tickerAddress] = _allowance;
    }
    
    
    
    function childAllowance(address _child, uint256 _allowance, string calldata _ticker) external {
        address tickerAddress = tickers[_ticker];
        require(tickerAddress != address(0x0));
        require(parantAddress[_child] == msg.sender);
        
        addressMeta storage am = metaAddresses[msg.sender];
        am.allowances[_child][tickerAddress] = _allowance;
    }
    
    
    function childAllowanceUT(address _child, uint256 _allowance, string calldata _ticker, string calldata _feeTicker, uint256 _nonce, bytes calldata _sign, address _relayer) external {
        address cAddress = getSigner("childAllowanceUT", _child, 0, _allowance, _ticker, _feeTicker, _nonce, false, bytes(""), _sign);
        
        require(parantAddress[_child] == cAddress);
        require(currentNonce[cAddress] == _nonce);
        currentNonce[cAddress] = currentNonce[cAddress].add(1);
        
        
        address tickerAddress = tickers[_ticker];
        address feeTickerAddress = tickers[_feeTicker];
        require(tickerAddress != address(0x0) && feeTickerAddress != address(0x0));
        
        internalTransfer(cAddress, _relayer, tickerFee[feeTickerAddress], false, feeTickerAddress, address(0x0), address(0x0));
        _childAllowance(cAddress, _child, tickerAddress, _allowance);
    }
    
    
    // ----------------------------------------------------------------------------
    
    
    function destroyNonce() external {
        currentNonce[msg.sender] = currentNonce[msg.sender].add(1);
    }
    
    
    // ------------->
    
    function _addTicker(string calldata _ticker, address _tickerAddress, uint256 _fee) external onlyOwner {
        require(tickers[_ticker] == address(0x0) && _tickerAddress != address(0x0));
        
        tickers[_ticker] = _tickerAddress;
        tickerFee[_tickerAddress] = _fee;
    }
    
    
    function _removeTicker(string calldata _ticker) external onlyOwner {
        require(tickers[_ticker] != address(0x0));
        
        delete tickerFee[tickers[_ticker]];
        delete tickers[_ticker];
    }
    
    
    function _updateTickerFee(string calldata _ticker, uint256 _fee) external onlyOwner {
        require(tickers[_ticker] != address(0x0));
        
        tickerFee[tickers[_ticker]] = _fee;
    }
    
    
    function _setProxyContract(address _address) external onlyOwner {
        require(proxyContract == address(0x0));
        
        proxyContract = _address;
    }
    
}