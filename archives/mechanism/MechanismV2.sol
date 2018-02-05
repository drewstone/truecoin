pragma solidity ^0.4.10;

contract Mechanism {
    event Submission(address submitter);

    address public manager;
    bool public initialized;

    address[] public participants;
    uint8[] public events;
    uint256 public timeLength;
    uint256 public initiationTime;
    uint256 public terminationTime;

    struct Pred {
        uint128[] predictions;
    }

    struct Question {
        bytes32 data;
        address[] participants;
        uint128[][] predictionsOfParticipants;
    }

    Question[] public questions;

    // Participants that have answered a specific question
    mapping (bytes32 => uint128[]) public participantsOfQuestion;

    // questions answered by specific participant
    mapping (address => uint128[]) public participantsQuestions;
    mapping (address => mapping (uint => uint)) hasAnsweredQuestion;

    function Mechanism(uint8[] _events, bytes32[] _questions, uint128 length) {
        require(initiationTime == 0);
        questions = _questions;
        events = _events;
        initiationTime = now;
        terminationTime = initiationTime + length * 1 days;
        manager = msg.sender;
    }

    function submit(bytes32 question, uint questionIndex, uint128[] predictions) isLive {
        require(questions[questionIndex].data == question);
        require(hasAnsweredQuestion[msg.sender][questionIndex] == 0);
        Question q = questions[questionIndex];
        q.predictionsOfParticipants.push(predictions);
        q.participants.push(msg.sender);
        Submission(msg.sender);
    }

    modifier isManager() { 
        require(msg.sender == manager);
        _;
    }

    modifier isLive() { 
            require(now <= terminationTime);
            _; 
        }
            
}
