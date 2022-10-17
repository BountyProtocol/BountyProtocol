// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (governance/utils/Votes.sol)
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CheckpointsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./interfaces/IVotesRepo.sol";

/**
 * @title Votes Repository
 * @dev Retains Voting Power History for other Contracts
 * @dev Based on VotesUpgradeable  https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/v4.7.0/contracts/governance/utils/VotesUpgradeable.sol
 * Version 1.0.0
 */
contract VotesRepoUpgradable is IVotesRepo, Initializable, ContextUpgradeable, EIP712Upgradeable {
    //** Implementation

    //Track Voting Units
    mapping(address => mapping(address => uint256)) internal _votingUnits;

    /// Expose Voting Power Transfer Method
    /// @dev Run this on the consumer contract. On _afterTokenTransfer()
    function transferVotingUnits(
        address from,
        address to,
        uint256 amount
    ) external override {
        _transferVotingUnits(from, to, amount);
    }

    /**
     * @dev Returns the balance of `account`.
     */
    function _getVotingUnits(address account) internal view returns (uint256) {
        return _votingUnits[msg.sender][account];
    }

    //** Core

    using CheckpointsUpgradeable for CheckpointsUpgradeable.History;
    using CountersUpgradeable for CountersUpgradeable.Counter;

    bytes32 private constant _DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    // mapping(address => address) private _delegation;
    mapping(address => mapping(address => address)) private _delegation;

    // mapping(address => CheckpointsUpgradeable.History) private _delegateCheckpoints;
    mapping(address => mapping(address => CheckpointsUpgradeable.History)) private _delegateCheckpoints;

    // CheckpointsUpgradeable.History private _totalCheckpoints;
    mapping(address => CheckpointsUpgradeable.History) private _totalCheckpoints;

    // mapping(address => CountersUpgradeable.Counter) private _nonces;
    mapping(address => mapping(address => CountersUpgradeable.Counter)) private _nonces;

    /**
     * @dev Returns the current amount of votes that `account` has.
     */
    function getVotes(address account) public view override returns (uint256) {
        console.log("[DEBUG] getVotes() STARTED", account);
        return _delegateCheckpoints[msg.sender][account].latest();
    }

    /**
     * @dev Returns the amount of votes that `account` had at the end of a past block (`blockNumber`).
     *
     * Requirements:
     *
     * - `blockNumber` must have been already mined
     */
    function getPastVotes(address account, uint256 blockNumber) public view override returns (uint256) {
        return _delegateCheckpoints[msg.sender][account].getAtBlock(blockNumber);
    }

    /**
     * @dev Returns the total supply of votes available at the end of a past block (`blockNumber`).
     *
     * NOTE: This value is the sum of all available votes, which is not necessarily the sum of all delegated votes.
     * Votes that have not been delegated are still part of total supply, even though they would not participate in a
     * vote.
     *
     * Requirements:
     *
     * - `blockNumber` must have been already mined
     */
    function getPastTotalSupply(uint256 blockNumber) public view override returns (uint256) {
        require(blockNumber < block.number, "VotesRepo: block not yet mined");
        return _totalCheckpoints[msg.sender].getAtBlock(blockNumber);
    }

    /**
     * @dev Returns the current total supply of votes.
     */
    function _getTotalSupply() internal view returns (uint256) {
        return _totalCheckpoints[msg.sender].latest();
    }

    /**
     * @dev Returns the delegate that `account` has chosen.
     */
    function delegates(address account) public view override returns (address) {
        return _delegation[msg.sender][account];
    }

    /** MEANINGLESS HERE
     * @dev Delegates votes from the sender to `delegatee`.
     * /
    function delegate(address delegatee) public override {
        address account = _msgSender();
        _delegate(account, delegatee);
    }

    /**
     * @dev Delegates votes from the sender to `delegatee`.
     */
    function delegateFrom(address from, address to) external override {
        _delegate(from, to);
    }

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
    ) public override {
        require(block.timestamp <= expiry, "VotesRepo: signature expired");
        address signer = ECDSAUpgradeable.recover(
            _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
            v,
            r,
            s
        );
        require(nonce == _useNonce(signer), "VotesRepo: invalid nonce");
        _delegate(signer, delegatee);
    }

    /**
     * @dev Delegate all of `account`'s voting units to `delegatee`.
     *
     * Emits events {DelegateChanged} and {DelegateVotesChanged}.
     */
    function _delegate(address account, address delegatee) internal {
        address oldDelegate = delegates(account);
        _delegation[msg.sender][account] = delegatee;

        emit DelegateChanged(account, oldDelegate, delegatee);
        _moveDelegateVotes(oldDelegate, delegatee, _getVotingUnits(account));
    }

    /**
     * @dev Transfers, mints, or burns voting units. To register a mint, `from` should be zero. To register a burn, `to`
     * should be zero. Total supply of voting units will be adjusted with mints and burns.
     */
    function _transferVotingUnits(
        address from,
        address to,
        uint256 amount
    ) internal {
        if (from == address(0)) {
            _totalCheckpoints[msg.sender].push(_add, amount);
        }
        if (to == address(0)) {
            _totalCheckpoints[msg.sender].push(_subtract, amount);
        }
        _moveDelegateVotes(delegates(from), delegates(to), amount);
    }

    /**
     * @dev Moves delegated votes from one delegate to another.
     */
    function _moveDelegateVotes(
        address from,
        address to,
        uint256 amount
    ) private {
        if (from != to && amount > 0) {
            if (from != address(0)) {
                (uint256 oldValue, uint256 newValue) = _delegateCheckpoints[msg.sender][from].push(_subtract, amount);
                emit DelegateVotesChanged(from, oldValue, newValue);
            }
            if (to != address(0)) {
                (uint256 oldValue, uint256 newValue) = _delegateCheckpoints[msg.sender][to].push(_add, amount);
                emit DelegateVotesChanged(to, oldValue, newValue);
            }
        }
    }

    function _add(uint256 a, uint256 b) private pure returns (uint256) {
        return a + b;
    }

    function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Consumes a nonce.
     *
     * Returns the current value and increments nonce.
     */
    function _useNonce(address owner) internal returns (uint256 current) {
        CountersUpgradeable.Counter storage nonce = _nonces[msg.sender][owner];
        current = nonce.current();
        nonce.increment();
    }

    /**
     * @dev Returns an address nonce.
     */
    function nonces(address owner) public view returns (uint256) {
        return _nonces[msg.sender][owner].current();
    }

    /**
     * @dev Returns the contract's {EIP712} domain separator.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32) {
        return _domainSeparatorV4();
    }

    /** MOVED
     * @dev Must return the voting units held by an account.
     * /
    function _getVotingUnits(address) internal view returns (uint256);

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[46] private __gap;
}
