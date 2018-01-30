pragma solidity ^0.4.10;

import '../math/MathLib.sol';
import './Mechanism.sol';

contract RBTSMechanism is Mechanism {
	function RBTSMechanism(uint8[] events, bytes32[] questionIds) {
		designer = msg.sender;
		_init(events, questionIds);
	}

	function submit(bytes32 questionId, uint128 signal, uint128 posterior, address participant) {
		_submit(questionId, signal, posterior, participant);
	}

	function score() returns (uint128[]) {
		uint128[] memory scores = new uint128[](participants.length);

		for (uint i = 0; i < participants.length; i++) {
			scores[i] = scoreParticipant(participants[i]);
		}

		return scores;
	}

	// function scoreQuestion(bytes32 question) returns (address[]) {
	// 	uint128[] memory scores = new uint128[](participants.length);
	// 	address[] memory zeroes = new address[](participants.length);
	// 	address[] memory ones = new address[](participants.length);

	// 	uint128 summed_zeroes;
	// 	uint128 summed_ones;

	// 	for (uint i = 0; i < questionParticipants[question].length; i++) {
	// 		if (binaryPreds[question][i] == 0) {
	// 			zeroes[i] = participants[questionParticipants[question][i]];
	// 			summed_zeroes += scoreQuestionByParticipant(question, participants[questionParticipants[question][i]]);
	// 		} else {
	// 			ones[i] = participants[questionParticipants[question][i]];
	// 			summed_ones += scoreQuestionByParticipant(question, participants[questionParticipants[question][i]]);
	// 		}
	// 	}

	// 	if (summed_zeroes > summed_ones) {
	// 		return zeroes;
	// 	} else if (summed_zeroes < summed_ones) {
	// 		return ones;
	// 	} else {
	// 		return new address[](0);
	// 	}
	// }

	function scoreParticipant(address participant) returns (uint128 score) {
		for (uint i = 0; i < answeredQuestionIndex[participant].length; i++) {
			score = MathLib.wadd(score, scoreQuestionByParticipant(questionIds[answeredQuestionIndex[participant][i] - 1], participant));
		}
	}

	function scoreQuestionByParticipant(bytes32 question, address participant) returns (uint128) {
		require(questionParticipants[question].length >= 3);

		// Reference agent index j, peer agent index k
		require(participantIndex[participant] != 0);

		// require(!mechanism.scored[question][i]);
		scored[question][participantIndex[participant]] = true;

		uint128 j = uint128((participantIndex[participant]+1) % participants.length);
		if (j == 0) {
			j = 1;
		}

		uint128 k = uint128((participantIndex[participant]+2) % participants.length);
		if (k == 0) {
			k = 1;
		}

		// User and reference agent's meta predictions (underlying distribution)
		uint128 y_i = getMetaPred(participant, question);
		uint128 y_j = getMetaPred(participants[j], question);
		uint128 y_iPrime = 0;

		// User and peer agent's binary predictions
		uint128 x_i = getBinaryPred(participant, question);
		uint128 x_k = getBinaryPred(participants[k], question);

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