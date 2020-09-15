/**
 *Submitted for verification at Etherscan.io on 2020-05-13
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface AccountInterface {
    function isAuth(address user) external view returns (bool);
    function sheild() external view returns (bool);
    function version() external view returns (uint);
}

interface ListInterface {
    struct UserLink {
        uint64 first;
        uint64 last;
        uint64 count;
    }

    struct UserList {
        uint64 prev;
        uint64 next;
    }

    struct AccountLink {
        address first;
        address last;
        uint64 count;
    }

    struct AccountList {
        address prev;
        address next;
    }

    function accounts() external view returns (uint);
    function accountID(address) external view returns (uint64);
    function accountAddr(uint64) external view returns (address);
    function userLink(address) external view returns (UserLink memory);
    function userList(address, uint64) external view returns (UserList memory);
    function accountLink(uint64) external view returns (AccountLink memory);
    function accountList(uint64, address) external view returns (AccountList memory);

}

interface IndexInterface {
    function master() external view returns (address);
    function list() external view returns (address);
    function connectors(uint) external view returns (address);
    function account(uint) external view returns (address);
    function check(uint) external view returns (address);
    function versionCount() external view returns (uint);

}

interface ConnectorsInterface {
    struct List {
        address prev;
        address next;
    }
    function chief(address) external view returns (bool);
    function connectors(address) external view returns (bool);
    function staticConnectors(address) external view returns (bool);

    function connectorArray(uint) external view returns (address);
    function connectorLength() external view returns (uint);
    function staticConnectorArray(uint) external view returns (address);
    function staticConnectorLength() external view returns (uint);
    function connectorCount() external view returns (uint);

    function isConnector(address[] calldata _connectors) external view returns (bool isOk);
    function isStaticConnector(address[] calldata _connectors) external view returns (bool isOk);

}

interface ConnectorInterface {
    function name() external view returns (string memory);
}

contract Helpers {
    address public index;
    address public list;
    address public connectors;
    IndexInterface indexContract;
    ListInterface listContract;
    ConnectorsInterface connectorsContract;
}

contract AccountResolver is Helpers {

    function getID(address account) public view returns(uint id){
        return listContract.accountID(account);
    }

    function getAccount(uint64 id) public view returns(address account){
        return listContract.accountAddr(uint64(id));
    }

    function getAuthorityIDs(address authority) public view returns(uint64[] memory){
        ListInterface.UserLink memory userLink = listContract.userLink(authority);
        uint64[] memory IDs = new uint64[](userLink.count);
        uint64 id = userLink.first;
        for (uint i = 0; i < userLink.count; i++) {
            IDs[i] = id;
            ListInterface.UserList memory userList = listContract.userList(authority, id);
            id = userList.next;
        }
        return IDs;
    }

    function getAuthorityAccounts(address authority) public view returns(address[] memory){
        uint64[] memory IDs = getAuthorityIDs(authority);
        address[] memory accounts = new address[](IDs.length);
        for (uint i = 0; i < IDs.length; i++) {
            accounts[i] = getAccount(IDs[i]);
        }
        return accounts;
    }

    function getIDAuthorities(uint id) public view returns(address[] memory){
        ListInterface.AccountLink memory accountLink = listContract.accountLink(uint64(id));
        address[] memory authorities = new address[](accountLink.count);
        address authority = accountLink.first;
        for (uint i = 0; i < accountLink.count; i++) {
            authorities[i] = authority;
            ListInterface.AccountList memory accountList = listContract.accountList(uint64(id), authority);
            authority = accountList.next;
        }
        return authorities;
    }

    function getAccountAuthorities(address account) public view returns(address[] memory){
        return getIDAuthorities(getID(account));
    }

    function getAccountVersions(address[] memory accounts) public view returns(uint[] memory) {
        uint[] memory versions = new uint[](accounts.length);
        for (uint i = 0; i < accounts.length; i++) {
            versions[i] = AccountInterface(accounts[i]).version();
        }
        return versions;
    }

    struct AuthorityData {
        uint64[] IDs;
        address[] accounts;
        uint[] versions;
    }

    struct AccountData {
        uint ID;
        address account;
        uint version;
        address[] authorities;
    }

    function getAuthorityDetails(address authority) public view returns(AuthorityData memory){
        address[] memory accounts = getAuthorityAccounts(authority);
        return AuthorityData(
            getAuthorityIDs(authority),
            accounts,
            getAccountVersions(accounts)
        );
    }

    function getAccountDetails(uint id) public view returns(AccountData memory){
        address account = getAccount(uint64(id));
        return AccountData(
            id,
            account,
            AccountInterface(account).version(),
            getIDAuthorities(id)
        );
    }

    function isShield(address account) public view returns(bool shield) {
        shield = AccountInterface(account).sheild();
    }
}


contract ConnectorsResolver is AccountResolver {
    struct ConnectorsData {
        address connector;
        uint connectorID;
        string name;
    }

    function getEnabledConnectors() public view returns(address[] memory){
        uint enabledCount = connectorsContract.connectorCount();
        address[] memory addresses = new address[](enabledCount);
        uint connectorArrayLength = connectorsContract.connectorLength();
        uint count;
        for (uint i = 0; i < connectorArrayLength ; i++) {
            address connector = connectorsContract.connectorArray(i);
            if (connectorsContract.connectors(connector)) {
                addresses[count] = connector;
                count++;
            }
        }
        return addresses;
    }

    function getEnabledConnectorsData() public view returns(ConnectorsData[] memory){
        uint enabledCount = connectorsContract.connectorCount();
        ConnectorsData[] memory connectorsData = new ConnectorsData[](enabledCount);
        uint connectorArrayLength = connectorsContract.connectorLength();
        uint count;
        for (uint i = 0; i < connectorArrayLength ; i++) {
            address connector = connectorsContract.connectorArray(i);
            if (connectorsContract.connectors(connector)) {
                connectorsData[count] = ConnectorsData(
                    connector,
                    i+1,
                    ConnectorInterface(connector).name()
                );
                count++;
            }
        }
        return connectorsData;
    }

    function getStaticConnectors() public view returns(address[] memory){
        uint staticLength = connectorsContract.staticConnectorLength();
        address[] memory staticConnectorArray = new address[](staticLength);
        for (uint i = 0; i < staticLength ; i++) {
            staticConnectorArray[i] = connectorsContract.staticConnectorArray(i);
        }
        return staticConnectorArray;
    }

    function getStaticConnectorsData() public view returns(ConnectorsData[] memory){
        uint staticLength = connectorsContract.staticConnectorLength();
        ConnectorsData[] memory staticConnectorsData = new ConnectorsData[](staticLength);
        for (uint i = 0; i < staticLength ; i++) {
            address staticConnector = connectorsContract.staticConnectorArray(i);
            staticConnectorsData[i] = ConnectorsData(
                staticConnector,
                i+1,
                ConnectorInterface(staticConnector).name()
            );
        }
        return staticConnectorsData;
    }
}


contract InstaDSAResolver is ConnectorsResolver {
    string public constant name = "DSA-Resolver-v1";
    uint public constant version = 1;

    constructor(address _index) public{
        index = _index;
        indexContract = IndexInterface(index);
        list = indexContract.list();
        listContract = ListInterface(list);
        connectors = indexContract.connectors(version);
        connectorsContract = ConnectorsInterface(connectors);
    }
}