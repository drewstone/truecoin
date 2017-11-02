pragma solidity ^0.4.10;

import '../math/MathLib.sol';
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

	function score(address participant) returns (uint128) {
		return 0;
	}

	function scoreTask(bytes32 taskId, address participant) returns (uint128) {
		uint participantAgentIndex = mechanism.getParticipantIndex(taskId, participant);
		require(participantAgentIndex != 999999999);
		require(!mechanism.scored[taskId][participantAgentIndex]);
		mechanism.scored[taskId][participantAgentIndex] = true;

		uint referenceAgentIndex;
		uint[] memory participantDistinctTasks;
		uint[] memory referenceDistinctTasks;

		(referenceAgentIndex, participantDistinctTasks, referenceDistinctTasks) = getNonOverlappingTasks(taskId, participant);
		address referenceAgent = mechanism.participants[referenceAgentIndex];

		uint participantBinaryPred;
		uint referenceBinaryPred;

		// Get binary predictions based on array index in task's participants
		for (uint i = 0; i < mechanism.participantIndex[taskId]; i++) {
			if (mechanism.participantIndex[taskId][i] == referenceAgentIndex) {
				referenceBinaryPred = mechanism.binaryPreds[taskId][i];
			} else if (mechanism.participantIndex[taskId][i] == participantAgentIndex) {
				participantBinaryPred = mechanism.binaryPreds[taskId][i];
			}
		}

		uint[] memory participantDistinctBinaryPreds = mechanism.getBinaryPreds(participant, participantDistinctTasks);
		uint[] memory referenceDistinctBinaryPreds = mechanism.getBinaryPreds(referenceAgent, referenceDistinctTasks);

		uint128 scoreA = scoreAij(participantBinaryPred, referenceBinaryPred);
		uint128 scoreB = scoreBij(participantDistinctBinaryPreds, referenceDistinctBinaryPreds);
		return MathLib.wsub(scoreA, scoreB);
		
	}

	function scoreAij(uint p, uint r) internal constant returns (uint128) {
		require((p == 0 || p == 1) && (r == 0 || r == 1));
		uint first = p * r;
		uint second = (1 - p) * (1 - r);
		uint score = 1 ether * (first + second);
		return MathLib.cast(score);
	}

	function scoreBij(uint[] ps, uint[] rs) internal constant returns (uint128) {
		require(ps.length == rs.length);

		uint d = ps.length * 1 ether;
		uint first = MathLib.wdiv(MathLib.sum(ps) * 1 ether, d);
		uint second = MathLib.wdiv(MathLib.sum(rs) * 1 ether, d);
		uint128 left = MathLib.wmul(first, second);
		uint128 right = MathLib.wmul(MathLib.wsub(1 ether, first), MathLib.wsub(1 ether, second));
		return MathLib.wadd(left, right);
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
				(participantDistinctTasks, referenceDistinctTasks) = MathLib.getDistinctElements(participantTasks, referenceAgTasks);

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
