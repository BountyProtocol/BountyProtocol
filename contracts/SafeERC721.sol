// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "./interfaces/ISoulBonds.sol";
import "./abstract/ERC721TrackerUpgradable.sol";
import "./abstract/ProtocolEntityUpgradable.sol";

/**
 * @title ERC721Tracker
 * This mock just publicizes internal functions for testing purposes
 */
contract SafeERC721 is ERC721TrackerUpgradable,
    ProtocolEntityUpgradable {

    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIds;


    /// Initializer
    function initialize (
        string memory name_, 
        string memory symbol_,
        string calldata uri_, 
        address owner_
    ) public initializer {
        //Init Protocol Entity (Set Hub)
        __ProtocolEntity_init(msg.sender);
        //ERC721 Init
        __ERC721_init(name_, symbol_);
        //Set Tracker
        _setTargetContract(dataRepo().addressGetOf(address(_HUB), "SBT"));
        //Represent the Self
        ISoul(_targetContract).mint(uri_);
        //Remember Deployer's SBT
        _setOwner(_getExtTokenIdOrMake(owner_));
    }

    /// Revert to original Owner function
    function _setOwner(uint256 ownerSBT) internal virtual {
        ISoulBonds(_targetContract).relSet("owner", ownerSBT);
    }

    /// Revert to original Owner function
    function owner() public view override returns (address) {
        uint256 ownerSBT = ISoulBonds(_targetContract).relGet("owner");
        return _getAccount(ownerSBT);
    }

    /// Mint NFT
    function mint(address to, string memory uri) public onlyOwner returns (uint256) {
        //Make sure account has SBT 
        _getExtTokenIdOrMake(to);
        //Mint
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(to, newItemId);
        //Set URI
        _setTokenURI(newItemId, uri);	//This Goes for Specific Metadata Set (IPFS and Such)
        //Done
        return newItemId;
    }

    /// Burn NFT
    function burn(uint256 id) public onlyOwner {
        _burn(id);
    }

}
