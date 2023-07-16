Compossible architecture for representing society

```
NOTE! This project is still under development. It means the SoulSystem Protocol hasn't been audited and data structures may still change. 
We are currently partnering with design partners to help ground the progress of the protocol. 
If you might be interested, have a matching use-case, or just want to say hello, please use the _Issues_ tab to reach out.  
```


# The SoulSystem Protocol 

A SoulSystem is a collection of composable primitives based around a soulbound token contract.


## Overview

This platform allows you to

- Mint SBT profiles to represent users 
- Create games to represent groups with rules (Distributed Social Organizations)
- Assign users roles (member, admin, dev, etc.) within the distributed organizations (DAO, Pod, etc.)
- Incentives - set up rules reactions for each org/game & reward them with various types of soulbound tokens (rep, xp, etc.)
- Design custom interaction flows between entities (Procedures)
- Open, extendible, customizable & compliant with existing asset types (ERC20/721/1155, etc.)
- [WIP] Simplified token-based permission mechanism 
- [WIP] Use soulbound tokens (role, rep, xp...) for governance

## Fractal Architecture

![image](https://user-images.githubusercontent.com/5618090/208204563-860d1dcd-ffee-44a1-8c0b-4dfb0791e96e.png)

## Technical info

- [Docs (Notion)](https://www.notion.so/virtualbrick/Contracts-4e383eb032e34cd08d5f035dee2dd9bb)
- [Changelog](https://github.com/MentorDAO/BountyProtocol/releases)
- [Boilerplate/Demo](https://www.soulsystem.app)
- [Architecture Schemas (Miro)](https://miro.com/app/board/uXjVOH541OI=/?share_link_id=612732936883)
## Getting Started

### Environment

Use .env and add your custom environment variables

### Commands

- Install environment: `npm install`
- Run tests: `npx hardhat test`
- Check contract size: `npx hardhat size-contracts`
- Deploy foundation (Mumbai): `npx hardhat run scripts/foundation.ts --network aurora`
- Deploy protocol (Mumbai): `npx hardhat run scripts/deploy.ts --network aurora`
- Compile contracts: `npx hardhat compile`
- Cleanup: `npx hardhat clean`

### Etherscan verification

Enter your Etherscan API key into the .env file and run the following command 
(replace `DEPLOYED_CONTRACT_ADDRESS` with the contract's address and "Hello, Hardhat!" with the parameters you sent the contract upon deployment:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```
