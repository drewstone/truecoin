pragma solidity ^0.4.10;

import './MechanismManager.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {
	address public m;

	event Initialized(address mechanismManager);
	event Setting(address manager, uint8 mechanismId, bytes32 name, address mechContract);
	event Submission(address manager, address participant, bytes32 taskId, uint128[2] preds);
	event Score(address manager, address participant, bytes32 name, uint128 score);

	function TruecoinProtocol() {
	}

	function initProtocol(address mechanismManager) {
		m = mechanismManager;
		Initialized(m);
	}

	function setNewMechanism(uint8 mechanismId, bytes32 name, address mechContract) returns (bool) {
		Setting(msg.sender, mechanismId, name, mechContract);
		return MechanismManager(m).set(msg.sender, mechanismId, name, mechContract);
	}

	function submitPrediction(address manager, uint8 mechanismId, bytes32 name, bytes32 taskId, uint128 i, uint128 p) returns (bool) {
		Submission(manager, msg.sender, taskId, [i,p]);
		return MechanismManager(m).submit(manager, mechanismId, name, taskId, i, p, msg.sender);
	}

	function claimScore(address manager, uint8 mechanismId, bytes32 name) returns (bool) {
		uint128 score = MechanismManager(m).score(manager, mechanismId, name, msg.sender);
		Score(manager, msg.sender, name, score);
	}

	function claimScoreByTask(address manager, uint8 mechanismId, bytes32 taskId, bytes32 name) returns (uint128) {
		uint128 score = MechanismManager(m).scoreTask(manager, mechanismId, taskId, name, msg.sender);
		Score(manager, msg.sender, name, score);
	}

	function determineMintedTokens(uint128 score) constant returns (uint256) {
		return uint256(score);
	}

	function getMechanism(address manager, uint8 mechanismId, bytes32 name) constant returns (address) {
		return MechanismManager(m).get(manager, mechanismId, name);
	}
}
