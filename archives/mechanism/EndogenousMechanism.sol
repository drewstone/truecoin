pragma solidity ^0.4.10;

import '../math/MathLib.sol';
import './Mechanism.sol';

contract EndogenousMechanism is Mechanism {
	function EndogenousMechanism(uint8[] events, bytes32[] questionIds) {
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
	

	function scoreParticipant(address participant) returns (uint128 score) {
		for (uint i = 0; i < answeredQuestionIndex[participant].length; i++) {
			score = MathLib.wadd(score, scoreQuestionByParticipant(questionIds[answeredQuestionIndex[participant][i] - 1], participant));
		}
	}

	function scoreQuestionByParticipant(bytes32 question, address participant) returns (uint128) {
		require(participantIndex[participant] != 0);

		if (getParticipantIndexByQuestion(participant, question) == questionParticipants[question].length) {
			return 0;
		} else if (scored[question][getParticipantIndexByQuestion(participant, question)]) {
			return 0;
		} else {
			scored[question][getParticipantIndexByQuestion(participant, question)] = true;
			uint referenceAgentIndex;

			// Iterate over participants that have answered the same question and get non-overlapping questions
			for (uint i = 0; i < questionParticipants[question].length; i++) {
				if (participants[questionParticipants[question][i]] != participant) {
					var (participantDistinctQuestions, referenceDistinctQuestions) = MathLib.getDistinctElements(
						answeredQuestionIndex[participant],
						answeredQuestionIndex[participants[questionParticipants[question][i]]]
					);

					if (participantDistinctQuestions.length > 0) {
						referenceAgentIndex = questionParticipants[question][i];
						break;
					}
				}
			}

			if (participantDistinctQuestions.length > 0) {
				bytes32[] memory pQuestions = new bytes32[](participantDistinctQuestions.length);
				bytes32[] memory rQuestions = new bytes32[](referenceDistinctQuestions.length);

				// Subtract 1 from question indices since we increment by 1 to start
				for (i = 0; i < pQuestions.length; i++) {
					pQuestions[i] = questionIds[participantDistinctQuestions[i] - 1];
					rQuestions[i] = questionIds[referenceDistinctQuestions[i] - 1];
				}

				return MathLib.wsub(
					scoreAij(
						getBinaryPred(participant, question),
						getBinaryPred(participants[referenceAgentIndex], question)
					),
					scoreBij(
						getBinaryPreds(participant, pQuestions),
						getBinaryPreds(participants[referenceAgentIndex], rQuestions)
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
		uint128 p_sum = MathLib.cast(MathLib.sum(ps) * 1.0 ether);
		uint128 r_sum = MathLib.cast(MathLib.sum(rs) * 1.0 ether);

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

/*
 	function scoreTaskENDG(bytes32 taskName, address designer) returns(uint128[] scores) {
        require(mechanismIndex[sha3(designer, taskName)] != address(0));
        require(!hasBeenScored[mechanismIndex[sha3(designer, taskName)]]);

        address taskAddress = mechanismIndex[sha3(designer, taskName)];
        // require(Mechanism(mech).terminationTime() < now);
        scores = new uint128[](Mechanism(taskAddress).getParticipantCount());
        for (uint i = 0; i < scores.length; i++) {
            uint count = 1;
            address[] memory p1Distinct;
            address[] memory p2Distinct;

            while (distinct.length < 1) {
                require(count < scores.length);
                var (p1Distinct, p2Distinct) = db.getDistinctTasks(
                    Mechanism(taskAddress).getParticipants()[i],
                    Mechanism(taskAddress).getParticipants()[i + count % scores.length]);
                count += 1;
            }

            for (uint j = 0; j < p1Distinct.length; j++) {

            }

            for (j = 0; j < p2Distinct.length; j++) {
                
            }
        }
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

        uint128 d = Math.cast(ps.length * 1.0 ether);
        uint128 p_sum = Math.cast(Math.sum(ps) * 1.0 ether);
        uint128 r_sum = Math.cast(Math.sum(rs) * 1.0 ether);

        uint128 first = Math.wdiv(p_sum, d);
        uint128 second = Math.wdiv(r_sum, d);

        uint128 left = Math.wmul(first, second);
        uint128 right = Math.wmul(Math.wsub(1.0 ether, first), Math.wsub(1.0 ether, second));
        return Math.wadd(left, right);
    }
*/