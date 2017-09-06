pragma solidity ^0.4.10;

import './TrueMarketManager.sol';
import '../token/Truecoin.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {

	address TRC;
	uint public rewardInterval;

	address[] managers;
	mapping (address => uint) marketManagerIndex;

	function TruecoinProtocol(uint totalSupply, uint startInterval) {
		TRC = new Truecoin(totalSupply);
		lastRewardTime = now;
		rewardInterval = startInterval;

		rewards.length++;
		managers.length++;
	}

	function _checkRewardInterval(address manager)
		internal
	{
		assert(marketManagerIndex[manager] != 0);
		uint index = marketManagerIndex[manager];
		TrueMarketManager m = TrueMarketManager(managers[index]);

		// Pay out rewards for this managers' questions and set new time
		if (now >= m.lastRewardTime + rewardInterval) {
			this._payoutRewards(m);
			m.setRewardTime(now);
		}
	}

	function _payoutRewards(TrueMarketManager m)
		internal
	{
		Truecoin t = Truecoin(TRC);
		address[] recipients = m.getPaymentsByRecipient();
	}

	function createManager() {
		assert(marketManagerIndex[msg.sender] == 0);

		// Create space for new manager
		uint index = managers.length++;
		marketManagerIndex[managers] = index;

		// Create new manager and set new index place
		address m = new TrueMarketManager(msg.sender);
		managers[index] = m;
	}

	function submitPrediction(address manager, bytes32 questionId, uint128 i, uint128 p) {
		// Assert manager exists
		uint index = marketManagerIndex[manager];
		assert(managers[index] != address(0x0));

		// Submit prediction
		TrueMarketManager m = TrueMarketManager(managers[index]);
		m.submit(i, p, msg.sender, questionId);
	}
}
