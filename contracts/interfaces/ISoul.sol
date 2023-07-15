// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";

/**
 * @title Soulbound Token Interface
 * @dev Additions to IERC721
 */
interface ISoul {
    //--- Functions

    /// Get Token ID by Address
    function tokenByAddress(address owner) external view returns (uint256);

    /// Mint (Create New Avatar for oneself)
    function mint(string memory tokenURI) external returns (uint256);

    /// Mint (Create New Token for Someone Else)
    function mintFor(address to, string memory tokenURI) external returns (uint256);

    /// Add (Create New Avatar Without an Owner)
    // function add(string memory tokenURI) external returns (uint256);

    /// Update Token's Metadata
    function update(uint256 tokenId, string memory uri) external returns (uint256);

    /// Opinion about another soul
    // function repAdd(uint256 tokenId, string calldata domain, bool rating, uint8 amount) external;
    function opinionAboutSoul(
        uint256 tokenId,
        string calldata domain,
        int256 score
    ) external;

    /// Opinion about another token
    function opinionAboutToken(
        address contractAddr,
        uint256 tokenId,
        string calldata domain,
        int256 score
    ) external;

    /// Map Account to Existing Token
    function tokenOwnerAdd(address owner, uint256 tokenId) external;

    /// Remove Account from Existing Token
    function tokenOwnerRemove(address owner, uint256 tokenId) external;

    /// Check if the Current Account has Control over a Token
    function hasTokenControl(uint256 tokenId) external view returns (bool);

    /// Check if a Specific Account has control over a Token
    function hasTokenControlAccount(uint256 tokenId, address account) external view returns (bool);

    /// Post and Announcement
    // function announcement(uint256 tokenId, string calldata uri) external;
    function announcement(
        uint256 tokenId,
        string calldata uri,
        string calldata context
    ) external;

    /// Return Token URI by Address
    function accountURI(address account) external view returns (string memory);

    //-- Handles

    /// Set handle for token
    function handleSet(uint256 tokenId, string calldata handle) external;

    /// Get handle by tokenId
    function handleGet(uint256 tokenId) external view returns (string memory);

    /// Find tokenId by handle
    function handleFind(string calldata handle) external view returns (uint256);

    //--- Events

    /// URI Change Event
    event URI(string value, uint256 indexed id); //Copied from ERC1155

    /// Reputation Changed
    event ReputationChange(uint256 indexed id, string domain, bool rating, uint256 score);

    /// General Announcement
    event Announcement(address indexed account, uint256 tokenId, string uri, string context);

    /// Soul Type Change
    event SoulType(uint256 indexed tokenId, string soulType);

    /// Soul Handle Change
    event SoulHandle(uint256 indexed tokenId, string handle);
}
