// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

//Errors
error MarAbiertoToken__AllTokensAreMinted();
error MarAbiertoToken__InsufficientETHAmount();
error MarAbiertoToken__AmountExceedsLimit();
error MarAbiertoToken__PresaleIsNotAvalible();

contract MarAbiertoToken is ERC721, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;

    Counters.Counter private s_tokenIdCounter;
    // could be a constant
    uint256 private s_supply = 1440;
    uint256 private s_mintPrice = 0.08 ether;
    uint256 private s_signatures = 0;
    uint256 constant MIN_SIGNATURES = 2;
    address private s_withdrawAddress;
    string private s_baseTokenURI;
    string private s_prerevealTokenURI;

    bool private s_isRevealed = false;
    bool private s_isPublicMintEnabled = false;
    bool private s_isPresaleMintEnabled = false;

    mapping(address => bool) private s_owners;
    mapping(address => bool) public whitelist;

    modifier validOwner() {
        require(s_owners[msg.sender] == true);
        _;
    }

    event NftMinted(uint256 indexed tokenId, address minter);
    event WithdrawFunds(address from, uint256 amount);

    constructor(
        string memory prerevealTokenURI,
        address _withdrawAddress
    ) ERC721("MAR ABIERTO NON FUNGIBLE TIME", "MANF") {
        addOwner(msg.sender);
        setPrerevealTokenURI(prerevealTokenURI);
        s_withdrawAddress = _withdrawAddress;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return s_baseTokenURI;
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        s_baseTokenURI = _baseTokenURI;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        if (s_isRevealed) {
            return super.tokenURI(_tokenId);
        }
        return s_prerevealTokenURI;
    }

    function setPrerevealTokenURI(string memory _prerevealTokenURI) public onlyOwner {
        s_prerevealTokenURI = _prerevealTokenURI;
    }

    function setMintPrice(uint256 _newMintPrice) public onlyOwner {
        s_mintPrice = _newMintPrice;
    }

    function addAddressesToWhitelist(address[] memory addrs) public onlyOwner {
        for (uint256 i = 0; i < addrs.length; i++) {
            whitelist[addrs[i]] = true;
        }
    }

    function removeAddressesFromWhitelist(address[] memory addrs) public onlyOwner {
        for (uint256 i = 0; i < addrs.length; i++) {
            whitelist[addrs[i]] = false;
        }
    }

    function mint(address to) public payable {
        require(s_isPublicMintEnabled, "Public minting is not currently enabled.");
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
        require(s_isPublicMintEnabled, "Public minting is not currently enabled.");

        if (msg.value < s_mintPrice * _amount) {
            revert MarAbiertoToken__InsufficientETHAmount();
        }

        for (uint256 i = 0; i < _amount; i++) {
            mint(msg.sender);
        }
    }

    function mintPresale(address to) public payable {
        if (!s_isPresaleMintEnabled || !whitelist[msg.sender]) {
            revert MarAbiertoToken__PresaleIsNotAvalible(); // typo
        }

        if (s_tokenIdCounter.current() >= 300) {
            revert MarAbiertoToken__AllTokensAreMinted();
        }

        uint256 tokenId = s_tokenIdCounter.current();
        s_tokenIdCounter.increment();

        _safeMint(to, tokenId);

        whitelist[msg.sender] = false;

        emit NftMinted(tokenId, msg.sender);
    }

    function mintAmountPresale(uint256 _amount) public payable {
        if (!s_isPresaleMintEnabled || !whitelist[msg.sender]) {
            revert MarAbiertoToken__PresaleIsNotAvalible();
        }

        if (_amount > 3) {
            revert MarAbiertoToken__AmountExceedsLimit();
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
        // possive reentrancy
        _safeMint(to, tokenId);

        emit NftMinted(tokenId, msg.sender);
    }

    function mintAmountOwner(uint256 _amount) public payable onlyOwner {
        for (uint256 i = 0; i < _amount; i++) {
            mintOwner(msg.sender);
        }
    }

    function withdraw() public payable validOwner {
        if (s_signatures != MIN_SIGNATURES) {
            s_signatures++;
        }

        uint256 balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");

        (bool success, ) = (s_withdrawAddress).call{value: balance}("");
        require(success, "Transfer failed.");

        s_signatures = 0;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function revealAndSetBaseURI(string memory _baseTokenURI) public onlyOwner {
        s_isRevealed = true;
        s_baseTokenURI = _baseTokenURI;
    }

    function enablePublicMinting() external onlyOwner {
        s_isPublicMintEnabled = true;
    }

    function disablePublicMinting() external onlyOwner {
        s_isPublicMintEnabled = false;
    }

    function enablePresaleMinting() external onlyOwner {
        s_isPresaleMintEnabled = true;
    }

    function disablePresaleMinting() external onlyOwner {
        s_isPresaleMintEnabled = false;
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

    function currentTokenId() public view returns (uint256) {
        return s_tokenIdCounter.current();
    }

    function getPrice() public view returns (uint256) {
        return s_mintPrice;
    }

    function getBaseURI() public view returns (string memory) {
        return s_baseTokenURI;
    }

    function addOwner(address _newOwner) public onlyOwner {
        s_owners[_newOwner] = true;
    }

    function removeOwner(address _oldOwner) public onlyOwner {
        s_owners[_oldOwner] = false;
    }

    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    fallback() external payable {}

    receive() external payable {}
}