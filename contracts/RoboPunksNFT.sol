// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RoboPunksNFT is ERC721, ERC721Enumerable, Pausable, Ownable, ERC721Burnable {
  using Counters for Counters.Counter;

  Counters.Counter private _tokenIdCounter;

  uint256 public mintPrice;
//   uint256 public totalSupply;
  uint256 public maxSupply;
  uint256 public maxPerWallet;
  bool public isPublicMintEnabled;
  string internal baseTokenUri;
  address payable public withdrawWallet;
  mapping(address => uint256) public walletMints;

  constructor() payable ERC721('RoboPunks', 'RP') {
    mintPrice = 0.02 ether;
    // totalSupply = 0;
    maxSupply = 1000;
    maxPerWallet = 3;
    //set withdraw wallet address
  }

  function pause() public onlyOwner {
      _pause();
  }

  function unpause() public onlyOwner {
      _unpause();
  }

  function setIsPublicMinthEnabled(bool isPublicMintEnabled_) public {
    isPublicMintEnabled = isPublicMintEnabled_;
  }

  function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner {
    baseTokenUri = baseTokenUri_;
  }

  function tokenURI(uint256 tokenId_) public view override returns (string memory) {
    require(_exists(tokenId_), 'Token does not exist!');
    return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_), '.json'));
  }

  function withdraw() external onlyOwner {
    (bool success, ) = withdrawWallet.call{ value: address(this).balance }('');
    require(success, 'withdraw failed');
  }

  function mint(uint256 quantity_) public payable {
    require(isPublicMintEnabled, 'minting not enabled');
    require(msg.value == quantity_ * mintPrice, 'wrong mint value');
    // require(totalSupply + quantity_ <= maxSupply, 'sold out');
    require(walletMints[msg.sender] + quantity_ <= maxPerWallet, 'exceed max wallet');

    // for (uint256 i = 0; i < quantity_; i++) {
    //   uint256 newTokenId = totalSupply + 1;
    //   totalSupply++;
    //   _safeMint(msg.sender, newTokenId);
    // }
  }

  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
