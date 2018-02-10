pragma solidity ^0.4.13;

import './Math.sol';
import './Mechanism.sol';
import './Protocol.sol';
import './Truecoin.sol';

/**
 * The RBTS contract
 */
contract RBTS {
    address public protocol;

    event ScoreTask(bytes32 taskName, address designer, uint128[] scores);

    function RBTS (address _protocol) {
        protocol = _protocol;
    }

    function score(bytes32 taskName, address designer) returns (uint128[] scores) {
        require(Protocol(protocol).isValidTask(taskName, designer));

        // require(Mechanism(mech).terminationTime() < now);
        Mechanism taskAddr = Mechanism(Protocol(protocol).getTask(taskName, designer));
        scores = new uint128[](taskAddr.getParticipantCount());

        for (uint l = 0; l < taskAddr.getQuestionCount(); l++) {
            for (uint i = 0; i < taskAddr.getParticipantCountOfQuestion(l); i++) {
                uint128 y_iPrime;

                if (taskAddr.getParticipantPredictionOfQuestion(l, i)[0] == 1) {
                    y_iPrime = Math.wadd(
                        uint128(taskAddr.getParticipantPredictionOfQuestion(
                            l,
                            uint128((i+1) % taskAddr.getParticipantCountOfQuestion(l))
                        )[1]),
                        Math.wmin(
                            uint128(taskAddr.getParticipantPredictionOfQuestion(
                                l,
                                uint128((i+1) % taskAddr.getParticipantCountOfQuestion(l))
                            )[1]),
                            Math.wsub(
                                1 ether,
                                uint128(taskAddr.getParticipantPredictionOfQuestion(
                                    l,
                                    uint128((i+1) % taskAddr.getParticipantCountOfQuestion(l))
                                )[1])
                            )
                        )
                    );
                } else {
                    y_iPrime = Math.wsub(
                        uint128(taskAddr.getParticipantPredictionOfQuestion(
                            l,
                            uint128((i+1) % taskAddr.getParticipantCountOfQuestion(l))
                        )[1]),
                        Math.wmin(
                            uint128(taskAddr.getParticipantPredictionOfQuestion(
                                l,
                                uint128((i+1) % taskAddr.getParticipantCountOfQuestion(l))
                            )[1]),
                            Math.wsub(
                                1 ether,
                                uint128(taskAddr.getParticipantPredictionOfQuestion(
                                    l,
                                    uint128((i+1) % taskAddr.getParticipantCountOfQuestion(l))
                                )[1])
                            )
                        )
                    );
                }

                // User's utility is sum of information and prediction scores
                scores[taskAddr.getParticipantIndexFromQuestion(l, i)] += Math.wadd(
                    quadraticScoring(
                        taskAddr.getParticipantPredictionOfQuestion(
                            l,
                            uint128((i+2) % taskAddr.getParticipantCountOfQuestion(l))
                        )[0],
                        y_iPrime
                    ),
                    quadraticScoring(
                        taskAddr.getParticipantPredictionOfQuestion(
                            l,
                            uint128((i+2) % taskAddr.getParticipantCountOfQuestion(l))
                        )[0],
                        uint128(taskAddr.getParticipantPredictionOfQuestion(l, i)[1]))
                    );
            }
        }

        ScoreTask(taskName, designer, scores);
        Protocol(protocol).isScored(taskName, designer);
        return scores;
    }

    function quadraticScoring(uint128 i, uint128 p) internal returns(uint128) {
        if (i == 1) {
            return Math.wsub(Math.wmul(2 * 1 ether, p), Math.wmul(p, p));
        } else {
            return Math.wsub(1 ether, Math.wmul(p, p));
        }
    }
}
