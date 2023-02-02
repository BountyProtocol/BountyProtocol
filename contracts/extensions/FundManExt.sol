// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./interfaces/IFundManExt.sol";
import "../abstract/GameExtension.sol";
import "../abstract/Escrow.sol";
import "../interfaces/ICTXEntityUpgradable.sol";

/**
 * @title Game Extension: Escrow Capabilities (Receive and Send funds)
 * This extension allows a game to send funds
 */
contract FundManExt is IFundManExt, GameExtension, Escrow {

    /// Disburse Token to SBT Holders
    function _disburse(address token, uint256 amount) internal {
        //Validate Amount
        require(amount > 0, "NOTHING_TO_DISBURSE");
        //Get Subject(s)
        uint256[] memory sbts = gameRoles().uniqueRoleMembers("subject");
        //Send Funds
        for (uint256 i = 0; i < sbts.length; i++) {
            if(token == address(0)){
                //Disburse Native Token
                _release(payable(IERC721(getSoulAddr()).ownerOf(sbts[i])), amount);
            }else{
                //Disburse ERC20 Token
                _releaseToken(token, IERC721(getSoulAddr()).ownerOf(sbts[i]), amount);
            }
        }
    }

    /// Initiate a transfer from the account
    function sendFunds(address payable to, uint256 amount) external AdminOnly {
        Address.sendValue(to, amount);
    }

    /// Initiate a transfer from the account
    function sendFundsERC20(address token, address to, uint256 amount) external AdminOnly {
        SafeERC20.safeTransfer(IERC20(token), to, amount);
    }

    /// Deposit Native Token
    function deposit() external payable {
        require(msg.value > 0, "NO_FUNDS_SENT");
        emit PaymentReceived(_msgSender(), msg.value);
        uint256 ratio = 100;
        uint256 reward = msg.value*ratio;
        //Reward
        _reward(_msgSender(), reward);
    }

    /// Reward with contribution tokens
    function _reward(address to, uint256 amount) private {
        ICTXEntityUpgradable(address(this)).roleAssign(to, "contributor", amount);
    }

}