// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

//Errors
error MarAbiertoToken__AllTokensAreMinted();
error MarAbiertoToken__CannotMintLegendaryNFT();
error MarAbiertoToken__InsufficientETHAmount();

// Implementar estandar ERC2981 

contract MarAbiertoToken is ERC721, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;

    Counters.Counter private s_tokenIdCounter;
    uint256 private s_supply = 50;
    uint256 private s_mintPrice = 0.1 ether;
    string private s_baseTokenURI;

    event NftMinted(uint256 indexed tokenId, address minter);

    constructor(string memory baseURI) ERC721("MarAbierto", "MAR") {
        setBaseURI(baseURI);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return s_baseTokenURI;
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        s_baseTokenURI = _baseTokenURI;
    }

    function addSupply(uint256 _amount) public onlyOwner {
        s_supply += _amount;
    }

    function setMintPrice(uint256 _newMintPrice) public onlyOwner {
        s_mintPrice = _newMintPrice;
    }

    function mint(address to) public payable {
        if (s_tokenIdCounter.current() >= s_supply) {
            revert MarAbiertoToken__AllTokensAreMinted();
        }

        if (msg.value < s_mintPrice) {
            revert MarAbiertoToken__InsufficientETHAmount();
        }

        uint256 tokenId = s_tokenIdCounter.current();
        s_tokenIdCounter.increment();

        _safeMint(to, tokenId);

        emit NftMinted(tokenId, msg.sender);
    }

    function mintAmount(uint256 _amount) public payable {
        if (msg.value < s_mintPrice * _amount) {
            revert MarAbiertoToken__InsufficientETHAmount();
        }
        for (uint256 i = 0; i < _amount; i++) {
            mint(msg.sender);
        }
    }

    function mintOwner(address to) public payable onlyOwner {
        if (s_tokenIdCounter.current() >= s_supply) {
            revert MarAbiertoToken__AllTokensAreMinted();
        }

        uint256 tokenId = s_tokenIdCounter.current();
        s_tokenIdCounter.increment();

        _safeMint(to, tokenId);

        emit NftMinted(tokenId, msg.sender);
    }

    function mintAmountOwner(uint256 _amount) public payable onlyOwner {
        for (uint256 i = 0; i < _amount; i++) {
            mintOwner(msg.sender);
        }
    }

    function withdraw() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");

        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // An override that disables the transfer of NFTs if the smartcontract is paused
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function getSupply() public view returns (uint256) {
        return s_supply;
    }

    function getPrice() public view returns (uint256) {
        return s_mintPrice;
    }

    function getBaseURI() public view returns (string memory) {
        return s_baseTokenURI;
    }
}
