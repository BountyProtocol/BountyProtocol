//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

// import "hardhat/console.sol";

// import "@openzeppelin/contracts/utils/Context.sol";
// import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "../libraries/DataTypes.sol";
import "../interfaces/IERC1155RolesTracker.sol";
import "../interfaces/IRulesRepo.sol";
import "../interfaces/IActionRepo.sol";
import "../interfaces/IProtocolEntity.sol";
import "../interfaces/IGameUp.sol";
import "../repositories/interfaces/IOpenRepo.sol";

/**
 * @title Rule Repository
 * @dev Contract as a Service -- Retains Rules for Other Contracts
 * To be used by a contract that implements IERC1155RolesTracker
 * Version 1.0
 * - Sender expected to be a protocol entity
 * - Sender expected to support getHub() & getRepoAddr()
 * 
 * Version 2.0
 * - Add Conditions for rules [WIP]
 * Version 3.0
 * - Rule Conditions 
 */
contract RuleRepo is IRulesRepo {

    //--- Storage

    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _ruleIds;

    //Rule Data
    mapping(address => mapping(uint256 => DataTypes.Rule)) internal _rules;
    mapping(address => mapping(uint256 => DataTypes.RepChange[])) internal _effects;  //Rule Efects (Reputation Changes)   //effects[id][] => {direction:true, value:5, name:'personal'}  // Generic, Iterable & Extendable/Flexible
    mapping(address => mapping(uint256 => DataTypes.Condition[])) internal _ruleConditions; //Conditions for Rule [WIP]
    mapping(address => mapping(uint256 => DataTypes.Confirmation)) internal _ruleConfirmation;  //Rule Confirmations
    mapping(address => mapping(uint256 => bytes32[])) internal _claims;  //Rule Claims (Consequences) //action GUIDs [UNUSED] 
    // mapping(address => mapping(uint256 => string) internal _uri;

    //--- Functions

    //** Protocol Functions
    
    //Use Self (Main Game)
    function game() internal view returns (IGame) {
        return IGame(address(msg.sender));
    }

    /// Hub Address
    function getHubAddress() internal view returns (address) {
        return IProtocolEntity(msg.sender).getHub();
    }

    //Get Data Repo Address (From Hub)
    function getRepoAddr() public view returns (address) {
        return IProtocolEntity(msg.sender).getRepoAddr();
    }

    //Get Data Repo
    function dataRepo() internal view returns (IOpenRepo) {
        return IOpenRepo(getRepoAddr());
    }

    //** Rule Management

    /// Check if rule ID exists
    function ruleHas(uint256 ruleId) public view returns (bool) {
        //Check if empty
        return _rules[msg.sender][ruleId].about.length != 0;
    }

    //-- Getters

    /// Get Rule
    function ruleGet(uint256 ruleId) public view override returns (DataTypes.Rule memory) {
        return _rules[msg.sender][ruleId];
    }

    /// Get Rule's Effects By Owner
    function effectsGetOf(address ownerAddress, uint256 ruleId) public view override returns (DataTypes.RepChange[] memory) {
        return _effects[ownerAddress][ruleId];
    }

    /// Get Rule's Effects
    function effectsGet(uint256 ruleId) public view override returns (DataTypes.RepChange[] memory) {
        return effectsGetOf(msg.sender, ruleId);
    }

    /// Get Rule's Conditions By Owner
    function conditionsGetOf(address ownerAddress, uint256 ruleId) public view override returns (DataTypes.Condition[] memory) {
        return _ruleConditions[ownerAddress][ruleId];
    }

    /// Get Rule's Conditions
    function conditionsGet(uint256 id) public view override returns (DataTypes.Condition[] memory) {
        return conditionsGetOf(msg.sender, id);
    }

    /// Get Rule's Confirmation Method
    function confirmationGetOf(address ownerAddress, uint256 id) public view override returns (DataTypes.Confirmation memory) {
        return _ruleConfirmation[ownerAddress][id];
    }

    /// Get Rule's Confirmation Method
    function confirmationGet(uint256 id) public view override returns (DataTypes.Confirmation memory) {
        return confirmationGetOf(msg.sender, id);
    }

    //-- Setters

    /// Create New Rule
    function ruleAdd(
        DataTypes.Rule memory rule, 
        DataTypes.RepChange[] memory effects,
        DataTypes.Confirmation memory confirmation
    ) public override returns (uint256) {
        //Validate rule.about -- actionGUID Exists
        address actionRepo = dataRepo().addressGetOf(getHubAddress(), "action");
        IActionRepo(actionRepo).actionGet(rule.about);  //Revetrs if does not exist
        //Add Rule
        uint256 ruleId = _ruleAdd(rule);
        //Set Confirmations
        _confirmationSet(ruleId, confirmation);
        //Set Effects
        _setEffects(ruleId, effects);
        //Return Rule ID
        return ruleId;
    }

    /// Update Rule's URI
    function ruleUpdateURI(uint256 ruleId, string memory uri) external override {
        _ruleSetURI(ruleId, uri);
    }

    /// Set Disable Status for Rule
    function ruleDisable(uint256 ruleId, bool disabled) external override {
        _ruleDisable(ruleId, disabled);
    }

    /// Update Rule's Effects
    function ruleEffectsUpdate(uint256 ruleId, DataTypes.RepChange[] memory effects) external override {
        //Set Effects
        _setEffects(ruleId, effects);
    }
    
    /// Update Rule's Confirmation Data
    function ruleUpdateConditions(uint256 ruleId, DataTypes.Condition[] memory conditions) external override {
        _conditionsSet(ruleId, conditions);
    }
    
    /// Update Rule's Confirmation Data
    function ruleUpdateConfirmation(uint256 ruleId, DataTypes.Confirmation memory confirmation) external override {
        _confirmationSet(ruleId, confirmation);
    }
    
    /// Add Rule
    function _ruleAdd(DataTypes.Rule memory rule) internal returns (uint256) {
        //Add New Rule
        _ruleIds.increment();
        uint256 ruleId = _ruleIds.current();
        //Set
        _ruleSet(ruleId, rule);
        //Return
        return ruleId;
    }

    /// Disable Rule
    function _ruleDisable(uint256 id, bool disabled) internal {
        _rules[msg.sender][id].disabled = disabled;
        //Event
        emit RuleDisabled(msg.sender, id, disabled);
    }
    
    /// Remove Rule
    function _ruleRemove(uint256 ruleId) internal {
        //Remove
        delete _rules[msg.sender][ruleId];
        //Event
        emit RuleRemoved(msg.sender, ruleId);
    }

    /// Set Rule Effects
    function _ruleAddEffects(
        uint256 ruleId, 
        DataTypes.RepChange[] memory effects
    ) internal {
        require(ruleHas(ruleId), "NO_SUCH_RULE");
        //Add New Effects
        for (uint256 i = 0; i < effects.length; ++i) {
            _effects[msg.sender][ruleId].push(effects[i]);
            //Effect Added Event
            emit RuleEffect(msg.sender, ruleId, effects[i].domain, effects[i].value);
        }
    }

    /// Set Rule Effects
    function _setEffects(
        uint256 ruleId, 
        DataTypes.RepChange[] memory effects
    ) internal {
        //Remove Current Effects
        delete _effects[msg.sender][ruleId];
        //Removed Event
        emit RemovedEffects(msg.sender, ruleId);
        //Add New Effects
        _ruleAddEffects(ruleId, effects);
    }

    /// Update Rule's URI
    function _ruleSetURI(uint256 ruleId, string memory uri) internal {
        require(ruleHas(ruleId), "NO_SUCH_RULE");
        //Set
        _rules[msg.sender][ruleId].uri = uri;
        //Event
        emit RuleURI(msg.sender, ruleId, uri);
    }
    
    /// Set Rule
    function _ruleSet(
        uint256 ruleId, 
        DataTypes.Rule memory rule
    ) internal {
        //Set
        _rules[msg.sender][ruleId] = rule;
        //Rule Updated Event
        emit Rule(msg.sender, ruleId, rule.about, rule.affected, rule.uri, rule.negation);
    }
    
    /// Add Rule Conditions
    function _ruleAddConditions(
        uint256 ruleId, 
        DataTypes.Condition[] memory conditions
    ) internal {
        require(ruleHas(ruleId), "NO_SUCH_RULE");
        //Add New Effects
        for (uint256 i = 0; i < conditions.length; ++i) {
            //Save
            _ruleConditions[msg.sender][ruleId].push(conditions[i]);
            //Condition Added Event
            emit Condition(msg.sender, ruleId, conditions[i].repo, conditions[i].id);
        }
    }

    /// Set Rule's Conditions
    function _conditionsSet(uint256 ruleId, DataTypes.Condition[] memory conditions) internal {
        //Remove Current Effects
        delete _ruleConditions[msg.sender][ruleId];
        //Removed Event
        emit RemovedConditions(msg.sender, ruleId);
        //Add
        _ruleAddConditions(ruleId, conditions);
    }

    /// Set Rule's Confirmations
    function _confirmationSet(uint256 id, DataTypes.Confirmation memory confirmation) internal {
        //Save
        _ruleConfirmation[msg.sender][id] = confirmation;
        //Event
        emit Confirmation(msg.sender, id, confirmation.ruling, confirmation.evidence, confirmation.witness);
    }

    /* What is that doing here?
    /// Set Action's Claim ID
    function _claimSet(uint256 id, bytes32 claim) internal {
        //Save
        _claims[msg.sender][id][0] = claim;
        //Event
        emit Claim(msg.sender, id, claim);
    }
   */
}
