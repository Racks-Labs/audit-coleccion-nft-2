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
7. [Conclusions](#conclusions)

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
*None found.*
### High <a name="high"></a>
*None found.*

### Medium <a name="medium"></a>
#### [M-1] Centralization Risk for trusted owners
Contracts have owners with privileged rights to perform admin tasks and neet to be trusted to not perform malicious updates or drain funds.

*Instances (8):*
```solidity
File: contracts/MarAbiertoToken.sol

35:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {

39:     function addSupply(uint256 _amount) public onlyOwner {

43:     function setMintPrice(uint256 _newMintPrice) public onlyOwner {

73:     function mintOwner(address to) public payable onlyOwner {

86:     function mintAmountOwner(uint256 _amount) public payable onlyOwner {

92:     function withdraw() public payable onlyOwner {

100:    function pause() public onlyOwner {

104:    function unpause() public onlyOwner {
```

### Low <a name="low"></a>
#### [L-1] TokenID counter is not easily accessible
There is no way for a user to know the actual TokenID without recurring to low level storage interaction. This would be beneficial for several reasons such as; publicly track how many tokens have been minted, verify the current token ID, which can be useful for various dApps or services interacting with your contract and  keep track of the remaining supply of the token (you can subtract the current ID from the total supply).  

*Instances (1):*
```solidity
20:    Counters.Counter private s_tokenIdCounter;
```

## Gas Optimization <a name="gas"></a>
#### [G-1] For Operations that will not overflow, you could use unchecked {++i}
`++i` costs less gas than `i++`, especially in for loops.

*Instances(2):*
```solidity
File: contracts/MarAbiertoToken.sol
68:        for (uint256 i = 0; i < _amount; i++) {
87:        for (uint256 i = 0; i < _amount; i++) {
```

#### [G-2] Use Custom Errors
Instead of using error strings, to reduce deployment and runtime cost, you should use Custom Errors. This would save both deployment and runtime cost. Each character of the error string occupies 1 byte, while the entire Custom Error, occupies 4 bytes.

*Instances(2):*
```solidity
File: contracts/MarAbiertoToken.sol
94:        require(balance > 0, "No ether left to withdraw");
97:        require(success, "Transfer failed.");
```

#### [G-3] Don't initialize variables with default value

*Instances(2):*
```solidity
File: contracts/MarAbiertoToken.sol
68:        for (uint256 i = 0; i < _amount; i++) {
87:        for (uint256 i = 0; i < _amount; i++) {
```

#### [G-4] Functions guaranteed to revert when called by normal users can be marked payable
If a function modifier such as onlyOwner is used, the function will revert if a normal user tries to pay the function. Marking the function as payable will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (5):*
```solidity
File: contracts/MarAbiertoToken.sol

35:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {

39:     function addSupply(uint256 _amount) public onlyOwner {

43:     function setMintPrice(uint256 _newMintPrice) public onlyOwner {

100:     function pause() public onlyOwner {

104:     function unpause() public onlyOwner {
```

#### [G-5] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (1):*
```solidity
File: contracts/MarAbiertoToken.sol

94:        require(balance > 0, "No ether left to withdraw");
```

## Possible Improvements <a name="improvements"></a>
*Check the presale POC on the repository for the whitelist implementation.*

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
*Gas costs would be prohibitive, we recommend using the **[ERC721A](https://github.com/chiru-labs/ERC721A)** implementation, which would make batch minting costs, closer to O(1), not ~O(n), as it is currently implemented. This would lead to massive gas costs savings, up to hundred of $.  
The only gas-related problem that ERC721A could involve are the first transfer of an NFT, which would double in cost, but subsequent ones would be slightly lower.*  
*The ERC721A is efficient with whitelisting and can set the number of NFT each address can mint in the presale, this would lower minting costs up to 80%.*
*Also be aware that your current supply is limited to 50 if you want to follow this improvement.*

***Second mint phase**: 
For the whitelist you can centralize it with your database gathering the addresses on a ¿form?, or make it permisionless with a Merkle Tree or public signatures.
You can set a bitmap to see if the user is on the presale list, and track how many NFT (max limit of 3) they have minted on a per-user basis using bits or leveraging [ERC721A Aux](https://chiru-labs.github.io/ERC721A/#/tips?id=aux).*
*This has the potential to reduce user gas cost for minting up to 80%.*

## Conclusions <a name="conclusions"></a>

Overall, the contract is standard and pretty straightforward, with not many pain points. However, there is significant room for improvement in terms of gas efficiency. If this is not addressed, it will impact the revenue of the collection owners and result in higher gas fees for the buyers/holders.


An ERC721A implementation would:  
* Save an estimated ~$600 in gas costs in the first mint phase  
* Save mint gas required in the presale phase  
(from a 2% to 80% depending of how many NFT they mint)  
* Natively implement whitelisting functionalities  
(not as gas efficient as a bitmap or public signatures, but close to them and easier to implement)  
* The only drawback would the first transfer gas cost  