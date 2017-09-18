pragma solidity ^0.4.10;

import '../mechanism/RBTSMechanism.sol';
import '../token/Truecoin.sol';
import '../util/StringUtils.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {
	using StringUtils for string;

	address public TRC;
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

	function createNewMechanism(string question, string mechanismType) returns (bool) {
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
		}

		return false;
	}

	function submitPrediction(address manager, string mechanismType, string question, uint128 i, uint128 p) returns (bool) {
		// Assert manager exists
		uint index = mechanismIndex[manager];

		if (mechanismType.equal('RBTS')) {
			require(mechanismWrappers[index].RBTSIndex[question] != address(0x0));
			RBTSMechanism m = RBTSMechanism(mechanismWrappers[index].RBTSIndex[question]);
			m.submit(i, p, msg.sender);
			return true;
		}

		return false;
	}
}
