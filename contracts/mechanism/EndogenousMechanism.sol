pragma solidity ^0.4.10;

import '../math/MathLib.sol';
import './Mechanism.sol';

contract EndogenousMechanism is Mechanism {	
	address public designer;
	mapping (bytes32 => uint) participantCount;

	function EndogenousMechanism(uint8[] events, bytes32[] taskIds, uint256 timeLength) {
		designer = msg.sender;
		_init(events, taskIds, timeLength);
	}

	function submit(bytes32 taskId, uint128 signal, uint128 posterior, address participant) {
		_submit(taskId, signal, posterior, participant);
	}

	function score(address participant) returns (uint128 score) {
		for (uint i = 0; i < answeredTaskIndex[participant].length; i++) {
			score = MathLib.wadd(score, scoreTask(taskIds[answeredTaskIndex[participant][i] - 1], participant));
		}
	}

	function scoreTask(bytes32 task, address participant) returns (uint128) {
		require(participantIndex[participant] != 0);

		if (getParticipantIndexByTask(participant, task) == taskParticipants[task].length) {
			return 0;
		} else if (scored[task][getParticipantIndexByTask(participant, task)]) {
			return 0;
		} else {
			scored[task][getParticipantIndexByTask(participant, task)] = true;
			uint referenceAgentIndex;

			// Iterate over participants that have answered the same task and get non-overlapping tasks
			for (uint i = 0; i < taskParticipants[task].length; i++) {
				if (participants[taskParticipants[task][i]] != participant) {
					var (participantDistinctTasks, referenceDistinctTasks) = MathLib.getDistinctElements(
						answeredTaskIndex[participant],
						answeredTaskIndex[participants[taskParticipants[task][i]]]
					);

					if (participantDistinctTasks.length > 0) {
						referenceAgentIndex = taskParticipants[task][i];
						break;
					}
				}
			}

			if (participantDistinctTasks.length > 0) {
				bytes32[] memory pTasks = new bytes32[](participantDistinctTasks.length);
				bytes32[] memory rTasks = new bytes32[](referenceDistinctTasks.length);

				// Subtract 1 from task indices since we increment by 1 to start
				for (i = 0; i < pTasks.length; i++) {
					pTasks[i] = taskIds[participantDistinctTasks[i] - 1];
					rTasks[i] = taskIds[referenceDistinctTasks[i] - 1];
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
		}

		return 0;
	}

	function scoreAij(uint128 p, uint128 r) internal constant returns (uint128) {
		// require((p == 0 || p == 1) && (r == 0 || r == 1));
		uint128 first = p * r;
		uint128 second = (1 - p) * (1 - r);
		uint128 score = 1.0 ether * (first + second);
		return score;
	}

	function scoreBij(uint128[] ps, uint128[] rs) internal constant returns (uint128) {
		require(ps.length == rs.length);

		uint128 d = MathLib.cast(ps.length * 1.0 ether);
		uint128 p_sum = MathLib.sum(ps) * 1.0 ether;
		uint128 r_sum = MathLib.sum(rs) * 1.0 ether;

		uint128 first = MathLib.wdiv(p_sum, d);
		uint128 second = MathLib.wdiv(r_sum, d);

		uint128 left = MathLib.wmul(first, second);
		uint128 right = MathLib.wmul(MathLib.wsub(1.0 ether, first), MathLib.wsub(1.0 ether, second));
		return MathLib.wadd(left, right);
	}

	function info() returns (address[], bytes32[], uint8[], uint256) {
		return _info();
	}
}
