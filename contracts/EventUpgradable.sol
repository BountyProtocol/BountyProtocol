//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "./interfaces/ICTXEntityUpgradable.sol";
import "./abstract/ProtocolEntityUpgradable.sol";
import "./abstract/ERC1155TrackerUpgradable.sol";
// import "./libraries/DataTypes.sol";

/**
 * @title Event Entities
 * @dev Version 1.0.0
 *
 * [id:start_time] => Tickets/Participants
 * 
 */
abstract contract EventUpgradable is 
    ICTXEntityUpgradable,
    ProtocolEntityUpgradable,
    ERC1155TrackerUpgradable {

    //--- Modifiers

    // modifier AdminOnly() virtual {
    //    //Validate Permissions
    //     require(roleHas(_msgSender(), "admin"), "INVALID_PERMISSIONS");
    //     _;
    // }

    modifier AdminOrOwner() virtual {
       //Validate Permissions
        require(_isAdminOrOwner(), "INVALID_PERMISSIONS");
        _;
    }

    modifier AdminOrOwnerOrHub() {
       //Validate Permissions
        require(_isAdminOrOwner() || _msgSender() == address(_HUB), "INVALID_PERMISSIONS");
        _;
    }

    modifier HubOnly() virtual {
       //Validate - Only By Hub
        require(_msgSender() == address(_HUB), "UNAUTHORIZED_ACCESS");
        _;
    }

    //-- Functions

    /// [WORKAROUND] Check if current account is Admin or Owner
    function _isAdminOrOwner() internal view returns (bool) {
        return (owner() == _msgSender()      //Owner
            // || roleHas(_msgSender(), "admin")    //Admin Role
        );
    }

    /// ERC165 - Supported Interfaces
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(ICTXEntityUpgradable).interfaceId 
            || super.supportsInterface(interfaceId);
    }

    /// Request to Join
    // function nominate(uint256 soulToken, string memory uri_) public override {
    //     emit Nominate(_msgSender(), soulToken, uri_);
    // }

    //** Generic Config
    
    /// Generic Config Get Function
    function confGet(string memory key) public view override returns (string memory) {
        return dataRepo().stringGet(key);
    }
    
    /// Generic Config Set Function
    function confSet(string memory key, string memory value) public override AdminOrOwnerOrHub {
        _confSet(key, value);
    }

    /// Set Contract URI
    function setContractURI(string calldata contractUri) external override AdminOrOwner {
        //Set
        _setContractURI(contractUri);
    }

    //--- Event Functions

    //Token Metadata URI
    mapping(uint256 => string) internal _tokenURIs; //Token Metadata URI
    // mapping(bytes32 => uint256) internal _times; //Existing Tokens (event times)


    /// Create a new Role
    /// @param time Event Start Time
    function _eventCreate(uint256 time, string calldata uri) internal returns (uint256) {

        
        //Map GUID to Token ID
        // _GUID[guid] = tokenId;
        _setURI(time, uri);

        // _mint(to, id, amount, data);
        // _mintActual(to, toToken, id, amount, data);
        

        //Event
        // emit GUIDCreated(tokenId, guid);
        // emit RoleCreated(tokenId, role);
        // emit EventCreated(time);
        
        return time;
    }

    /// Set Token's Metadata URI
    function _setURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        _tokenURIs[tokenId] = _tokenURI;
        //URI Changed Event
        emit URI(_tokenURI, tokenId);
    }

    /// Get Metadata URI by GUID
    // function URI(uint256 tokenId) public view override returns (string memory) {
    //     return _tokenURIs[tokenId];
    // }

}