// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "../../contracts/audit.sol"; 

contract TestMarAbiertoToken is MarAbiertoToken {
    constructor() MarAbiertoToken("https://mytoken.com/") {
        // Owner can mint tokens freely for testing
        for (uint i = 0; i < 10; i++) {
            mintOwner(msg.sender);
        }
    }
    // Property 1: After calling `mint`, the total supply of tokens should be increased by one.
    function echidna_test_mint_increases_supply() public returns (bool) {
        uint256 supplyBefore = getSupply();
        mintOwner(msg.sender);
        uint256 supplyAfter = getSupply();
        return supplyAfter == supplyBefore + 1;
    }

    // Property 2: After calling `mint`, the balance of the minter should be increased by one.
    function echidna_test_mint_increases_balance() public returns (bool) {
        uint256 balanceBefore = balanceOf(msg.sender);
        mintOwner(msg.sender);
        uint256 balanceAfter = balanceOf(msg.sender);
        return balanceAfter == balanceBefore + 1;
    }

    // Property 4: After calling `setMintPrice`, the new mint price should be the same as the value passed to the function.
    function echidna_test_set_mint_price() public returns (bool) {
        uint256 newPrice = 0.2 ether;
        setMintPrice(newPrice);
        return getPrice() == newPrice;
    }

    // Property 5: After calling `setBaseURI`, the new base URI should be the same as the value passed to the function.
    function echidna_test_set_base_URI() public returns (bool) {
        string memory newURI = "https://newtoken.com/";
        setBaseURI(newURI);
        return keccak256(bytes(getBaseURI())) == keccak256(bytes(newURI));
    }
}
