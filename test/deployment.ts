import { Contract, Signer } from "ethers";
import { ethers } from "hardhat";
import { deployContract, deployUUPS, deployHub } from "../utils/deployment";

describe("Deployment", function () {
    let gameContract: Contract;
    let claimContract: Contract;
    let hubContract: Contract;
    // let Contract: Contract;
    // let actionRepoContract: Contract;
    let openRepoContract: Contract;
    // let SoulUpgradable: Contract;
    // let actionContract: Contract;
    // let oldHubContract: Contract;

    //Addresses
    let account1: Signer;
    let account2: Signer;

    before(async function () {
        //Populate Accounts
        [account1, account2] = await ethers.getSigners();

        //--- OpenRepo (UUPS)
        openRepoContract = await deployUUPS("OpenRepoUpgradable", []);

        //--- Game Implementation
        gameContract = await deployContract("GameUpgradable", []);
        await gameContract.deployed();

        //--- Claim Implementation
        claimContract = await deployContract("ClaimUpgradable", []);
        await claimContract.deployed();
    });

    it("Should Deploy Upgradable Hub Contract", async function () {
        hubContract = await deployHub(openRepoContract.address);
        // console.log("HubUpgradable deployed to:", proxyHub.address);
    });

    it("Should Change Hub", async function () {
        //Deploy Another Hub Upgradable
        const proxyHub2 = await deployHub(openRepoContract.address);
        // console.log("Hub Address:", hubContract.address);
        //Change Hub
        proxyHub2.hubChange(hubContract.address);
    });

    it("Should Deploy Upgradable Soul Contract", async function () {
        //Deploy Soul Upgradable
        const proxyAvatar = await deployUUPS("SoulUpgradable", [hubContract.address]);
        await proxyAvatar.deployed();
        this.avatarContract = proxyAvatar;
        //Set Avatar Contract to Hub
        hubContract.assocSet("SBT", proxyAvatar.address);
        // console.log("SoulUpgradable deployed to:", proxyAvatar.address);
    });

    it("Should Deploy History (ActionRepo)", async function () {
        //Deploy Action Repository
        const proxyActionRepo = await deployUUPS("ActionRepoTrackerUp", [hubContract.address]);
        await proxyActionRepo.deployed();
        //Set Avatar Contract to Hub
        hubContract.assocSet("history", proxyActionRepo.address);
        // this.historyContract = proxyActionRepo;
        // console.log("ActionRepoTrackerUp deployed to:", proxyActionRepo.address);
    });

    /* FOR DEBUGGING PURPOSES
    describe("Mock", function () {
        it("Should Deploy Mock Hub Contract", async function () {
            //--- Mock Hub
            let mockHub = await ethers.getContractFactory("HubMock").then(res => res.deploy(
                openRepoContract.address,
                gameContract.address,
                claimContract.address
            ));
            await mockHub.deployed();
            // console.log("MockHub Deployed to:", mockHub.address);
        });
    });
    */
});


