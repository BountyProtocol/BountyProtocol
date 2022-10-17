// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// import "hardhat/console.sol";

import "@openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol";
import "../repositories/interfaces/IVotesRepoTracker.sol";
import "../abstract/GameExtension.sol";

/** COPY OF VotesTracker.sol
 *
 * @title Game Extension: Votes supports
 * like Votes / VotesUpgradeable
 * 
 * Manged by Reputation
 * 
 * Rep[domain] -weight-> Voting power
 * 
 */
contract VotesExt is IVotesUpgradeable, GameExtension {

    /// Get the Votes Repo Address
    function votesRepoAddr() public view returns (address){
        return dataRepo().addressGetOf(address(getHubAddress()), "VOTES_REPO");
    }

    /// Get the Votes Repo
    function _votesRepo() internal view returns (IVotesRepoTracker) {
        return IVotesRepoTracker(votesRepoAddr());
    }

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

    /**
     * @dev Delegates votes from signer to `delegatee`.
     */
    function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) public virtual override {
        _votesRepo().delegateBySig(delegatee, nonce, expiry, v, r, s);
    }

}