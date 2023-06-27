import { ethers } from "hardhat";
const { upgrades } = require("hardhat");
const hre = require("hardhat");
const chain = hre.hardhatArguments.network;
import contractAddrs from "./_contractAddr";
const contractAddr = contractAddrs[chain];


/**
 * Deploy Demo Data
 */
async function main() {
  
  const fs = require("fs");
  const path = require("path");
  const dir = path.resolve(__dirname, "./data/demo_data.json");
  const demo_data = JSON.parse(fs.readFileSync(dir, "utf8"));
  console.log('JSON:', demo_data);

  //Demo Souls
  const soulContract = await ethers.getContractFactory("SoulUpgradable").then(res => res.attach(contractAddr.avatar));
  // for(let soul of getSoulsData()){
  for(let soul of demo_data){
    if(soul.type == '' && soul.role == '')
    try{
      await soulContract.mintFor(soul.owner, soul.uri);
      console.log(`Soul Added for Account:'${soul.owner}'`)
    }catch(error){
      console.log("[CAUGHT] Skip Account:"+soul.owner, error);
    }
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
