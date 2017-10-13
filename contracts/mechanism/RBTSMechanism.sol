pragma solidity ^0.4.10;

import '../math/DSMath.sol';
import './MechanismLib.sol';

contract RBTSMechanism {
	using MechanismLib for MechanismLib.M;
	MechanismLib.M mechanism;
	
	address public manager;
	address public designer;

	function RBTSMechanism(address mechanismDesigner, uint8[] events, bytes32[] tasks) {
		manager = msg.sender;
		designer = mechanismDesigner;
		mechanism.init(events, tasks);
	}

	function submit(bytes32 taskId, uint128 signal, uint128 posterior, address participant) {
		mechanism.submit(taskId, signal, posterior, participant);
	}

	function score(bytes32 taskId, address participant) returns (uint128) {
		require(mechanism.participants[taskId].length >= 3);

		// Reference agent index j, peer agent index k
		uint i = getParticipantIndex(taskId, participant);
		require(i != 0);

		require(!mechanism.scored[taskId][i]);
		mechanism.scored[taskId][i] = true;

		uint128 j = uint128((i+1) % mechanism.participants[taskId].length);
		uint128 k = uint128((i+2) % mechanism.participants[taskId].length);

		// User and reference agent's meta predictions (underlying distribution)
		uint128 y_i = mechanism.metaPreds[taskId][i];
		uint128 y_j = mechanism.metaPreds[taskId][j];
		uint128 y_iPrime = 0;

		// User and peer agent's binary predictions
		uint128 x_i = mechanism.binaryPreds[taskId][i];
		uint128 x_k = mechanism.binaryPreds[taskId][k];

		uint128 delta = DSMath.wmin(y_j, DSMath.wsub(1 ether, y_j));

		if (x_i == 1) {
			y_iPrime = DSMath.wadd(y_j, delta);
		} else {
			y_iPrime = DSMath.wsub(y_j, delta);
		}

		// User's utility is sum of information and prediction scores
		return DSMath.wadd(RBTSQuadraticScoring(x_k, y_iPrime), RBTSQuadraticScoring(x_k, y_i));
	}

	function RBTSQuadraticScoring(uint128 i, uint128 p) internal returns(uint128) {
		if (i == 1) {
			return uint128(DSMath.wsub(DSMath.wmul(2 * 1 ether, p), DSMath.wmul(p, p)));
		} else {
			return uint128(DSMath.wsub(1 ether, DSMath.wmul(p, p)));
		}
	}

	function getParticipantIndex(bytes32 taskId, address participant) constant returns (uint) {
		for (uint i = 0; i < mechanism.participants[taskId].length; i++) {
			if (mechanism.participants[taskId][i] == participant) {
				return i;
			}
		}

		return 0;
	}
}