//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

/**
 * @dev This contract is just to not break the storage in the upgradable contract
 * TODO: Remove this on new version
 */
abstract contract ContractBase {
    
    //--- Storage

    //Contract URI
    string internal _contract_uri;

}