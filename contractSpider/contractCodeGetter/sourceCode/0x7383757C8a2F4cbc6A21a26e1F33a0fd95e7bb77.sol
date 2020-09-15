/**
 *Submitted for verification at Etherscan.io on 2020-05-08
*/

pragma solidity ^0.5.4;// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.



/**
 * @title Owned
 * @dev Basic contract to define an owner.
 * @author Julien Niset - <julien@argent.im>
 */
contract Owned {

    // The owner
    address public owner;

    event OwnerChanged(address indexed _newOwner);

    /**
     * @dev Throws if the sender is not the owner.
     */
    modifier onlyOwner {
        require(msg.sender == owner, "Must be owner");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Lets the owner transfer ownership of the contract to a new owner.
     * @param _newOwner The new owner.
     */
    function changeOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Address must not be null");
        owner = _newOwner;
        emit OwnerChanged(_newOwner);
    }
}

contract GemLike {
    function balanceOf(address) public view returns (uint);
    function transferFrom(address, address, uint) public returns (bool);
    function approve(address, uint) public returns (bool success);
    function decimals() public view returns (uint);
    function transfer(address,uint) external returns (bool);
}

contract DSTokenLike {
    function mint(address,uint) external;
    function burn(address,uint) external;
}

contract VatLike {
    function can(address, address) public view returns (uint);
    function dai(address) public view returns (uint);
    function hope(address) public;
    function wards(address) public view returns (uint);
    function ilks(bytes32) public view returns (uint Art, uint rate, uint spot, uint line, uint dust);
    function urns(bytes32, address) public view returns (uint ink, uint art);
    function frob(bytes32, address, address, address, int, int) public;
    function slip(bytes32,address,int) external;
    function move(address,address,uint) external;
}

contract JoinLike {
    function ilk() public view returns (bytes32);
    function gem() public view returns (GemLike);
    function dai() public view returns (GemLike);
    function join(address, uint) public;
    function exit(address, uint) public;
    VatLike public vat;
    uint    public live;
}

contract ManagerLike {
    function vat() public view returns (address);
    function urns(uint) public view returns (address);
    function open(bytes32, address) public returns (uint);
    function frob(uint, int, int) public;
    function give(uint, address) public;
    function move(uint, address, uint) public;
    function flux(uint, address, uint) public;
    function shift(uint, uint) public;
    mapping (uint => bytes32) public ilks;
    mapping (uint => address) public owns;
}

contract ScdMcdMigrationLike {
    function swapSaiToDai(uint) public;
    function swapDaiToSai(uint) public;
    function migrate(bytes32) public returns (uint);
    JoinLike public saiJoin;
    JoinLike public wethJoin;
    JoinLike public daiJoin;
    ManagerLike public cdpManager;
    SaiTubLike public tub;
}

contract ValueLike {
    function peek() public returns (uint, bool);
}

contract SaiTubLike {
    function skr() public view returns (GemLike);
    function gem() public view returns (GemLike);
    function gov() public view returns (GemLike);
    function sai() public view returns (GemLike);
    function pep() public view returns (ValueLike);
    function bid(uint) public view returns (uint);
    function ink(bytes32) public view returns (uint);
    function tab(bytes32) public returns (uint);
    function rap(bytes32) public returns (uint);
    function shut(bytes32) public;
    function exit(uint) public;
}

contract VoxLike {
    function par() public returns (uint);
}

contract JugLike {
    function drip(bytes32) external;
}

contract PotLike {
    function chi() public view returns (uint);
    function pie(address) public view returns (uint);
    function drip() public;
}


/**
 * @title MakerRegistry
 * @dev Simple registry containing a mapping between token collaterals and their corresponding Maker Join adapters.
 * @author Olivier VDB - <olivier@argent.xyz>
 */
contract MakerRegistry is Owned {

    VatLike public vat;
    address[] public tokens;
    mapping (address => Collateral) public collaterals;
    mapping (bytes32 => address) public collateralTokensByIlks;

    struct Collateral {
        bool exists;
        uint128 index;
        JoinLike join;
        bytes32 ilk;
    }

    event CollateralAdded(address indexed _token);
    event CollateralRemoved(address indexed _token);

    constructor(VatLike _vat) public {
        vat = _vat;
    }

    /**
     * @dev Adds a new token as possible CDP collateral.
     * @param _joinAdapter The Join Adapter for the token.
     */
    function addCollateral(JoinLike _joinAdapter) external onlyOwner {
        require(vat.wards(address(_joinAdapter)) == 1, "MR: _joinAdapter not authorised in vat");
        address token = address(_joinAdapter.gem());
        require(!collaterals[token].exists, "MR: collateral already added");
        collaterals[token].exists = true;
        collaterals[token].index = uint128(tokens.push(token) - 1);
        collaterals[token].join = _joinAdapter;
        bytes32 ilk = _joinAdapter.ilk();
        collaterals[token].ilk = ilk;
        collateralTokensByIlks[ilk] = token;
        emit CollateralAdded(token);
    }

    /**
     * @dev Removes a token as possible CDP collateral.
     * @param _token The token to remove as collateral.
     */
    function removeCollateral(address _token) external onlyOwner {
        require(collaterals[_token].exists, "MR: collateral does not exist");
        delete collateralTokensByIlks[collaterals[_token].ilk];

        address last = tokens[tokens.length - 1];
        if (_token != last) {
            uint128 targetIndex = collaterals[_token].index;
            tokens[targetIndex] = last;
            collaterals[last].index = targetIndex;
        }
        tokens.length --;
        delete collaterals[_token];
        emit CollateralRemoved(_token);
    }

    /**
    * @dev Gets the list of supported collaterals.
    */
    function getCollateralTokens() external view returns (address[] memory _tokens) {
        _tokens = new address[](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            _tokens[i] = tokens[i];
        }
        return _tokens;
    }

    /**
     * @dev Gets the ilk for a given token collateral.
     * @param _token The token collateral.
     */
    function getIlk(address _token) external view returns (bytes32 _ilk) {
        _ilk = collaterals[_token].ilk;
    }

    /**
    * @dev Gets the join adapter and collateral token for a given ilk.
    */
    function getCollateral(bytes32 _ilk) external view returns (JoinLike _join, GemLike _token) {
        _token = GemLike(collateralTokensByIlks[_ilk]);
        _join = collaterals[address(_token)].join;
    }
}