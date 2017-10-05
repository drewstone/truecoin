pragma solidity ^0.4.10;

contract Mechanism {
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

	function init(M storage self, uint8[] events, bytes32[] questions) internal {
		require(self.initiationTime == 0);

		self.tasks.length++;
		self.events = events;
		self.initiationTime = now;

		for (uint i = 0; i< questions.length; i++) {
			self.taskIndex[questions[i]] = self.tasks.length;
			self.tasks.push(Task(questions[i]));
		}
	}

	function submit(M storage self, bytes32 question, uint128 i, uint128 p, address submitter) internal {
		require(self.taskIndex[question] != 0);
		Task t = self.tasks[self.taskIndex[question]];

		require(t.pOrdering[submitter] == 0);
		t.participants.push(submitter);
		t.binaryPreds.push(i);
		t.metaPreds.push(p);
		t.scored.push(false);
		t.pOrdering[submitter] = t.participants.length;
	}

	function clear(M storage self) internal {
		delete self.participants;
		delete self.binaryPreds;
		delete self.metaPreds;
		self.participants.length++;
	}
}
