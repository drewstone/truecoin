pragma solidity ^0.4.10;

import '../math/DSMath.sol';
import '../math/ArrayMath.sol';
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

	function scoreTask(bytes32 taskId, address participant) returns (uint128) {
		uint referenceAgentIndex;
		uint[] memory participantDistinctTasks;
		uint[] memory referenceDistinctTasks;
		(referenceAgentIndex, participantDistinctTasks, referenceDistinctTasks) = getNonOverlappingTasks(taskId, participant);
		participantAgentIndex = mechanism.getParticipantIndex(taskId, participant);
		address referenceAgent = mechanism.participants[referenceAgentIndex];

		uint participantBinaryPred;
		uint referenceBinaryPred;

		// Get binary predictions based on array index in task's participants
		for (uint i = 0; i < mechanism.participantIndex[taskId]; i++) {
			if (mechanism.participantIndex[taskId][i] == referenceAgentIndex) {
				referenceBinaryPred = mechanism.binaryPreds[taskId][i];
			} else if (mechanism.participantIndex[taskid][i] == participantAgentIndex) {
				participantBinaryPred = mechanism.binaryPreds[taskId][i];
			}
		}

		uint[] memory participantDistinctBinaryPreds = mechanism.getBinaryPreds(participant, participantDistinctTasks);
		uint[] memory referenceDistinctBinaryPreds = mechanism.getBinaryPreds(referenceAgent, referenceDistinctTasks);

		uint128 scoreA = uint128(1 ether * (participantBinaryPred * referenceBinaryPred - (1 - participantBinaryPred) * (1 - referenceBinaryPred));
		uint128 scoreB = uint128(1 ether * )
		return 0;
	}

	function getNonOverlappingTasks(bytes32 taskId, address participant) internal returns (uint, uint[], uint[]) {
		uint[] memory participantIndices = mechanism.participantIndex[taskId];
		uint[] memory participantTasks = mechanism.answeredTaskIndex[participant];

		uint referenceAgentIndex;
		uint[] memory participantDistinctTasks;
		uint[] memory referenceDistinctTasks;

		// Iterate over participants that have answered the same task and get non-overlapping tasks
		for (uint j = 0; j < participantIndices.length; j++) {
			if (mechanism.participants[participantIndices[j]] != participant) {
				address referenceAgent = mechanism.participants[participantIndices[j]];
				uint[] memory referenceAgTasks = mechanism.answeredTaskIndex[referenceAgent];
				(participantDistinctTasks, referenceDistinctTasks) = ArrayMath.getDistinctElements(participantTasks, referenceAgTasks);

				if (participantDistinctTasks.length > 0) {
					referenceAgentIndex = participantIndices[j];
					break;
				}
			}
		}

		require(participantDistinctTasks.length > 0);
		return (referenceAgentIndex, participantDistinctTasks, referenceDistinctTasks);
	}

	function info() returns (address[], bytes32[], uint8[], uint256) {
		return mechanism.info();
	}
}
