pragma solidity ^0.5.0;

import "./ERC20.sol";
import "./SafeMath.sol";
import "./ERC223ReceivingContract.sol";


contract EGToken is ERC20 {
    string public constant _name = "Everest Gold Unit";

    string public constant _symbol = "EGU";

    uint8 public constant _decimal = 12;

    address private _superAdmin;

    address private _egNetwork;

    address private _blacklistController;

    address private _whitelistController;

    mapping(address => bool) private _blacklist;

    mapping(address => bool) private _whitelist;

    bool public _initialized = false;



    function initialize(address superAdmin, address blacklist ,address whitelist) public {
        require(!_initialized);
        _superAdmin = superAdmin;
        _blacklistController = blacklist;
        _whitelistController = whitelist;
        _initialized = true;
    }



    /**
    *@event
    */
    event NewSuperAdmin(address indexed account);

    event NewEGNetwork(address indexed EGNetwork);

    event NewBlackListController(address indexed BlackListController);

    event BlacklistAddress(address indexed blacklistAccount);

    event DeBlacklistAddress(address indexed unblacklistAccount);

    event NewWhiteListController(address indexed whiteListController);

    event AddWhitelistAddress(address indexed whitelistAccount);

    event DeWhitelistAddress(address indexed unwhitelistAccount);

    event BurnBlacklistToken(address indexed blacklistAddress, uint256 burnAmount);



    /**
    *@modifier
    */

    modifier onlySuperAdmin() {
        require(msg.sender == _superAdmin, "Sender is not a super secrete admin");
        _;
    }

    modifier onlyBlackListController(){
        require(msg.sender == _blacklistController, "Sender is not a blacklist controller");
        _;
    }

    modifier onlyEGNetwork() {
        require(msg.sender == _egNetwork, "Sender is not a EG network");
        _;
    }

    modifier onlyNotBlacklist(address account) {
        require(! isBlacklist(account), "Account is in the blacklist");
        _;
    }

    modifier onlyWhiteListController(){
        require(msg.sender == _whitelistController, "Sender is not a whitelist controller");
        _;
    }

    modifier onlyWhitelist(address account) {
        require(isWhitelist(account), "Account is not in the whitelist");
        _;
    }


    /**
    *@dev check whether it's a blacklist account
    *@params address - account
    */
    function isBlacklist(address account) public view returns(bool) {
        return _blacklist[account];
    }

    function isWhitelist(address account) public view returns(bool) {
        return _whitelist[account];
    }


    function superAdmin() public view returns (address) {
        return _superAdmin;
    }


    function updateSuperAdmin(address newSuperAdmin) public onlySuperAdmin {
        _superAdmin = newSuperAdmin;
        emit NewSuperAdmin(_superAdmin);
    }


    function getEGNetwork() public view returns (address) {
        return _egNetwork;
    }

    function updateEGNetwork(address newEGNetwork) public onlySuperAdmin {
        _egNetwork = newEGNetwork;
        emit NewEGNetwork(newEGNetwork);
    }


    function blacklistController() public view returns (address) {
        return address(_blacklistController);
    }



    /**
    *@dev to update the blackListController and only BlacklistController can update it
    *@param blackListController address
    */
    function updateBlacklist(address blackListController) public onlyBlackListController {
        _blacklistController = blackListController;
        emit NewBlackListController(blackListController);
    }


    /**
    *@dev add an account into the blacklist and only EG network can add it
    *       in the EG network contract, only operation admin can add it
    *@params address - account
    */
    function blacklistAddress(address account) public onlyEGNetwork {
        require(! isBlacklist(account),"Account is already in a blacklist");
        _blacklist[account] = true;
        emit BlacklistAddress(account);
    }

    /**
    *@dev only BlacklistController is able to deblacklist account
    *@param address - unblacklist account
    */
    function deBlacklistAddress(address account) public onlyBlackListController {
        require(isBlacklist(account),"Account is not in a blacklist");
        _blacklist[account] = false;
        emit DeBlacklistAddress(account);
    }


    function whitelistController() public view returns (address) {
        return address(_whitelistController);
    }

    function updateWhitelist(address whiteListController) public onlyWhiteListController {
        _whitelistController = whiteListController;
        emit NewWhiteListController(whiteListController);
    }



    function whitelistAddress(address account)
    public
    onlyWhiteListController
    {
        require(!isWhitelist(account),"Account is already in a whitelist");
        _whitelist[account] = true;
        emit AddWhitelistAddress(account);
    }


    function deWhitelistAddress(address account)
    public
    onlyWhiteListController
    {
        require(isWhitelist(account),"Account is not in a whitelist");
        _whitelist[account] = false;
        emit DeWhitelistAddress(account);
    }



    /**
    *@dev    ERC223 features https://github.com/Dexaran/ERC223-token-standard
    *       only unblacklist account and recipient can transfer or receive token
    *        Invokes the "tokenFallback' function if the recipient is a contract.
    *           The token transfer fails if the recipient is a contract but does not implement the "tokenFallback" function
    *           or the fallback function to receive fund.
    *@params    address of recipient and amount
    */
    function transfer(address recipient, uint256 amount)
    public
    onlyNotBlacklist(msg.sender)
    onlyNotBlacklist(recipient)
    onlyWhitelist(msg.sender)
    onlyWhitelist(recipient)
    returns (bool) {
        uint codeLength;
        bytes memory empty;

        assembly {
            // Retrieve the size of the code on target address, this needs assembly
            codeLength := extcodesize(recipient)
        }

        super.transfer(recipient, amount);

        if(codeLength > 0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(recipient);
            receiver.tokenFallback(msg.sender, amount, empty);
        }

        return true;
    }


    /**
    *@dev   only unblacklist account and recipient can transfer and  receive token
    *@params    address of sender, recipient, amount
    */
    function transferFrom(address sender, address recipient, uint256 amount)
    public
    onlyNotBlacklist(sender)
    onlyNotBlacklist(recipient)
    onlyWhitelist(sender)
    onlyWhitelist(recipient)
    returns (bool) {
        return super.transferFrom(sender, recipient,amount);
    }

    /**
    *@dev onlyNotBlacklist can approve for other doing transfer
    *@params address spender, amount
    */
    function approve(address spender, uint256 value)
    public
    onlyNotBlacklist(spender)
    onlyWhitelist(spender)
    returns (bool) {
        return super.approve(spender, value);
    }


    /**
    *@dev onlyNotBlacklist can increase allowances
    *@params address spender, addedValue
    */
    function increaseAllowance(address spender, uint256 addedValue)
    public
    onlyNotBlacklist(spender)
    onlyWhitelist(spender)
    returns (bool) {
        return super.increaseAllowance(spender, addedValue);
    }

    /**
    *@dev onlyNotBlacklist can decrease allowances
    *@params address spender, subtractedValue
    */
    function decreaseAllowance(address spender, uint256 subtractedValue)
    public
    onlyNotBlacklist(spender)
    onlyWhitelist(spender)
    returns (bool) {
        return super.decreaseAllowance(spender, subtractedValue);
    }


    /**
    * @dev any can destroy token, even the blacklist guys.
    *
    * See `ERC20._burn`.
    */
    function burn(uint256 amount)
    public
    onlyWhitelist(msg.sender)
    {
        _burn(msg.sender, amount);
    }

    /**
     * @dev See `ERC20._burnFrom`.
     */
    function burnFrom(address account, uint256 amount)
    public
    onlyWhitelist(account)
    {
        _burnFrom(account, amount);
    }


    /**
    *@dev only blacklist controller is able to burn the blacklist token
    *@param blacklist address
    *@param amount of EG token will be burnt from the blacklist
    */
    function burnBlacklistToken(address blacklistAccount, uint256 burnAmount)
    public
    onlyBlackListController
    {
        require(isBlacklist(blacklistAccount),"Account is not in blacklist");
        require(burnAmount <= balanceOf(blacklistAccount),"Burn amount is over the black balance");
        _burn(blacklistAccount, burnAmount);
        emit BurnBlacklistToken(blacklistAccount, burnAmount);
    }



    /**
    *@dev only EGT generator listed on EGT network is able to minted token
    *     implete ERC223 features for minted wallet who has the features ERC223
    *@params targeted account received token - usually a multi-sign wallet
    *@param amount of EG token is minted
    */
    function mint(address account, uint256 amount)
    public
    onlyEGNetwork
    returns (bool) {
        uint codeLength;
        // add empty data to backwards compatibility with ERC20
        bytes memory empty;

        assembly {
            // Retrieve the size of the code on target address, this needs assembly
            codeLength := extcodesize(account)
        }

        _mint(account, amount);

        if(codeLength > 0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(account);
            receiver.tokenFallback(msg.sender, amount, empty);
        }

        return true;
    }


}
