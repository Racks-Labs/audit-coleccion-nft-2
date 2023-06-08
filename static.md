# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Use `selfbalance()` instead of `address(this).balance` | 2 |
| [GAS-2](#GAS-2) | Using bools for storage incurs overhead | 5 |
| [GAS-3](#GAS-3) | Cache array length outside of loop | 2 |
| [GAS-4](#GAS-4) | Use calldata instead of memory for function arguments that do not get mutated | 6 |
| [GAS-5](#GAS-5) | For Operations that will not overflow, you could use unchecked | 33 |
| [GAS-6](#GAS-6) | Use Custom Errors | 4 |
| [GAS-7](#GAS-7) | Don't initialize variables with default value | 6 |
| [GAS-8](#GAS-8) | Long revert strings | 2 |
| [GAS-9](#GAS-9) | Functions guaranteed to revert when called by normal users can be marked `payable` | 15 |
| [GAS-10](#GAS-10) | `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too) | 6 |
| [GAS-11](#GAS-11) | Use != 0 instead of > 0 for unsigned integer comparison | 1 |
### <a name="GAS-1"></a>[GAS-1] Use `selfbalance()` instead of `address(this).balance`
Use assembly when getting a contract's balance of ETH.

You can use `selfbalance()` instead of `address(this).balance` when getting your contract's balance of ETH to save gas.
Additionally, you can use `balance(address)` instead of `address.balance()` when getting an external contract's balance of ETH.

*Saves 15 gas when checking internal balance, 6 for external*

*Instances (2)*:
```solidity
File: audit.sol

175:         uint256 balance = address(this).balance;

248:         return address(this).balance;

```

### <a name="GAS-2"></a>[GAS-2] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (5)*:
```solidity
File: audit.sol

29:     bool private s_isRevealed = false;

30:     bool private s_isPublicMintEnabled = false;

31:     bool private s_isPresaleMintEnabled = false;

33:     mapping(address => bool) private s_owners;

34:     mapping(address => bool) public whitelist;

```

### <a name="GAS-3"></a>[GAS-3] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (2)*:
```solidity
File: audit.sol

77:         for (uint256 i = 0; i < addrs.length; i++) {

83:         for (uint256 i = 0; i < addrs.length; i++) {

```

### <a name="GAS-4"></a>[GAS-4] Use calldata instead of memory for function arguments that do not get mutated
Mark data types as `calldata` instead of `memory` where possible. This makes it so that the data is not automatically loaded into memory. If the data passed into the function does not need to be changed (like updating values in an array), it can be passed in as `calldata`. The one exception to this is if the argument must later be passed into another function that takes an argument that specifies `memory` storage.

*Instances (6)*:
```solidity
File: audit.sol

45:         string memory prerevealTokenURI,

57:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {

68:     function setPrerevealTokenURI(string memory _prerevealTokenURI) public onlyOwner {

76:     function addAddressesToWhitelist(address[] memory addrs) public onlyOwner {

82:     function removeAddressesFromWhitelist(address[] memory addrs) public onlyOwner {

192:     function revealAndSetBaseURI(string memory _baseTokenURI) public onlyOwner {

```

### <a name="GAS-5"></a>[GAS-5] For Operations that will not overflow, you could use unchecked

*Instances (33)*:
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

77:         for (uint256 i = 0; i < addrs.length; i++) {

77:         for (uint256 i = 0; i < addrs.length; i++) {

83:         for (uint256 i = 0; i < addrs.length; i++) {

83:         for (uint256 i = 0; i < addrs.length; i++) {

109:         if (msg.value < s_mintPrice * _amount) {

113:         for (uint256 i = 0; i < _amount; i++) {

113:         for (uint256 i = 0; i < _amount; i++) {

120:             revert MarAbiertoToken__PresaleIsNotAvalible(); // typo

120:             revert MarAbiertoToken__PresaleIsNotAvalible(); // typo

146:         for (uint256 i = 0; i < _amount; i++) {

146:         for (uint256 i = 0; i < _amount; i++) {

165:         for (uint256 i = 0; i < _amount; i++) {

165:         for (uint256 i = 0; i < _amount; i++) {

172:             s_signatures++;

172:             s_signatures++;

```

### <a name="GAS-6"></a>[GAS-6] Use Custom Errors
[Source](https://blog.soliditylang.org/2021/04/21/custom-errors/)
Instead of using error strings, to reduce deployment and runtime cost, you should use Custom Errors. This would save both deployment and runtime cost.

*Instances (4)*:
```solidity
File: audit.sol

89:         require(s_isPublicMintEnabled, "Public minting is not currently enabled.");

107:         require(s_isPublicMintEnabled, "Public minting is not currently enabled.");

176:         require(balance > 0, "No ether left to withdraw");

179:         require(success, "Transfer failed.");

```

### <a name="GAS-7"></a>[GAS-7] Don't initialize variables with default value

*Instances (6)*:
```solidity
File: audit.sol

23:     uint256 private s_signatures = 0;

77:         for (uint256 i = 0; i < addrs.length; i++) {

83:         for (uint256 i = 0; i < addrs.length; i++) {

113:         for (uint256 i = 0; i < _amount; i++) {

146:         for (uint256 i = 0; i < _amount; i++) {

165:         for (uint256 i = 0; i < _amount; i++) {

```

### <a name="GAS-8"></a>[GAS-8] Long revert strings

*Instances (2)*:
```solidity
File: audit.sol

89:         require(s_isPublicMintEnabled, "Public minting is not currently enabled.");

107:         require(s_isPublicMintEnabled, "Public minting is not currently enabled.");

```

### <a name="GAS-9"></a>[GAS-9] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (15)*:
```solidity
File: audit.sol

57:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {

68:     function setPrerevealTokenURI(string memory _prerevealTokenURI) public onlyOwner {

72:     function setMintPrice(uint256 _newMintPrice) public onlyOwner {

76:     function addAddressesToWhitelist(address[] memory addrs) public onlyOwner {

82:     function removeAddressesFromWhitelist(address[] memory addrs) public onlyOwner {

184:     function pause() public onlyOwner {

188:     function unpause() public onlyOwner {

192:     function revealAndSetBaseURI(string memory _baseTokenURI) public onlyOwner {

197:     function enablePublicMinting() external onlyOwner {

201:     function disablePublicMinting() external onlyOwner {

205:     function enablePresaleMinting() external onlyOwner {

209:     function disablePresaleMinting() external onlyOwner {

239:     function addOwner(address _newOwner) public onlyOwner {

243:     function removeOwner(address _oldOwner) public onlyOwner {

247:     function getBalance() public view onlyOwner returns (uint256) {

```

### <a name="GAS-10"></a>[GAS-10] `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too)
*Saves 5 gas per loop*

*Instances (6)*:
```solidity
File: audit.sol

77:         for (uint256 i = 0; i < addrs.length; i++) {

83:         for (uint256 i = 0; i < addrs.length; i++) {

113:         for (uint256 i = 0; i < _amount; i++) {

146:         for (uint256 i = 0; i < _amount; i++) {

165:         for (uint256 i = 0; i < _amount; i++) {

172:             s_signatures++;

```

### <a name="GAS-11"></a>[GAS-11] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (1)*:
```solidity
File: audit.sol

176:         require(balance > 0, "No ether left to withdraw");

```


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Missing checks for `address(0)` when assigning values to address state variables | 1 |
| [NC-2](#NC-2) |  `require()` / `revert()` statements should have descriptive reason strings | 1 |
| [NC-3](#NC-3) | Event is missing `indexed` fields | 2 |
| [NC-4](#NC-4) | Functions not used internally could be marked external | 18 |
### <a name="NC-1"></a>[NC-1] Missing checks for `address(0)` when assigning values to address state variables

*Instances (1)*:
```solidity
File: audit.sol

50:         s_withdrawAddress = _withdrawAddress;

```

### <a name="NC-2"></a>[NC-2]  `require()` / `revert()` statements should have descriptive reason strings

*Instances (1)*:
```solidity
File: audit.sol

37:         require(s_owners[msg.sender] == true);

```

### <a name="NC-3"></a>[NC-3] Event is missing `indexed` fields
Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (2)*:
```solidity
File: audit.sol

41:     event NftMinted(uint256 indexed tokenId, address minter);

42:     event WithdrawFunds(address from, uint256 amount);

```

### <a name="NC-4"></a>[NC-4] Functions not used internally could be marked external

*Instances (18)*:
```solidity
File: audit.sol

57:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {

72:     function setMintPrice(uint256 _newMintPrice) public onlyOwner {

76:     function addAddressesToWhitelist(address[] memory addrs) public onlyOwner {

82:     function removeAddressesFromWhitelist(address[] memory addrs) public onlyOwner {

106:     function mintAmount(uint256 _amount) public payable {

118:     function mintPresale(address to) public payable {

137:     function mintAmountPresale(uint256 _amount) public payable {

164:     function mintAmountOwner(uint256 _amount) public payable onlyOwner {

170:     function withdraw() public payable validOwner {

184:     function pause() public onlyOwner {

188:     function unpause() public onlyOwner {

192:     function revealAndSetBaseURI(string memory _baseTokenURI) public onlyOwner {

223:     function getSupply() public view returns (uint256) {

227:     function currentTokenId() public view returns (uint256) {

231:     function getPrice() public view returns (uint256) {

235:     function getBaseURI() public view returns (string memory) {

243:     function removeOwner(address _oldOwner) public onlyOwner {

247:     function getBalance() public view onlyOwner returns (uint256) {

```


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Empty Function Body - Consider commenting why | 2 |
### <a name="L-1"></a>[L-1] Empty Function Body - Consider commenting why

*Instances (2)*:
```solidity
File: audit.sol

251:     fallback() external payable {}

253:     receive() external payable {}

```


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 18 |
### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (18)*:
```solidity
File: audit.sol

16: contract MarAbiertoToken is ERC721, Pausable, Ownable, ERC721Burnable {

57:     function setBaseURI(string memory _baseTokenURI) public onlyOwner {

68:     function setPrerevealTokenURI(string memory _prerevealTokenURI) public onlyOwner {

72:     function setMintPrice(uint256 _newMintPrice) public onlyOwner {

76:     function addAddressesToWhitelist(address[] memory addrs) public onlyOwner {

82:     function removeAddressesFromWhitelist(address[] memory addrs) public onlyOwner {

151:     function mintOwner(address to) public payable onlyOwner {

164:     function mintAmountOwner(uint256 _amount) public payable onlyOwner {

184:     function pause() public onlyOwner {

188:     function unpause() public onlyOwner {

192:     function revealAndSetBaseURI(string memory _baseTokenURI) public onlyOwner {

197:     function enablePublicMinting() external onlyOwner {

201:     function disablePublicMinting() external onlyOwner {

205:     function enablePresaleMinting() external onlyOwner {

209:     function disablePresaleMinting() external onlyOwner {

239:     function addOwner(address _newOwner) public onlyOwner {

243:     function removeOwner(address _oldOwner) public onlyOwner {

247:     function getBalance() public view onlyOwner returns (uint256) {

```

