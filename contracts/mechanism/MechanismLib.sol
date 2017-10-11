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
		Task[] tasks;
		uint8[] events;
		uint256 initiationTime;
		mapping (bytes32 => uint) taskIndex;
	}

	function init(M storage self, uint8[] events, bytes32[] tasks) internal {
		require(self.initiationTime == 0);

		self.tasks.length++;
		self.events = events;
		self.initiationTime = now;

		for (uint i = 0; i < tasks.length; i++) {
			self.taskIndex[tasks[i]] = self.tasks.length++;
			self.tasks.push(Task({
				question: tasks[i],
				scored: new bool[](0),
				participants: new address[](0),
				binaryPreds: new uint128[](0),
				metaPreds: new uint128[](0)
			}));
		}
	}

	function submit(M storage self, bytes32 taskId, uint128 i, uint128 p, address submitter) internal {
		require(self.taskIndex[taskId] > 0);
		Task t = self.tasks[self.taskIndex[taskId]];

		require(t.pOrdering[submitter] == 0);
		t.participants.push(submitter);
		t.binaryPreds.push(i);
		t.metaPreds.push(p);
		t.scored.push(false);
		t.pOrdering[submitter] = t.participants.length;
	}
}
