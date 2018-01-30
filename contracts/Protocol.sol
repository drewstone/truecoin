pragma solidity ^0.4.10;

import './Scorer.sol';
import './Mechanism.sol';
import './Database.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract Protocol {
    using Database for Database.DB;
    Database.DB db;

    address public owner;

    event Initialized(address mechanismManager);
    event Creation(address designer, bytes32 taskName, address mechContract, uint time);
    event Submission(address designer, address participant, bytes32 taskName, uint128[2] predictions, address mech);
    event BatchSubmission(address designer, address participant, bytes32 taskName, uint128[2][] predictions, address mech);
    
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

    function createTask(bytes32 taskName, uint8[] events, bytes32[] questions, uint128 length) returns (bool) {
        require(mechanismIndex[sha3(msg.sender, taskName)] == address(0));
        address mech = new Mechanism(events, questions, length, taskName);
        mechanismIndex[sha3(msg.sender, taskName)] = mech;
        db.addTaskMechanism(mech, taskName, questions);
        Creation(msg.sender, taskName, mech, length);
        return true;
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
