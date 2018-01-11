pragma solidity ^0.4.10;

import './MechanismManager.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {
	address public owner;
	address public m;

	event Initialized(address mechanismManager);
	event Setting(
		address designer,
		uint8 mechanismId,
		bytes32 name,
		address mechContract,
		uint time);
	event Submission(
		address designer,
		address participant,
		bytes32 taskId,
		uint128[2] preds);
	event Score(
		address designer,
		address participant,
		bytes32 name,
		uint128 score);
	event Settlement(
		address designer,
		address caller,
		bytes32 name,
		address mechContract);
	

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

	function setNewMechanism(uint8 mechanismId, bytes32 name, address mechContract, uint256 timeLength) {
		MechanismManager(m).set(msg.sender, mechanismId, name, mechContract, timeLength);
		Setting(msg.sender, mechanismId, name, mechContract, timeLength);
	}

	function settleMechanism(uint8 mechanismId, bytes32 name, address mechContract) {
		MechanismManager(m).settle(msg.sender, mechanismId, name, mechContract);
		Settlement(msg.sender, mechanismId, name, mechContract);
	}

	function submitPrediction(address designer, uint8 mechanismId, bytes32 name, bytes32 taskId, uint128 signal, uint128 posterior) {
		MechanismManager(m).submit(designer, mechanismId, name, taskId, signal, posterior, msg.sender);
		Submission(designer, msg.sender, taskId, [signal, posterior]);
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
	
	/*
	 *	------------------------ VERSION 1 software - LEGACY functionality ------------------------
	 */

	function claimScore(address designer, uint8 mechanismId, bytes32 name) {
		uint128 score = MechanismManager(m).score(designer, mechanismId, name, msg.sender);
		Score(designer, msg.sender, name, score);
	}

	function claimScoreByTask(address designer, uint8 mechanismId, bytes32 name, bytes32 taskId) {
		uint128 score = MechanismManager(m).scoreTaskByParticipant(designer, mechanismId, name, taskId, msg.sender);
		Score(designer, msg.sender, name, score);
	}

	/*
	 * --------------------------------------------------------------------------------------------
	 */

}
