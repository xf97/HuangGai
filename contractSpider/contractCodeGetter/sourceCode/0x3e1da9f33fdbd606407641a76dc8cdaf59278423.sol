/**
 *Submitted for verification at Etherscan.io on 2020-05-17
*/

pragma solidity ^0.5.0;

contract ERC20Detailed {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);


    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * > Note that this information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * `IERC20.balanceOf` and `IERC20.transfer`.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}


/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract MultisigVaultERC20 {

    struct Approval {
        uint256 nonce;
        uint256 coincieded;
        address[] coinciedeParties;
    }

    uint8 private participantsAmount;
    uint8 private signatureMinThreshold;
    uint32 private nonce;
    address public currencyAddress;

    mapping(address => bool) public parties;

    mapping(
        // Destination
        address => mapping(
            // Amount
            uint256 => Approval
        )
    ) public approvals;

    mapping(uint256 => bool) public finished;

    event ConfirmationReceived(address indexed from, address indexed destination, address currency, uint256 amount);
    event ConsensusAchived(address indexed destination, address currency, uint256 amount);

    /**
      * @dev Construcor.
      *
      * Requirements:
      * - `_signatureMinThreshold` .
      * - `_parties`.
      */
    constructor(
        uint8 _signatureMinThreshold,
        address[] memory _parties,
        address _currencyAddress
    ) public {
        require(_parties.length > 0 && _parties.length <= 10);
        require(_signatureMinThreshold > 0 && _signatureMinThreshold <= _parties.length);

        signatureMinThreshold = _signatureMinThreshold;
        currencyAddress = _currencyAddress;

        for (uint256 i = 0; i < _parties.length; i++) parties[_parties[i]] = true;
    }

    function getNonce(
        address _destination,
        uint256 _amount
    ) public view returns (uint256) {
        Approval storage approval = approvals[_destination][_amount];

        return approval.nonce;
    }

    function partyCoincieded(
        address _destination,
        uint256 _amount,
        uint256 _nonce,
        address _partyAddress
    ) public view returns (bool) {
        if ( finished[_nonce] ) {
          return true;
        } else {
          Approval storage approval = approvals[_destination][_amount];

          for (uint i=0; i<approval.coinciedeParties.length; i++) {
             if (approval.coinciedeParties[i] == _partyAddress) return true;
          }

          return false;
        }
    }


    function approve(
        address _destination,
        uint256 _amount
    ) public returns (bool) {
        require(parties[msg.sender]); // isMember
        require(token().balanceOf(address(this)) >= _amount); // isSufficientBalance

        Approval storage approval = approvals[_destination][_amount]; // Create new project

        bool coinciedeParties = false;
        for (uint i=0; i<approval.coinciedeParties.length; i++) {
           if (approval.coinciedeParties[i] == msg.sender) coinciedeParties = true;
        }

        require(!coinciedeParties);

        if (approval.coincieded == 0) {
            nonce += 1;
            approval.nonce = nonce;
        }

        approval.coinciedeParties.push(msg.sender);
        approval.coincieded += 1;

        emit ConfirmationReceived(msg.sender, _destination, currencyAddress, _amount);

        if ( approval.coincieded >= signatureMinThreshold ) {
            token().transfer(_destination, _amount); // Release funds

            finished[approval.nonce] = true;
            delete approvals[_destination][_amount];

            emit ConsensusAchived(_destination, currencyAddress, _amount);
        }

       return false;
    }

    function token() public view returns (ERC20Detailed) {
        return ERC20Detailed(currencyAddress);
    }

    function symbol() public view returns (string memory) {
        return token().symbol();
    }

    function decimals() public view returns (uint8) {
        return token().decimals();
    }
}