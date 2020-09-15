/**
 *Submitted for verification at Etherscan.io on 2020-07-30
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface CTokenInterface {
    function exchangeRateStored() external view returns (uint);
    function borrowBalanceStored(address) external view returns (uint);

    function balanceOf(address) external view returns (uint);
}

interface ListInterface {
    function accounts() external view returns (uint64);
    function accountID(address) external view returns (uint64);
    function accountAddr(uint64) external view returns (address);
}

contract Helpers {

    struct CompData {
        uint balanceOfUser;
        uint borrowBalanceStoredUser;
    }
    struct data {
        address user;
        CompData[] tokensData;
    }
    
     struct datas {
        CompData[] tokensData;
    }
}


contract Resolver is Helpers {
    
    function getDSAWallets(uint len) public view returns(address[] memory) {
        address[] memory wallets = new address[](len);
        ListInterface list = ListInterface(0x4c8a1BEb8a87765788946D6B19C6C6355194AbEb);
        uint _len = len == 0 ? uint(list.accounts()) : len;
        for (uint i = 0; i < _len; i++) {
            wallets[i] = list.accountAddr(uint64(i+1));
        }
        return wallets;
    }

    function getPosition(
        address[] calldata owners,
        address[] calldata cAddress
    )
        external
        view
        returns (datas[] memory)
    {
        datas[] memory _data = new datas[](cAddress.length);
        for (uint i = 0; i < cAddress.length; i++) {
            CompData[] memory tokensData = new CompData[](owners.length);
            CTokenInterface cToken = CTokenInterface(cAddress[i]);
            for (uint j = 0; j < owners.length; j++) {
                address _owner = owners[j];
                tokensData[j] = CompData(
                    cToken.balanceOf(_owner),
                    cToken.borrowBalanceStored(_owner)
                );
            }
            _data[i] = datas(
                tokensData
            );
        }
        return _data;
    }

}