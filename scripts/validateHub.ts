// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
// import { verify, deployContract, deployUUPS, deployGameExt } from "../utils/deployment";
import { ZERO_ADDR } from "../utils/consts";
const hre = require("hardhat");
const chain = hre.hardhatArguments.network;

//Track Addresses (Fill in present addresses to prevent new deplopyment)
import contractAddrs from "./_contractAddr";
const contractAddr = contractAddrs[chain];
import publicAddrs from "./_publicAddrs";
const publicAddr = publicAddrs[chain];
let deployed: any = [];

async function main() {

  //Validate Foundation
  if(!publicAddr.openRepo || !publicAddr.ruleRepo) throw "Must First Deploy Foundation Contracts on Chain:'"+chain+"'";

  console.log("Running on Chain: ", chain);

  let hubContract;

  //Validate Hub Associations
  if(!hubContract && contractAddr.hub) hubContract = await ethers.getContractFactory("HubUpgradable").then(res => res.attach(contractAddr.hub));
  if(hubContract){
    console.log("Validate Hub ", hubContract.address);
    let assoc: any = {};
    assoc.sbt = await hubContract.assocGet("SBT");
    assoc.history = await hubContract.assocGet("action");
    // console.log("Hub: ", hubContract.address, " Assoc:", assoc, contractAddr);
    if(assoc.sbt == ZERO_ADDR){
      await hubContract.assocSet("SBT", contractAddr.avatar);
      console.log("Updated SBT to: ", contractAddr.avatar);
    }
    if(assoc.history == ZERO_ADDR){
      await hubContract.assocSet("action", contractAddr.history);
      console.log("Updated History to: ", contractAddr.history);
    }
    // else console.log("History", contractAddr.history, ZERO_ADDR, (assoc.history == ZERO_ADDR));
  }

  //TODO: Validate Game Extensions

  /* [WIP]
  //TODO: Validate History

  //TODO: Validate Souls
  await ethers.getContractFactory("SoulUpgradable").then(async res =>  {
    let contract = res.attach(contractAddr.avatar);
    let hubAddr = await contract.hub();
    console.log("Hubs:", hubAddr, contractAddr.hub);
  });
  */
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
