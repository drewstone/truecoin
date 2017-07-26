pragma solidity ^0.4.10;

import './BayesianTruthMechanism.sol';

contract BayesianTruthSerumManager {
	using BayesianTruthMechanism for BayesianTruthMechanism.Manager;
	BayesianTruthMechanism.Manager manager;
	
	address public owner;
	event VoteSubmission(address sender, uint128 binary, uint128 meta);

	function BayesianTruthSerumManager() {
		owner = msg.sender;
	}

	function startMechanism() {
		require(manager.mechanism.initiationTime == 0);
		
		manager.init(60, 3);
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
	
	function submitVote(uint128 i, uint128 p) {
		manager.submit(msg.sender, i, p);
		VoteSubmission(msg.sender, i, p);
	}
}