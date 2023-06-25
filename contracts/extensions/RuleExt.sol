// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

// import "hardhat/console.sol";

import "./interfaces/IRuleExt.sol";
import "../abstract/GameExtension.sol";
import "../libraries/DataTypes.sol";
import "../interfaces/IRules.sol";

/**
 * @title Game Extension: Rule Management 
 */
contract RuleExt is IRuleExt, GameExtension {

    //Get Rules Repo
    function _ruleRepo() internal view returns (IRules) {
        address ruleRepoAddr = dataRepo().addressGetOf(getHubAddress(), "RULE_REPO");
        return IRules(ruleRepoAddr);
    }

    //-- Getters

    /// Get Rule
    function ruleGet(uint256 id) public view override returns (DataTypes.Rule memory) {
        return _ruleRepo().ruleGet(id);
    }

    /// Get Rule's Effects
    function effectsGet(uint256 id) public view override returns (DataTypes.RepChange[] memory) {
        return _ruleRepo().effectsGet(id);
    }

    /// Get Rule's Confirmation Method
    function confirmationGet(uint256 id) public view override returns (DataTypes.Confirmation memory) {
        return _ruleRepo().confirmationGet(id);
    }

    //-- Setters

    /// Create New Rule
    function ruleAdd(
        DataTypes.Rule memory rule, 
        DataTypes.RepChange[] memory effects, 
        DataTypes.Confirmation memory confirmation
    ) public override returns (uint256) {
        require(gameRoles().roleHas(_msgSender(), "admin"), "Admin Only");
        return _ruleRepo().ruleAdd(rule, effects, confirmation);
    }

    /// Update Rule
    function ruleUpdate(
        uint256 id, 
        DataTypes.Rule memory rule, 
        DataTypes.RepChange[] memory effects
    ) external override {
        require(gameRoles().roleHas(_msgSender(), "admin"), "Admin Only");
        _ruleRepo().ruleUpdate(id, rule, effects);
    }

    /// Set Disable Status for Rule
    function ruleDisable(uint256 id, bool disabled) external override {
        require(gameRoles().roleHas(_msgSender(), "admin"), "Admin Only");
        _ruleRepo().ruleDisable(id, disabled);
    }

    /// Update Rule's Confirmation Data
    function ruleUpdateConfirmation(uint256 id, DataTypes.Confirmation memory confirmation) external override {
        require(gameRoles().roleHas(_msgSender(), "admin"), "Admin Only");
        _ruleRepo().ruleUpdateConfirmation(id, confirmation);
    }

    
}