pragma solidity ^0.4.10;

import '../token/Ownable.sol';
import './MechanismManager.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol is Ownable {
	address public owner;
	address public m;
	bool public initialized;

	event Initialized(address mechanismManager);
	event SettingUp(address designer, uint8 mechanismId, bytes32 taskName, address mechContract, uint time);
	event Submission(address designer, address participant, bytes32 taskId, uint128[2] preds);
	event Score(address designer, address participant, bytes32 taskName, uint128 score);
	event Settlement(address designer, address caller, bytes32 taskName, address mechContract);
	
	function TruecoinProtocol() {
		owner = msg.sender;
	}

	function initProtocol(address mechanismManagerAddress) onlyOwner {
		require(initialized == false);
		m = mechanismManagerAddress;
		Initialized(mechanismManagerAddress);
		initialized = true;
	}

	function destroyOwner() onlyOwner {
		owner = this;
	}

	function setNewMechanism(uint8 mechanismId, bytes32 taskName, address mechContract, uint256 timeLength) isInitialized {
		MechanismManager(m).setup(msg.sender, mechanismId, taskName, mechContract, timeLength);
		SettingUp(msg.sender, mechanismId, taskName, mechContract, timeLength);
	}

	function settleMechanism(uint8 mechanismId, bytes32 taskName, address mechContract) isInitialized {
		MechanismManager(m).settle(msg.sender, mechanismId, taskName, mechContract);
		Settlement(msg.sender, mechanismId, taskName, mechContract);
	}

	function submitPrediction(address designer, uint8 mechanismId, bytes32 taskName, bytes32 taskId, uint128 signal, uint128 posterior) isInitialized {
		MechanismManager(m).submit(designer, mechanismId, taskName, taskId, signal, posterior, msg.sender);
		Submission(designer, msg.sender, taskId, [signal, posterior]);
	}

	function determineMintedTokens(uint128 score) constant returns (uint256) {
		return uint256(score);
	}

	function getMechanism(address designer, uint8 mechanismId, bytes32 taskName) constant returns (address) {
		return MechanismManager(m).get(designer, mechanismId, taskName);
	}

	modifier isInitialized() { 
		require(initialized);
		_; 
	}
	
	/*
	 *	------------------------ VERSION 1 software - LEGACY functionality ------------------------
	 */

	function claimScore(address designer, uint8 mechanismId, bytes32 taskName) {
		uint128 score = MechanismManager(m).score(designer, mechanismId, taskName, msg.sender);
		Score(designer, msg.sender, taskName, score);
	}

	function claimScoreByTask(address designer, uint8 mechanismId, bytes32 taskName, bytes32 taskId) {
		uint128 score = MechanismManager(m).scoreQuestionByParticipant(designer, mechanismId, taskName, taskId, msg.sender);
		Score(designer, msg.sender, taskName, score);
	}

	/*
	 * --------------------------------------------------------------------------------------------
	 */

}
