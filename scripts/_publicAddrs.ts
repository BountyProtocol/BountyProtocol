//Track Addresses (Fill in present addresses to user existing deplopyment)
const publicAddr: any = {
  hardhat:{
    openRepo: "",
    ruleRepo: "",
  },
  rinkeby:{
    openRepo: "0x7b0AA37bCf5D231C13C920E0e372027919510fF9", //D2.0 (UUPS)
    ruleRepo: "0xa14C272e1D6BE9c89933e2Ad8560e83F945Ee407", //D1.0
  },
  goerli:{
    openRepo: "0xD1a6789c8A47a931833369E9EAAD5c42BF819473", //D2.1 (UUPS)
    ruleRepo: "0xF8B45CB9c3A63bE93B63a382729C733cB988de69", //D1.0
  },
  mumbai:{
    openRepo: "0x647DBF306fE835E231dB1f9d711364806467E20a", //0.5.2
    ruleRepo: "0x196FA9eCFbf6cE2643E53dB477332aD68a80D20f", //0.5.2
  },
  optimism:{
    openRepo: "",
    ruleRepo: "",
  },
  optimism_kovan:{
    openRepo: "0xFF20BA5dcD0485e2587F1a75117c0fc80941B61C",
    ruleRepo: "0x98B28D02AF16600790aAE38d8F587eA99585BBb2",
  },
  aurora:{
    openRepo: "",
    ruleRepo: "",
  },
  aurora_plus:{
    //Owner: 0x874a6E7F5e9537C4F934Fa0d6cea906e24fc287D
    openRepo: "0x2C9cc43C53141AA1CD16699f4Fe24742269c2Fe5", //0.6.1.1
    // openRepo: "0x41966B4485CBd781fE9e82f90ABBA96958C096CF", //OpenRepo v2.3.1
    ruleRepo: "0xc877ef0c936DF03cB3fC637EF3Db719EFFbED493", //0.6.1.1
  },
  aurora_test:{
    openRepo: "0x0075A3c4c30e3F67C4efABfE6e25532e79bea4b3", //0.6.1.1
    ruleRepo: "0xFF3aC21bE90C625f1de9EB5a89d3b0BeDb100Db0", //0.6.1.1
  },
};

export default publicAddr;