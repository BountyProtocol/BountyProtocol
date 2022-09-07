// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./abstract/ERC1155TrackerUpgradable.sol";
import "./abstract/ProtocolEntityUpgradable.sol";

/**
 * @title ERC1155Tracker
 * This mock just publicizes internal functions for testing purposes
 */
contract ERC1155Tracker is ERC1155TrackerUpgradable,
    ProtocolEntityUpgradable {

    uint256 private _deployerSBT;

    /// Initializer
    function initialize () public initializer {
        //Set Tracker
        _setTargetContract(repo().addressGetOf(address(_HUB), "SBT"));
        //Init Protocol Entity (Set Hub)
        __ProtocolEntity_init(msg.sender);
        //Remember Deployer's SBT
        _deployerSBT = getExtTokenId(tx.origin);
    }

    /// Owned by Original 
    function owner() public view override returns (address) {
        return _getAccount(_deployerSBT);
    }

    function mint(
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public onlyOwner {
        _mint(to, id, value, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, values, data);
    }

    function burn(
        address owner,
        uint256 id,
        uint256 value
    ) public onlyOwner {
        _burn(owner, id, value);
    }

    function burnBatch(
        address owner,
        uint256[] memory ids,
        uint256[] memory values
    ) public onlyOwner {
        _burnBatch(owner, ids, values);
    }
}
