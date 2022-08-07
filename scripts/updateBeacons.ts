import { ethers } from "hardhat";
const { upgrades } = require("hardhat");
const hre = require("hardhat");
const chain = hre.hardhatArguments.network;

import contractAddrs from "./_contractAddr";
const contractAddr = contractAddrs[chain];

/**
 * Migrate Contracts Between Hubs
 */
async function main() {
  //Hub
  let hubContract = await ethers.getContractFactory("HubUpgradable").then(res => res.attach(contractAddr.hub));
  if(true){
    //Update Implementations
    await hubContract.upgradeImplementation("game", contractAddr.game);
    await hubContract.upgradeImplementation("claim", contractAddr.claim);
    await hubContract.upgradeImplementation("task", contractAddr.task);
    console.log("Beacons Updated");
  }
  if(false){
    //Set to HUB
    await hubContract.assocSet("SBT", contractAddr.avatar);
    await hubContract.assocSet("history", contractAddr.history);
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
