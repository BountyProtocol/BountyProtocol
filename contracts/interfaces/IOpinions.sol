// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

// import "../libraries/DataTypes.sol";

interface IOpinions {
    
    //--- Functions

    /// Fetch Opinion (Crosschain)
    function getRepForDomain(uint256 sbt, address contractAddr, uint256 tokenId, string calldata domain) external view returns (int256);

    /// Fetch Opinion (Current Chain)
    function getRepForDomain(address contractAddr, uint256 tokenId, string calldata domain) external view returns (int256);

    /// Fetch Opinion (Self)
    function getRepForDomain(uint256 tokenId, string calldata domain) external view returns (int256);

    function getPastRepForDomain(uint256 sbt, address contractAddr, uint256 tokenId, string calldata domain, uint256 blockNumber) external view returns (int256);

    //--- Events

    /// Opinion Changed
    event OpinionChange(uint256 sbt, address indexed contractAddr, uint256 indexed tokenId, string domain, int256 oldValue, int256 newValue);
    // event OpinionChange(uint256 sbt, address indexed contractAddr, uint256 indexed tokenId, string domain, int256 score);
    // event OpinionChange(uint256 sbt, uint256 indexed sbtOf, uint256 indexed sbtOn, string domain, int256 score);

}
