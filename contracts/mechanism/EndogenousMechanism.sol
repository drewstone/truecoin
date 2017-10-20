pragma solidity ^0.4.10;

import '../math/DSMath.sol';
import './MechanismLib.sol';

contract EndogenousMechanism {	
	using MechanismLib for MechanismLib.M;
	MechanismLib.M mechanism;
	
	address public manager;
	address public designer;
	mapping (bytes32 => uint) participantCount;

	function EndogenousMechanism(address mechanismDesigner, uint8[] events, bytes32[] taskIds) {
		manager = msg.sender;
		designer = mechanismDesigner;
		mechanism.init(events, taskIds);
	}

	function submit(bytes32 taskId, uint128 signal, uint128 posterior, address participant) {
		mechanism.submit(taskId, signal, posterior, participant);
	}

	function score(bytes32 taskId, address participant) returns (uint128) {
		return 0;
	}

	function getOverlappingSets(bytes32 taskId, address participant) internal returns (bytes32[]) {
		uint i = mechanism.getParticipantIndex(taskId, participant);
		require(i != 999999999);

		uint128 j = uint128((i+1) % mechanism.participants.length);
		address referenceAgent = mechanism.participants[j];

		uint[] memory participantTasks = mechanism.answeredTaskIndex[participant];
		uint[] memory referenceAgTasks = mechanism.answeredTaskIndex[referenceAgent];


	}

	function info() returns (address[], bytes32[], uint8[], uint256) {
		return mechanism.info();
	}
}
