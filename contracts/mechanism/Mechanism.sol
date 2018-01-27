pragma solidity ^0.4.10;

contract Mechanism {
	address public protocol;
	address public manager;
	address public designer;
	bool public initialized;
	
	bytes32[] public taskIds;
	address[] public participants;
	uint8[] public events;
	uint256 public timeLength;
	uint256 public initiationTime;
	uint256 public terminationTime;

	// Index of participants
	mapping (address => uint) public participantIndex;
	
	// Index of tasks (redundant for indexing and iteration)
	mapping (bytes32 => uint) public taskIndex;

	// Participants that have answered a specific task
	mapping (bytes32 => uint[]) public taskParticipants;

	// Tasks answered by specific participant
	mapping (address => uint[]) public answeredTaskIndex;
	
	// Binary predictions for a task
	mapping (bytes32 => uint128[]) public binaryPreds;

	// Meta predictions for a task
	mapping (bytes32 => uint128[]) public metaPreds;

	// Scored statistics for a task indexed as in participantIndex
	mapping (bytes32 => bool[]) public scored;

	function setup(address prtcl, address mngr, uint length) {
		protocol = prtcl;
		manager = mngr;
		timeLength = length;
	}

	function _init(uint8[] evts, bytes32[] tasks) internal {
		require(initiationTime == 0);
		require(!initialized);

		initialized = true;
		taskIds = tasks;
		events = evts;
		initiationTime = now;
		terminationTime = initiationTime + timeLength;
		participants.length++;

		for (uint i = 0; i < tasks.length; i++) {
			taskIndex[tasks[i]] = i+1;
		}
	}

	function _submit(bytes32 taskId, uint128 signal, uint128 posterior, address submitter) isLive isManager internal {
		require(taskIndex[taskId] > 0);

		// Ensure submitter has not submitted answers to this task
		for (uint i = 0; i < taskParticipants[taskId].length; i++) {
			if (participantIndex[submitter] == taskParticipants[taskId][i]) {
				return;
			}
		}

		// If participant hasn't answered questions, add to list of participants
		if (participantIndex[submitter] == 0) {
			participantIndex[submitter] = participants.length;
			participants.push(submitter);
			taskParticipants[taskId].push(participantIndex[submitter]);
		} else {
			taskParticipants[taskId].push(participantIndex[submitter]);
		}

		binaryPreds[taskId].push(signal);
		metaPreds[taskId].push(posterior);
		scored[taskId].push(false);
		answeredTaskIndex[submitter].push(taskIndex[taskId]);
	}

	function _info() internal returns (address[], bytes32[], uint8[], uint256) {
		return (participants, taskIds, events, initiationTime);
	}

	function getParticipantIndexByTask(address participant, bytes32 task) returns (uint) {
		for (uint i = 0; i < taskParticipants[task].length; i++) {
			if (taskParticipants[task][i] == participantIndex[participant]) {
				return i;
			}
		}

		return taskParticipants[task].length;
	}

	function getBinaryPreds(address participant, bytes32[] tasks) returns (uint128[]) {
		uint128[] memory preds = new uint128[](tasks.length);

		for (uint i = 0; i < tasks.length; i++) {
			preds[i] = getBinaryPred(participant, tasks[i]);
		}

		return preds;
	}

	function getBinaryPred(address participant, bytes32 task) returns (uint128) {
		for (uint i = 0; i < taskParticipants[task].length; i++) {
			if (taskParticipants[task][i] == participantIndex[participant]) {
				return binaryPreds[task][i];
			}
		}

		return 0;
	}

	function getMetaPred(address participant, bytes32 task) returns (uint128) {
		for (uint i = 0; i < taskParticipants[task].length; i++) {
			if (taskParticipants[task][i] == participantIndex[participant]) {
				return metaPreds[task][i];
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
