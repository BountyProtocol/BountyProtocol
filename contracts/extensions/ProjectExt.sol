// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

// import "hardhat/console.sol";

import "../abstract/GameExtension.sol";
import "../interfaces/ICTXEntityUpgradable.sol";
import "../interfaces/ITask.sol";

/**
 * @title Game Extension: Project Functionality
 * This extension allows a Game to create Tasks Procedures
 */
contract ProjectExt is GameExtension {

    /// Make a new Task
    /// @dev a wrapper function for creation, adding rules, assigning roles & posting
    function makeTask(
        string calldata type_, 
        string calldata name_, 
        string calldata uri_
    ) public payable returns (address) {
        //Validate Caller Permissions (Member of Game)
        require(gameRoles().roleHas(_msgSender(), "member"), "Members Only");
        //Create new Claim
        address newContract = hub().makeTask(type_, name_, uri_);
        //Register New Contract
        _registerNewClaim(newContract);
        //Create Custom Roles
        ICTXEntityUpgradable(newContract).roleCreate("applicant");    //Applicants (Can Deliver Results)
        //Assing Default Roles
        ICTXEntityUpgradable(newContract).roleAssign(_msgSender(), "admin", 1);
        ICTXEntityUpgradable(newContract).roleAssign(_msgSender(), "creator", 1);
        //Fund Task
        if(msg.value > 0){
            (bool sent, ) = payable(newContract).call{value: msg.value}("");
            require(sent, "Failed to forward Ether to new contract");
        }
        //Open by default
        ITask(newContract).stageOpen();
        //Return new Contract Address
        return newContract;
    }

    /// Register New Claim Contract
    function _registerNewClaim(address claimContract) private {
        //Register Child Contract
        dataRepo().addressAdd("claim", claimContract);
        // dataRepo().addressAdd("task", claimContract);   //TODO: Change this to 'task' or 'child' or 'part'...
    }

}