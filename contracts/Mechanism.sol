pragma solidity ^0.4.10;

library Mechanism {
	struct M {
		address parentContract;
		uint8[] events;
		mapping (address => uint) pOrdering;
		address[] participants;
		uint128[] binaryPreds;
		uint128[] metaPreds;
		uint256 initiationTime;
		uint256 expirationTime;
		bytes32 predictedOutcome;
	}

	function init(M storage self, uint128 numseconds)
		internal
	{
		require(self.initiationTime == 0);

		self.parentContract = this;
		self.events = [0,1];
		self.initiationTime = now;
		self.expirationTime = now +  numseconds * 1 seconds;
		self.participants.length++;
	}

	function submit(M storage self, address voter, uint128 i, uint128 p)
		internal
	{
		require(self.pOrdering[voter] == 0 && now < self.expirationTime);

		self.pOrdering[voter] = self.participants.length;
		self.participants.push(voter);
		self.binaryPreds.push(i);
		self.metaPreds.push(p);
	}

	function getBinaryPreds(M storage self)
		constant
		returns (address[], uint128[])
	{
		return (self.participants, self.binaryPreds);
	}

	function getMetaPreds(M storage self)
		constant
		returns (address[], uint128[])
	{
		return (self.participants, self.metaPreds);
	}
}
