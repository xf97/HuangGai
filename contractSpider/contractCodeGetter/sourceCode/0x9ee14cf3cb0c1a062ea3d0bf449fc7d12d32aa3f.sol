pragma solidity ^0.6.0;


import './ERC721Full.sol';
import './Ownable.sol';
import './Roles.sol';
import './Math.sol';

/// @title WardensNFT
/// @author Original from Jason Haas <jasonrhaas@gmail.com>
/// @author Modified by Youssef Khouidi for the X5Engine.com
/// @author Re-modified by Scott Stevenson for Web3vm.com projects
/// @notice WardensNFTs ERC721 interface for minting, cloning, and transferring WardensNFTs tokens.
/// @notice forked and modified from gitcoin Kudos Token https://github.com/gitcoinco/Kudos721Contract

contract WardensNFTs is ERC721Full("WardensNFT", "WNFT"), Ownable {
using SafeMath for uint256;
using Roles for Roles.Role;
Roles.Role moderators;
address payable ownerRegency = 0x00a2Ddfa736214563CEa9AEf5100f2e90c402918;
address payable ownerWardens1 = 0x7beAd6F7dB10Ae70090aee1742F5f9Af83D76784;
address payable ownerWardens2 = 0xb799e0b02Cc6738f704cF15dcBE0934eC73A2707;
address payable ownerWardens3 = 0xAD5bA38e921bDE497C18Be44977A255C57A55F18;
address payable ownerWardens4 = 0x9FcCea1dCa74b110f265ac5f86F7Acf0B3709aC0;
address payable ownerWardens5 = 0x5219c80f8179f3361a605fbB5DDb7528308A1DC0;

struct WardensNFT {
uint256 priceFinney;
uint256 numClonesAllowed;
uint256 numClonesInWild;
uint256 clonedFromId;
}

WardensNFT[] public wardensNFTs;
uint256 public cloneFeePercentage = 10;
bool public isMintable = true;

modifier mintable {
require(
isMintable == true,
"New wardensNFTs are no longer mintable on this contract."
);
_;
}

constructor () public {
if(wardensNFTs.length == 0) {
WardensNFT memory _dummyWardensNFT = WardensNFT({priceFinney: 0,numClonesAllowed: 0, numClonesInWild: 0,
clonedFromId: 0
});
wardensNFTs.push(_dummyWardensNFT);
}
}

function addModRoles(address[] memory _moderators) public onlyOwner {
for(uint i=0; i< _moderators.length; i++)
{
moderators.add(_moderators[i]);
}
}

function addOneModRole(address _moderator) public onlyOwner {
moderators.add(_moderator);
}

function removeOneModRole(address _moderator) public onlyOwner {
moderators.remove(_moderator);
}

function isMod() public view returns (bool){
return moderators.has(msg.sender);
}

function mint(address _to, uint256 _priceFinney, uint256 _numClonesAllowed, string memory _tokenURI) public mintable returns (uint256 tokenId) {
require(moderators.has(msg.sender) || Ownable.isOwner(), "DOES NOT HAVE Moderator ROLE or not Owner");

WardensNFT memory _wardensNFT = WardensNFT({priceFinney: _priceFinney, numClonesAllowed: _numClonesAllowed,
numClonesInWild: 0, clonedFromId: 0
});

wardensNFTs.push(_wardensNFT);
tokenId = wardensNFTs.length - 1;
wardensNFTs[tokenId].clonedFromId = tokenId;

_mint(_to, tokenId);
_setTokenURI(tokenId, _tokenURI);

}

function clone(address _to, uint256 _tokenId, uint256 _numClonesRequested) public payable mintable {

WardensNFT memory _wardensNFT = wardensNFTs[_tokenId];
uint256 cloningCost = _wardensNFT.priceFinney * 10**15 * _numClonesRequested;
require(
_wardensNFT.numClonesInWild + _numClonesRequested <= _wardensNFT.numClonesAllowed,
"The number of WardensNFTs clones requested exceeds the number of clones allowed.");
require(
msg.value >= cloningCost,
"Not enough Wei to pay for the WardensNFTs clones.");


uint256 ownerRegencyCut = (cloningCost.mul(20)).div(100);
ownerRegency.transfer(ownerRegencyCut);

uint256 ownerWardens1Cut = (cloningCost.mul(20)).div(100);
ownerWardens1.transfer(ownerWardens1Cut);

uint256 ownerWardens2Cut = (cloningCost.mul(15)).div(100);
ownerWardens2.transfer(ownerWardens2Cut);

uint256 ownerWardens3Cut = (cloningCost.mul(15)).div(100);
ownerWardens3.transfer(ownerWardens3Cut);

uint256 ownerWardens4Cut = (cloningCost.mul(15)).div(100);
ownerWardens4.transfer(ownerWardens4Cut);

uint256 ownerWardens5Cut = (cloningCost.mul(15)).div(100);
ownerWardens5.transfer(ownerWardens5Cut);

_wardensNFT.numClonesInWild += _numClonesRequested;
wardensNFTs[_tokenId] = _wardensNFT;

for (uint i = 0; i < _numClonesRequested; i++) {
WardensNFT memory _newWardensNFT;
_newWardensNFT.priceFinney = _wardensNFT.priceFinney;
_newWardensNFT.numClonesAllowed = 0;
_newWardensNFT.numClonesInWild = 0;
_newWardensNFT.clonedFromId = _tokenId;

wardensNFTs.push(_newWardensNFT);
uint256 newTokenId = wardensNFTs.length-1;

_mint(_to, newTokenId);

string memory _tokenURI = this.tokenURI(_tokenId);
_setTokenURI(newTokenId, _tokenURI);
}
msg.sender.transfer( msg.value - cloningCost );
}


function burn(address _owner, uint256 _tokenId) public {

require(moderators.has(msg.sender) || Ownable.isOwner(), "DOES NOT HAVE Moderator ROLE or not Owner");

WardensNFT memory _wardensNFT = wardensNFTs[_tokenId];
uint256 gen0Id = _wardensNFT.clonedFromId;
if (_tokenId != gen0Id) {
WardensNFT memory _gen0WardensNFT = wardensNFTs[gen0Id];
_gen0WardensNFT.numClonesInWild -= 1;
wardensNFTs[gen0Id] = _gen0WardensNFT;
}
delete wardensNFTs[_tokenId];
_burn(_owner, _tokenId);
}

function setCloneFeePercentage(uint256 _cloneFeePercentage) public {
require(moderators.has(msg.sender) || Ownable.isOwner(), "DOES NOT HAVE Moderator ROLE or not Owner");
require(
_cloneFeePercentage >= 0 && _cloneFeePercentage <= 100,
"Invalid range for cloneFeePercentage. Must be between 0 and 100.");
cloneFeePercentage = _cloneFeePercentage;
}

function setMintable(bool _isMintable) public {
require(moderators.has(msg.sender) || Ownable.isOwner(), "DOES NOT HAVE Moderator ROLE or not Owner");
isMintable = _isMintable;
}

function setPrice(uint256 _tokenId, uint256 _newPriceFinney) public {
require(moderators.has(msg.sender) || Ownable.isOwner(), "DOES NOT HAVE Moderator ROLE or not Owner");
WardensNFT memory _wardensNFT = wardensNFTs[_tokenId];

_wardensNFT.priceFinney = _newPriceFinney;
wardensNFTs[_tokenId] = _wardensNFT;
}

function setTokenURI(uint256 _tokenId, string memory _tokenURI) public {
require(moderators.has(msg.sender) || Ownable.isOwner(), "DOES NOT HAVE Moderator ROLE or not Owner");
_setTokenURI(_tokenId, _tokenURI);
}

function getWardensNFTsById(uint256 _tokenId) view public returns (uint256 priceFinney,
uint256 numClonesAllowed,
uint256 numClonesInWild,
uint256 clonedFromId
)
{
WardensNFT memory _wardensNFT = wardensNFTs[_tokenId];

priceFinney = _wardensNFT.priceFinney;
numClonesAllowed = _wardensNFT.numClonesAllowed;
numClonesInWild = _wardensNFT.numClonesInWild;
clonedFromId = _wardensNFT.clonedFromId;
}

function getNumClonesInWild(uint256 _tokenId) view public returns (uint256 numClonesInWild)
{
WardensNFT memory _wardensNFT = wardensNFTs[_tokenId];

numClonesInWild = _wardensNFT.numClonesInWild;
}

function getLatestId() view public returns (uint256 tokenId)
{
if (wardensNFTs.length == 0) {
tokenId = 0;
} else {
tokenId = wardensNFTs.length - 1;
}
}
}
