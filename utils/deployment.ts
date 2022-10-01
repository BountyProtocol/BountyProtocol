import { Contract } from "ethers";
import { run } from "hardhat";
import { ethers } from "hardhat";
import contractAddrs from "../scripts/_contractAddr";
// import { deployments, ethers } from "hardhat"
const { upgrades } = require("hardhat");
const hre = require("hardhat");
const chain = hre.hardhatArguments.network;
const contractAddr = contractAddrs[chain];
const ZERO_ADDR = '0x0000000000000000000000000000000000000000';

// export const deployRepoRules = async (contractAddress: string, args: any[]) => {
// }

/// Deploy Regular Contrac
export const deployContract = async (contractName: string, args: any[]) => {
  return await ethers.getContractFactory(contractName).then(res => res.deploy(args));
}

/// Deploy Upgradable Contract (UUPS)
export const deployUUPS = async (contractName: string, args: any[]) => {
  return await ethers.getContractFactory(contractName)
    .then(Contract => upgrades.deployProxy(Contract, args, {kind: "uups", timeout: 120000}));
}

/// Deploy Game Extensions
export const deployGameExt = async (hubContract: Contract) => {
  let verification:any = [];
  console.log("Start Deploying Game Extensions...");

  /* [mumbai] FAILS W/reason: 'replacement fee too low', code: 'REPLACEMENT_UNDERPRICED', */
  if(chain!=='mumbai'){
    //Game Extension: Court of Law
    await deployContract("CourtExt", []).then(async res => {
      await hubContract.assocSet("GAME_COURT", res.address);
      console.log("(i) Deployed Game CourtExt Extension ", res.address);
      verification.push({name:"CourtExt", address:res.address, params:[]});
    });
  }
  
  //Game Extension: mDAO
  await deployContract("MicroDAOExt", []).then(async res => {
    await hubContract.assocSet("GAME_MDAO", res.address);
    console.log("(i) Deployed Game MicroDAOExt Extension ", res.address);
    verification.push({name:"MicroDAOExt", address:res.address, params:[]});
  });
  //Game Extension: Project
  await deployContract("ProjectExt", []).then(async res => {
    await hubContract.assocSet("GAME_PROJECT", res.address);
    console.log("(i) Deployed Game ProjectExt Extension ", res.address);
    verification.push({name:"ProjectExt", address:res.address, params:[]});
  });
  //Game Extension: Fund Management
  await deployContract("FundManExt", []).then(async res => {
    // await hubContract.assocAdd("GAME_DAO", res.address);
    await hubContract.assocAdd("GAME_MDAO", res.address);
    await hubContract.assocAdd("GAME_PROJECT", res.address);
    console.log("(i) Deployed Game FundManExt Extension ", res.address);
    verification.push({name:"FundManExt", address:res.address, params:[]});
  });
  

  //Verify Contracts
  for(let item of verification){
    await verify(item.address, item.params);
  }
}

/// Deploy Hub
export const deployHub = async (openRepoAddress: String) => {
  
    //--- Game Upgradable Implementation
    let gameUpContract = await deployContract("GameUpgradable", []);

    //--- Claim Implementation
    let claimContract = await deployContract("ClaimUpgradable", []);
    
    //--- Task Implementation
    let taskContract = await deployContract("TaskUpgradable", []);
    
    //--- Hub Upgradable (UUPS)
    let hubContract = await deployUUPS("HubUpgradable", [
      openRepoAddress,
        gameUpContract.address, 
        claimContract.address,
        taskContract.address,
      ]);
    await hubContract.deployed();
    //Return
    return hubContract;
}

/**
 * Set / Update Hub Assoc
 */
export const hubAssocUpdate = async () => {
  let hubContract = await ethers.getContractFactory("HubUpgradable").then(res => res.attach(contractAddr.hub));
  if(hubContract){
    console.log("Validate Hub ", hubContract.address);
    let assoc: any = {};
    assoc.sbt = await hubContract.assocGet("SBT");
    // console.log("Hub: ", hubContract.address, " Assoc:", assoc, contractAddr);
    if(assoc.sbt != contractAddr.avatar){
      await hubContract.assocSet("SBT", contractAddr.avatar);
      console.log("Hub: Updated SBT to: ", contractAddr.avatar);
    }
    assoc.history = await hubContract.assocGet("history");
    if(assoc.history == contractAddr.history){
      await hubContract.assocSet("history", contractAddr.history);
      console.log("Hub: Updated History to: ", contractAddr.history);
    }
    // else console.log("Not the same", contractAddr.history, ZERO_ADDR, (assoc.history == ZERO_ADDR));
  }
  else console.error("Failed to attach to Hub Contract at: " +contractAddr.hub);
}

/// Verify Contract on Etherscan
export const verify = async (contractAddress: string, args: any[]) => {
  if(!!chain){
    // console.log("Verifying contract...")
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    })
    .catch(error => {
      if (error.message.toLowerCase().includes("already verified")) {
        console.log("Contract already verified");
      } else {
        console.log("[CAUGHT] Verification Error on Chain:"+chain, error);
      }
    });
  }
  // else console.log("Skip verification on Chain:"+chain);
}
