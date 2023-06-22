// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

interface IVotesRepoTracker {

    //--- Events

    /**
     * @dev Emitted when an account changes their delegate.
     */
    event DelegateChangedToken(uint256 indexed delegator, uint256 indexed fromDelegate, uint256 indexed toDelegate);

    /**
     * @dev Emitted when a token transfer or delegate change results in changes to a delegate's number of votes.
     */
    event DelegateVotesChangedToken(uint256 indexed delegate, uint256 previousBalance, uint256 newBalance);

    /**
     * @dev Emitted when an account changes their delegate.
     */
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);

    /**
     * @dev Emitted when a token transfer or delegate change results in changes to a delegate's number of votes.
     */
    event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);


    //--- Functions
    
    /// Expose Voting Power Transfer Method
    function transferVotingUnits(uint256 from, uint256 to, uint256 amount) external;

    /// Expose Target Contract
    function getTargetContract() external returns (address);
    

    /**
     * @dev Returns the current amount of votes that `account` has.
     */
    function getVotes(address account) external view returns (uint256);
    function getVotesForToken(uint256 sbt) external view returns (uint256);

    /**
     * @dev Returns the amount of votes that `account` had at the end of a past block (`blockNumber`).
     */
    function getPastVotes(address account, uint256 blockNumber) external view returns (uint256);
    function getPastVotesForToken(uint256 sbt, uint256 blockNumber) external view returns (uint256);

    /**
     * @dev Returns the total supply of votes available at the end of a past block (`blockNumber`).
     *
     * NOTE: This value is the sum of all available votes, which is not necessarily the sum of all delegated votes.
     * Votes that have not been delegated are still part of total supply, even though they would not participate in a
     * vote.
     */
    function getTotalSupply() external view returns (uint256);
    function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);

    /**
     * @dev Returns the delegate that `account` has chosen.
     */
    function delegates(address account) external view returns (address);
    function delegatesToken(uint256 sbt) external view returns (uint256);
    function delegatesTokenOf(address contractAddr, uint256 sbt) external view returns (uint256);

    /**
     * @dev Delegates votes from the sender to `delegatee`.
     */
    // function delegate(address delegatee) external;
    function delegateFrom(address from, address to) external;

    /**
     * @dev Delegates votes from signer to `delegatee`.
     */
    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}
