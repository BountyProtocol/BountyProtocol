// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

// import "hardhat/console.sol";

import "../abstract/GameExtension.sol";
// import "../interfaces/IClaim.sol";
// import "../interfaces/ITask.sol";

/** [WIP]
 * @title Game Extension: Action
 * This extension allows a Game to run Actions (from ActionRepo)
 */
contract ActionExt is GameExtension {



    /**
     * https://github.com/makerdao/multicall/blob/master/src/Multicall.sol
     * https://github.com/makerdao/multicall/blob/master/src/Multicall2.sol
     * Structure Call: https://github.com/safe-global/safe-contracts/blob/da66b45ec87d2fb6da7dfd837b29eacdb9a604c5/src/utils/execution.ts
     */
    /// Run Custom Action
    function runAction(bytes32 actionGUID) external {
        if(actionGUID == actionGUID){
            // address targetContract = '';
            // (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            // bytes memory data = abi.encodeWithSignature(verb:"set(uint256)", params:_value)
            // address(tool:contract).call(data);

            //Defaults ? -- Internal affordances / data templates
            // Cover Function??
            // internalTransfer / pay / send(){
                //default: from:subject, to:target, amount:all
                // subject sent/paid/gave o:money to target (+amount)
            // }
            // internalRoleAdd/Assign()
            //      default: role:object, tokenId: subject, amount
            //      => subject assigned the role of object (+amount)
            //
            
        }
    }

    mapping(bytes32 => bytes) internal availableActions;

}