pragma solidity ^0.4.10;

import '../math/DSMath.sol';
import './Mechanism.sol';

contract RBTSMechanism {
	using Mechanism for Mechanism.M;
	Mechanism.M mechanism;
	
	address public protocol;
	address public designer;
	uint public participantCount;
	uint public lastRewardTime;

	function RBTSMechanism(address manager, string question) {
		protocol = msg.sender;
		designer = manager;
		participantCount = 0;
		mechanism.init(question);
	}
	
	function submit(uint128 i, uint128 p, address submitter) isProtocol {
		require(mechanism.pOrdering[submitter] == 0);

		mechanism.submit(i, p, submitter);
		participantCount = participantCount + 1;
	}

	function score(address participant) isProtocol returns (uint128) {
		require(mechanism.pOrdering[participant] != 0);
		require(participantCount >= 3);

		// Reference agent index j, peer agent index k
		uint i = mechanism.pOrdering[participant] - 1;

		require(!mechanism.scored[i]);
		mechanism.scored[i] = true;

		uint128 j = uint128((i+1) % participantCount);
		uint128 k = uint128((i+2) % participantCount);

		// User and reference agent's meta predictions (underlying distribution)
		uint128 y_i = mechanism.metaPreds[i];
		uint128 y_j = mechanism.metaPreds[j];
		uint128 y_iPrime = 0;

		// User and peer agent's binary predictions
		uint128 x_i = mechanism.binaryPreds[i];
		uint128 x_k = mechanism.binaryPreds[k];

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

	function getParticipants() constant returns (address[]) {
		uint participantLength = mechanism.participants.length - 1;
		address[] memory participants = new address[](participantLength);
		for (uint i = 0; i < participants.length; i++) {
			participants[i] = mechanism.participants[i + 1];
		}

		return participants;
	}

	function getBinaryPreds() constant returns (uint128[]) {
		return mechanism.binaryPreds;
	}

	function getMetaPreds() constant returns (uint128[]) {
		return mechanism.metaPreds;
	}

	function getEvents() constant returns (uint8[]) {
		return mechanism.events;
	}

	function getInfo() constant returns (address[], uint128[], uint128[], uint8[]) {
		return (getParticipants(), getBinaryPreds(), getMetaPreds(), getEvents());
	}

	modifier isProtocol() { 
		require(msg.sender == protocol); 
		_;
	}
	
}