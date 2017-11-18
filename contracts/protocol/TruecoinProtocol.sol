pragma solidity ^0.4.10;

import './MechanismManager.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {
	address public owner;
	address public m;

	event Initialized(address mechanismManager);
	event Setting(address designer, uint8 mechanismId, bytes32 name, address mechContract);
	event Submission(address designer, address participant, bytes32 taskId, uint128[2] preds);
	event Score(address designer, address participant, bytes32 name, uint128 score);

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

	function submitPrediction(address designer, uint8 mechanismId, bytes32 name, bytes32 taskId, uint128 signal, uint128 posterior) {
		MechanismManager(m).submit(designer, mechanismId, name, taskId, signal, posterior, msg.sender);
		Submission(designer, msg.sender, taskId, [signal, posterior]);
	}

	function claimScore(address designer, uint8 mechanismId, bytes32 name) {
		uint128 score = MechanismManager(m).score(designer, mechanismId, name, msg.sender);
		Score(designer, msg.sender, name, score);
	}

	function claimScoreByTask(address designer, uint8 mechanismId, bytes32 name, bytes32 taskId) {
		uint128 score = MechanismManager(m).scoreTask(designer, mechanismId, name, taskId, msg.sender);
		Score(designer, msg.sender, name, score);
	}

	function determineMintedTokens(uint128 score) constant returns (uint256) {
		return uint256(score);
	}

	function getMechanism(address designer, uint8 mechanismId, bytes32 name) constant returns (address) {
		return MechanismManager(m).get(designer, mechanismId, name);
	}

	modifier isOwner() { 
		require(msg.sender == owner);
		_; 
	}
	
}
