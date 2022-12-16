Compossible architecture for representing society

```
We are currently looking for a strong design partner with a matching use case. 
```


# The Soul-System Protocol 

A Soul-System is a collection of composible primitives based around a soulbound token contract.


## Overview

This platform allows you to

- Mint SBT profiles to represent users 
- Create games to represent groups with rules (Distributed Social Organizations)
- Assign users roles (member, admin, dev, etc') within the distributed organizations (DAO, Pod, etc')
- Incentives - set up rules reactions for each org/game & reward them with various types of soulbound tokens (rep, xp, etc')
- Design custom interaction flows between entities (Procedures)
- Open, extendibe, customizable & complient with existing asset types (ERC20/721/1155, etc')
- [TBD] Use soulbound tokens (role, rep, xp...) for governance
- [TBD] Recursive control structure between games

## Architecture

![image](https://user-images.githubusercontent.com/5618090/208204563-860d1dcd-ffee-44a1-8c0b-4dfb0791e96e.png)

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
