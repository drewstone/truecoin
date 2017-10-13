pragma solidity ^0.4.10;

import '../math/DSMath.sol';
import './MechanismLib.sol';

contract RBTSMechanism {
	using MechanismLib for MechanismLib.M;
	MechanismLib.M mechanism;
	
	address public manager;
	address public designer;
	mapping (bytes32 => uint) participantCount;

	function RBTSMechanism(address mechanismDesigner, uint8[] events, bytes32[] tasks) {
		manager = msg.sender;
		designer = mechanismDesigner;
		mechanism.init(events, tasks);
	}

	function submit(bytes32 taskId, uint128 signal, uint128 posterior, address participant) {
		mechanism.submit(taskId, signal, posterior, participant);
		participantCount[taskId] = participantCount[taskId] + 1;
	}

	// function score(bytes32 taskId, address participant) isManager returns (uint128) {
	// 	var task = mechanism.tasks[mechanism.taskIndex[taskId]];
	// 	require(task.pOrdering[participant] != 0);
	// 	require(participantCount[taskId] >= 3);

	// 	// Reference agent index j, peer agent index k
	// 	uint i = task.pOrdering[participant] - 1;

	// 	require(!task.scored[i]);
	// 	task.scored[i] = true;

	// 	uint128 j = uint128((i+1) % participantCount[taskId]);
	// 	uint128 k = uint128((i+2) % participantCount[taskId]);

	// 	// User and reference agent's meta predictions (underlying distribution)
	// 	uint128 y_i = task.metaPreds[i];
	// 	uint128 y_j = task.metaPreds[j];
	// 	uint128 y_iPrime = 0;

	// 	// User and peer agent's binary predictions
	// 	uint128 x_i = task.binaryPreds[i];
	// 	uint128 x_k = task.binaryPreds[k];

	// 	uint128 delta = DSMath.wmin(y_j, DSMath.wsub(1 ether, y_j));

	// 	if (x_i == 1) {
	// 		y_iPrime = DSMath.wadd(y_j, delta);
	// 	} else {
	// 		y_iPrime = DSMath.wsub(y_j, delta);
	// 	}

	// 	// User's utility is sum of information and prediction scores
	// 	return DSMath.wadd(RBTSQuadraticScoring(x_k, y_iPrime), RBTSQuadraticScoring(x_k, y_i));
	// }

	function RBTSQuadraticScoring(uint128 i, uint128 p) internal returns(uint128) {
		if (i == 1) {
			return uint128(DSMath.wsub(DSMath.wmul(2 * 1 ether, p), DSMath.wmul(p, p)));
		} else {
			return uint128(DSMath.wsub(1 ether, DSMath.wmul(p, p)));
		}
	}
}