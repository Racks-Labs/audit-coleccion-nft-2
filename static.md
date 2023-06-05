# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Use `selfbalance()` instead of `address(this).balance` | 1 |
| [GAS-2](#GAS-2) | Use calldata instead of memory for function arguments that do not get mutated | 2 |
| [GAS-3](#GAS-3) | For Operations that will not overflow, you could use unchecked | 24 |
| [GAS-4](#GAS-4) | Use Custom Errors | 2 |
| [GAS-5](#GAS-5) | Don't initialize variables with default value | 2 |
| [GAS-6](#GAS-6) | Functions guaranteed to revert when called by normal users can be marked `payable` | 5 |
| [GAS-7](#GAS-7) | `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too) | 2 |
| [GAS-8](#GAS-8) | Use != 0 instead of > 0 for unsigned integer comparison | 1 |
### <a name="GAS-1"></a>[GAS-1] Use `selfbalance()` instead of `address(this).balance`
Use assembly when getting a contract's balance of ETH.

You can use `selfbalance()` instead of `address(this).balance` when getting your contract's balance of ETH to save gas.
Additionally, you can use `balance(address)` instead of `address.balance()` when getting an external contract's balance of ETH.

*Saves 15 gas when checking internal balance, 6 for external*

*Instances (1)*:
```solidity
File: audit.sol

93:         uint256 balance = address(this).balance;

```

### <a name="GAS-2"></a>[GAS-2] Use calldata instead of memory for function arguments that do not get mutated
Mark data types as `calldata` instead of `memory` where possible. This makes it so that the data is not automatically loaded into memory. If the data passed into the function does not need to be changed (like updating values in an array), it can be passed in as `calldata`. The one exception to this is if the argument must later be passed into another function that takes an argument that specifies `memory` storage.

*Instances (2)*:
```solidity
File: audit.sol

27:     constructor(string memory baseURI) ERC721("MarAbierto", "MAR") {

35:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {

```

### <a name="GAS-3"></a>[GAS-3] For Operations that will not overflow, you could use unchecked

*Instances (24)*:
```solidity
File: audit.sol

4: import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

4: import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

4: import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

4: import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

5: import "@openzeppelin/contracts/security/Pausable.sol";

5: import "@openzeppelin/contracts/security/Pausable.sol";

5: import "@openzeppelin/contracts/security/Pausable.sol";

6: import "@openzeppelin/contracts/access/Ownable.sol";

6: import "@openzeppelin/contracts/access/Ownable.sol";

6: import "@openzeppelin/contracts/access/Ownable.sol";

7: import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

7: import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

7: import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

7: import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

7: import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

8: import "@openzeppelin/contracts/utils/Counters.sol";

8: import "@openzeppelin/contracts/utils/Counters.sol";

8: import "@openzeppelin/contracts/utils/Counters.sol";

40:         s_supply += _amount;

65:         if (msg.value < s_mintPrice * _amount) {

68:         for (uint256 i = 0; i < _amount; i++) {

68:         for (uint256 i = 0; i < _amount; i++) {

87:         for (uint256 i = 0; i < _amount; i++) {

87:         for (uint256 i = 0; i < _amount; i++) {

```

### <a name="GAS-4"></a>[GAS-4] Use Custom Errors
[Source](https://blog.soliditylang.org/2021/04/21/custom-errors/)
Instead of using error strings, to reduce deployment and runtime cost, you should use Custom Errors. This would save both deployment and runtime cost.

*Instances (2)*:
```solidity
File: audit.sol

94:         require(balance > 0, "No ether left to withdraw");

97:         require(success, "Transfer failed.");

```

### <a name="GAS-5"></a>[GAS-5] Don't initialize variables with default value

*Instances (2)*:
```solidity
File: audit.sol

68:         for (uint256 i = 0; i < _amount; i++) {

87:         for (uint256 i = 0; i < _amount; i++) {

```

### <a name="GAS-6"></a>[GAS-6] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (5)*:
```solidity
File: audit.sol

35:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {

39:     function addSupply(uint256 _amount) public onlyOwner {

43:     function setMintPrice(uint256 _newMintPrice) public onlyOwner {

100:     function pause() public onlyOwner {

104:     function unpause() public onlyOwner {

```

### <a name="GAS-7"></a>[GAS-7] `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too)
*Saves 5 gas per loop*

*Instances (2)*:
```solidity
File: audit.sol

68:         for (uint256 i = 0; i < _amount; i++) {

87:         for (uint256 i = 0; i < _amount; i++) {

```

### <a name="GAS-8"></a>[GAS-8] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (1)*:
```solidity
File: audit.sol

94:         require(balance > 0, "No ether left to withdraw");

```


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Event is missing `indexed` fields | 1 |
| [NC-2](#NC-2) | Functions not used internally could be marked external | 10 |
### <a name="NC-1"></a>[NC-1] Event is missing `indexed` fields
Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (1)*:
```solidity
File: audit.sol

25:     event NftMinted(uint256 indexed tokenId, address minter);

```

### <a name="NC-2"></a>[NC-2] Functions not used internally could be marked external

*Instances (10)*:
```solidity
File: audit.sol

39:     function addSupply(uint256 _amount) public onlyOwner {

43:     function setMintPrice(uint256 _newMintPrice) public onlyOwner {

64:     function mintAmount(uint256 _amount) public payable {

86:     function mintAmountOwner(uint256 _amount) public payable onlyOwner {

92:     function withdraw() public payable onlyOwner {

100:     function pause() public onlyOwner {

104:     function unpause() public onlyOwner {

118:     function getSupply() public view returns (uint256) {

122:     function getPrice() public view returns (uint256) {

126:     function getBaseURI() public view returns (string memory) {

```


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 9 |
### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (9)*:
```solidity
File: audit.sol

17: contract MarAbiertoToken is ERC721, Pausable, Ownable, ERC721Burnable {

35:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {

39:     function addSupply(uint256 _amount) public onlyOwner {

43:     function setMintPrice(uint256 _newMintPrice) public onlyOwner {

73:     function mintOwner(address to) public payable onlyOwner {

86:     function mintAmountOwner(uint256 _amount) public payable onlyOwner {

92:     function withdraw() public payable onlyOwner {

100:     function pause() public onlyOwner {

104:     function unpause() public onlyOwner {

```

