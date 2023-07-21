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

    const erc20Addresses: string[] = [
    // '0xb7e3617adb58dc34068522bd20cfe1660780b750',
    // '0x645322989d07131a23dfc57b57f745b15e936a59',
    // '0x7ba718083591c70ce0c1720f7be314968950acf7',
    '0x4e834cdcc911605227eedddb89fad336ab9dc00a',
    '0x2BAe00C8BC1868a5F7a216E881Bae9e662630111',
    '0x2ab98d9ea81af20037af1a4f43cc3e6977545840',
    '0x09c9d464b58d96837f8d8b6f4d9fe4ad408d3a4f',
    '0x8bec47865ade3b172a928df8f990bc7f2a3b9f79',
    '0xb4530aa877d25e51c18677753acd80ffa54009b2',
    '0x5C92A4A7f59A9484AFD79DbE251AD2380E589783',
    '0x8973c9ec7b79fe880697cdbca744892682764c37',
    '0xb59d0fdaf498182ff19c4e80c00ecfc4470926e2',
    '0x2b9025aecc5ce7a8e6880d3e9c6e458927ecba04',
    '0x9f1f933c660a1dc856f0e0fe058435879c5ccef0',
    '0x672ea93e5486c04464209a655ad0c503c62024d9',
    '0x130e6203f05805cd8c44093a53c7b50775eb4ca3',
    '0x4ee3e4e8286c9b22901041e3cb9105542d88810c',
    '0x4148d2Ce7816F0AE378d98b40eB3A7211E1fcF0D',
    '0xa06fa703b95ed5224165edd94a8956a0cc4dec55',
    '0x0240ae04c9f47b91cf47ca2e7ef44c9de0d385ac',
    '0xe62233aeaed9b9ea007704262e15445e0d756c0b',
    '0x94190d8ef039c670c6d6b9990142e0ce2a1e3178',
    '0x7ca1c28663b76cfde424a9494555b94846205585',
    '0xdeacf0faa2b80af41470003b5f6cd113d47b4dcd',
    '0x026dda7f0f0a2e42163c9c80d2a5b6958e35fc49',
    '0xabe9818c5fb5e751c4310be6f0f18c8d85f9bd7f',
    '0xcc84668daae56f9f2ef907ce79c8ca0d4fdb12a7',
    '0xe301ed8c7630c9678c39e4e45193d1e7dfb914f7',
    '0xe3520349f477a5f6eb06107066048508498a291b',
    '0x72f9fedef0fb0fc8db22453b692f7d5a17b98a66',
    '0x941b45cb782cced9814821e9b684261fa353bcd5',
    '0xc51c983ea4c4c5a7e071999f600645efc26b03f1',
    '0x17cbd9C274e90C537790C51b4015a65cD015497e',
    '0x7916afb40e8d776e9002477d4bad56767711b8e7',
    '0xd5c997724e4b5756d08e6464c01afbc5f6397236',
    '0x7538162F05BEc5084A92a5F47C2A094fCF73e372',
    '0x90eb16621274fb47a071001fbbf7550948874cb5',
    '0xea62791aa682d455614eaa2a12ba3d9a2fd197af',
    '0xda2585430fef327ad8ee44af8f1f989a2a91a3d2',
    '0xc8fdd32e0bf33f0396a18209188bb8c6fb8747d2',
    '0x6961775A3Cafa23fcd24Df8F9b72fc98692B9288',
    '0x943f4bf75d5854e92140403255a471950ab8a26f',
    '0x5ac53f985ea80c6af769b9272f35f122201d0f56',
    '0x95f09a800e80a17eac1ba746489c48a1e012d855',
    '0x6454e4a4891c6b78a5a85304d34558dda5f3d6d8',
    '0xE4eB03598f4DCAB740331fa432f4b85FF58AA97E',
    '0x25e801Eb75859Ba4052C4ac4233ceC0264eaDF8c',
    '0x918dbe087040a41b786f0da83190c293dae24749',
    '0x7c9f09d9c56e5aae95f20a9077911b982341ca67',
    '0xC4bdd27c33ec7daa6fcfd8532ddB524Bf4038096',
    '0xd126b48c072f4668e944a8895bc74044d5f2e85b',
    '0x1d1f82d8b8fc72f29a8c268285347563cb6cd8b3',
    '0xa33C3B53694419824722C10D99ad7cB16Ea62754',
    '0xc21ff01229e982d7c8b8691163b0a3cb8f357453',
    '0x096f9fdda1e6f59ad2a8216bbd64daa9140222cc',
    ];
    for(let address of erc20Addresses){
        // const address = erc20Addresses[i];
        const erc20Contract = await ethers.getContractAt('GameUpgradable', address);
        erc20Contract.contractURI()
            .then((uri: any) => console.log(`Contract:${address} URI:${uri}`))
            .catch((error: any) => console.log(`Contract:${address} No URI`));
        
    }
    
    //Open Repo
    if(0 && publicAddr.openRepo){
        const openRepoContract = await ethers.getContractAt('OpenRepoUpgradable', publicAddr.openRepo);

        const res = await openRepoContract.addressGetAllOf('0xcf516b3218ea79aa51c886b643adfd699d9e09ac', 'claim');
        console.log("Claims:", res);
    }//OpenRepo

    //Soul
    if(0 && contractAddr.avatar){
        const soulContract = await ethers.getContractAt('SoulUpgradable', contractAddr.avatar);

        //Mint a Soul
        // let tokenId = await soulContract.mint("");
        // let tokenId = await soulContract.tokenByAddress(this.tester5Addr);
        // console.log("Soul Token ID: ", tokenId);


        //Aurora - Transfer Profile between Account 
        // await soulContract.transferFrom("0x8b08BDA46eB904B18E8385F1423a135167647cA3", "0xE1a71E7cCCCc9D06f8bf1CcA3f236C0D04Da741B", 8); //Alan
        // await soulContract.transferFrom("0x874a6E7F5e9537C4F934Fa0d6cea906e24fc287D", "0x8b08BDA46eB904B18E8385F1423a135167647cA3", 6); //Roy

    }//Avatar
    // else console.error("Failed to find address for 'avatar' Contract", contractAddr);

    //Hub Associations & Validation 
    if(1 && contractAddr.hub){
        const hubContract = await ethers.getContractAt('HubUpgradable', contractAddr.hub);

        //Update Game Extension: Project
        // await deployContract("ProjectExt", []).then(async res => {
        //     console.log("(i) Deployed Game Extension: ProjectExt", res.address);
        //     await hubContract.assocSet("GAME_PROJECT", res.address);
        // });
    

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
       
    }//Hub
    // else console.error("Failed to find address for Hub Contract", contractAddr);

}//main()

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
