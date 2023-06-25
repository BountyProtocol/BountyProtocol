
/**
 * Generates a single Game ABI that includes all functions from all extensions
 */
import { utils } from "ethers";
const hre = require("hardhat");
const fs = require("fs")
const path = require("path")
const { Fragment, FormatTypes } = utils;

async function main() {
    let abis = [];
    let gameABI = getTheAbi("../artifacts/contracts/GameUpgradable.sol/GameUpgradable.json")
    // console.log("gameABI", gameABI);
    abis.push(gameABI);

    let abiExtFiles = ['ActionExt','RuleExt','FundManExt','MicroDAOExt','ProjectExt','VotesExt','CourtExt'];
    for(let abiExtFileName of abiExtFiles){
        const abiExtFile = `../artifacts/contracts/extensions/${abiExtFileName}.sol/${abiExtFileName}.json`;
        const extABI = getTheAbi(abiExtFile)
        // const { extABI } = await hre.artifacts.readArtifact(abiExtFileName);
        if(!!extABI){
            abis.push(extABI);
            // console.log("ABI For", abiExtFileName, extABI);
        }
        else console.error("Failed to load ABI for ", abiExtFileName);
    }

    const mergedABI = await abiMerge(abis);
    // console.log(mergedABI);
    const artifact = createArtifact("GameFull", mergedABI);
    // Save into the Hardhat cache so artifact utilities can load it
    await hre.artifacts.saveArtifactAndDebugFile(artifact);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

/// Load Artifact JSON & extract the ABI array
function getTheAbi(filePath: string): any[] | undefined {
    try {
      const dir = path.resolve(__dirname, filePath)
      // console.log(`dir`, dir);
      const file = fs.readFileSync(dir, "utf8");
      const json = JSON.parse(file);
      const abi = json.abi;
      // console.log(`abi`, abi);
      return abi;
    } catch (e) {
      console.log(`Error loading artifact: ${filePath}`, e);
    }
}

/**
 * Merge ABIs
 * 
 */
export async function abiMerge(abis: any[]): Promise<Array<any>> {

    // const { artifact } = await hre.artifacts.readArtifact("GameUpgradable");  //undefined
    // console.log("artifact", artifact); return [];

    const mergedAbi: any[] = [];
    const abiSigs: string[] = [];
    for (let abi of abis) {
        /* Failed to work
        const methods = new ethersABI.Interface(abi).functions;
        Object.keys(methods).forEach(key => {
            console.log('key', key);
            console.log('format', methods[key].format());
            const raw = utils.keccak256(key);   //Fails
            // const sighash = utils.bufferToHex(raw).slice(2, 10);
            // console.log('sighash', sighash);
            // methodIDs[sighash] = methods[key];
        });
        */
        for (let abiEl of abi) {
            // try{
                if (!["constructor","fallback","receive"].includes(abiEl.type)) {
                    const elGUID = funcId(abiEl);
                    // console.log("ABI Element GUID:", elGUID);
                    if(!abiSigs.includes(elGUID)){
                        abiSigs.push(elGUID);
                        mergedAbi.push(abiEl);
                    }
                    else console.log(" SKIP existing ABI Element:", elGUID);
                }
            // }
            // catch(error){
            //     console.error("[CAUGHT] Error", {error, abi});
            // }
        }//Each ABI Element
    }//Each ABI
    return mergedAbi;
}

/// Function Unique Identifier
function funcId(abiEl: any): string {
    const sighash = Fragment.fromObject(abiEl).format();
    // console.log('Sighash', sighash);
    let fId = abiEl.type + ':' + sighash;
    // if(abiEl?.outputs && abiEl.outputs.length > 0){
    //     fId += '_returns(' + abiEl.outputs.map((el: { type: string; }) => el.type).join(',') + ')';
    // }
    return fId;
}

/// Save new artifact to FS
function createArtifact(artifactName: string, abi: unknown[]) {
    return {
      _format: "hh-sol-artifact-1",
      contractName: artifactName,
      sourceName: `GameFull/GameFull`,
      abi: abi,
      deployedBytecode: "",
      bytecode: "",
      linkReferences: {},
      deployedLinkReferences: {},
    } as const;
  }