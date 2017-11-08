pragma solidity ^0.4.10;

import '../math/MathLib.sol';
import './MechanismLib.sol';

contract RBTSMechanism {
	using MechanismLib for MechanismLib.M;
	MechanismLib.M mechanism;
	
	address public manager;
	address public designer;

	function RBTSMechanism(address mechanismDesigner, uint8[] events, bytes32[] taskIds) {
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
		require(mechanism.taskParticipants[taskId].length >= 3);

		// Reference agent index j, peer agent index k
		require(mechanism.participantIndex[participant] != 0);

		// require(!mechanism.scored[taskId][i]);
		mechanism.scored[taskId][mechanism.participantIndex[participant]] = true;

		uint128 j = uint128((mechanism.participantIndex[participant]+1) % mechanism.participants.length);
		if (j == 0) {
			j = 1;
		}

		uint128 k = uint128((mechanism.participantIndex[participant]+2) % mechanism.participants.length);
		if (k == 0) {
			k = 1;
		}

		// User and reference agent's meta predictions (underlying distribution)
		uint128 y_i = mechanism.getMetaPred(participant, mechanism.taskIndex[taskId]);
		uint128 y_j = mechanism.getMetaPred(mechanism.participants[j], mechanism.taskIndex[taskId]);
		uint128 y_iPrime = 0;

		// User and peer agent's binary predictions
		uint128 x_i = mechanism.getBinaryPred(participant, mechanism.taskIndex[taskId]);
		uint128 x_k = mechanism.getBinaryPred(mechanism.participants[k], mechanism.taskIndex[taskId]);

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
		return mechanism.info();
	}
}