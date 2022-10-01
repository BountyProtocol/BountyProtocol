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
  //Demo Souls
  let soulContract = await ethers.getContractFactory("SoulUpgradable").then(res => res.attach(contractAddr.avatar));
  for(let soul of getSoulsData()){
    try{
      await soulContract.mintFor(soul.owner, soul.uri);
      console.log(`Soul Added for Account:'${soul.owner}'`)
    }catch(error){
      console.log("[CAUGHT] Skip Account:"+soul.owner, error);}
  }

  //TODO: Demo DAOs & Pods
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

const getSoulsData = () => [
    {
      "id": "1",
      "type": "",
      "owner": "0x4306d7a79265d2cb85db0c5a55ea5f4f6f73c4b1",
      "uri": "https://ipfs.infura.io/ipfs/QmcQGNWgoba9bQyuB69wPhnxSRg1kunwTUnrNp97NiaLgB"
    },
    {
      "id": "13",
      "type": "",
      "owner": "0x70867d94302a4eef645436699607b58122ee9fa9",
      "uri": "https://ipfs.infura.io/ipfs/QmaYLYTWn1DEJMDm5L6P9eybbYARJ8cz3Hcgcq73pqcRsE"
    },
    {
      "id": "14",
      "type": "",
      "owner": "0x70d374376c987a3ebcf8168f8ff7f84097664868",
      "uri": "https://ipfs.infura.io/ipfs/QmewTQNaaLTXPNEAX5cZCMYX5mdJMU9r3XWxxmvfTmKjZV"
    },
    {
      "id": "15",
      "type": "",
      "owner": "0xe1a71e7ccccc9d06f8bf1cca3f236c0d04da741b",
      "uri": "https://ipfs.infura.io/ipfs/QmNrx3xzYLNFVkmR5z6Hs2F8idLWtjz3mW7zzvcFwvwC99"
    },
    {
      "id": "4",
      "type": "",
      "owner": "0x874a6e7f5e9537c4f934fa0d6cea906e24fc287d",
      "uri": "ipfs://Qma8kj5sTEQAgV42hrLqmqj14NvNcaXn2RfgMdzu2M15DJ"
    },
    {
      "id": "7",
      "type": "",
      "owner": "0x3f121f9a16bd6c83d325985417ada3fe0f517b7d",
      "uri": "https://ipfs.infura.io/ipfs/QmStWbXsxwDbXVfAKmvg5GYGXGyL1bvVD6xHr6UKEbHCso"
    },
    {
      "id": "9",
      "type": "",
      "owner": "0x8b08bda46eb904b18e8385f1423a135167647ca3",
      "uri": "https://ipfs.infura.io/ipfs/QmZXRA5GRS9cgDMMkr5sTdwHr6daruhWmRRgvyM9CD17tX"
    }
  ];
