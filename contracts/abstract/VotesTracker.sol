// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "hardhat/console.sol";

// import "@openzeppelin/contracts/governance/utils/IVotes.sol";
import "@openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol";
import "../repositories/interfaces/IVotesRepoTracker.sol";

/**
 * Add this to an ERC1155Tracker abstract contract that adds Votes capabilities via the CaaS:VotesRepo
 * 
 * @dev the inhereting contract must call 
 *  IVotesRepoTracker().transferVotingUnits(fromSBT, toSBT, amount) to register any power changes
 * voting power change logic is up to the implementing contract
 *
 * 
 * @dev This is a base abstract contract that tracks voting units, which are a measure of voting power that can be
 * transferred, and provides a system of vote delegation, where an account can delegate its voting units to a sort of
 * "representative" that will pool delegated voting units from different accounts and can then use it to vote in
 * decisions. In fact, voting units _must_ be delegated in order to count as actual votes, and an account has to
 * delegate those votes to itself if it wishes to participate in decisions and does not have a trusted representative.
 *
 * This contract is often combined with a token contract such that voting units correspond to token units. For an
 * example, see {ERC721Votes}.
 *
 * The full history of delegate votes is tracked on-chain so that governance protocols can consider votes as distributed
 * at a particular block number to protect against flash loans and double voting. The opt-in delegate system makes the
 * cost of this history tracking optional.
 *
 * When using this module the derived contract must implement {_getVotingUnits} (for example, make it return
 * {ERC721-balanceOf}), and can use {_transferVotingUnits} to track a change in the distribution of those units (in the
 * previous example, it would be included in {ERC721-_beforeTokenTransfer}).
 *
 */
abstract contract VotesTracker is IVotesUpgradeable {

    /// Get the Votes Repo
    /// @dev Implementing contract must override this!
    function _votesRepo() internal view virtual returns (IVotesRepoTracker) {
        revert("Must override _votesRepo()");
    }

    /* From ERC721Votes

    /**
     * 
     * /
    function _afterTokenTransferTracker(
        address operator, 
        uint256 fromSBT, 
        uint256 toSBT, 
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        // super._afterTokenTransferTracker(
        //     operator, 
        //     fromSBT, 
        //     toSBT, 
        //     ids,
        //     amounts,
        //     data
        // );

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            if(id == _votingToken){
                uint256 amount = amounts[i];

                // _transferVotingUnits(from, to, 1);

                //Run this on power changes
                _votesRepo().transferVotingUnits(fromSBT, toSBT, amount);

            }
        }
    }

    /** DOESN'T REALLY NEED THIS...
     * @dev Returns the balance of `account`.
     * /
    function _getVotingUnits(address account) internal view virtual override returns (uint256) {
        // return balanceOf(account);
        uint256 sbt = ?
        _votesRepo().getVotingUnits(sbt);
    }
    */



    //-- IVotes INTERFACE https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/governance/utils/IVotes.sol
    
    /// Get Current Power
    /// @dev Returns the current amount of votes that `account` has.
    function getVotes(address account) external view override returns (uint256) {
        return _votesRepo().getVotes(account);
    }
    
    /// Get Past Power
    function getPastVotes(address account, uint256 blockNumber) public view virtual override returns (uint256) {
        return _votesRepo().getPastVotes(account, blockNumber);
    }

    /**
     * @dev Returns the total supply of votes available at the end of a past block (`blockNumber`).
     *
     * NOTE: This value is the sum of all available votes, which is not necessarily the sum of all delegated votes.
     * Votes that have not been delegated are still part of total supply, even though they would not participate in a
     * vote.
     */
    function getPastTotalSupply(uint256 blockNumber) public view virtual override returns (uint256) {
        return _votesRepo().getPastTotalSupply(blockNumber);
    }

    /**
     * @dev Returns the delegate that `account` has chosen.
     */
    function delegates(address account) public view virtual override returns (address) {
        return _votesRepo().delegates(account);
    }
    
    /**
     * @dev Delegates votes from the sender to `delegatee`.
     */
    function delegate(address delegatee) public virtual override {
        _votesRepo().delegateFrom(msg.sender, delegatee);
    }
    // function delegateToToken(uint256 delegateeSBT) public virtual override {
    //      uint256 fromSBT = getCurrentSBT();
    //     _votesRepo().delegateFrom(fromSBT, delegateeSBT);
    // }

    /**
     * @dev Delegates votes from signer to `delegatee`.
     */
    function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) public virtual override {
        _votesRepo().delegateBySig(delegatee, nonce, expiry, v, r, s);
    }

}