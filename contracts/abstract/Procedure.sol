//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

// import "hardhat/console.sol";

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "../interfaces/IProcedure.sol";
import "../interfaces/IGameUp.sol";
import "../libraries/DataTypes.sol";
import "../abstract/CTXEntityUpgradable.sol";
import "../abstract/Posts.sol";

/**
 * @title Procedure Basic Logic for Contracts 
 */
abstract contract Procedure is IProcedure, CTXEntityUpgradable, Posts {

    //-- Storage

    //Stage (Claim Lifecycle)
    DataTypes.ClaimStage public stage;

    // Contract name
    string public name;
    // Contract symbol
    string public symbol;

    //--- Modifiers

    /// Permissions Modifier
    modifier AdminOrOwnerOrCTX() {
       //Validate Permissions
        require(owner() == _msgSender()      //Owner
            || roleHas(_msgSender(), "admin")    //Admin Role
            || _msgSender() == getContainerAddr()
            , "INVALID_PERMISSIONS");

        _;
    }

    //-- Functions

    /// ERC165 - Supported Interfaces
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IProcedure).interfaceId || super.supportsInterface(interfaceId);
    }

    /* Maybe, When used more than once

    // function nextStage(string calldata uri) public {
        // if (sha3(myEnum) == sha3("Bar")) return MyEnum.Bar;
    // }

    /// Set Association
    function _assocSet(string memory key, address contractAddr) internal {
        dataRepo().addressSet(key, contractAddr);
    }

    /// Get Contract Association
    function assocGet(string memory key) public view override returns (address) {
        //Return address from the Repo
        return dataRepo().addressGet(key);
    }
    */

    /// Initializer
    function initialize(string memory name_) public virtual override initializer {
        //Initializers
        __ProtocolEntity_init(_msgSender()); //Sender is the Hub
        _setTargetContract(getSoulAddr()); //SBT
        //Identifiers
        name = name_;
        //Init Default Roles
        _roleCreate("admin");
        _roleCreate("creator");
        _roleCreate("subject");        //Acting Agent
        _roleCreate("authority");      //Deciding authority
    }
    /// Change Claim Stage
    function _setStage(DataTypes.ClaimStage stage_) internal {
        //Set Stage
        stage = stage_;
        //Stage Change Event
        emit Stage(stage);
    }

    /// Claim Stage: Reject Claim --> Cancelled
    function _stageCancel(string calldata uri_) internal {
        //Claim is now Closed
        _setStage(DataTypes.ClaimStage.Cancelled);
        //Cancellation Event
        emit Cancelled(uri_, _msgSender());
    }

    /// Execute Reaction
    function _execute() internal {

        //Validate Stage
        require(stage == DataTypes.ClaimStage.Execution , "STAGE:EXECUSION_ONLY");

        //Validate Stage Requirements
        // require(uniqueRoleMembersCount("subject") > 0 , "NO_WINNERS_PICKED");

        //Push to Stage:Closed
        _setStage(DataTypes.ClaimStage.Closed);
        
        //Get Reactions? 

        //Run Reactions
            // Disburse (function on self)
            // Execute Rules
                // IGame(getContainerAddr()).onClaimConfirmed(parentRuleId, getSoulAddr(), tokenId);
            //Execute Repository Action
                // Re-actionId
                // IGame(getContainerAddr()).runAction(actionId);

        //Emit Execusion Event
        // emit Executed(_msgSender());
    }
    
    /// Set Parent Container (Movable Components)
    function setParentCTX(address container) external override {
    	//Validate
	    require(
            owner() == _msgSender()      //Owner
            || roleHas(_msgSender(), "admin")    //Admin Role
            || _msgSender() == address(_HUB)   //Through the Hub
            , "INVALID_PERMISSIONS");
        _setParentCTX(container);
    }

    /// Set Parent Container
    function _setParentCTX(address container) internal {
        //Validate
        require(container != address(0), "Invalid Container Address");
        require(IERC165(container).supportsInterface(type(IGame).interfaceId), "Implementation Does Not Support Game Interface");  //Might Cause Problems on Interface Update. Keep disabled for now.
        //Set to OpenRepo
        dataRepo().addressSet("container", container);
    }

    /// Get Container Address
    function getContainerAddr() internal view returns (address) {
        return dataRepo().addressGet("container");
    }

    //** Role Management
    
    /// Create a new Role
    ///@dev override just to change the permissions mofidier
    function roleCreate(string memory role) external override AdminOrOwnerOrCTX {
        _roleCreate(role);
    }

    /// Create a new Role & Set URI
    ///@dev override just to change the permissions mofidier
    function roleMake(string memory role, string memory _tokenURI) external virtual override AdminOrOwnerOrCTX {
        _roleCreate(role);
        _setRoleURI(role, _tokenURI);
    }

    /// Assign to a Role
    function roleAssign(address account, string memory role, uint256 amount) public override roleExists(role) {
        //Special Validations for Special Roles 
        if(_msgSender() != address(_HUB)  && _msgSender() != owner() && _msgSender() != getContainerAddr()){
            if (Utils.stringMatch(role, "admin") || Utils.stringMatch(role, "authority")) {
                require(getContainerAddr() != address(0), "Unknown Parent Container");
                //Validate: Must Hold same role in Containing Game
                require(IERC1155RolesTracker(getContainerAddr()).roleHas(account, role), "User Required to hold same role in the Game context");
            }
            else{
                //Admin Role
                require(roleHas(_msgSender(), "admin"), "INVALID_PERMISSIONS");
            }
        }
        //Add
        _roleAssign(account, role, amount);
    }
    
    /// Assign Tethered Token to a Role
    function roleAssignToToken(uint256 ownerToken, string memory role, uint256 amount) public override AdminOrOwnerOrCTX {
        _roleAssignToToken(ownerToken, role, amount);
    }

    /* Identical to parent
    /// Remove Tethered Token from a Role
    function roleRemoveFromToken(uint256 ownerToken, string memory role, uint256 amount) public override roleExists(role) AdminOrOwner {
        _roleRemoveFromToken(ownerToken, role, amount);
    }
    */

    // function post(string entRole, string uri) 
    // - Post by account + role (in the claim, since an account may have multiple roles)

    // function post(uint256 token_id, string entRole, string uri) 
    //- Post by Entity (Token ID or a token identifier struct)
 
    /// Add Post 
    /// @param entRole  posting as entitiy in role (posting entity must be assigned to role)
    /// @param tokenId  Acting SBT Token ID
    /// @param uri_     post URI
    function post(string calldata entRole, uint256 tokenId, string calldata uri_) public override {
        //Validate that User Controls The Token
        require(ISoul(getSoulAddr()).hasTokenControlAccount(tokenId, _msgSender())
            || ISoul(getSoulAddr()).hasTokenControlAccount(tokenId, tx.origin)
            , "POST:SOUL_NOT_YOURS"); //Supports Contract Permissions
        //Validate: Soul Assigned to the Role 
        require(roleHasByToken(tokenId, entRole), "POST:ROLE_NOT_ASSIGNED");    //Validate the Calling Account
        //Validate Stage
        require(stage < DataTypes.ClaimStage.Closed, "STAGE:CLOSED");
        //Post Event
        _post(tx.origin, tokenId, entRole, uri_);
    }
}
    