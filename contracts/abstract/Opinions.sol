//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "../interfaces/IOpinions.sol";
import "../libraries/CheckpointsUpgradeableInt.sol";

/**
 * @title Soul Opinion Extension. with checkpoint history.
 * - Hold & Update Multidimentional Preference Data about Other Contracts & Tokens
 * 
 * [Ent(SBT)] -> [contract:token]+[domain] => [value]
 * 
 */
abstract contract Opinions is IOpinions {
    
    using CheckpointsUpgradeableInt for CheckpointsUpgradeableInt.History;

    /// Opinion Tracking - Positive & Negative Opinion Tracking Per Domain (Environmantal, Personal, Community, Professional) For Tokens in Contracts
    /// [Chain][Contract][Token] => [Domain][Rating] => uint     //W/Crosschain Support
    // mapping(uint256 => mapping(address => mapping(uint256 => mapping(string => mapping(bool => uint256))))) internal _rep;

    //Only souls can have opinions + attachd to the SBT Contract
    // v [SBT_A:(Game)][contract][tokenId][domain] => amount
    // mapping(uint256 => mapping(address => mapping(uint256 => mapping(uint256 => int256)))) internal _rep;
    // mapping(uint256 => mapping(address => mapping(uint256 => mapping(uint256 => CheckpointsUpgradeable.History)))) internal _rep;
    mapping(uint256 => mapping(address => mapping(uint256 => mapping(string => CheckpointsUpgradeableInt.History)))) internal _rep;

    function _getCurrentSBT() internal view virtual returns (uint256);

    /// Fetch Opinion (Any)
    function getRepForDomain(uint256 sbt, address contractAddr, uint256 tokenId, string calldata domain) public view override returns (int256) {
        return _rep[sbt][contractAddr][tokenId][domain].latest();
    }

    /// Fetch Opinion (Current SBT)
    function getRepForDomain(address contractAddr, uint256 tokenId, string calldata domain) public view override returns (int256) {
        return getRepForDomain(_getCurrentSBT(), contractAddr, tokenId, domain);
    }

    /// Fetch Opinion (Self)
    function getRepForDomain(uint256 tokenId, string calldata domain) public view override returns (int256) {
        return getRepForDomain(address(this), tokenId, domain);
    }

    /// Get Opinion at a specified mined block 
    function getPastRepForDomain(  
        uint256 sbt, 
        address contractAddr, 
        uint256 tokenId, 
        string calldata domain, 
        uint256 blockNumber
    ) external view virtual override returns (int256) {
        return _rep[sbt][contractAddr][tokenId][domain].getAtBlock(blockNumber);
    }

    /// Add Opinion (sbt to sbt)
    function _opinionChange(address contractAddr, uint256 tokenId, string calldata domain, int256 score) internal {
        //Fetch Current SBT
        uint256 sbt = _getCurrentSBT();
        //Apply Change
        (int256 oldValue, int256 newValue) = _rep[sbt][address(this)][tokenId][domain].push(_add, score);
        //Opinion Change Event
        emit OpinionChange(sbt, contractAddr, tokenId, domain, oldValue, newValue);
    }

    /// @dev used as value modifier 
    function _add(int256 a, int256 b) private pure returns (int256) {
        return a + b;
    }

}
