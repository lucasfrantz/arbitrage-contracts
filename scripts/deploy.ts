import { ethers } from "hardhat";

async function main() {
  const Scanner = await ethers.getContractFactory("ArbitrageScanner");
  const scanner = await Scanner.deploy();

  await scanner.deployed();

  console.log("Scanner deployed to:", scanner.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
