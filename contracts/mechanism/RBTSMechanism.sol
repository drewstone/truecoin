pragma solidity ^0.4.10;

import '../math/MathLib.sol';
import './Mechanism.sol';

contract RBTSMechanism is Mechanism {
	function RBTSMechanism(uint8[] events, bytes32[] taskIds) {
		designer = msg.sender;
		_init(events, taskIds);
	}

	function submit(bytes32 taskId, uint128 signal, uint128 posterior, address participant) {
		_submit(taskId, signal, posterior, participant);
	}

	function score(address participant) returns (uint128) {
		uint[] memory tIds = answeredTaskIndex[participant];
		uint128 score;
		for (uint i = 0; i < tIds.length; i++) {
			score = MathLib.wadd(score, scoreTask(taskIds[tIds[i]], participant));
		}
		
		return score;
	}

	function scoreTask(bytes32 taskId, address participant) returns (uint128) {
		require(taskParticipants[taskId].length >= 3);

		// Reference agent index j, peer agent index k
		require(participantIndex[participant] != 0);

		// require(!mechanism.scored[taskId][i]);
		scored[taskId][participantIndex[participant]] = true;

		uint128 j = uint128((participantIndex[participant]+1) % participants.length);
		if (j == 0) {
			j = 1;
		}

		uint128 k = uint128((participantIndex[participant]+2) % participants.length);
		if (k == 0) {
			k = 1;
		}

		// User and reference agent's meta predictions (underlying distribution)
		uint128 y_i = getMetaPred(participant, taskIndex[taskId]);
		uint128 y_j = getMetaPred(participants[j], taskIndex[taskId]);
		uint128 y_iPrime = 0;

		// User and peer agent's binary predictions
		uint128 x_i = getBinaryPred(participant, taskIndex[taskId]);
		uint128 x_k = getBinaryPred(participants[k], taskIndex[taskId]);

		uint128 delta = MathLib.wmin(y_j, MathLib.wsub(1 ether, y_j));

		if (x_i == 1) {
			y_iPrime = MathLib.wadd(y_j, delta);
		} else {
			y_iPrime = MathLib.wsub(y_j, delta);
		}

		// User's utility is sum of information and prediction scores
		return MathLib.wadd(RBTSQuadraticScoring(x_k, y_iPrime), RBTSQuadraticScoring(x_k, y_i));
	}

	function RBTSQuadraticScoring(uint128 i, uint128 p) internal returns(uint128) {
		if (i == 1) {
			return MathLib.wsub(MathLib.wmul(2 * 1 ether, p), MathLib.wmul(p, p));
		} else {
			return MathLib.wsub(1 ether, MathLib.wmul(p, p));
		}
	}

	function info() constant returns (address[], bytes32[], uint8[], uint256) {
		return _info();
	}
}