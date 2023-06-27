//Track Addresses (Fill in present addresses to prevent new deplopyment)
const contractAddr: any = {
  rinkeby: {
      game:"0x4650e8FC59AbfD38B90712501225Fd19562C97AC",  //D2.91
      claim:"0xF1326573800a70bbeDF360eCF6cdfCbE20459945",  //D2.8
      task: "0xc5a8f704cc85e2e9630Af03e975344594c96C8D5", //D1.0
      hub:"0xadE0EE8E93bC6EeB87c7c5279B36eA7977fCAF96", //D4.6 (Proxy)
      avatar:"0x0665dfc970Bd599e08ED6084DC12B2dD028cC416",  //D2.8 (Proxy)
      history:"0xD7ab715a2C1e5b450b54B1E3cE5136D755c715B8", //D4.4 (Proxy)
  },
  goerli:{
    game: "0xDB4236A452aD591F39d04F758D3A8aBc92EC4bd4", //0.5.1
    claim: "0x8761b3E3bCDd243A063f18d5C24528C1400FA95B", //0.5.1
    task: "0x848bCc3a27724B09415e030cDeCe669b87a4Fe47", //0.5.1
    hub: "0x4F1b5C2b4925D077226144466eA576Ff8f3eEA78", //0.5.1
    avatar: "0x93f5D16e5c590849CdCb4c0CC5666C4c927c92B8", //0.5.1
    history:"0xce5F671e5e2C9c122e09Fe323aB0840155ab1D60", //0.5.1
  },
  mumbai:{
    game: "0x91373f5d129B4eeBc55d13D7FEd9De528C59A495", //0.6.0
    claim: "0x15D7aEF51CED9DaE07d03BaBF1b2492a7b83b1A4", //0.6.0
    task: "0x56F7CB732aaEbC7967D1885899a83FFE48120d27", //0.6.0
    hub: "0xc0d1D74547356B2be0709cE841F5F2Fa5D8c63D7", //0.6.0 (Proxy)
    avatar: "0x232902B2460D82d61f04f76F49b888AF67f73ef2", //0.6.0 (Proxy)
    history: "0x95BD98a656C907fC037aF87Ea740fD94188Cd65f", //D4.4 (Proxy)
  },
  optimism_kovan:{
    game: "0xA8846989cBcbE4370B5628D4279271af4E87C036", //0.5.2
    claim: "0xA6F2d6d114778556FDf55eE6B83e20b1d2809C6a", //0.5.2
    task: "0x2E3c328B1F7796D9f0841634494c65f31b9eF24e", //0.5.2
    hub: "0x274e54BFFDbb94442FC8Df155d47b42BEF90c76B", //0.5.2 D220807
    avatar: "0x5d25e4713fA815D0E9c1B5186C80c689a9a6cA21", //0.5.2
    history: "0xCC76EB23Fc740f3617a33d236F3E5781B2a27C69", //0.5.2
  },
  optimism:{
    game: "",
    claim: "",
    task: "",
    hub: "",
    avatar: "",
    history:"",
  },
  polygon:{
    game: "",
    claim: "",
    task: "",
    hub: "",
    avatar: "",
    history:"",
  },
  aurora_plus:{ //0.6.1.1
    game: "0x04d9Afa36005F28d3Da3c19b2b7A1220d12A7a49", //0.6.2
    claim: "0xE70691993390a674A7a62f91e674BE5C843aE4f9",
    task: "0xb36D35f902DEaE9af4a996735a9b4F8dE64a7309",
    hub: "0x3CfF0AC9554Bc90ac37b8b84c2449F5B27f35740", //Owner: 0xE1a71E7cCCCc9D06f8bf1CcA3f236C0D04Da741B
    avatar: "0xD1b792De2c9c358F0C765C9f07DD618A12d8E97C",
    history: "0x75228869bD1Bbae3b534681826730134e2385a13",
  },
  aurora_test:{
    game: "",
    claim: "",
    task: "",
    hub: "",
    avatar: "",
    history:"",
  },
};

export default contractAddr;