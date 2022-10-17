// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol";

/**
 * @title Votes Repository Interface
 * @dev Retains Voting Power History for other Contracts
 */
interface IVotesRepoTracker {
// interface IVotesRepoTracker is IVotesUpgradeable  {

    //--- Events

    /**
     * @dev Emitted when an account changes their delegate.
     */
    event DelegateChangedToken(uint256 indexed delegator, uint256 indexed fromDelegate, uint256 indexed toDelegate);

    /**
     * @dev Emitted when a token transfer or delegate change results in changes to a delegate's number of votes.
     */
    event DelegateVotesChangedToken(uint256 indexed delegate, int256 previousBalance, int256 newBalance);


    //--- Functions
    
    /// Expose Voting Power Transfer Method
    function transferVotingUnits(uint256 from, uint256 to, int256 amount) external;

    /// Expose Target SBT Contract
    function getTargetContract() external returns (address);

    //--- Traditional Functions

    function delegatesToken(uint256 accountToken) external view returns (uint256);

    function getVotesForToken(uint256 account) external view returns (int256);

    function getPastVotesForToken(uint256 account, uint256 blockNumber) external view returns (int256);

}
