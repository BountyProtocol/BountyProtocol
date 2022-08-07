// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

// import { ethers } from "hardhat";
const { ethers, upgrades } = require("hardhat");
const hre = require("hardhat");
const chain = hre.hardhatArguments.network;

import contractAddrs from "./_contractAddr";
const contractAddr = contractAddrs[chain];

async function main() {
  //Proxy Address
  const proxyAddress = contractAddr.hub;
  //Validate
  if(!proxyAddress) throw "Missing Proxy Address";

  //Accounts
  // const [deployer, admin] = await ethers.getSigners();

  //Log
  console.log("Update Soul Proxy:");

  //Fetch New Implementation Contract
  let NewImplementation = await ethers.getContractFactory("HubUpgradable");
  
  //Validate Upgrade
//   await upgrades.prepareUpgrade(proxyAddress, NewImplementation);
  //Run Upgrade    
  await upgrades.upgradeProxy(proxyAddress, NewImplementation);

  //Attach
  // const newProxyAddress = await NewImplementation.attach(proxyAddress.address);

  //Log
  console.log("Hub Contract Updated");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
