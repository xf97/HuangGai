pragma solidity ^0.6.0;

import './ERC721Full.sol';
import './Ownable.sol';
import './Roles.sol';
import './Math.sol';

/// @title RegencyNFT
/// @author Original from Jason Haas <jasonrhaas@gmail.com>
/// @author Modified by Youssef Khouidi for the X5Engine.com
/// @author Re-modified by Scott Stevenson for Web3vm.com projects
/// @notice RegencyNFTs ERC721 interface for minting, cloning, and transferring RegencyNFTs tokens.
/// @notice forked and modified from gitcoin Kudos Token https://github.com/gitcoinco/Kudos721Contract

contract RegencyNFTs is ERC721Full("RegencyNFT", "RNFT"), Ownable {
using SafeMath for uint256;
using Roles for Roles.Role;
Roles.Role moderators;
address payable ownerRegency = 0x00a2Ddfa736214563CEa9AEf5100f2e90c402918;
address payable ownerRegent1 = 0x7beAd6F7dB10Ae70090aee1742F5f9Af83D76784;
address payable ownerRegent2 = 0xb799e0b02Cc6738f704cF15dcBE0934eC73A2707;
address payable ownerRegent3 = 0xAD5bA38e921bDE497C18Be44977A255C57A55F18;
address payable ownerRegent4 = 0x9FcCea1dCa74b110f265ac5f86F7Acf0B3709aC0;
address payable ownerRegent5 = 0x5219c80f8179f3361a605fbB5DDb7528308A1DC0;

struct RegencyNFT {
uint256 priceFinney;
uint256 numClonesAllowed;
uint256 numClonesInWild;
uint256 clonedFromId;
}

RegencyNFT[] public regencyNFTs;
uint256 public cloneFeePercentage = 10;
bool public isMintable = true;

modifier mintable {
require(
isMintable == true,
"New regencyNFTs are no longer mintable on this contract."
);
_;
}

constructor () public {
if(regencyNFTs.length == 0) {
RegencyNFT memory _dummyRegencyNFT = RegencyNFT({priceFinney: 0,numClonesAllowed: 0, numClonesInWild: 0,
clonedFromId: 0
});
regencyNFTs.push(_dummyRegencyNFT);
}
}

function addModRoles(address [] memory _moderators) public onlyOwner {
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

RegencyNFT memory _regencyNFT = RegencyNFT({priceFinney: _priceFinney, numClonesAllowed: _numClonesAllowed,
numClonesInWild: 0, clonedFromId: 0
});

regencyNFTs.push(_regencyNFT);
tokenId = regencyNFTs.length - 1;
regencyNFTs[tokenId].clonedFromId = tokenId;

_mint(_to, tokenId);
_setTokenURI(tokenId, _tokenURI);

}

function clone(address _to, uint256 _tokenId, uint256 _numClonesRequested) public payable mintable {

RegencyNFT memory _regencyNFT = regencyNFTs[_tokenId];
uint256 cloningCost = _regencyNFT.priceFinney * 10**15 * _numClonesRequested;
require(
_regencyNFT.numClonesInWild + _numClonesRequested <= _regencyNFT.numClonesAllowed,
"The number of RegencyNFTs clones requested exceeds the number of clones allowed.");
require(
msg.value >= cloningCost,
"Not enough Wei to pay for the RegencyNFTs clones.");


uint256 ownerRegencyCut = (cloningCost.mul(50)).div(100);
ownerRegency.transfer(ownerRegencyCut);

uint256 ownerRegent1Cut = (cloningCost.mul(10)).div(100);
ownerRegent1.transfer(ownerRegent1Cut);

uint256 ownerRegent2Cut = (cloningCost.mul(10)).div(100);
ownerRegent2.transfer(ownerRegent2Cut);

uint256 ownerRegent3Cut = (cloningCost.mul(10)).div(100);
ownerRegent3.transfer(ownerRegent3Cut);

uint256 ownerRegent4Cut = (cloningCost.mul(10)).div(100);
ownerRegent4.transfer(ownerRegent4Cut);

uint256 ownerRegent5Cut = (cloningCost.mul(10)).div(100);
ownerRegent5.transfer(ownerRegent5Cut);

_regencyNFT.numClonesInWild += _numClonesRequested;
regencyNFTs[_tokenId] = _regencyNFT;

for (uint i = 0; i < _numClonesRequested; i++) {
RegencyNFT memory _newRegencyNFT;
_newRegencyNFT.priceFinney = _regencyNFT.priceFinney;
_newRegencyNFT.numClonesAllowed = 0;
_newRegencyNFT.numClonesInWild = 0;
_newRegencyNFT.clonedFromId = _tokenId;

regencyNFTs.push(_newRegencyNFT);
uint256 newTokenId = regencyNFTs.length-1;

_mint(_to, newTokenId);

string memory _tokenURI = this.tokenURI(_tokenId);
_setTokenURI(newTokenId, _tokenURI);
}
msg.sender.transfer( msg.value - cloningCost );
}


function burn(address _owner, uint256 _tokenId) public {

require(moderators.has(msg.sender) || Ownable.isOwner(), "DOES NOT HAVE Moderator ROLE or not Owner");

RegencyNFT memory _regencyNFT = regencyNFTs[_tokenId];
uint256 gen0Id = _regencyNFT.clonedFromId;
if (_tokenId != gen0Id) {
RegencyNFT memory _gen0RegencyNFT = regencyNFTs[gen0Id];
_gen0RegencyNFT.numClonesInWild -= 1;
regencyNFTs[gen0Id] = _gen0RegencyNFT;
}
delete regencyNFTs[_tokenId];
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
RegencyNFT memory _regencyNFT = regencyNFTs[_tokenId];

_regencyNFT.priceFinney = _newPriceFinney;
regencyNFTs[_tokenId] = _regencyNFT;
}

function setTokenURI(uint256 _tokenId, string memory _tokenURI) public {
require(moderators.has(msg.sender) || Ownable.isOwner(), "DOES NOT HAVE Moderator ROLE or not Owner");
_setTokenURI(_tokenId, _tokenURI);
}

function getRegencyNFTsById(uint256 _tokenId) view public returns (uint256 priceFinney,
uint256 numClonesAllowed,
uint256 numClonesInWild,
uint256 clonedFromId
)
{
RegencyNFT memory _regencyNFT = regencyNFTs[_tokenId];

priceFinney = _regencyNFT.priceFinney;
numClonesAllowed = _regencyNFT.numClonesAllowed;
numClonesInWild = _regencyNFT.numClonesInWild;
clonedFromId = _regencyNFT.clonedFromId;
}

function getNumClonesInWild(uint256 _tokenId) view public returns (uint256 numClonesInWild)
{
RegencyNFT memory _regencyNFT = regencyNFTs[_tokenId];

numClonesInWild = _regencyNFT.numClonesInWild;
}

function getLatestId() view public returns (uint256 tokenId)
{
if (regencyNFTs.length == 0) {
tokenId = 0;
} else {
tokenId = regencyNFTs.length - 1;
}
}
}