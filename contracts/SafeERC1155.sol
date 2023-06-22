// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "./interfaces/ISoulBonds.sol";
import "./abstract/ERC1155TrackerUpgradable.sol";
import "./abstract/ProtocolEntityUpgradable.sol";


/**
 * @title ERC1155Tracker
 * This mock just publicizes internal functions for testing purposes
 */
contract SafeERC1155 is ERC1155TrackerUpgradable,
    ProtocolEntityUpgradable {

    /// Initializer
    function initialize (string calldata uri_, address owner_) public initializer {
        //Init Protocol Entity (Set Hub)
        __ProtocolEntity_init(msg.sender);
        
        //Set Tracker's SBT Contract
        _setTargetContract(dataRepo().addressGetOf(address(_HUB), "SBT"));

        //Represent the Self
        ISoul(_targetContract).mint(uri_);

        //Attach to Deployer's SBT
       _setOwner(_getExtTokenIdOrMake(owner_));
    }

    /// Revert to original Owner function
    function _setOwner(uint256 ownerSBT) internal virtual {
        //Soul to Soul Connection (A:SBT1 r:owner b:SBT2)
        ISoulBonds(_targetContract).relSet("owner", ownerSBT);
    }

    /// Owned by Original 
    function owner() public view override returns (address) {
        uint256 ownerSBT = ISoulBonds(_targetContract).relGet("owner");
        return _getAccount(ownerSBT);
    }

    function mint(
        address to,
        uint256 id,
        uint256 value,
        string calldata uri //TODO: TBD TokenURI support
        // bytes memory data
    ) public onlyOwner {
        //Validate SBT
        _getExtTokenIdOrMake(to);
        //Mint
        _mint(to, id, value, "");
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
        address from,
        uint256 id,
        uint256 value
    ) public onlyOwner {
        _burn(from, id, value);
    }

    function burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory values
    ) public onlyOwner {
        _burnBatch(from, ids, values);
    }
}
