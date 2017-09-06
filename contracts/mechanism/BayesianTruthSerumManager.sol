pragma solidity ^0.4.10;

import './BayesianTruthMechanism.sol';

contract BayesianTruthSerumManager {
	using BayesianTruthMechanism for BayesianTruthMechanism.Manager;
	BayesianTruthMechanism.Manager manager;
	
	event VoteSubmission(address sender, uint128 binary, uint128 meta);

	function startMechanism(uint128 mins)
		internal
	{
		require(manager.mechanism.initiationTime == 0);
		manager.init(1 minutes * mins);
	}
	
	function getScores()
		constant
		returns (address[], uint128[])
	{
		var (participants, _, _, _) = this.getMechanismInfo();
		uint128[] scores = manager.score();

		return (participants, scores);
	}

	function getMechanismInfo()
		constant
		returns (address[], uint128[], uint128[], uint8[])
	{
		uint participantLength = manager.mechanism.participants.length - 1;
		address[] memory participants = new address[](participantLength);
		for (uint i = 0; i < participants.length; i++) {
			participants[i] = manager.mechanism.participants[i + 1];
		}

		return (
			participants,
			manager.mechanism.binaryPreds,
			manager.mechanism.metaPreds,
			manager.mechanism.events
		);
	}
	
	function submitVote(uint128 i, uint128 p, address submitter)
		internal
	{
		manager.submit(submitter, i, p);
		VoteSubmission(submitter, i, p);
	}
}