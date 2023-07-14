// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

interface IContractBase {
    
    //--- Functions

    /// Contract URI
    function contractURI() external view returns (string memory);

    //-- Events
    
    /// Contract URI Changed
    event ContractURI(string);

}
