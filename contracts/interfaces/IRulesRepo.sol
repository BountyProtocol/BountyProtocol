// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "../libraries/DataTypes.sol";

interface IRulesRepo {
    
    /// Expose Action Repo Address
    // function actionRepo() external view returns (address);

    ///Get Rule
    function ruleGet(uint256 id) external view returns (DataTypes.Rule memory);

    /// Get Rule's Effects
    function effectsGet(uint256 id) external view returns (DataTypes.RepChange[] memory);

    /// Get Rule's Effects By Owner
    function effectsGetOf(address ownerAddress, uint256 id) external view returns (DataTypes.RepChange[] memory);

    /// Get Rule's Effects
    function conditionsGet(uint256 id) external view returns (DataTypes.Condition[] memory);

    /// Get Rule's Effects By Owner
    function conditionsGetOf(address ownerAddress, uint256 id) external view returns (DataTypes.Condition[] memory);

    /// Get Rule's Confirmation Method
    function confirmationGetOf(address ownerAddress, uint256 id) external view returns (DataTypes.Confirmation memory);

    /// Get Rule's Confirmation Method
    function confirmationGet(uint256 id) external view returns (DataTypes.Confirmation memory);

    /// Update Confirmation Method for Action
    // function confirmationSet(uint256 id, DataTypes.Confirmation memory confirmation) external;

    //--
    
    /// Generate a Global Unique Identifier for a Rule
    // function ruleGUID(DataTypes.Rule memory rule) external pure returns (bytes32);

    /// Create New Rule
    function ruleAdd(
        DataTypes.Rule memory rule, 
        DataTypes.Confirmation memory confirmation, 
        DataTypes.RepChange[] memory effects
    ) external returns (uint256);

    /// Update Rule
    function ruleUpdate(
        uint256 id, 
        DataTypes.Rule memory rule, 
        DataTypes.RepChange[] memory effects
    ) external;
    
    /// Set Disable Status for Rule
    function ruleDisable(uint256 id, bool disabled) external;

    /// Update Rule's Confirmation Data
    function ruleConfirmationUpdate(uint256 id, DataTypes.Confirmation memory confirmation) external;
  
    //--- Events

    /// Action Repository (HISTORY) Set
    // event ActionRepoSet(address actionRepo);

    /// Rule Added or Changed
    event Rule(address indexed originAddress, uint256 indexed id, bytes32 about, string affected, string uri, bool negation);

    /// Rule Disabled Status Changed
    event RuleDisabled(address indexed originAddress, uint256 id, bool disabled);

    /// Rule Removed
    event RuleRemoved(address indexed originAddress, uint256 indexed id);

    /// Rule's Effects
    // event RuleEffects(address indexed originAddress, uint256 indexed id, int8 environmental, int8 personal, int8 social, int8 professional);
    /// Generic Role Effect
    // event RuleEffect(address indexed originAddress, uint256 indexed id, bool direction, uint8 value, string name);
    event RuleEffect(address indexed originAddress, uint256 indexed id, string domain, int256 value);

    /// Action Confirmation Change
    event Confirmation(address indexed originAddress, uint256 indexed id, string ruling, bool evidence, uint witness);

    /// Claim Change
    event Claim(address indexed originAddress, uint256 indexed id, bytes32 claimId);

}
