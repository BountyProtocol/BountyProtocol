// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "./abstract/ERC721TrackerUpgradable.sol";
import "./abstract/ProtocolEntityUpgradable.sol";

/**
 * @title ERC721Tracker
 * This mock just publicizes internal functions for testing purposes
 */
contract ERC721Tracker is ERC721TrackerUpgradable,
    ProtocolEntityUpgradable {

    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIds;

    uint256 private _deployerSBT;

    /// Initializer
    function initialize (string memory name_, string memory symbol_) public initializer {
        //Set Tracker
        _setTargetContract(repo().addressGetOf(address(_HUB), "SBT"));
        //Init Protocol Entity (Set Hub)
        __ProtocolEntity_init(msg.sender);
        //ERC721 Init
        __ERC721_init(name_, symbol_);
        //Remember Deployer's SBT
        _setOwner(getExtTokenId(tx.origin));
    }

    /// Revert to original Owner function
    function _setOwner(uint256 ownerSBT) internal virtual {
        
        // relation().set( getExtTokenId(tx.origin) );

        _deployerSBT = ownerSBT;
    }

    /// Revert to original Owner function
    function owner() public view override returns (address) {
        return _getAccount(_deployerSBT);
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
