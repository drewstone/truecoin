pragma solidity ^0.4.10;

library MechanismLib {
	struct Task {
		bytes32 question;
		mapping (address => uint) pOrdering;
		bool[] scored;
		address[] participants;
		uint128[] binaryPreds;
		uint128[] metaPreds;
	}

	struct M {
		bytes32[] taskIds;
		address[] participants;
		uint8[] events;
		uint256 initiationTime;

		mapping (bytes32 => uint) taskIndex;
		mapping (bytes32 => uint[]) participantIndex;
		mapping (address => uint[]) answeredTaskIndex;
		
		mapping (bytes32 => uint128[]) binaryPreds;
		mapping (bytes32 => uint128[]) metaPreds;
		mapping (bytes32 => bool[]) scored;
	}

	function init(M storage self, uint8[] events, bytes32[] taskIds) internal {
		require(self.initiationTime == 0);

		self.taskIds = taskIds;
		self.events = events;
		self.initiationTime = now;

		for (uint i = 0; i < taskIds.length; i++) {
			self.taskIndex[taskIds[i]] = i+1;
		}
	}

	function submit(M storage self, bytes32 taskId, uint128 i, uint128 p, address submitter) internal {
		require(self.taskIndex[taskId] > 0);

		// Ensure submitter has not submitted answers to this task
		for (uint inx = 0; inx < self.participantIndex[taskId].length; inx++) {
			uint pInx = self.participantIndex[taskId][inx];
			require(self.participants[pInx] != submitter);
		}

		// If participant hasn't answered questions, add to list of participants
		if (self.answeredTaskIndex[submitter].length == 0) {
			self.participants.push(submitter);
			self.participantIndex[taskId].push(self.participants.length - 1);
		} else {
			uint tempTaskIndex = self.answeredTaskIndex[submitter][0];
			bytes32 tId = self.taskIds[tempTaskIndex];
			self.participantIndex[taskId].push(getParticipantIndex(self, tId, submitter));
		}

		self.binaryPreds[taskId].push(i);
		self.metaPreds[taskId].push(p);
		self.scored[taskId].push(false);
		self.answeredTaskIndex[submitter].push(self.taskIndex[taskId]);
	}

	function info(M storage self) internal returns (address[] a, bytes32[] b, uint8[] c, uint256 d) {
		a = self.participants;
		b = self.taskIds;
		c = self.events;
		d = self.initiationTime;
	}

	function getParticipantIndex(M storage self, bytes32 taskId, address participant) constant returns (uint) {
		for (uint i = 0; i < self.participantIndex[taskId].length; i++) {
			uint pInx = self.participantIndex[taskId][i];
			if (self.participants[pInx] == participant) {
				return i;
			}
		}

		// hardcoded error amount
		return 999999999;
	}
}
