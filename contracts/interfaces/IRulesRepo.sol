// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "../libraries/DataTypes.sol";

interface IRulesRepo {
    
    /// Expose Action Repo Address
    // function actionRepo() external view returns (address);

    ///Get Rule
    function ruleGet(uint256 ruleId) external view returns (DataTypes.Rule memory);

    /// Get Rule's Effects
    function effectsGet(uint256 ruleId) external view returns (DataTypes.RepChange[] memory);

    /// Get Rule's Effects By Owner
    function effectsGetOf(address ownerAddress, uint256 id) external view returns (DataTypes.RepChange[] memory);

    /// Get Rule's Effects
    function conditionsGet(uint256 ruleId) external view returns (DataTypes.Condition[] memory);

    /// Get Rule's Effects By Owner
    function conditionsGetOf(address ownerAddress, uint256 ruleId) external view returns (DataTypes.Condition[] memory);

    /// Get Rule's Confirmation Method
    function confirmationGetOf(address ownerAddress, uint256 ruleId) external view returns (DataTypes.Confirmation memory);

    /// Get Rule's Confirmation Method
    function confirmationGet(uint256 ruleId) external view returns (DataTypes.Confirmation memory);

    /// Update Confirmation Method for Action
    // function confirmationSet(uint256 id, DataTypes.Confirmation memory confirmation) external;

    //--
    
    /// Generate a Global Unique Identifier for a Rule
    // function ruleGUID(DataTypes.Rule memory rule) external pure returns (bytes32);

    /// Create New Rule
    function ruleAdd(
        DataTypes.Rule memory rule, 
        DataTypes.RepChange[] memory effects,
        DataTypes.Confirmation memory confirmation
    ) external returns (uint256);

    /* CANCELLED - Be More Specific
    /// Update Rule
    function ruleUpdate(
        uint256 ruleId, 
        DataTypes.Rule memory rule, 
        DataTypes.RepChange[] memory effects
    ) external;
    */ 

    /// Update Rule's URI
    function ruleUpdateURI(uint256 ruleId, string memory uri) external;

    /// Set Disable Status for Rule
    function ruleDisable(uint256 ruleId, bool disabled) external;
    
    /// Update Rule's Effects
    function ruleEffectsUpdate(uint256 ruleId, DataTypes.RepChange[] memory effects) external;
    
    /// Update Rule's Effects
    function ruleUpdateConditions(uint256 ruleId, DataTypes.Condition[] memory conditions) external;

    /// Update Rule's Confirmation Data
    function ruleUpdateConfirmation(uint256 ruleId, DataTypes.Confirmation memory confirmation) external;
  
    //--- Events

    /// Action Repository (HISTORY) Set
    // event ActionRepoSet(address actionRepo);

    /// Rule Added or Changed
    event Rule(address indexed originAddress, uint256 indexed ruleId, bytes32 about, string affected, string uri, bool negation);

    /// Rule Disabled Status Changed
    event RuleDisabled(address indexed originAddress, uint256 ruleId, bool disabled);

    /// Rule Removed
    event RuleRemoved(address indexed originAddress, uint256 indexed ruleId);

    /// Rule Removed Effects
    event RemovedEffects(address indexed originAddress, uint256 indexed ruleId);

    /// Rule Removed Conditions
    event RemovedConditions(address indexed originAddress, uint256 indexed ruleId);

    /// Rule URI Changed 
    event RuleURI(address indexed originAddress, uint256 ruleId, string uri);

    /// Rule's Effects
    // event RuleEffects(address indexed originAddress, uint256 indexed id, int8 environmental, int8 personal, int8 social, int8 professional);
    /// Generic Role Effect
    // event RuleEffect(address indexed originAddress, uint256 indexed id, bool direction, uint8 value, string name);
    event RuleEffect(address indexed originAddress, uint256 indexed ruleId, string domain, int256 value);

    /// Rule Condtion Added
    event Condition(address indexed originAddress, uint256 indexed ruleId, string repo, bytes32 id);

    /// Rule Confirmation Added
    event Confirmation(address indexed originAddress, uint256 indexed ruleId, string ruling, bool evidence, uint witness);

    /// Claim Change
    // event Claim(address indexed originAddress, uint256 indexed id, bytes32 claimId);

}
