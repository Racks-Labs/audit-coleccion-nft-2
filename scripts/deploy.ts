// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

/*
  @dev This is a deploy scrit for the contract
*/

async function main() {
  const collectionFactory = await ethers.getContractFactory("audit.sol");
  const baseUri = "https://ipfs.i"; // need to add the ipfs hash here
  const collection = await collectionFactory.deploy(baseUri); // put the constructor arguments here if there are any.

  await collection.deployed();

  console.log("Greeter deployed to:", collection.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
