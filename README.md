```
Due to the lack of traction in the space project has came to a halt. 
We are currently looking for a strong design partner with a matching use case to continue development. 
```

# The Solidify Protocol 

A composible architecture for representing reality. 

## Overview

This platform allows you to

- Mint SBT profiles to represent users and resources
- Assign these people roles within distributed social organizations (DAO, Pod, etc')
- Set up roles and incentives for each org
- Design custom interaction flows and incentives
- Reward participants with tokens & reputation
- Moderate the population, handle claims, and retrive assets.
- Full extendibility and customization

## Technical info

- [Docs (Notion)](https://www.notion.so/virtualbrick/Contracts-4e383eb032e34cd08d5f035dee2dd9bb)
- [Changelog](https://github.com/MentorDAO/BountyProtocol/releases)
- [Partial Demo](https://solidify.space)

## Getting Started

### Environment

Clone .env.example to .env and fill in your environment parameters

### Commands

- Install environemnt: `npm install`
- Run tests: `npx hardhat test`
- Check contract size: `npx hardhat size-contracts`
- Deploy protocol (Rinkeby): `npx hardhat run scripts/deploy.ts --network rinkeby`
- Deploy foundation (Mumbai): `npx hardhat run scripts/foundation.ts --network mumbai`
- Deploy protocol (Mumbai): `npx hardhat run scripts/deploy.ts --network mumbai`
- Compile contracts: `npx hardhat compile`
- Cleanup: `npx hardhat clean`

### Etherscan verification

Enter your Etherscan API key into the .env file and run the following command 
(replace `DEPLOYED_CONTRACT_ADDRESS` with the contract's address and "Hello, Hardhat!" with the parameters you sent the contract upon deployment:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```
