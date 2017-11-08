pragma solidity ^0.4.10;

library MechanismLib {
	struct M {
		bytes32[] taskIds;
		address[] participants;
		uint8[] events;
		uint256 initiationTime;

		// Index of participants
		mapping (address => uint) participantIndex;
		
		// Index of tasks (redundant for indexing and iteration)
		mapping (bytes32 => uint) taskIndex;

		// Participants that have answered a specific task
		mapping (bytes32 => uint[]) taskParticipants;

		// Tasks answered by specific participant
		mapping (address => uint[]) answeredTaskIndex;
		
		// Binary predictions for a task
		mapping (bytes32 => uint128[]) binaryPreds;

		// Meta predictions for a task
		mapping (bytes32 => uint128[]) metaPreds;

		// Scored statistics for a task indexed as in participantIndex
		mapping (bytes32 => bool[]) scored;
	}

	function init(M storage self, uint8[] events, bytes32[] tasks) internal {
		require(self.initiationTime == 0);

		self.taskIds = tasks;
		self.events = events;
		self.initiationTime = now;
		self.participants.length++;

		for (uint i = 0; i < tasks.length; i++) {
			self.taskIndex[tasks[i]] = i+1;
		}
	}

	function submit(M storage self, bytes32 taskId, uint128 signal, uint128 posterior, address submitter) internal {
		require(self.taskIndex[taskId] > 0);

		// Ensure submitter has not submitted answers to this task
		for (uint i = 0; i < self.taskParticipants[taskId].length; i++) {
			if (self.participantIndex[submitter] == self.taskParticipants[taskId][i]) {
				return;
			}
		}

		// If participant hasn't answered questions, add to list of participants
		if (self.participantIndex[submitter] == 0) {
			self.participantIndex[submitter] = self.participants.length;
			self.participants.push(submitter);
			self.taskParticipants[taskId].push(self.participantIndex[submitter]);
		} else {
			self.taskParticipants[taskId].push(self.participantIndex[submitter]);
		}

		self.binaryPreds[taskId].push(signal);
		self.metaPreds[taskId].push(posterior);
		self.scored[taskId].push(false);
		self.answeredTaskIndex[submitter].push(self.taskIndex[taskId]);
	}

	function info(M storage self) internal returns (address[] a, bytes32[] b, uint8[] c, uint256 d) {
		a = self.participants;
		b = self.taskIds;
		c = self.events;
		d = self.initiationTime;
	}

	function getBinaryPreds(M storage self, address participant, uint[] taskIndices) internal returns (uint128[]) {
		uint128[] memory preds = new uint128[](taskIndices.length);

		for (uint i = 0; i < taskIndices.length; i++) {
			preds[i] = getBinaryPred(self, participant, taskIndices[i]);
		}

		return preds;
	}

	function getBinaryPred(M storage self, address participant, uint taskIndex) internal returns (uint128) {
		for (uint i = 0; i < self.taskParticipants[self.taskIds[taskIndex]].length; i++) {
			if (self.taskParticipants[self.taskIds[taskIndex]][i] == self.participantIndex[participant]) {
				return self.binaryPreds[self.taskIds[taskIndex]][i];
			}
		}

		return 0;
	}

	function getMetaPred(M storage self, address participant, uint taskIndex) internal returns (uint128) {
		for (uint i = 0; i < self.taskParticipants[self.taskIds[taskIndex]].length; i++) {
			if (self.taskParticipants[self.taskIds[taskIndex]][i] == self.participantIndex[participant]) {
				return self.metaPreds[self.taskIds[taskIndex]][i];
			}
		}

		return 0;
	}
}
