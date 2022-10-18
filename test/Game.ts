import { expect } from "chai";
import { Signer } from "ethers";
import { ethers } from "hardhat";
import { deployContract, deployUUPS, deployHub, deployGameExt } from "../utils/deployment";
import { ZERO_ADDR, test_uri } from "../utils/consts";

describe("Game Extensions", function () {
    //Addresses
    let owner: Signer;
    let tester1: Signer;
    let tester2: Signer;
    let tester3: Signer;

    before(async function () {
        //Populate Accounts
        [owner, tester1, tester2, tester3] = await ethers.getSigners();
        this.ownerAddr = await owner.getAddress();
        this.tester1Addr = await tester1.getAddress();
        this.tester2Addr = await tester2.getAddress();
        this.tester3Addr = await tester3.getAddress();
        
        //--- OpenRepo Upgradable (UUPS)
        this.dataRepo = await deployUUPS("OpenRepoUpgradable", []);

        //--- Deploy Hub (& Game, Claim, Task, etc')
        this.hubContract = await deployHub(this.dataRepo.address);
            
        //--- Rule Repository
        this.ruleRepo = await deployContract("RuleRepo", []);
        //Set to Hub
        await this.hubContract.assocSet("RULE_REPO", this.ruleRepo.address);

        //--- Deploy All Game Extensions
        deployGameExt(this.hubContract);

        //--- Soul Upgradable (UUPS)
        this.soulContract = await deployUUPS("SoulUpgradable", [this.hubContract.address]);
        //Set Avatar Contract to Hub
        await this.hubContract.assocSet("SBT", this.soulContract.address);

        //--- History Upgradable (UUPS)
        this.actionContract = await deployUUPS("ActionRepoTrackerUp", [this.hubContract.address]);
        //Set History Contract to Hub
        await this.hubContract.assocSet("action", this.actionContract.address);

        //--- Votes Repository Upgradable (UUPS)
        this.votesRepo = await deployUUPS("VotesRepoTrackerUp", [this.hubContract.address]);
        //Set to Hub
        await this.hubContract.assocSet("VOTES_REPO", this.votesRepo.address);
        
        //Mint SBTs
        await this.soulContract.connect(owner).mint(test_uri);
        await this.soulContract.connect(tester1).mint(test_uri);
        await this.soulContract.connect(tester2).mint(test_uri);
        await this.soulContract.connect(tester3).mint(test_uri);
    });

    /**
     * Projects Flow
     */
    describe("mDAO Game Flow", function () {

        it("Deploy mDAO", async function () {
        // before(async function () {
            let game = {
                name: "Test Game",
                type: "MDAO",
            };
            //Simulate to Get New Game Address
            let gameAddr = await this.hubContract.callStatic.makeGame(game.type, game.name, test_uri);
            //Expect Valid Address
            expect(gameAddr).to.be.properAddress;
            //Create New Game
            await this.hubContract.makeGame(game.type, game.name, test_uri);
            //Init Game Contract Object
            this.gameContract = await ethers.getContractAt('GameUpgradable', gameAddr);
            console.log("Deployed Game Contract to ", this.gameContract.address);
        });

        describe("Votes Extension", function () {

            before(async function () {
                // console.log("use Game Contract at ", this.gameContract.address);
                this.gameVotes = await ethers.getContractAt('VotesExt', this.gameContract.address);
            });

            it("User can join as a member", async function () {
                //Check Before
                expect(await this.gameContract.roleHas(this.tester2Addr, "member")).to.equal(false);
                //Join Game
                await this.gameContract.connect(tester2).join();
                //Check After
                expect(await this.gameContract.roleHas(this.tester2Addr, "member")).to.equal(true);
              });
              
            it("Members receive voting power", async function () {
                expect(await this.gameVotes.getVotes(this.tester2Addr)).to.equal(1);
            });
            
        }); //Votes Extension

    }); //mDAO

}); //Game Extensions