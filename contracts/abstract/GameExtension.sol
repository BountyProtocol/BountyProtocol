// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Context.sol";
import "../repositories/interfaces/IOpenRepo.sol";
import "../interfaces/IERC1155RolesTracker.sol";
import "../interfaces/IProtocolEntity.sol";
import "../interfaces/IRules.sol";
import "../interfaces/IGameUp.sol";
import "../interfaces/IActionRepo.sol";
import "../interfaces/IHub.sol";
import "../interfaces/ISoul.sol";

/**
 * @title GameExtension
 */
abstract contract GameExtension is Context {

    //--- Modifiers

    
    /// Permissions Modifier
    modifier AdminOnly() {
       //Validate Permissions
        require(gameRoles().roleHas(_msgSender(), "admin"), "ADMIN_ONLY");
        _;
    }
    
    //--- Functions 

    /// Use Self (Main Game)
    function game() internal view returns (IGame) {
        return IGame(address(this));
    }

    /// Use Game Role Interface on Self 
    function gameRoles() internal view returns (IERC1155RolesTracker) {
        return IERC1155RolesTracker(address(this));
    }

    /// Get Data Repo Address (From Hub)
    function getRepoAddr() public view returns (address) {
        return IProtocolEntity(address(this)).getRepoAddr();
    }

    /// Get Assoc Repo
    function dataRepo() internal view returns (IOpenRepo) {
        return IOpenRepo(getRepoAddr());
    }

    /// Hub Address
    function getHubAddress() internal view returns (address) {
        return IProtocolEntity(address(this)).getHub();
    }
      
    /// Get Hub
    function hub() public view returns (IHub) {
        return IHub(getHubAddress());
    }  

    /// Get Soul Contract Address
    function getSoulAddr() internal view returns (address) {
        return dataRepo().addressGetOf(getHubAddress(), "SBT");
    }

    /// Get Soul Contract
    function soul() internal view returns (ISoul) {
        return ISoul(getSoulAddr());
    }  
    
    /// Get Action Repo Contract Address
    function getActionAddr() internal view returns (address) {
        return dataRepo().addressGetOf(getHubAddress(), "action");
    }

    /// Get Action Repo Contract Address
    function actionRepo() internal view returns (IActionRepo) {
        return IActionRepo(getActionAddr());
    }
    
    /// Auto-Rules Interface
    function rules() internal view returns (IRules) {
        return IRules(address(this));
    }

}
