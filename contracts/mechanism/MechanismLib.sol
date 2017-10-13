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
		bytes32[] tasks;
		uint8[] events;
		uint256 initiationTime;
		mapping (bytes32 => uint) taskIndex;
		mapping (bytes32 => address[]) participants;
		mapping (bytes32 => uint128[]) binaryPreds;
		mapping (bytes32 => uint128[]) metaPreds;
		mapping (bytes32 => bool[]) scored;
	}

	function init(M storage self, uint8[] events, bytes32[] tasks) internal {
		require(self.initiationTime == 0);

		self.tasks = tasks;
		self.events = events;
		self.initiationTime = now;

		for (uint i = 0; i < tasks.length; i++) {
			self.taskIndex[tasks[i]] = i+1;
		}
	}

	function submit(M storage self, bytes32 taskId, uint128 i, uint128 p, address submitter) internal {
		require(self.taskIndex[taskId] > 0);

		for (uint inx = 0; inx < self.participants[taskId].length; inx++) {
			require(self.participants[taskId][inx] != submitter);
		}

		self.participants[taskId].push(submitter);
		self.binaryPreds[taskId].push(i);
		self.metaPreds[taskId].push(p);
		self.scored[taskId].push(false);
	}
}
