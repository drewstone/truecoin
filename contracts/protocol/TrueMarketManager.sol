pragma solidity ^0.4.10;

import '../mechanism/BayesianTruthSerumManager.sol';

/**
 * This contract allows users to create new BTS mechanisms
 */
contract TrueMarketManager {
	address public manager;
	address public TRC;
	uint public lastRewardTime;

	struct PredictionMarket {
		bytes32 question;
		BayesianTruthSerumManager manager;
	}

	PredictionMarket[] markets;
	mapping (bytes32 => uint) marketIndex;

	function MarketManager(address creator) {
		manager = creator;
		markets.length++;
	}

	function setRewardTime(uint time)
		internal
		isTRC
	{
		lastRewardTime = time;
	}

	function transferOwnership(address newOwner)
		internal
		isManager
	{
		manager = newOwner;
	}

	function create(bytes32 question, uint128 mins)
		internal
		isManager
	{
		// Ensure no repetitive questions by hash
		assert(marketIndex[sha3(manager, question, mins)] != 0)
		BayesianTruthSerumManager bts = new BayesianTruthSerumManager();
		bts.startMechanism(mins);

		// Save market to history
		bytes32 marketHashIndex = sha3(manager, question, mins);
		uint index = markets.length++;
		marketIndex[marketHashIndex] = index;
		markets[index] = PredictionMarket({question: question, manager: bts});
	}

	function submit(uint128 i, uint128 p, address submitter, bytes32 questionId)
		internal
	{
		PredictionMarket pm = markets[questionId];
		BayesianTruthSerumManager m = pm.manager;
		m.submitVote(i, p, submitter);
	}

	function getPaymentsByRecipient() {
		for (uint i = 0; i < markets.length; i++) {
			PredictionMarket pm = markets[i];
			var (participants, scores) = pm.manager.getScores();

		}
	}

	modifier isManager() { 
		if (msg.sender != manager) throw; 
		_; 
	}
	
	modifier isTRC() { 
		if (msg.sender != TRC) throw; 
		_; 
	}
	
}
