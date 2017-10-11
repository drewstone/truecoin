pragma solidity ^0.4.10;

import './MechanismManager.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {
	address public mechMan;

	event Initialized(address mechanismManager);
	event MechanismCreation(address manager, uint8 mechanismId, bytes32 taskId);

	function TruecoinProtocol(uint totalSupply, uint startInterval) {
	}

	function initProtocol() {
		address mechMan = new MechanismManager();
		Initialized(mechMan);
	}

	function createNewMechanism(uint8 mechanismId, uint8[] events, bytes32 taskId, bytes32[] tasks) returns (bool) {
		MechanismManager m = MechanismManager(mechMan);
		MechanismCreation(msg.sender, mechanismId, taskId);
		return m.create(msg.sender, mechanismId, events, taskId, tasks);
	}

	function submitPrediction(address manager, uint8 mechanismId, bytes32 taskId, bytes32 task, uint128 i, uint128 p) returns (bool) {
		MechanismManager m = MechanismManager(mechMan);
		return m.submit(manager, mechanismId, taskId, task, i, p, msg.sender);
	}

	function determineMintedTokens(uint128 score) constant returns (uint256) {
		return uint256(score);
	}
}
