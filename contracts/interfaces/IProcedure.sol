// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "../libraries/DataTypes.sol";

interface IProcedure {

    //-- Functions

    /// Initialize
    function initialize(string memory name_) external;

    /// Set Parent Container
    function setParentCTX(address container) external;

    /// Add Post 
    function post(string calldata entRole, uint256 tokenId, string calldata uri) external;

    //--- Events

    /// Claim Stage Change
    event Stage(DataTypes.ClaimStage stage);

    /// Post Verdict
    event Verdict(string uri, address account);

    /// Claim Cancelation Data
    event Executed(address account);

    /// Claim Cancelation Data
    event Cancelled(string uri, address account);

}