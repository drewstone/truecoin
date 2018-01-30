pragma solidity ^0.4.10;

contract Mechanism {
    event Submission(address submitter, bytes32 question, uint128[2] predictions);

    address public manager;
    bytes32 public name;

    address[] public participants;
    uint8[] public events;
    uint256 public timeLength;
    uint256 public initiationTime;
    uint256 public terminationTime;

    struct Question {
        bytes32 data;
        address[] participants;
        uint128[2][] predictionsOfParticipants;
    }

    Question[] public questions;

    // Participants that have answered a specific question
    mapping (bytes32 => uint128[]) public participantsOfQuestion;

    // questions answered by specific participant
    mapping (address => uint128[]) public participantsQuestions;
    mapping (address => mapping (uint => uint)) hasAnsweredQuestion;

    function Mechanism(uint8[] _events, bytes32[] _questions, uint128 _length, bytes32 _name) {
        require(initiationTime == 0);
        events = _events;
        name = _name;
        initiationTime = now;
        terminationTime = initiationTime + (_length * 1 days);
        manager = msg.sender;

        for (uint i = 0; i < _questions.length; i++) {
            questions.length++;
            questions[i].data = _questions[i];
        }
    }

    function submit(bytes32 question, uint questionIndex, uint128[2] predictions, address submitter) isLive {
        require(questions[questionIndex].data == question);
        require(hasAnsweredQuestion[submitter][questionIndex] == 0);
        require(msg.sender == manager || msg.sender == submitter);
        hasAnsweredQuestion[submitter][questionIndex] = 1;

        Question q = questions[questionIndex];
        q.predictionsOfParticipants.push(predictions);
        q.participants.push(submitter);
        Submission(submitter, question, predictions);
    }

    function submitBatch(bytes32[] qs, uint[] questionIndices, uint128[2][] predictions, address submitter) isLive {
        require(msg.sender == manager || msg.sender == submitter);

        for (uint i = 0; i < qs.length; i++) {
            submit(qs[i], questionIndices[i], predictions[i], submitter);
        }
    }

    function getQuestions() constant returns (bytes32[] qs) {
        qs = new bytes32[](questions.length);
        for (uint i = 0; i < questions.length; i++) {
            qs[i] = questions[i].data;
        }
    }

    function getAnswers(uint questionIndex) constant returns (uint128[]) {
        Question q = questions[questionIndex];
        uint128[] memory answers = new uint128[](q.participants.length);
        for (uint i = 0; i < answers.length; i++) {
            answers[i] = q.predictionsOfParticipants[i][0];
        }

        return answers;
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
