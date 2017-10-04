pragma solidity ^0.4.10;

library Mechanism {
	struct M {
		string question;
		uint8[] events;
		mapping (address => uint) pOrdering;
		bool[] scored;
		address[] participants;
		uint128[] binaryPreds;
		uint128[] metaPreds;
		uint256 initiationTime;
	}

	function init(M storage self, string question) internal {
		require(self.initiationTime == 0);
		self.question = question;
		self.events = [0,1];
		self.initiationTime = now;
		self.participants.length++;
	}

	function submit(M storage self, uint128 i, uint128 p, address submitter) internal {
		self.pOrdering[submitter] = self.participants.length;
		self.participants.push(submitter);
		self.binaryPreds.push(i);
		self.metaPreds.push(p);
		self.scored.push(false);
	}

	function clear(M storage self) internal {
		delete self.participants;
		delete self.binaryPreds;
		delete self.metaPreds;
	}

	function getBinaryPreds(M storage self) constant returns (address[], uint128[]) {
		return (self.participants, self.binaryPreds);
	}

	function getMetaPreds(M storage self) constant returns (address[], uint128[]) {
		return (self.participants, self.metaPreds);
	}

	function isScored(M storage self, address participant) constant returns (bool) {
		uint index = self.pOrdering[participant];
		return self.scored[index-1];
	}
}
