//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/utils/CheckpointsUpgradeable.sol";
// import "../libraries/DataTypes.sol";
// import "../interfaces/IOpinions.sol";

/**
 * @title Rating for Contracts & Tokens
 * @dev Designed To Be Used by Games
 * - Hold & Update Multidimentional Rating Data about Other On-Chain Entities
 */
abstract contract OpinionRepo {
    
    // See VotesRoleRepoTrackerUp.sol

/* COPY of
    //CANCELLED: Track Voting Units (Checkpoints)    
    // mapping(address => mapping(address => uint256)) internal _unitsBalance;
    // mapping(address => mapping(uint256 => uint256)) internal _unitsBalance;
    mapping(address => mapping(uint256 => CheckpointsUpgradeable.History)) private _unitsBalance;
*/
/* COPY of
    /// Opinion Tracking - Positive & Negative Opinion Tracking Per Domain (Environmantal, Personal, Community, Professional) For Tokens in Contracts
    /// [Chain][Contract][Token] => [Domain][Rating] => uint     //W/Crosschain Support
    mapping(uint256 => mapping(address => mapping(uint256 => mapping(string => mapping(bool => uint256))))) internal _rep;
*/

}