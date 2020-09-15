/**
 *Submitted for verification at Etherscan.io on 2020-07-04
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

// ============================================================================
// External functions/types used by this contract
// ============================================================================

interface ERC20 {
  function balanceOf(address account) external returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount)
    external returns (bool);
}

interface ERC721 {
  function transferFrom( address _from, address _to, uint256 _tokenId )
    external payable;
}

// ============================================================================
// Admin:
//  - cannot interfere with, change or stop any listing
//  - adds known ERC20s to an 'approved tokens' list
//  - sets and adjusts fees
//  - receives excess ether (fees) and accidental transfers of ETH or tokens
//  - cannot help victims of fraud or accidental misuse of this contract
// ============================================================================

contract HasAdmin {
  address payable public admin_;

  modifier isAdmin {
    if (msg.sender != admin_) { revert("must be admin"); }
    _;
  }

  constructor() public { admin_ = msg.sender; }

  function setAdmin( address payable newadmin ) public isAdmin {
    admin_ = newadmin;
  }
}

// ****************************************************************************
// Simple Ethereum Xchange roBot (S*E*X*Bot)
//
// Notes:
// 1. DO NOT do a simple Ether transfer to this contract - use the functions
// 2. Same for tokens: DO NOT transfer() tokens directly to this contract
// 3. There is no rate feed/oracle - clients must manage listings carefully.
// 4. All software has bugs and smart contracts are difficult to get right.
//    No warranties, use at own risk.
// 5. Scams happen. Buyer is solely responsible to verify listing details.
//
// ****************************************************************************

contract SEXBot is HasAdmin {

  event Made( bytes32 indexed id, address indexed seller );
  event Taken( bytes32 indexed id, address indexed buyer );
  event Canceled( bytes32 indexed id );
  event Updated( bytes32 indexed id );

  // list of well-known ERC20s tokens this contract accepts
  address[] public tokenSCAs;
  mapping( address => bool ) public safelist;

  // NOTE: a token value of address(0) indicates Ether
  struct Listing {
    address payable seller;
    uint256 sellunits;
    address selltoken;
    uint256 askunits;
    address asktoken;
  }

  mapping( bytes32 => Listing ) public listings;

  uint256 public makerfee;
  uint256 public updatefee;
  uint256 public cancelfee;
  uint256 public takerfee;
  uint256 public counter;

  string public clientIPFSHash;

  bytes4 magic; // required return value from onERC721Received() function

  function make( uint256 _sellunits,
                 address _selltok,
                 uint256 _askunits,
                 address _asktok ) public payable returns (bytes32) {

    require( safelist[_selltok], "unrecognized sell token" );
    require( safelist[_asktok], "unrecognized ask token" );

    if (_selltok == address(0)) { // ETH
      require( _sellunits + makerfee >= _sellunits, "safemath: bad arg" );
      require( msg.value >= _sellunits + makerfee, "insufficient fee" );
      admin_.transfer( msg.value - _sellunits );
    }
    else {
      ERC20 tok = ERC20(_selltok);
      require( tok.transferFrom(msg.sender, address(this), _sellunits),
               "failed transferFrom()" );
      admin_.transfer( msg.value );
    }

    bytes32 id = keccak256( abi.encodePacked(
      counter++, now, msg.sender, _sellunits, _selltok, _askunits, _asktok) );

    listings[id] =
      Listing( msg.sender, _sellunits, _selltok, _askunits, _asktok );

    emit Made( id, msg.sender );
    return id;
  }

  function take( bytes32 _id ) public payable {

    require( listings[_id].seller != address(0), "listing unavailable" );

    // receive payment:
    //   asktoken => this
    //   takerfee => admin

    if (listings[_id].asktoken == address(0)) { // ETH
      require( msg.value >= listings[_id].askunits + takerfee, "low value" );
      admin_.transfer( msg.value - listings[_id].askunits );
    }
    else {
      require( ERC20( listings[_id].asktoken )
               .transferFrom(msg.sender, address(this), listings[_id].askunits),
               "transferFrom() failed" );
      admin_.transfer( msg.value );
    }

    // delivery:
    //   selltoken => msg.sender
    //   asktoken => seller

    if (listings[_id].selltoken == address(0)) { // ETH
      msg.sender.transfer( listings[_id].sellunits );
    }
    else {
      ERC20( listings[_id].selltoken )
      .transfer( msg.sender, listings[_id].sellunits );
    }

    if (listings[_id].asktoken == address(0)) { // ETH
      listings[_id].seller.transfer( listings[_id].askunits );
    }
    else {
      ERC20( listings[_id].asktoken )
      .transfer( listings[_id].seller, listings[_id].askunits );
    }

    listings[_id].seller = address(0);
    emit Taken( _id, msg.sender );
  }

  function update( bytes32 _id, uint256 _askunits, address _asktok )
  public payable {
    require( msg.sender == listings[_id].seller, "must be seller" );
    require( msg.value >= updatefee, "insufficient fee to update" );
    require( safelist[_asktok], "unrecognized ask token" );

    listings[_id].askunits = _askunits;
    listings[_id].asktoken = _asktok;

    admin_.transfer( msg.value );
    emit Updated( _id );
  }

  function cancel( bytes32 _id ) public payable {
    require( msg.sender == listings[_id].seller, "must be seller" );
    require( msg.value >= cancelfee, "insufficient fee to cancel" );

    if (listings[_id].selltoken == address(0)) {
      listings[_id].seller.transfer( listings[_id].sellunits );
    }
    else {
      ERC20 tok = ERC20( listings[_id].selltoken );
      tok.transfer( msg.sender, listings[_id].sellunits );
    }

    listings[_id].seller = address(0); // mark as canceled
    admin_.transfer( msg.value );
    emit Canceled( _id );
  }

  // =========================================================================
  // Admin and internal functions
  // =========================================================================

  constructor( uint256 _mf, uint256 _uf, uint256 _cf, uint256 _tf ) public {
    tokenSCAs.push( address(0) );
    safelist[address(0)] = true;

    makerfee = _mf;
    updatefee = _uf;
    cancelfee = _cf;
    takerfee = _tf;

    magic = bytes4( keccak256(
      abi.encodePacked("onERC721Received(address,address,uint256,bytes)")) );
  }

  function setFee( uint8 _which, uint256 _amtwei ) public isAdmin {
    if (_which == uint8(0)) makerfee = _amtwei;
    else if (_which == uint8(1)) updatefee = _amtwei;
    else if (_which == uint8(2)) cancelfee = _amtwei;
    else if (_which == uint8(3)) takerfee = _amtwei;
    else revert( "invalid fee specified" );
  }

  function tokenCount() public view returns (uint256) {
    return tokenSCAs.length;
  }

  function listToken( address _toksca, bool _stat ) public isAdmin {
    tokenSCAs.push( _toksca );
    safelist[_toksca] = _stat;
  }

  function setClient( string memory _client ) public isAdmin {
    clientIPFSHash = _client;
  }

  // =========================================================================
  // Remaining logic attempts to capture accidental donations of ether or
  // certain token types
  // =========================================================================

  // if caller sends ether and leaves calldata blank
  receive() external payable {
    admin_.transfer( msg.value );
  }

  // called if calldata has a value that does not match a function
  fallback() external payable {
    admin_.transfer( msg.value );
  }

  // ERC721 (NFT) transfer callback
  function onERC721Received( address _operator,
                             address _from,
                             uint256 _tokenId,
                             bytes calldata _data) external returns(bytes4) {
    if (   _operator == address(0x0)
        || _from == address(0x0)
        || _data.length > 0 ) {} // suppress warnings unused params

    ERC721(msg.sender).transferFrom( address(this), admin_, _tokenId );
    return magic;
  }
}