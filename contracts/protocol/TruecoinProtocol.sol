pragma solidity ^0.4.10;

import './MechanismManager.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {
	MechanismManager public m;

	event Initialized(address mechanismManager);
	event Creation(address manager, uint8 mechanismId, bytes32 name, bytes32[] taskIds);
	event Submission(address manager, bytes32 taskId, uint128 i, uint128 p);
	event Score(address manager, address participant, bytes32 name, uint128 score);

	function TruecoinProtocol() {
	}

	function initProtocol() {
		m = new MechanismManager();
		Initialized(m);
	}

	function createNewMechanism(uint8 mechanismId, uint8[] events, bytes32 name, bytes32[] taskIds) returns (bool) {
		Creation(msg.sender, mechanismId, name, taskIds);
		return m.create(msg.sender, mechanismId, events, name, taskIds);
	}

	function submitPrediction(address manager, uint8 mechanismId, bytes32 name, bytes32 taskId, uint128 i, uint128 p) returns (bool) {
		Submission(manager, taskId, i, p);
		return m.submit(manager, mechanismId, name, taskId, i, p, msg.sender);
	}

	function claimScore(address manager, uint8 mechanismId, bytes32 name) returns (bool) {
		uint128 score = m.score(manager, mechanismId, name, msg.sender);
		Score(manager, msg.sender, name, score);
	}

	function determineMintedTokens(uint128 score) constant returns (uint256) {
		return uint256(score);
	}

	function getMechanism(address manager, uint8 mechanismId, bytes32 name) constant returns (address) {
		return m.get(manager, mechanismId, name);
	}
}
