//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

// import "hardhat/console.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "../interfaces/IProtocolEntity.sol";
import "../interfaces/IHub.sol";
import "../interfaces/ISoul.sol";
import "../libraries/DataTypes.sol";
import "../abstract/ContractBasePlacehodler.sol";
import "../repositories/interfaces/IOpenRepo.sol";
import "../libraries/Utils.sol";

/**
 * Common Protocol Functions
 */
abstract contract ProtocolEntityUpgradable is 
        IProtocolEntity, 
        ContractBase, //DEPRECATED - ContractURI would now point to SBT
        OwnableUpgradeable {
    
    //--- Storage

    // address internal _HUB;    //Hub Contract
    IHub internal _HUB;    //Hub Contract
    

    //--- Functions

    /// Initializer
    function __ProtocolEntity_init(address hub) internal onlyInitializing {
        //Set Protocol's Hub Address
        _setHub(hub);
    }

    /// Contract URI
    function contractURI() public view override returns (string memory) {
        //Run function on destination contract
        return ISoul(getSoulAddr()).accountURI(address(this));
    }

    /// Set Contract URI
    function _setContractURI(string calldata contract_uri) internal {
        uint256 tokenId = ISoul(getSoulAddr()).tokenByAddress(address(this));
        ISoul(getSoulAddr()).update(tokenId, contract_uri);
    }    

    /// Inherit owner from Protocol's Hub
    function owner() public view virtual override(IProtocolEntity, OwnableUpgradeable) returns (address) {
        return _HUB.owner();
    }

    /// Get Current Hub Contract Address
    function getHub() external view override returns (address) {
        return _getHub();
    }

    /// Set Hub Contract
    function _getHub() internal view returns (address) {
        return address(_HUB);
    }
    
    /// Change Hub (Move To a New Hub)
    function setHub(address hubAddr) external override {
        require(_msgSender() == address(_HUB), "HUB:UNAUTHORIZED_CALLER");
        _setHub(hubAddr);
    }

    /// Set Hub Contract
    function _setHub(address hubAddr) internal {
        //Validate Contract's Designation
        require(Utils.stringMatch(IHub(hubAddr).role(), "Hub"), "Invalid Hub Contract");
        //Set
        _HUB = IHub(hubAddr);
    }

    //** Data Repository 
    
    //Get Data Repo Address (From Hub)
    function getRepoAddr() public view override returns (address) {
        return _HUB.getRepoAddr();
    }

    //Get Assoc Repo
    function dataRepo() internal view returns (IOpenRepo) {
        return IOpenRepo(getRepoAddr());
    }

    /// Get Soul Contract Address
    function getSoulAddr() internal view returns (address) {
        return dataRepo().addressGetOf(address(_HUB), "SBT");
    }

    /// Generic Config Get Function
    // function confGet(string memory key) public view override returns (string memory) {
    //     return dataRepo().stringGet(key);
    // }

    /// Generic Config Set Function
    function _confSet(string memory key, string memory value) internal {
        dataRepo().stringSet(key, value);
    }

}
