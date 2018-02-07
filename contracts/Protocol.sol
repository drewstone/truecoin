pragma solidity ^0.4.10;

import './Mechanism.sol';
import './Database.sol';
import './Math.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract Protocol {
    using Database for Database.DB;
    Database.DB db;

    address public owner;

    event Initialized(address mechanismManager);
    event Creation(address designer, bytes32 taskName, address mechContract, uint time, bytes32 description, bytes32[] tags);
    event Submission(address designer, address participant, bytes32 taskName, uint128[2] predictions, address mech);
    event BatchSubmission(address designer, address participant, bytes32 taskName, uint128[2][] predictions, address mech);
    event ScoreTask(bytes32 taskName, address designer, uint128[] scores);

    mapping (bytes32 => address) public mechanismIndex;

    function Protocol() {
        owner = msg.sender;
    }

    function destroyOwner() onlyOwner {
        owner = this;
    }

    function submitQuestion(bytes32 taskName, address designer, bytes32 question, uint questionIndex, uint128[2] predictions) returns (bool) {
        require(mechanismIndex[sha3(designer, taskName)] != address(0));

        Mechanism mech = Mechanism(mechanismIndex[sha3(designer, taskName)]);
        mech.submit(question, questionIndex, predictions, msg.sender);

        Submission(designer, msg.sender, taskName, predictions, mech);
        return true;
    }

    function submitBatch(bytes32 taskName, address designer, bytes32[] questions, uint[] questionIndices, uint128[2][] predictions) returns (bool) {
        require(mechanismIndex[sha3(designer, taskName)] != address(0));

        Mechanism mech = Mechanism(mechanismIndex[sha3(designer, taskName)]);
        mech.submitBatch(questions, questionIndices, predictions, msg.sender);

        BatchSubmission(designer, msg.sender, taskName, predictions, mech);
        return true;
    }

    function createTask(bytes32 taskName, bytes32[] events, bytes32[] questions, uint128 length, bytes32 description, bytes32[] tags) returns (bool) {
        require(mechanismIndex[sha3(msg.sender, taskName)] == address(0));

        address mech = new Mechanism(events, questions, length, taskName, description, tags);
        mechanismIndex[sha3(msg.sender, taskName)] = mech;
        db.addTaskMechanism(mech, taskName, questions, description, tags);
        Creation(msg.sender, taskName, mech, length, description, tags);
        return true;
    }

    function scoreTaskRBTS(bytes32 taskName) returns (bool) {
        require(mechanismIndex[sha3(msg.sender, taskName)] != address(0));
        
        address mech = mechanismIndex[sha3(msg.sender, taskName)];
        // require(Mechanism(mech).terminationTime() < now);

        uint128[] memory scores = new uint128[](Mechanism(mech).getParticipantCount());
        for (uint l = 0; l < Mechanism(mech).getQuestionCount(); l++) {
            for (uint i = 0; i < Mechanism(mech).getParticipantCountOfQuestion(l); i++) {
                
                // User and reference agent's meta predictions (underlying distribution)
                uint128 y_i = uint128(Mechanism(mech).getParticipantPredictionOfQuestion(l, i)[1]);
                uint128 y_j = uint128(Mechanism(mech).getParticipantPredictionOfQuestion(
                    l,
                    uint128((i+1) % Mechanism(mech).getParticipantCountOfQuestion(l))
                )[1]);

                uint128 y_iPrime;

                if (Mechanism(mech).getParticipantPredictionOfQuestion(l, i)[0] == 1) {
                    y_iPrime = Math.wadd(
                        uint128(Mechanism(mech).getParticipantPredictionOfQuestion(
                            l,
                            uint128((i+1) % Mechanism(mech).getParticipantCountOfQuestion(l))
                        )[1]),
                        Math.wmin(
                            uint128(Mechanism(mech).getParticipantPredictionOfQuestion(
                                l,
                                uint128((i+1) % Mechanism(mech).getParticipantCountOfQuestion(l))
                            )[1]),
                            Math.wsub(
                                1 ether,
                                uint128(Mechanism(mech).getParticipantPredictionOfQuestion(
                                    l,
                                    uint128((i+1) % Mechanism(mech).getParticipantCountOfQuestion(l))
                                )[1])
                            )
                        )
                    );
                } else {
                    y_iPrime = Math.wsub(
                        uint128(Mechanism(mech).getParticipantPredictionOfQuestion(
                            l,
                            uint128((i+1) % Mechanism(mech).getParticipantCountOfQuestion(l))
                        )[1]),
                        Math.wmin(
                            uint128(Mechanism(mech).getParticipantPredictionOfQuestion(
                                l,
                                uint128((i+1) % Mechanism(mech).getParticipantCountOfQuestion(l))
                            )[1]),
                            Math.wsub(
                                1 ether,
                                uint128(Mechanism(mech).getParticipantPredictionOfQuestion(
                                    l,
                                    uint128((i+1) % Mechanism(mech).getParticipantCountOfQuestion(l))
                                )[1])
                            )
                        )
                    );
                }

                // User's utility is sum of information and prediction scores
                scores[Mechanism(mech).getParticipantIndexFromQuestion(l, i)] += Math.wadd(
                    quadraticScoring(
                        Mechanism(mech).getParticipantPredictionOfQuestion(
                            l,
                            uint128((i+2) % Mechanism(mech).getParticipantCountOfQuestion(l))
                        )[0],
                        y_iPrime
                    ),
                    quadraticScoring(
                        Mechanism(mech).getParticipantPredictionOfQuestion(
                            l,
                            uint128((i+2) % Mechanism(mech).getParticipantCountOfQuestion(l))
                        )[0],
                        uint128(Mechanism(mech).getParticipantPredictionOfQuestion(l, i)[1]))
                    );
            }
        }

        ScoreTask(taskName, msg.sender, scores);
        return true;
    }

    function quadraticScoring(uint128 i, uint128 p) internal returns(uint128) {
        if (i == 1) {
            return Math.wsub(Math.wmul(2 * 1 ether, p), Math.wmul(p, p));
        } else {
            return Math.wsub(1 ether, Math.wmul(p, p));
        }
    }

    /**
     * -----------------------------------------------------------------------
     * 
     *                           CONSTANT FUNCTIONS
     */

    function getTasks() constant returns (address[]) {
        return db.tasks;
    }

    function getTask(bytes32 taskName, address designer) constant returns (address) {
        return mechanismIndex[sha3(designer, taskName)];
    }

    function getTaskByHash(bytes32 taskHash) constant returns (address) {
        return mechanismIndex[taskHash];
    }

    function getDesigners() constant returns (address[]) {
        return db.designers;
    }

    function getDesignerCount() constant returns (uint) {
        return db.designers.length;
    }

    function getTaskCount() constant returns (uint) {
        return db.tasks.length;
    }

    modifier onlyOwner() { 
        require(msg.sender == owner);
        _; 
    }
    
    /**
     * -----------------------------------------------------------------------
     */
}
