pragma solidity ^0.4.10;

contract Mechanism {
    event Submission(address submitter, bytes32 question, uint128[2] predictions);

    address public protocol;
    address public designer;
    bytes32 public name;
    bytes32 public keccak;
    bytes32 public description;
    bytes32[] public tags;

    address[] public participants;
    bytes32[] public events;
    uint256 public initiationTime;
    uint256 public terminationTime;

    uint128[] totalAnswersByOption;
    uint128 totalAnswers;

    struct Question {
        bytes32 data;
        uint[] participantIndices;
        uint128[2][] predictionsOfParticipants;
    }

    Question[] public questions;

    // Participants that have answered a specific question
    mapping (bytes32 => uint128[]) public participantsOfQuestion;
    mapping (address => uint) participantsIndex;
    

    // questions answered by specific participant
    mapping (address => uint128[]) public questionsOfParticipant;
    mapping (address => mapping (uint => uint)) hasAnsweredQuestion;

    function Mechanism(bytes32[] _events, bytes32[] _questions, uint128 _length, bytes32 _name, bytes32 _description, bytes32[] _tags, address _designer) public {
        require(initiationTime == 0);
        protocol = msg.sender;
        events = _events;
        name = _name;
        description = _description;
        tags = _tags;
        keccak = keccak256(_designer, _name);
        designer = _designer;

        totalAnswersByOption = new uint128[](_events.length);
        initiationTime = now;
        terminationTime = initiationTime + (_length * 1 days);
        participants.length++;

        for (uint i = 0; i < _questions.length; i++) {
            questions.length++;
            questions[i].data = _questions[i];
        }
    }

    function submit(bytes32 question, uint questionIndex, uint128[2] predictions, address submitter) public isLive {
        require(questions[questionIndex].data == question);
        require(hasAnsweredQuestion[submitter][questionIndex] == 0);
        require(msg.sender == protocol || msg.sender == submitter);
        hasAnsweredQuestion[submitter][questionIndex] = 1;

        if (participantsIndex[submitter] == 0) {
            participantsIndex[submitter] = participants.length;
            participants.push(submitter);
        }

        Question storage q = questions[questionIndex];
        q.predictionsOfParticipants.push(predictions);
        q.participantIndices.push(participantsIndex[submitter]);

        totalAnswers += 1;
        totalAnswersByOption[predictions[0]] += 1;
        Submission(submitter, question, predictions);
    }

    function submitBatch(bytes32[] qs, uint[] questionIndices, uint128[2][] predictions, address submitter) public isLive {
        require(msg.sender == protocol || msg.sender == submitter);

        for (uint i = 0; i < qs.length; i++) {
            submit(qs[i], questionIndices[i], predictions[i], submitter);
        }
    }

    function getQuestion(uint questionIndex) public view returns (bytes32, address[], uint128[2][]) {
        Question memory q = questions[questionIndex];
        address[] memory ps = new address[](q.participantIndices.length);
        for (uint i = 0; i < ps.length; i++) {
            ps[i] = participants[q.participantIndices[i]];
        }

        return (q.data, ps, q.predictionsOfParticipants);
    }

    function getQuestions() public view returns (bytes32[] qs) {
        qs = new bytes32[](questions.length);
        for (uint i = 0; i < questions.length; i++) {
            qs[i] = questions[i].data;
        }
    }

    function getAnswers(uint questionIndex) public view returns (uint128[2][]) {
        Question memory q = questions[questionIndex];
        uint128[2][] memory answers = new uint128[2][](q.participantIndices.length);
        for (uint i = 0; i < answers.length; i++) {
            answers[i] = q.predictionsOfParticipants[i];
        }

        return answers;
    }

    function getParticipantCount() public view returns (uint) {
        return participants.length - 1;
    }

    function getQuestionCount() public view returns (uint) {
        return questions.length;
    }

    function getAnswerQuestionCountOfParticipant(uint participantIndex) public view returns (uint) {
        return questionsOfParticipant[participants[participantIndex]].length;
    }

    function getParticipantCountOfQuestion(uint questionIndex) public view returns (uint) {
        Question memory q = questions[questionIndex];
        return q.participantIndices.length;
    }

    function getParticipantPredictionOfQuestion(uint questionIndex, uint participantIndexInQuestion) public view returns (uint128[2]) {
        Question memory q = questions[questionIndex];
        return q.predictionsOfParticipants[participantIndexInQuestion];
    }

    function getParticipantIndexFromQuestion(uint questionIndex, uint participantIndex) public view returns (uint) {
        Question memory q = questions[questionIndex];
        return q.participantIndices[participantIndex];
    }

    function getParticipantsOfQuestion(uint questionIndex) public view returns (uint[]) {
        Question memory q = questions[questionIndex];
        return q.participantIndices;
    }

    function getPredictionsOfQuestion(uint questionIndex) public view returns (uint128[2][]) {
        Question memory q = questions[questionIndex];
        return q.predictionsOfParticipants;
    }

    function getParticipant(uint participantIndex) public view returns (address) {
        return participants[participantIndex];
    }

    function getParticipants() public view returns (address[]) {
        address[] memory ps = new address[](participants.length - 1);
        for (uint i = 0; i < ps.length; i++) {
            ps[i] = participants[i+1];
        }

        return ps;
    }

    function getEvents() public view returns (bytes32[]) {
        return events;
    }

    function getTags() public view returns (bytes32[]) {
        return tags;
    }

    modifier isLive() { 
        require(now <= terminationTime);
        _; 
    }
            
}
