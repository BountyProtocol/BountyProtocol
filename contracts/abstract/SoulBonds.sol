//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

// import "hardhat/console.sol";

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "../interfaces/ISoulBonds.sol";
import "../libraries/UintArray.sol";

/**
 * @title Soul Bonds (Soul to Soul Relations)
 * Version 1.0
 * - Save & Return Associations
 * - Owned by Requesting Address
 */
abstract contract SoulBonds is ISoulBonds {

    //--- Storage
    
    //Associations by Contract Address
    using UintArray for uint[];
    mapping(uint256 => mapping(string => uint[])) internal _relations;
    
    //--- Functions

    /// Get the SBT ID of the current user (msg.sender)
    /// @dev Implementing contract must override this!
    function _getCurrentSBT() internal view virtual returns (uint256) { 
        revert("Must override _getCurrentSBT()");
        // return _getExtTokenIdOrMake(_msgSender());   //For Tracker
        // return tokenByAddress(_msgSender()); //For Soul
    }

    /// ERC165 - Supported Interfaces
    /// @dev Implementing contract should implement this
    // function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    //     return interfaceId == type(ISoulBonds).interfaceId 
    //         || super.supportsInterface(interfaceId);
    // }
    
    /// Get Relation By Origin Owner Node
    function relGetOf(uint256 fromSBT, string memory key) public view override returns (uint256) {
        //Return Item
        return _relations[fromSBT][key][0];
    }

    /// Get First Relation in Slot
    function relGet(string memory key) external view override returns (uint256) {
        uint256 fromSBT = _getCurrentSBT();
        return relGetOf(fromSBT, key);
    }
    
    /// Get First Relation by Index
    function relGetIndexOf(uint256 fromSBT, string memory key, uint256 index) public view override returns (uint256) {
        require(fromSBT != 0, "SoulBond: No such SBT");
        return _relations[fromSBT][key][index];
    }

    /// Get First Relation in Index
    function relGetIndex(string memory key, uint256 index) external view override returns (uint256) {
        return relGetIndexOf(_getCurrentSBT(), key, index);
    }
    
    /// Get All Relations in Slot
    function relGetAllOf(uint256 fromSBT, string memory key) public view override returns (uint256[] memory) {
        require(fromSBT != 0, "SoulBond: No such SBT");
        return _relations[fromSBT][key];
    }

    /// Get All Relations in Slot
    function relGetAll(string memory key) external view override returns (uint256[] memory) {
        return relGetAllOf(_getCurrentSBT(), key);
    }

    /// Set Relation
    function relSet(string memory key, uint256 toSBT) external virtual override {
        _relSetOf(_getCurrentSBT(), key, toSBT);
    }
    
    /// Add Relation to Slot
    function relAdd(string memory key, uint256 toSBT) external virtual override {
        _relAddOf(_getCurrentSBT(), key, toSBT);
    }
    
    /// Remove Relation from Slot
    function relRemove(string memory key, uint256 toSBT) external virtual override {
        _relRemoveOf(_getCurrentSBT(), key, toSBT);
    }
    
    /// Set Relation
    function _relSetOf(uint256 fromSBT, string memory key, uint256 toSBT) internal {
        require(fromSBT != 0, "SoulBond: missing origin SBT");
        require(toSBT != 0, "SoulBond: missing target SBT");
        //Clear Entire Array
        delete _relations[fromSBT][key];
        //Set as the first slot of an empty array
        _relations[fromSBT][key].push(toSBT);
        //Association Changed Event
        emit RelSet(fromSBT, key, toSBT);
    }
    
    /// Add Relation to Slot
    function _relAddOf(uint256 fromSBT, string memory key, uint256 toSBT) internal {
        //Add to Array
        _relations[fromSBT][key].push(toSBT);
        //Association Changed Event
        emit RelAdd(fromSBT, key, toSBT);
    }
    
    /// Remove Relation from Slot
    function _relRemoveOf(uint256 fromSBT, string memory key, uint256 toSBT) internal {
        //Set as the first slot of an empty array
        _relations[fromSBT][key].removeItem(toSBT);
        //Association Changed Event
        emit RelRemoved(fromSBT, key, toSBT);
    }

}