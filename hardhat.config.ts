import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";

require('@openzeppelin/hardhat-upgrades');
require('hardhat-contract-sizer');

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

// const config: HardhatUserConfig = {
const config = {
  
  // solidity: "0.8.4",
  solidity: {
    compilers: [
      {
        version: "0.8.9",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
            // runs: 10,
          },
        },
      },
    ],
  },

  networks: {
    hardhat: {
    },
    // rinkeby: {
    //   url: process.env.RINKEBY_RPC || "",
    //   accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    //   gas: 2100000,
    //   gasPrice: 8000000000
    //   // gasPrice: 10000000000,
    // },
    // goerli: {
    //   url: process.env.GOERLI_RPC || "",
    //   accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    // },
    mumbai: {
      // url: process.env.MUMBAI_RPC || "",
      // url: "https://rpc-mumbai.maticvigil.com",
      url: "https://polygon-mumbai.g.alchemy.com/v2/ccyKLe0OfwiowHcFkxKYBZBr2ViojXis",
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
      // gasPrice: 1000000000,
    },
    polygon: {
      url: "https://rpc-mainnet.maticvigil.com/",
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
      // chainId: 137,
      // gasPrice: 1000000000,
      // accounts: [process.env.PRIVATE_KEY]
    },
    aurora_plus:{ // Aurora+    
      // chainId: 1313161554
      // Block explorer: https://aurorascan.dev  
      url: process.env.AURORA_RPC || "" ,
      // url: "https://mainnet.aurora.dev/7FoWjbcX9Y2EQdAXkFmjG6pNpv4RYdQTdpE4psY7QBd", //0x3cd4f2D1B4fE810B9C024B0f99DdE37E7B9Ed654
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    aurora:{
      url: "https://mainnet.aurora.dev/",
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    aurora_test:{
      // chainId: 1313161555
      url: "https://testnet.aurora.dev/",
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    
    optimism: {
      url: process.env.OP_RPC || "",
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    optimism_kovan: {
      url: process.env.OP_TEST_RPC || "",
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },

  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    // apiKey: process.env.ETHERSCAN_API_KEY,
    apiKey: {
      rinkeby: process.env.ETHERSCAN_API_KEY,
      goerli: process.env.ETHERSCAN_API_KEY,
      polygonMumbai: process.env.ETHERSCAN_API_KEY_POLY,
      optimisticEthereum: process.env.ETHERSCAN_API_KEY_OP,
      optimisticKovan: process.env.ETHERSCAN_API_KEY_OP,
      aurora: process.env.ETHERSCAN_API_KEY_AURORA,
    }    
  },

};

export default config;
