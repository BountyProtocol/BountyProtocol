// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import { deployContract } from "../utils/deployment";
const hre = require("hardhat");
const chain = hre.hardhatArguments.network;

//Track Addresses (Fill in present addresses to prevent new deplopyment)
import contractAddrs from "./_contractAddr";
const contractAddr = contractAddrs[chain];
import publicAddrs from "./_publicAddrs";
if(!publicAddrs.hasOwnProperty(chain)) throw "Unknown Chain:"+chain;
const publicAddr = publicAddrs[chain];
let deployed: any = [];


/**
 * MISC COMMANDS
 */
async function main() {
    //Change Game's Conf
    // const gameContract = await ethers.getContractFactory("GameUpgradable").then(res => res.attach("0x1c879765c9ec09706d80939d58acf1b663de9795"));
    // await gameContract.confSet("type", "GAME");
    // await gameContract.confSet("role", "MDAO");

    
    
    //Soul
    if(1 && contractAddr.avatar){
        const soulContract = await ethers.getContractAt('SoulUpgradable', contractAddr.avatar);

        //Mint a Soul
        // let tokenId = await soulContract.mint("");
        // let tokenId = await soulContract.tokenByAddress(this.tester5Addr);
        // console.log("Soul Token ID: ", tokenId);


        //Aurora - Transfer Profile between Account 
        // await soulContract.transferFrom("0x8b08BDA46eB904B18E8385F1423a135167647cA3", "0xE1a71E7cCCCc9D06f8bf1CcA3f236C0D04Da741B", 8); //Alan
        // await soulContract.transferFrom("0x874a6E7F5e9537C4F934Fa0d6cea906e24fc287D", "0x8b08BDA46eB904B18E8385F1423a135167647cA3", 6); //Roy

    }
    // else console.error("Failed to find address for 'avatar' Contract", contractAddr);

    //Hub Associations & Validation 
    if(0 && contractAddr.hub){
        const hubContract = await ethers.getContractAt('HubUpgradable', contractAddr.hub);

        //Transfer Protocol Ownership
        // hubContract.transferOwnership("0xE1a71E7cCCCc9D06f8bf1CcA3f236C0D04Da741B");

        //Deploy a New Game
        // await hubContract.makeGame("MDAO", "Virtual Brick", "ipfs://QmWhoRa1oYoJ1xrhgq2BUqQUiY2CFR4udGk26sU8iRBrVb");
        // await hubContract.makeGame("PROJECT", "Love Store", "ipfs://Qmc7AABpuW6zw8WHus8vNPXs25ueaX4guSKCNL8byvPAJi");

        /*
        console.log("Deploy All Game Extensions & Set to Hub");
        if(hubContract){
            //Deploy All Game Extensions & Set to Hub
            deployGameExt(hubContract);
        }
        */
        
        //Game Extension: Court of Law
        // await deployContract("CourtExt", []).then(async res => {
        //     await hubContract.assocSet("GAME_COURT", res.address);
        //     console.log("Deployed Court Ext. ", res.address);
        // });
       
    }
    // else console.error("Failed to find address for Hub Contract", contractAddr);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
