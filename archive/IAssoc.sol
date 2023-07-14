// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

interface IAssoc {
    
    //--- Functions

    //Get Contract Association
    function assocGet(string memory key) external view returns (address);

    //--- Events

    /// Association Set
    event Assoc(string key, address contractAddr);

}
