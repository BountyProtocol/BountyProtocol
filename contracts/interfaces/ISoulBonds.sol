// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

interface ISoulBonds {
    
    //--- Functions

    /// Get Boolean By Origin Owner Node
    function relGetOf(uint256 fromSBT, string memory key) external view returns (uint256);

    /// Get First Boolean in Slot
    function relGet(string memory key) external view returns (uint256);
    
    /// Get First Boolean by Index
    function relGetIndexOf(uint256 fromSBT, string memory key, uint256 index) external view returns (uint256);

    /// Get First Boolean in Index
    function relGetIndex(string memory key, uint256 index) external view returns (uint256);
    
    /// Get All Relations in Slot (For SBT)
    function relGetAllOf(uint256 fromSBT, string memory key) external view returns (uint256[] memory);

    /// Get All Boolean in Slot
    function relGetAll(string memory key) external view returns (uint256[] memory);

    /// Set Boolean
    function relSet(string memory key, uint256 toSBT) external;
    
    /// Add Boolean to Slot
    function relAdd(string memory key, uint256 toSBT) external;
    
    /// Remove Boolean from Slot
    function relRemove(string memory key, uint256 toSBT) external;

    //--- Events

    /// Relation Set
    event RelSet(uint256 fromSBT, string key, uint256 toSBT);

    /// Relation Added
    event RelAdd(uint256 fromSBT, string key, uint256 toSBT);

    /// Relation Removed
    event RelRemoved(uint256 fromSBT, string key, uint256 toSBT);

}
