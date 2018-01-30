pragma solidity ^0.4.10;

contract Mechanism {
	address public protocol;
	address public manager;
	address public designer;
	bool public initialized;
	
	bytes32[] public questionIds;
	address[] public participants;
	uint8[] public events;
	uint256 public timeLength;
	uint256 public initiationTime;
	uint256 public terminationTime;

	// Index of participants
	mapping (address => uint) public participantIndex;
	
	// Index of questions (redundant for indexing and iteration)
	mapping (bytes32 => uint) public questionIndex;

	// Participants that have answered a specific question
	mapping (bytes32 => uint[]) public questionParticipants;

	// questions answered by specific participant
	mapping (address => uint[]) public answeredQuestionIndex;
	
	// Binary predictions for a question
	mapping (bytes32 => uint128[]) public binaryPreds;

	// Meta predictions for a question
	mapping (bytes32 => uint128[]) public metaPreds;

	// Scored statistics for a question indexed as in participantIndex
	mapping (bytes32 => bool[]) public scored;

	function setup(address prtcl, address mngr, uint length) {
		protocol = prtcl;
		manager = mngr;
		timeLength = length;
	}

	function _init(uint8[] evts, bytes32[] questions) internal {
		require(initiationTime == 0);
		require(!initialized);

		initialized = true;
		questionIds = questions;
		events = evts;
		initiationTime = now;
		terminationTime = initiationTime + timeLength;
		participants.length++;

		for (uint i = 0; i < questions.length; i++) {
			questionIndex[questions[i]] = i+1;
		}
	}

	function _submit(bytes32 questionId, uint128 signal, uint128 posterior, address submitter) isLive isManager internal {
		require(questionIndex[questionId] > 0);

		// Ensure submitter has not submitted answers to this question
		for (uint i = 0; i < questionParticipants[questionId].length; i++) {
			require(participantIndex[submitter] != questionParticipants[questionId][i]
				|| participantIndex[submitter] == 0);
		}

		// If participant hasn't answered questions, add to list of participants
		if (participantIndex[submitter] == 0) {
			participantIndex[submitter] = participants.length;
			participants.push(submitter);
			questionParticipants[questionId].push(participantIndex[submitter]);
		} else {
			questionParticipants[questionId].push(participantIndex[submitter]);
		}

		binaryPreds[questionId].push(signal);
		metaPreds[questionId].push(posterior);
		scored[questionId].push(false);
		answeredQuestionIndex[submitter].push(questionIndex[questionId]);
	}

	function _info() internal returns (address[], bytes32[], uint8[], uint256) {
		return (participants, questionIds, events, initiationTime);
	}

	function getParticipantIndexByQuestion(address participant, bytes32 question) returns (uint) {
		for (uint i = 0; i < questionParticipants[question].length; i++) {
			if (questionParticipants[question][i] == participantIndex[participant]) {
				return i;
			}
		}

		return questionParticipants[question].length;
	}

	function getBinaryPreds(address participant, bytes32[] questions) returns (uint128[]) {
		uint128[] memory preds = new uint128[](questions.length);

		for (uint i = 0; i < questions.length; i++) {
			preds[i] = getBinaryPred(participant, questions[i]);
		}

		return preds;
	}

	function getBinaryPred(address participant, bytes32 question) returns (uint128) {
		for (uint i = 0; i < questionParticipants[question].length; i++) {
			if (questionParticipants[question][i] == participantIndex[participant]) {
				return binaryPreds[question][i];
			}
		}

		return 0;
	}

	function getMetaPred(address participant, bytes32 question) returns (uint128) {
		for (uint i = 0; i < questionParticipants[question].length; i++) {
			if (questionParticipants[question][i] == participantIndex[participant]) {
				return metaPreds[question][i];
			}
		}

		return 0;
	}

	function getParticipants() returns (address[] p) {
		p = participants;
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
