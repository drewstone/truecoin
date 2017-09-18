pragma solidity ^0.4.10;

import '../math/DSMath.sol';
import './Mechanism.sol';

contract RBTSMechanism {
	using Mechanism for Mechanism.M;
	Mechanism.M mechanism;
	
	address public designer;

	uint128[] scores;
	uint public participantCount;
	uint public lastRewardTime;

	event VoteSubmission(uint128 binary, uint128 meta, address submitter);

	function RBTSMechanism(address manager, string question) {
		designer = manager;
		participantCount = 0;
		mechanism.init(question);
	}
	
	function getScores() returns (address[], uint128[]) {
		return (mechanism.participants, scores);
	}

	function getMechanismInfo() constant returns (address[], uint128[], uint128[], uint8[]) {
		uint participantLength = mechanism.participants.length - 1;
		address[] memory participants = new address[](participantLength);
		for (uint i = 0; i < participants.length; i++) {
			participants[i] = mechanism.participants[i + 1];
		}

		return (participants, mechanism.binaryPreds, mechanism.metaPreds, mechanism.events);
	}
	
	function submit(uint128 i, uint128 p, address submitter) {
		require(mechanism.pOrdering[submitter] == 0);

		mechanism.submit(i, p, submitter);
		participantCount = participantCount + 1;
		VoteSubmission(i, p, submitter);
	}

	function score() returns (address[], uint128[]) {
		require(scores.length == 0);

		uint pLength = mechanism.participants.length;
		scores = new uint128[](pLength);

		for (uint i = 0; i < pLength; i++) {
			uint128 informationScore;
			uint128 predictionScore;

			uint128 referenceAgent = uint128((i+1) % pLength);
			uint128 peerAgent = uint128((i+2) % pLength);

			uint128 meta = mechanism.metaPreds[referenceAgent];
			uint128 delta = DSMath.wmin(meta, DSMath.wmin(1 ether, meta));

			if (mechanism.binaryPreds[i] == 0) {
				informationScore = RBTSQuadraticScoring(
					mechanism.binaryPreds[peerAgent] * 1 ether,
					DSMath.wsub(meta, delta)
				);
			} else {
				informationScore = RBTSQuadraticScoring(
					mechanism.binaryPreds[peerAgent] * 1 ether,
					DSMath.wadd(meta, delta)
				);
			}

			predictionScore = RBTSQuadraticScoring(
				mechanism.binaryPreds[peerAgent],
				mechanism.metaPreds[i]
			);

			scores[i] = DSMath.wadd(informationScore, predictionScore);
		}

		return getScores();
	}

	function RBTSQuadraticScoring(uint128 i, uint128 p) internal returns(uint128) {
		if (i == 0) {
			return uint128(DSMath.wsub(DSMath.wmul(2 * 1 ether, p), DSMath.wmul(p, p)));
		} else {
			return uint128(DSMath.wsub(1 ether,DSMath.wmul(p, p)));
		}
	}
}