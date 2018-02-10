pragma solidity ^0.4.10;

import './Math.sol';
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

    function Protocol() {
        owner = msg.sender;
    }

    function destroyOwner() onlyOwner {
        owner = this;
    }

    function setTruecoinContract(address trcContract) onlyOwner returns (bool) {
        truecoin = trcContract;
     }

    /**
     *                           ADMIN FUNCTIONS
     *
     * -----------------------------------------------------------------------
     * 
     *                           MARKET FUNCTIONS
     */

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

        db.answeredTasksByParticipant[msg.sender].push(address(mech));
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

    /**
     *                           MARKET FUNCTIONS
     *
     * -----------------------------------------------------------------------
     * 
     *                           SCORING FUNCTIONS
     */

     function setScoringContract(bytes32 scoreType, address scoringContract) onlyOwner returns (bool) {
        if (scoreType == bytes32("rbts")) {
            rbts = scoringContract;
        }

        return true;
     }

     function isValidTask(bytes32 taskName, address designer) returns (bool) {
        require(mechanismIndex[sha3(designer, taskName)] != address(0));
        require(!hasBeenScored[mechanismIndex[sha3(designer, taskName)]]);
        return true;
     }

     function isScored(bytes32 taskName, address designer) returns (bool) {
        hasBeenScored[mechanismIndex[sha3(designer, taskName)]] = true;
        return true;
     }
     

    /**
     *                           SCORING FUNCTIONS
     *
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
     *                           CONSTANT FUNCTIONS
     *
     * -----------------------------------------------------------------------
     */
}
