pragma solidity ^0.4.10;

import '../mechanism/BayesianTruthSerumManager.sol';

/**
 * This contract allows users to create new BTS mechanisms
 */
contract MarketManager {

	struct PredictionMarket {
		address creator;
		bytes32 question;
		BayesianTruthSerumManager manager;
	}

	mapping (bytes32 => PredictionMarket) markets;

	function MarketManager() {
	}

	function createMarket(bytes32 question, uint128 mins) {
		BayesianTruthSerumManager bts = new BayesianTruthSerumManager();
		bts.startMechanism(mins);

		bytes32 marketHashIndex = sha3(msg.sender, question, mins);

		uint nonce = 1;
		while (markets[marketHashIndex].creator != address(0x0)) {
			marketHashIndex = sha3(msg.sender, question, mins, nonce);
			nonce = nonce + 1;
		}

		markets[marketHashIndex] = PredictionMarket({
			creator: msg.sender,
			question: question,
			manager: bts
		});
	}
}
