//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

// import "hardhat/console.sol";

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
// import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./repositories/interfaces/IOpenRepo.sol";
import "./interfaces/IProtocolEntity.sol";
import "./interfaces/ICTXEntityUpgradable.sol";
import "./interfaces/IHub.sol";
import "./interfaces/IGameUp.sol";
import "./interfaces/IClaim.sol";
import "./interfaces/IProcedure.sol";
// import "./interfaces/ITask.sol";
import "./interfaces/ISoul.sol";
import "./interfaces/IRules.sol";
import "./libraries/DataTypes.sol";
import "./abstract/ContractBase.sol";
import "./abstract/AssocExt.sol";


/**
 * Hub Contract
 * - Hold Known Contract Addresses (Avatar, History)
 * - Contract Factory (Games & Claims)
 * - Remember Products (Games & Claims)
 */
contract HubUpgradable is 
        IHub 
        , Initializable
        , ContractBase
        , OwnableUpgradeable 
        , UUPSUpgradeable
        , AssocExt
        , ERC165Upgradeable
    {

    //---Storage

    // Arbitrary contract designation signature
    string public constant override role = "Hub";
    string public constant override symbol = "HUB";
    mapping(string => address) internal _beacons; // Mapping for Active Game Contracts
    mapping(address => bool) internal _games; // Mapping for Active Game Contracts
    mapping(address => address) internal _procedures; // Mapping for Claim Contracts  [G] => [R]


    //--- Modifiers

    /// Check if GUID Exists
    modifier activeGame() {
        //Validate Caller Permissions (Active Game)
        require(_games[_msgSender()], "UNAUTHORIZED: Valid Game Only");
        _;
    }

    //--- Functions
 
    /// ERC165 - Supported Interfaces
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IHub).interfaceId 
            || super.supportsInterface(interfaceId);
    }

    /// Initializer
    function initialize (
        address openRepo,
        address gameContract, 
        address claimContract,
        address taskContract
    ) public initializer {
        //Set Data Repo Address
        _setRepo(openRepo);
        //Initializers
        __Ownable_init();
        __UUPSUpgradeable_init();
        //Init Game Contract Beacon
        _beaconAdd("game", gameContract);
        //Init Claim Contract Beacon
        _beaconAdd("claim", claimContract);
        //Init Task Contract Beacon
        _beaconAdd("task", taskContract);
    }

    /// Upgrade Permissions
    function _authorizeUpgrade(address newImplementation) internal onlyOwner override { }

    /// @dev Returns the address of the current owner.
    function owner() public view override(IHub, OwnableUpgradeable) returns (address) {
        return OwnableUpgradeable.owner();
    }
    
    /// Update Hub
    function hubChange(address newHubAddr) external override onlyOwner {
        //Avatar
        address SBTAddress = repo().addressGet("SBT");
        if(SBTAddress != address(0)) {
            try IProtocolEntity(SBTAddress).setHub(newHubAddr) {}  //Failure should not be fatal
            catch Error(string memory /*reason*/) {}
        }
        //History
        address actionRepo = repo().addressGet("history");
        if(actionRepo != address(0)) {
            try IProtocolEntity(actionRepo).setHub(newHubAddr) {}   //Failure should not be fatal
            catch Error(string memory reason) {
                // console.log("Failed to update Hub for ActionRepo Contract", reason);
            }
        }
        //Emit Hub Change Event
        emit HubChanged(newHubAddr);
    }

    //-- Assoc

    /// Get Contract Association
    function assocGet(string memory key) public view override returns (address) {
        //Return address from the Repo
        return repo().addressGet(key);
    }

    /// Set Association
    function assocSet(string memory key, address contractAddr) external onlyOwner {
        repo().addressSet(key, contractAddr);
    }
    
    /// Add Association
    function assocAdd(string memory key, address contractAddr) external onlyOwner {
        repo().addressAdd(key, contractAddr);
    }

    /// Remove Association
    function assocRemove(string memory key, address contractAddr) external onlyOwner {
        repo().addressRemove(key, contractAddr);
    }

    //Repo Address
    function getRepoAddr() external view override returns (address) {
        return address(repo());
    }

    //--- Factory 

    /// Make a new Game
    function gameMake(
        string calldata type_, 
        string calldata name_, 
        string calldata uri_
    ) external override returns (address) {
        //Deploy
        BeaconProxy newProxyContract = new BeaconProxy(
            _beacons["game"],
            abi.encodeWithSelector(
                IGame( payable(address(0)) ).initialize.selector,
                type_,          //Game Type
                name_,          //Name
                uri_            //Contract URI
            )
        );
        //Register as a Soul
        _mintSoul(address(newProxyContract), uri_);
        //Event
        emit ContractCreated("game", address(newProxyContract));
        
        //Set Type (to be called after creating a Soul)
        ICTXEntityUpgradable(address(newProxyContract)).confSet("type", type_);
        ICTXEntityUpgradable(address(newProxyContract)).confSet("role", type_);

        //Remember
        _games[address(newProxyContract)] = true;
        //Register Game to Repo
        repo().addressAdd("game", address(newProxyContract));
        //Return
        return address(newProxyContract);
    }

    /// Make a new Claim
    function claimMake(
        string calldata type_, 
        string calldata name_, 
        string calldata uri_
    ) public override activeGame returns (address) {
        //Deploy
        BeaconProxy newProxyContract = new BeaconProxy(
            _beacons["claim"],
            abi.encodeWithSelector(
                IProcedure( payable(address(0)) ).initialize.selector,
                name_,          //Name
                uri_            //Contract URI
            )
        );
        //Register as a Soul
        _mintSoul(address(newProxyContract), uri_);
        //Event
        emit ContractCreated("process", address(newProxyContract));

        //Set Type (to be called after creating a Soul)
        ICTXEntityUpgradable(address(newProxyContract)).confSet("type", type_);
        ICTXEntityUpgradable(address(newProxyContract)).confSet("role", type_);
        //Set Container
        IProcedure(address(newProxyContract)).setParentCTX(_msgSender());
        
        //Remember Parent
        _procedures[address(newProxyContract)] = _msgSender();
        //Return
        return address(newProxyContract);
    }

    /// Make a new Task
    function taskMake(
        string calldata type_, 
        string calldata name_, 
        string calldata uri_ 
    ) public override activeGame returns (address) {
        //Deploy (Same as Claim)
        BeaconProxy newProxyContract = new BeaconProxy(
            _beacons["task"],
            abi.encodeWithSelector(
                IProcedure( payable(address(0)) ).initialize.selector,
                name_,          //Name
                uri_            //Contract URI
            )
        );
        //Register as a Soul
        _mintSoul(address(newProxyContract), uri_);
        //Event
        emit ContractCreated("process", address(newProxyContract));

        //Set Type (to be called after creating a Soul)
        ICTXEntityUpgradable(address(newProxyContract)).confSet("type", type_);
        ICTXEntityUpgradable(address(newProxyContract)).confSet("role", type_);
        //Set Container
        IProcedure(address(newProxyContract)).setParentCTX(_msgSender());
        
        //Remember Parent (Same as Claims)
        _procedures[address(newProxyContract)] = _msgSender();
        //Return
        return address(newProxyContract);
    }

    /// Make a new ERC1155Tracker
    function makeERC1155(string calldata uri_) public override returns (address) {
        //Deploy
        BeaconProxy newProxyContract = new BeaconProxy(
            _beacons["erc1155"],
            abi.encodeWithSignature("initialize()")
        );
        //Register as a Soul
        _mintSoul(address(newProxyContract), uri_);
        //Event
        emit ContractCreated("erc1155", address(newProxyContract));
        
        //Remember Parent (Same as Claims)
        _procedures[address(newProxyContract)] = _msgSender();
        
        //Return
        return address(newProxyContract);
    }

    //--- Reputation

    /// Add Reputation (Positive or Negative)
    function repAdd(address contractAddr, 
        uint256 tokenId, 
        string calldata domain, 
        bool rating, 
        uint8 amount
    ) public override activeGame {
        //Update SBT's Reputation
        address SBTAddress = repo().addressGet("SBT");
        if(SBTAddress != address(0) && SBTAddress == contractAddr) {
            _repAddAvatar(tokenId, domain, rating, amount);
        }
    }

    /// Add Repuation to SBT Token
    function _repAddAvatar(uint256 tokenId, string calldata domain, bool rating, uint8 amount) internal {
        address SBTAddress = repo().addressGet("SBT");
        try ISoul(SBTAddress).repAdd(tokenId, domain, rating, amount) {}   //Failure should not be fatal
        catch Error(string memory /*reason*/) {}
    }

    /// Mint an SBT for another account
    function mintForAccount(address account, string calldata tokenURI) external override activeGame returns (uint256) {
        // address SBTAddress = repo().addressGet("SBT");
        // uint256 sbt = ISoul(SBTAddress).tokenByAddress(account);
        // uint256 sbt = ISoul(SBTAddress).mintFor(account, tokenURI);
        uint256 sbt = _mintSoul(account, tokenURI);
        //Validate
        require(sbt != 0, "Failed to Mint Token");
        return sbt;
    }

    /// Mint a new SBT for Entity
    function _mintSoul(address account, string calldata uri_) internal returns (uint256) {
        //Register as a Soul
        try ISoul(repo().addressGet("SBT")).mintFor(account, uri_) 
        returns (uint256 sbt) {
            return sbt;
        }
        catch Error(string memory reason) { //Failure should not be fatal
            // console.log("Failed to mint a soul for the new Contract", reason);
            return 0;
        }
    }

    //--- Upgrades & Beacon Management
 
    /// Register a new upgradable beacon
    function beaconAdd(string memory name, address implementation) external onlyOwner override {
        _beaconAdd(name, implementation);
    }

    /// Register a new upgradable beacon
    function _beaconAdd(string memory name, address implementation) internal {
        //Validate
        require(_beacons[name] == address(0), "Beacon already exists");
        //Init Contract Beacon
        UpgradeableBeacon _beacon = new UpgradeableBeacon(implementation);
        //Save Address
        _beacons[name] = address(_beacon);
    }

    /// Generic ImplementationUpgrade
    function upgradeImplementation(string memory key, address newImplementation) public onlyOwner {
        //Upgrade Beacon
        UpgradeableBeacon(_beacons[key]).upgradeTo(newImplementation);
        //Upgrade Event
        emit UpdatedImplementation(key, newImplementation);
    }
}