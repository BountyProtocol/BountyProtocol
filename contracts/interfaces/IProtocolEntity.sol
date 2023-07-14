//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

/**
 * Common Protocol Functions
 */
interface IProtocolEntity {
    
    /// Inherit owner from Protocol's config
    function owner() external view returns (address);
    
    // Change Hub (Move To a New Hub)
    function setHub(address hubAddr) external;

    /// Get Hub Contract
    function getHub() external view returns (address);
    
    //Repo Address
    function getRepoAddr() external view returns (address);

    /// Contract URI
    function contractURI() external view returns (string memory);

    /// Get the SBT ID of the current user (msg.sender)
    function getCurrentSBT() external view returns (uint256);
    
}
