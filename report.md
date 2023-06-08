# Contract Audit Report

![Racks Labs Logo](https://apinft.racksmafia.com/logo.jpg)  
**Author:** Racks Labs  
**Date:** June 6, 2023

---
    

## Prepared by: [Racks Labs](https://www.labs.racksmafia.com/)
### Lead Auditors: 
* [Alex Encinas](https://github.com/alexenc)
* [Alex Arteaga](https://github.com/alex-alra-arteaga)
* [David Salvatella](https://github.com/xRozzo)

---

## Table of Contents
1. [Disclaimer](#disclaimer)
2. [Contract Summary](#contract-summary)
3. [Audit Details](#audit-details)
   - [Scope](#scope)
   - [Severity Criteria](#severity-criteria)
   - [Summary of Findings](#summary-of-findings)
   - [Tools Used](#tools-used)
4. [Findings](#findings)
   - [Critical](#critical)
   - [High](#high)
   - [Medium](#medium)
   - [Low](#low)
5. [Gas Optimization](#gas)
6. [Possible Improvements](#improvements)

---

## Disclaimer <a name="disclaimer"></a>
*This audit report, conducted by Racks Labs, is exclusively intended to provide an independent and professional analysis of the security and functionality of the smart contract under review. The scope of our services and responsibilities is confined to the detection and assessment of potential vulnerabilities intrinsic to the deterministic nature of smart contracts.*

*Racks Labs is not liable for, and expressly disclaims, any potential malicious activities, fraud, or deviations from the declared roadmap by the contract owner, which might occur inside or outside the programmed parameters of the smart contract. All users are urged to exercise their own due diligence and discretion when interacting with smart contracts.*

## Contract Summary <a name="contract-summary"></a>
This is an Ethereum smart contract for a non-fungible token (NFT) named "MarAbiertoToken". It includes features for minting unique tokens, adjusting supply and mint price, and pausing token transfers. The contract owner has special privileges, such as minting without payment and withdrawing Ether from the contract.

## Audit Details <a name="audit-details"></a>

### Scope <a name="scope"></a>
The following smart contracts were in scope of the audit:
    · MarAbiertoToken

### Severity Criteria <a name="severity-criteria"></a>

| Vulnerability Level   | Classification                                                                                                                     |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| [Critical](#Critical) | Easily exploitable by anyone, causing loss/manipulation of assets or data.                                                         |
| [High](#High)         | Arduously exploitable by a subset of addresses, causing loss/manipulation of assets or data.                                       |
| [Medium](#Medium)     | Inherent risk of future exploits that may or may not impact the smart contract execution due to current or future implementations. |
| [Low](#Low)           | Minor deviation from best practices.                                                                                               |
| [Gas](#Gas)           | Gas Optimization                                                                                                                   |

### Summary of Findings <a name="summary-of-findings"></a>

|  ID   | Title                                                                            | Severity |
|-----|----------------------------------------------------------------------------------|----------|
| [M-1] | Centralization Risk for trusted owners                                           | Medium |
| [L-1] | TokenID counter is not easily accessible                                         | Low      |
| [G-1] | For Operations that will not overflow, you could use unchecked {++i}             | Gas      |
| [G-1] | For Operations that will not overflow, you could use unchecked                   | Gas      |
| [G-2] | Use Custom Errors                                                                | Gas      |
| [G-3] | Don't initialize variables with default value                                    | Gas      |
| [G-4] | Functions guaranteed to revert when called by normal users can be marked payable | Gas      |
| [G-5] | Use != 0 instead of > 0 for unsigned integer comparison                          | Gas      |

### Tools Used <a name="tools-used"></a>
*Hardhat, Mocha Unit Testing, Echidna, 4naly3er, Manual Reviewing*

## Findings <a name="findings"></a>
### Critical <a name="critical"></a>

#### [C-1] Prereveal loss of data
TokenURI, which is the function that gets called to fetch the NFT metadata is not dynamic depending on the tokenID, it will only return the fixed `s_prerevealTokenURI`, at most, it will only show one.

```solidity
function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
    if (s_isRevealed) {
        return super.tokenURI(_tokenId);
    }
    return s_prerevealTokenURI;
}
```

### High <a name="high"></a>
*None found.*

### Medium <a name="medium"></a>
#### [M-1] Centralization Risk for trusted owners
Contracts have owners with privileged rights to perform admin tasks and neet to be trusted to not perform malicious updates or drain funds. Any malicious or social engineered attack can create a serious deviation from the collections roadmap.

*Instances (16):*
```solidity
File: contracts/MarAbiertoToken.sol

57:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
68:     function setPrerevealTokenURI(string memory _prerevealTokenURI) public onlyOwner {
72:     function setMintPrice(uint256 _newMintPrice) public onlyOwner {
76:     function addAddressesToWhitelist(address[] memory addrs) public onlyOwner {
82:     function removeAddressesFromWhitelist(address[] memory addrs) public onlyOwner {
151:    function mintOwner(address to) public payable onlyOwner {
164:    function mintAmountOwner(uint256 _amount) public payable onlyOwner {
184:    function pause() public onlyOwner {
188:    function unpause() public onlyOwner {
192:    function revealAndSetBaseURI(string memory _baseTokenURI) public onlyOwner {
197:    function enablePublicMinting() external onlyOwner {
201:    function disablePublicMinting() external onlyOwner {
205:    function enablePresaleMinting() external onlyOwner {
209:    function disablePresaleMinting() external onlyOwner {
239:    function addOwner(address _newOwner) public onlyOwner {
243:    function removeOwner(address _oldOwner) public onlyOwner {

```

## Gas Optimization <a name="gas"></a>
#### [G-1] For Operations that will not overflow, you could use unchecked {++i}
`++i` costs less gas than `i++`, especially in for loops.

*Instances(5):*
```solidity
File: contracts/MarAbiertoToken.sol
77:        for (uint256 i = 0; i < addrs.length; i++) {
83:        for (uint256 i = 0; i < addrs.length; i++) {
113:       for (uint256 i = 0; i < _amount; i++) {
146:       for (uint256 i = 0; i < _amount; i++) {
165:       for (uint256 i = 0; i < _amount; i++) {
```

#### [G-2] Use Custom Errors
Instead of using error strings, to reduce deployment and runtime cost, you should use Custom Errors. This would save both deployment and runtime cost. Each character of the error string occupies 1 byte, while the entire Custom Error, occupies 4 bytes.

*Instances(4):*
```solidity
File: contracts/MarAbiertoToken.sol
89:        require(s_isPublicMintEnabled, "Public minting is not currently enabled.");
107:       require(s_isPublicMintEnabled, "Public minting is not currently enabled.");
176:       require(balance > 0, "No ether left to withdraw");
179:       require(success, "Transfer failed.");
```

#### [G-3] Don't initialize variables with default value

*Instances(6):*
```solidity
File: contracts/MarAbiertoToken.sol

23:        uint256 private s_signatures = 0;
29:        bool private s_isRevealed = false;
30:        bool private s_isPublicMintEnabled = false;
31:        bool private s_isPresaleMintEnabled = false;
77:        for (uint256 i = 0; i < addrs.length; i++) {
83:        for (uint256 i = 0; i < addrs.length; i++) {
113:       for (uint256 i = 0; i < _amount; i++) {
146:       for (uint256 i = 0; i < _amount; i++) {
165:       for (uint256 i = 0; i < _amount; i++) {
```

#### [G-4] Functions guaranteed to revert when called by normal users can be marked payable
If a function modifier such as onlyOwner is used, the function will revert if a normal user tries to pay the function. Marking the function as payable will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (5):*
```solidity
File: contracts/MarAbiertoToken.sol

57:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
68:     function setPrerevealTokenURI(string memory _prerevealTokenURI) public onlyOwner {
72:     function setMintPrice(uint256 _newMintPrice) public onlyOwner {
76:     function addAddressesToWhitelist(address[] memory addrs) public onlyOwner {
82:     function removeAddressesFromWhitelist(address[] memory addrs) public onlyOwner {
184:    function pause() public onlyOwner {
188:    function unpause() public onlyOwner {
192:    function revealAndSetBaseURI(string memory _baseTokenURI) public onlyOwner {
197:    function enablePublicMinting() external onlyOwner {
201:    function disablePublicMinting() external onlyOwner {
205:    function enablePresaleMinting() external onlyOwner {
209:    function disablePresaleMinting() external onlyOwner {
239:    function addOwner(address _newOwner) public onlyOwner {
243:    function removeOwner(address _oldOwner) public onlyOwner {
247:    function getBalance() public view onlyOwner returns (uint256) {
```

#### [G-5] Use != 0 instead of > 0 for unsigned integer comparison
It's more expensive cause of the low-level opcodes management.

*Instances (1):*
```solidity
File: contracts/MarAbiertoToken.sol

176:    require(balance > 0, "No ether left to withdraw");
```

#### [G-6] Use > instead of >= for unsigned integer comparison
It's more expensive cause of the low-level opcodes management.

*Instances (1):*
```solidity
123:    if (s_tokenIdCounter.current() >= 300) {
```

Instead, you can use:
```solidity
123:    if (s_tokenIdCounter.current() > 299) {
```

#### [G-6] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (5)*:
```solidity
File: contracts/MarAbiertoToken.sol

29:     bool private s_isRevealed = false;

30:     bool private s_isPublicMintEnabled = false;

31:     bool private s_isPresaleMintEnabled = false;

33:     mapping(address => bool) private s_owners;

34:     mapping(address => bool) public whitelist;
```

#### [G-7] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (2)*:
```solidity
File: contracts/MarAbiertoToken.sol

77:     for (uint256 i = 0; i < addrs.length; i++) {

83:     for (uint256 i = 0; i < addrs.length; i++) {
```

#### [G-8] Use **constant** to save deployment and read cost
Variable cannot be changed, only read, and is deployment setted.

```solidity
File: contracts/MarAbiertoToken.sol

21:    uint256 private s_supply = 1440;
```

#### [G-9] Use modifiers to remove duplicated code
You should use modifiers for better code readibility and remove these check statements which get repeated several times.
This way you only declare the code once.

```solidity
File: contracts/MarAbiertoToken.sol

89:     require(s_isPublicMintEnabled, "Public minting is not currently enabled.");
107:    require(s_isPublicMintEnabled, "Public minting is not currently enabled.");
119:    if (!s_isPresaleMintEnabled || !whitelist[msg.sender]) {
138:    if (!s_isPresaleMintEnabled || !whitelist[msg.sender]) {
```

#### [G-10] Cache storage variables to memory as soon as possible
Caching to memory storage variables which are read more than once in a function should be stored to lower gas consumption.
`s_tokenIdCounter` can be cached to tokenId before the first `s_tokenIdCounter.current()` statement in the following functions:
```solidity
File: contracts/MarAbiertoToken.sol

88:     function mint(address to) public payable {
118:    function mintPresale(address to) public payable {
151:    function mintOwner(address to) public payable onlyOwner {
```

### Informational

1. You have a typo on the following custom error:

```solidity
revert MarAbiertoToken__PresaleIsNotAvalible();
```

2. It doesn't make any sense to have an onlyOwner modifier in a read function, even less when it is a public data that even etherscan makes public in its UI for every contract:
```solidity
247:    function getBalance() public view onlyOwner returns (uint256) {
```

## Possible Improvements <a name="improvements"></a>
*Check the presale POC on the repository for the possible whitelist implementation.*

*Make `s_isPresaleMintEnabled` boolean variable public to know the presale is enabled or disabled.*

***[Could use ERC-2891 for royalties](https://docs.opensea.io/docs/part-3-set-your-drop-earnings#creator-earnings)**: Would make your royalties on by the following function interface:*
```solidity
function royaltyInfo(
        uint256 _tokenId,
        uint256 _salePrice
    ) external view returns (
        address receiver,
        uint256 royaltyAmount
    );
```
*See [EIP-2891](https://eips.ethereum.org/EIPS/eip-2981)*

***Refund Excess Payment**: In your mint and mintAmount functions, you're checking if the sent value is less than the mint price. However, you're not handling the case where the user sends more than the required amount. You could add a refund mechanism to return the excess Ether.*
Note: *The ether returned should not be lower than the explicit gas cost of the code which manages the refund.*

***Access Control**: You're using the Ownable contract from OpenZeppelin, which is a good start. However, you might want to consider more granular access control. For example, you could have separate roles for minting tokens and changing contract parameters. You could use something like OwnableRoles from OpenZeppelin.*

***First mint phase**: You can set a batch mint of the 140 NFT to the desired wallet in the constructor. This would setup the first minting phase just on the deployment of the entire smart contract.*
*Gas costs would be prohibitive, we recommend using the **[ERC721A](https://github.com/chiru-labs/ERC721A)** implementation, which would make batch minting costs, closer to O(1), not ~O(n), as it is currently implemented. This would lead to massive gas costs savings, up to hundred of $. The only gas-related problem that ERC721A could involve are the first transfer of an NFT, which would double in cost, but subsequent ones would be slightly lower.*  
*The ERC721A is efficient with whitelisting and can set the number of NFT each address can mint in the presale, this would lower minting costs up to 80%.*
*Also be aware that your current supply is limited to 50 if you want to follow this improvement.*

***Second mint phase**: 
For the whitelist you can centralize it with your database gathering the addresses on a ¿form?, or make it permisionless with a Merkle Tree or public signatures.
You can set a bitmap to see if the user is on the presale list, and track how many NFT (max limit of 3) they have minted on a per-user basis using bits or leveraging [ERC721A Aux](https://chiru-labs.github.io/ERC721A/#/tips?id=aux).*
*This has the potential to reduce user gas cost for minting up to 80%.*

## Conclusions

Overall, the contract is standard and pretty straightforward, with not many pain points. However, there is significant room for improvement in terms of gas efficiency. If this is not addressed, it will impact the revenue of the collection owners and result in higher gas fees for the buyers/holders.


An ERC721A implementation would:
    · Save an estimated ~$600 in gas costs in the first mint phase
    · Save mint gas required in the presale phase
    (from a 2% to 80% depending of how many NFT they mint)
    · Natively implement whitelisting functionalities
    (not as gas efficient as a bitmap or public signatures, but close to them and easier to implement)
    · The only drawback would the first transfer gas cost