pragma solidity ^0.4.10;

import '../math/MathLib.sol';
import './Mechanism.sol';

contract EndogenousMechanism is Mechanism {	
	address public manager;
	address public designer;
	mapping (bytes32 => uint) participantCount;

	function EndogenousMechanism(uint8[] events, bytes32[] taskIds) {
		designer = msg.sender;
		_init(events, taskIds);
	}

	function submit(bytes32 taskId, uint128 signal, uint128 posterior, address participant) {
		_submit(taskId, signal, posterior, participant);
	}

	function score(address participant) returns (uint128 score) {
		uint[] memory tIds = answeredTaskIndex[participant];
		for (uint i = 0; i < tIds.length; i++) {
			score = MathLib.wadd(score, scoreTask(taskIds[tIds[i]], participant));
		}
	}

	function scoreTask(bytes32 task, address participant) returns (uint128) {
		require(participantIndex[participant] != 0);

		// Return no payment if task was previously scored
		if (scored[task][participantIndex[participant]]) {
			return 0;
		}

		scored[task][participantIndex[participant]] = true;

		uint referenceAgentIndex;
		uint[] memory participantDistinctTasks;
		uint[] memory referenceDistinctTasks;

		// Iterate over participants that have answered the same task and get non-overlapping tasks
		for (uint i = 0; i < taskParticipants[task].length; i++) {
			if (participants[taskParticipants[task][i]] != participant) {
				(participantDistinctTasks, referenceDistinctTasks) = MathLib.getDistinctElements(
					answeredTaskIndex[participant],
					answeredTaskIndex[participants[taskParticipants[task][i]]]
				);

				if (participantDistinctTasks.length > 0) {
					referenceAgentIndex = taskParticipants[task][i];
					break;
				}
			}
		}

		bytes32[] memory pTasks = new bytes32[](participantDistinctTasks.length);
		bytes32[] memory rTasks = new bytes32[](referenceDistinctTasks.length);

		for (i = 0; i < pTasks.length; i++) {
			pTasks[i] = taskIds[participantDistinctTasks[i]];
			rTasks[i] = taskIds[referenceDistinctTasks[i]];
		}

		return MathLib.wsub(
			scoreAij(
				getBinaryPred(participant, task),
				getBinaryPred(participants[referenceAgentIndex], task)
			),
			scoreBij(
				getBinaryPreds(participant, pTasks),
				getBinaryPreds(participants[referenceAgentIndex], rTasks)
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
		return _info();
	}
}
