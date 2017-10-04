pragma solidity ^0.4.10;

import '../mechanism/RBTSMechanism.sol';
import '../token/Truecoin.sol';
import '../util/StringUtils.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {
	using StringUtils for string;

	Truecoin public TRC;
	uint public rewardInterval;
	uint public lastRewardTime;

	struct MechanismWrappers {
		mapping (string => address) RBTSIndex;
	}

	MechanismWrappers[] mechanismWrappers;
	mapping (address => uint) mechanismIndex;

	function TruecoinProtocol(uint totalSupply, uint startInterval) {
		TRC = new Truecoin(totalSupply);
		rewardInterval = startInterval;
		mechanismWrappers.length++;
	}

	function createNewMechanism(string mechanismType, string question) returns (bool) {
		uint index;

		if (mechanismIndex[msg.sender] == 0) {
			index = mechanismWrappers.length++;
			mechanismIndex[msg.sender] = index;
		} else {
			index = mechanismIndex[msg.sender];
		}

		// Create new manager and set new index place
		if (mechanismType.equal('RBTS')) {
			if (mechanismWrappers[index].RBTSIndex[question] != address(0x0)) {
				return false;
			}

			address rbts = new RBTSMechanism(msg.sender, question);
			mechanismWrappers[index].RBTSIndex[question] = rbts;
			return true;
		} else {
			return false;
		}
	}

	function submitPrediction(address manager, string mechanismType, string question, uint128 i, uint128 p)
		returns (bool)
	{
		require(mechanismIndex[manager] != 0);
		uint index = mechanismIndex[manager];

		if (mechanismType.equal('RBTS')) {
			RBTSMechanism m = RBTSMechanism(mechanismWrappers[index].RBTSIndex[question]);
			m.submit(i, p, msg.sender);
			return true;
		} else {
			return false;
		}
	}

	function claimReward(address manager, string mechanismType, string question)
		returns (uint256)
	{
		require(mechanismIndex[manager] != 0);
		uint index = mechanismIndex[manager];
		uint128 score;

		if (mechanismType.equal('RBTS')) {
			RBTSMechanism m = RBTSMechanism(mechanismWrappers[index].RBTSIndex[question]);
			score = m.score(msg.sender);
		} else {
			return score;
		}

		uint256 reward = determineMintedTokens(score);
		TRC.mint(msg.sender, reward);
		return reward;
	}

	function getMechanism(address manager, string mechanismType, string question)
		constant returns (address)
	{
		require(mechanismIndex[manager] != 0);
		uint index = mechanismIndex[manager];

		if (mechanismType.equal('RBTS')) {
			RBTSMechanism m = RBTSMechanism(mechanismWrappers[index].RBTSIndex[question]);
			return address(m);
		} else {
			return address(0x0);
		}
	}

	function determineMintedTokens(uint128 score) constant returns (uint256) {
		return uint256(score);
	}
}
