pragma solidity ^0.4.10;

import './Scorer.sol';
import './Mechanism.sol';
import './Database.sol';
import './Truecoin.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract Protocol {
    using Database for Database.DB;
    Database.DB db;

    address public owner;
    address public truecoin;
    address public rbts;

    event Initialized(address mechanismManager);
    event Creation(address designer, bytes32 taskName, address mechContract, uint time, bytes32 description, bytes32[] tags);
    event Submission(address designer, address participant, bytes32 taskName, uint128[2] predictions, address mech);
    event BatchSubmission(address designer, address participant, bytes32 taskName, uint128[2][] predictions, address mech);

    mapping (bytes32 => address) public mechanismIndex;
    mapping (address => bool) public hasBeenScored;
    mapping (bytes32 => uint128) public scores;

    function Protocol() public  {
        owner = msg.sender;
    }

    function destroyOwner() onlyOwner public {
        owner = this;
    }

    function setTruecoinContract(address trcContract) onlyOwner public returns (bool) {
        truecoin = trcContract;
     }

    /**
     *                           ADMIN FUNCTIONS
     *
     * -----------------------------------------------------------------------
     * 
     *                           MARKET FUNCTIONS
     */

    function submitQuestion(bytes32 taskName, address designer, bytes32 question, uint questionIndex, uint128[2] predictions) public returns (bool) {
        require(mechanismIndex[keccak256(designer, taskName)] != address(0));

        Mechanism mech = Mechanism(mechanismIndex[keccak256(designer, taskName)]);
        mech.submit(question, questionIndex, predictions, msg.sender);

        Submission(designer, msg.sender, taskName, predictions, mech);
        return true;
    }

    function submitBatch(bytes32 taskName, address designer, bytes32[] questions, uint[] questionIndices, uint128[2][] predictions) public returns (bool) {
        require(mechanismIndex[keccak256(designer, taskName)] != address(0));

        Mechanism mech = Mechanism(mechanismIndex[keccak256(designer, taskName)]);
        mech.submitBatch(questions, questionIndices, predictions, msg.sender);

        BatchSubmission(designer, msg.sender, taskName, predictions, mech);

        db.answeredTasksByParticipant[msg.sender].push(address(mech));
        return true;
    }

    function createTask(bytes32 taskName, bytes32[] events, bytes32[] questions, uint128 length, bytes32 description, bytes32[] tags) public returns (bool) {
        require(mechanismIndex[keccak256(msg.sender, taskName)] == address(0));

        address mech = new Mechanism(events, questions, length, taskName, description, tags, msg.sender);
        mechanismIndex[keccak256(msg.sender, taskName)] = mech;
        db.addTaskMechanism(mech, taskName, questions, description, tags);
        Creation(msg.sender, taskName, mech, length, description, tags);
        return true;
    }

    /**
     *                           MARKET FUNCTIONS
     *
     * -----------------------------------------------------------------------
     * 
     *                           SCORING FUNCTIONS
     */

     function mintForTask(bytes32 scoreType, address taskAddr) public {
        Scorer scorer;
        if (scoreType == bytes32("rbts")) {
            scorer = Scorer(rbts);
        }

        bytes32 taskName = Mechanism(taskAddr).name();
        address designer = Mechanism(taskAddr).designer();
        scorer.score(taskName, designer);
        for (uint i = 0; i < Mechanism(taskAddr).getParticipantCount(); i++) {
            uint128 score = scorer.getScoreOfParticipant(taskAddr, i);
            Truecoin(truecoin).mint(
                Mechanism(taskAddr).getParticipant(i), score);
            scores[keccak256(
                    Mechanism(taskAddr).getParticipant(i), 
                    designer,
                    taskName)] = score;
        }

        hasBeenScored[mechanismIndex[keccak256(
            designer,
            taskName
        )]] = true;
     }

     function setScoringContract(bytes32 scoreType, address scoringContract) onlyOwner public returns (bool) {
        if (scoreType == bytes32("rbts")) {
            rbts = scoringContract;
        }

        return true;
     }

     function isValidTask(bytes32 taskName, address designer) public view returns (bool) {
        require(mechanismIndex[keccak256(designer, taskName)] != address(0));
        require(!hasBeenScored[mechanismIndex[keccak256(designer, taskName)]]);
        return true;
     }

     function getScore(address user, address taskAddr) public view returns (uint128) {
         return scores[keccak256(
                        user, 
                        Mechanism(taskAddr).designer(),
                        Mechanism(taskAddr).name())];
     }

    /**
     *                           SCORING FUNCTIONS
     *
     * -----------------------------------------------------------------------
     * 
     *                           CONSTANT FUNCTIONS
     */

    function getTasks() public view returns (address[]) {
        return db.tasks;
    }

    function getTask(bytes32 taskName, address designer) public view returns (address) {
        return mechanismIndex[keccak256(designer, taskName)];
    }

    function getTasksOfDesigner(address designer) public view returns (address[]) {
        address[] memory tasks = new address[](db.taskHashesByDesigner[designer].length);
        for (uint i = 0; i < db.taskHashesByDesigner[designer].length; i++) {
            tasks[i] = mechanismIndex[db.taskHashesByDesigner[designer][i]];
        }

        return tasks;
    }

    function getTaskByHash(bytes32 taskHash) public view returns (address) {
        return mechanismIndex[taskHash];
    }

    function getDesigners() public view returns (address[]) {
        return db.designers;
    }

    function getDesignerCount() public view returns (uint) {
        return db.designers.length;
    }

    function getTaskCount() public view returns (uint) {
        return db.tasks.length;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _; 
    }
    
    /**
     *                           CONSTANT FUNCTIONS
     *
     * -----------------------------------------------------------------------
     */
}