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

    /// Initializer
    function initialize (string memory name_, string memory symbol_) public initializer {
        //Set Tracker
        _setTargetContract(repo().addressGetOf(address(_HUB), "SBT"));
        //Init Protocol Entity (Set Hub)
        __ProtocolEntity_init(msg.sender);
        //ERC721 Init
        __ERC721_init(name_, symbol_);
    }

    function mint(address to, uint256 id) public {
        _mint(to, id);
    }

    function burn(uint256 id) public {
        _burn(id);
    }

}
