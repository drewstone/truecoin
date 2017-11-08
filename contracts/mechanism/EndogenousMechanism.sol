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
		uint[] memory taskIds = mechanism.answeredTaskIndex[participant];
		uint128 score;
		for (uint i = 0; i < taskIds.length; i++) {
			score = MathLib.wadd(score, scoreTask(mechanism.taskIds[taskIds[i]], participant));
		}
		
		return score;
	}

	function scoreTask(bytes32 taskId, address participant) returns (uint128) {
		require(mechanism.participantIndex[participant] != 0);

		// Return no payment if task was previously scored
		if (mechanism.scored[taskId][mechanism.participantIndex[participant]]) {
			return 0;
		}

		mechanism.scored[taskId][mechanism.participantIndex[participant]] = true;

		uint referenceAgentIndex;
		uint[] memory participantDistinctTasks;
		uint[] memory referenceDistinctTasks;

		// Iterate over participants that have answered the same task and get non-overlapping tasks
		for (uint i = 0; i < mechanism.taskParticipants[taskId].length; i++) {
			if (mechanism.participants[mechanism.taskParticipants[taskId][i]] != participant) {
				(participantDistinctTasks, referenceDistinctTasks) = MathLib.getDistinctElements(
					mechanism.answeredTaskIndex[participant],
					mechanism.answeredTaskIndex[mechanism.participants[mechanism.taskParticipants[taskId][i]]]
				);

				if (participantDistinctTasks.length > 0) {
					referenceAgentIndex = mechanism.taskParticipants[taskId][i];
					break;
				}
			}
		}

		return MathLib.wsub(
			scoreAij(
				mechanism.getBinaryPred(participant, mechanism.taskIndex[taskId]),
				mechanism.getBinaryPred(mechanism.participants[referenceAgentIndex], mechanism.taskIndex[taskId])
			),
			scoreBij(
				mechanism.getBinaryPreds(participant, participantDistinctTasks),
				mechanism.getBinaryPreds(mechanism.participants[referenceAgentIndex], referenceDistinctTasks)
			)
		);
		
	}

	function scoreAij(uint p, uint r) internal constant returns (uint128) {
		require((p == 0 || p == 1) && (r == 0 || r == 1));
		uint128 first = MathLib.cast(p * r);
		uint128 second = MathLib.cast((1 - p) * (1 - r));
		uint128 score = 1 ether * (first + second);
		return score;
	}

	function scoreBij(uint128[] ps, uint128[] rs) internal constant returns (uint128) {
		require(ps.length == rs.length);

		uint128 d = MathLib.cast(ps.length * 1 ether);
		uint128 first = MathLib.wdiv(MathLib.cast(MathLib.sum(ps)) * 1 ether, d);
		uint128 second = MathLib.wdiv(MathLib.cast(MathLib.sum(rs)) * 1 ether, d);
		uint128 left = MathLib.wmul(first, second);
		uint128 right = MathLib.wmul(MathLib.wsub(1 ether, first), MathLib.wsub(1 ether, second));
		return MathLib.wadd(left, right);
	}

	function info() returns (address[], bytes32[], uint8[], uint256) {
		return mechanism.info();
	}
}
