// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "hardhat/console.sol";

import "../abstract/GameExtension.sol";
import "../interfaces/IActionRepo.sol";
// import "../interfaces/IClaim.sol";
// import "../interfaces/ITask.sol";
import "../libraries/Utils.sol";
// import "../libraries/DataTypes.sol";

/** [WIP]
 * @title Game Extension: Action
 * This extension allows a Game to run Actions (from ActionRepo)
 */
contract ActionExt is GameExtension {

    struct RoleMap {
        string role;
        address addr;
    }
    struct IntMap {
        string role;
        uint256 value;
    }
    struct StrMap {
        string role;
        string value;
    }

    /// Get Action Repo Address
    function getActionRepoAddr() internal view returns (address) {
        return dataRepo().addressGetOf(getHubAddress(), "action");
    }

    function test() public pure returns(string memory){
        return "WORKS";
    }


    /// Test Permissions Test
    function testPermissions(uint256 ruleRefId) public view returns(bool) {
        return validatePermissions(ruleRefId, "everyone", "post", "comment", "");
        // return validatePermissions(ruleRefId, "admin", "post", "announcement", "");
    }

    /// Check Permission Triple [TEST]
    function validatePermissions(uint256 ruleRefId, string memory subject, string memory verb, string memory object, string memory tool) public view returns (bool) {
        DataTypes.Rule memory rule = rules().ruleGet(ruleRefId);
        DataTypes.SVO memory action = actionRepo().actionGet(rule.about);
        //Match action
        require(
            Utils.stringMatch(action.subject, subject)
            && Utils.stringMatch(action.verb, verb)
            && Utils.stringMatch(action.object, object)
            && Utils.stringMatch(action.tool, tool)
            , "ActionExt:RULE_MISMATCH"
        );
        
        //Validate Subject's Role
        /// @dev user does not hold the claimed role
        require(Utils.stringMatch(subject, "everyone") || gameRoles().roleHas(_msgSender(), subject), 
            "ActionExt:ROLE_MISMATCH");

        return !rule.negation;
    }

    /// Run Custom Action
    function runActionData(bytes32 actionGUID, bytes memory data) external {
        //Fetch Action
        address actionRepoAddr = getActionRepoAddr();
        console.log("** [WIP] actionRepoAddr", actionRepoAddr);
        if(actionRepoAddr != address(0)){
            // DataTypes.SVO memory action;
            // action = IActionRepo(actionRepoAddr).actionGet(actionGUID);
            // (string memory subject, string memory object, string memory verb, string memory tool) 
            //     = IActionRepo(actionRepoAddr).actionGetStr(actionGUID);
            // console.log("** Action T,V -- ", subject, object);
   
            try IActionRepo(actionRepoAddr).actionGet(actionGUID) returns (DataTypes.SVO memory action) {
                console.log("** [WIP] Action T,V", action.tool, action.verb);
                if(Utils.stringMatch(action.tool, "soul")){
                    if(Utils.stringMatch(action.verb, "rate")){
                        //Update Soul's Opinion (Reputation)
                        address targetContract = getSoulAddr();
                        console.log("** [WIP] action targetContract", targetContract);
                        (uint256 targetTokenId, string memory domain, int256 value) = abi.decode(
                            data,
                            (uint256, string, int256)
                        );
                        console.log("** [WIP] action decoded params", targetTokenId, domain);
                        try ISoul(getSoulAddr()).opinionAboutToken(targetContract, targetTokenId, domain, value) {
                            console.log("[WIP] Rep Changed", targetContract, targetTokenId);
                        }   //Failure should not be fatal
                        catch Error(string memory reason) {
                            revert(reason);
                        }
                    }
                }
            } catch Error(string memory reason) {
                revert(reason);
            }

        }
    }

    /**
     * https://github.com/makerdao/multicall/blob/master/src/Multicall.sol
     * https://github.com/makerdao/multicall/blob/master/src/Multicall2.sol
     * Structure Call: https://github.com/safe-global/safe-contracts/blob/da66b45ec87d2fb6da7dfd837b29eacdb9a604c5/src/utils/execution.ts
     */
    /// Run Custom Action
    function runActionXX(
        bytes32 actionGUID, 
        RoleMap[] memory roleMap, 
        IntMap[] memory intMap,
        StrMap[] memory strMap
    ) external {
        console.log("** runActionXX() STARTED");
        //Fetch Action
        address actionRepoAddr = getActionRepoAddr();
        console.log("** actionRepoAddr", actionRepoAddr);
        if(actionRepoAddr != address(0)){
            DataTypes.SVO memory action = IActionRepo(actionRepoAddr).actionGet(actionGUID);
            // Utils.stringMatch(action.tool, "") || 
            if(Utils.stringMatch(action.tool, "game")){
                //Self Functions
            } 
            else if(Utils.stringMatch(action.tool, "hub")){
                //Hub Functions
            }
            else if(Utils.stringMatch(action.tool, "soul")){
                if(Utils.stringMatch(action.verb, "rate")){
                    //Update Soul's Opinion (Reputation)
                    // address targetContract = getAddr("", roleMap);
                    address targetContract = getSoulAddr();
                    console.log("** action targetContract", targetContract);

                    uint256 targetTokenId = getInt("object", intMap);
                    console.log("action object (targetTokenId)", targetTokenId);

                    string memory domain = getStr("domain", strMap);
                    console.log("action domain", domain);
                    
                    string memory direction = getStr("direction", strMap);
                    console.log("action direction", direction);
                    
                    uint256 amount = getInt("value", intMap);
                    console.log("action amount", amount);
                    int256 value;
                    // value = Utils.stringMatch(direction, "negative") ? int256(amount) : amount;
                    if(Utils.stringMatch(direction, "negative")) value = -int256(amount);
                    else value = int256(amount);
                     
                    // console.log("action value", value);

                    try ISoul(getSoulAddr()).opinionAboutToken(targetContract, targetTokenId, domain, value) {}   //Failure should not be fatal
                    catch Error(string memory) {}
                }
            }

        } //ActionRepo connected

        // address targetContract = '';
        // (bool success, bytes memory result) = address(this).delegatecall(data[i]);
        // bytes memory data = abi.encodeWithSignature(verb:"set(uint256)", params:_value)
        // address(tool:contract).call(data);

        //Defaults ? -- Internal affordances / data templates
        // Cover Function??
        // internalTransfer / pay / send(){
            //default: from:subject, to:target, amount:all
            // subject sent/paid/gave o:money to target (+amount)
        // }
        // internalRoleAdd/Assign()
        //      default: role:object, tokenId: subject, amount
        //      => subject assigned the role of object (+amount)
        //
            
    }

    mapping(bytes32 => bytes) internal availableActions;

//-- Getters
    function getAddr(string memory role, RoleMap[] memory roleMap) internal view returns (address) {
        for (uint256 i = 0; i < roleMap.length; ++i) {
            if(Utils.stringMatch(role, roleMap[i].role)) return roleMap[i].addr;
        }
    }

    function getInt(string memory role, IntMap[] memory intMap) internal view returns (uint256) {
        for (uint256 i = 0; i < intMap.length; ++i) {
            if(Utils.stringMatch(role, intMap[i].role)) return intMap[i].value;
        }
    }

    function getStr(string memory role, StrMap[] memory strMap) internal view returns (string memory) {
        for (uint256 i = 0; i < strMap.length; ++i) {
            if(Utils.stringMatch(role, strMap[i].role)) return strMap[i].value;
        }
    }

}