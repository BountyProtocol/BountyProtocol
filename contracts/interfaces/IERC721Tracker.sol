// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721Tracker is IERC721MetadataUpgradeable {

    /// Get Target Contract
    function getTargetContract() external view returns (address);

    /// Single Token Transfer
    event TransferByToken(uint256 indexed fromSBT, uint256 indexed toSBT, uint256 indexed id);

    /// Token URI Changed Event
    event URI(string value, uint256 indexed id);

}