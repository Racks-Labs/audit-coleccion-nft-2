# Contract Audit Report

![Logo](data:image/png;base64,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)
**Author:** Racks Labs  
**Date:** June 6, 2023

---


## Prepared by: [Racks Labs](https://www.labs.racksmafia.com/)
### Lead Auditors: 
* Alex Encinas 
* Alex Arteaga 
* David Salvatella

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

| ID    | Title                                                                            | Severity |
|-------|----------------------------------------------------------------------------------|----------|
| [M-1] | Centralization Risk for trusted owners                                           | Medium   |
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
Instead of using error strings, to reduce deployment and runtime cost, you should use Custom Errors. This would save both deployment and runtime cost.

*Instances(2):*
```solidity
File: contracts/MarAbiertoToken.sol
94:        for (uint256 i = 0; i < _amount; i++) {
97:        for (uint256 i = 0; i < _amount; i++) {
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
*Check the presale POC for the whitelist implementation*

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
*Gas costs would be prohibitive, we recommend using the **[ERC721A](https://github.com/chiru-labs/ERC721A)** implementation, which would make batch minting costs, closer to O(1), not ~O(n), as it is currently implemented. This would lead to massive gas costs, up to hundred of $.*
*Also be aware that your current supply is limited to 50 if you want to follow this improvement.*

***Second mint phase**: 
For the whitelist you can centralize it with your database gathering the addresses on a ¿form?, or make it permisionless with a Merkle Tree or public signatures.
You can set a bitmap to see if the user is on the presale list, and track how many NFT (max limit of 3) they have minted on a per-user basis using bits or leveraging ERC721A `uint128 numberMinted` inside the `AddressData`.*
*This has the potential to reduce user gas cost for minting up to 90%.