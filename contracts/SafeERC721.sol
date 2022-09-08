// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./abstract/ERC721TrackerUpgradable.sol";
import "./abstract/ProtocolEntityUpgradable.sol";

/**
 * @title ERC721Tracker
 * This mock just publicizes internal functions for testing purposes
 */
contract ERC721Tracker is ERC721TrackerUpgradable,
    ProtocolEntityUpgradable {

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
        // repo()
        _deployerSBT = ownerSBT;
    }

    /// Revert to original Owner function
    function owner() public view override returns (address) {
        return _getAccount(_deployerSBT);
    }

    function mint(address to, uint256 id) public onlyOwner {
        _mint(to, id);
    }

    function burn(uint256 id) public onlyOwner {
        _burn(id);
    }

}
