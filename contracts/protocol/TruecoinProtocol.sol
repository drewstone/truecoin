pragma solidity ^0.4.10;

import './MechanismManager.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {
	address public owner;
	address public m;

	event Initialized(address mechanismManager);
	event Setting(address manager, uint8 mechanismId, bytes32 name, address mechContract);
	event Submission(address manager, address participant, bytes32 taskId, uint128[2] preds);
	event Score(address manager, address participant, bytes32 name, uint128 score);

	function TruecoinProtocol() {
		owner = msg.sender;
	}

	function initProtocol(address mechanismManager) isOwner {
		m = mechanismManager;
		Initialized(m);
	}

	function destroyOwner() isOwner {
		owner = address(0x0);
	}

	function setNewMechanism(uint8 mechanismId, bytes32 name, address mechContract) {
		MechanismManager(m).set(msg.sender, mechanismId, name, mechContract);
		Setting(msg.sender, mechanismId, name, mechContract);
	}

	function submitPrediction(address manager, uint8 mechanismId, bytes32 name, bytes32 taskId, uint128 signal, uint128 posterior) {
		MechanismManager(m).submit(manager, mechanismId, name, taskId, signal, posterior, msg.sender);
		Submission(manager, msg.sender, taskId, [signal, posterior]);
	}

	function claimScore(address manager, uint8 mechanismId, bytes32 name) {
		uint128 score = MechanismManager(m).score(manager, mechanismId, name, msg.sender);
		Score(manager, msg.sender, name, score);
	}

	function claimScoreByTask(address manager, uint8 mechanismId, bytes32 name, bytes32 taskId) {
		uint128 score = MechanismManager(m).scoreTask(manager, mechanismId, name, taskId, msg.sender);
		Score(manager, msg.sender, name, score);
	}

	function determineMintedTokens(uint128 score) constant returns (uint256) {
		return uint256(score);
	}

	function getMechanism(address manager, uint8 mechanismId, bytes32 name) constant returns (address) {
		return MechanismManager(m).get(manager, mechanismId, name);
	}

	modifier isOwner() { 
		require(msg.sender == owner);
		_; 
	}
	
}
