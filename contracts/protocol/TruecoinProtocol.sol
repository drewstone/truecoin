pragma solidity ^0.4.10;

import './MechanismManager.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {
	MechanismManager public m;

	event Initialized(address mechanismManager);
	event Creation(address manager, uint8 mechanismId, bytes32 taskId);
	event Submission(address manager, bytes32 taskId, uint128 i, uint128 p);

	function TruecoinProtocol() {
	}

	function initProtocol() {
		m = new MechanismManager();
		Initialized(m);
	}

	function createNewMechanism(uint8 mechanismId, uint8[] events, bytes32 taskId, bytes32[] tasks) returns (bool) {
		Creation(msg.sender, mechanismId, taskId);
		return m.create(msg.sender, mechanismId, events, taskId, tasks);
	}

	function submitPrediction(address manager, uint8 mechanismId, bytes32 taskId, uint128 i, uint128 p) returns (bool) {
		Submission(manager, taskId, i, p);
		return m.submit(manager, mechanismId, taskId, i, p, msg.sender);
	}

	function determineMintedTokens(uint128 score) constant returns (uint256) {
		return uint256(score);
	}
}
