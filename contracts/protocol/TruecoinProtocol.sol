pragma solidity ^0.4.10;

import '../mechanism/RBTSMechanism.sol';
import '../token/Truecoin.sol';

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocol {
	address public TRC;
	uint public rewardInterval;
	uint public lastRewardTime;

	struct MechanismWrappers {
		mapping (bytes32 => address) RBTSIndex;
	}

	MechanismWrappers[] mechanismWrappers;
	mapping (address => uint) mechanismIndex;

	function TruecoinProtocol(uint totalSupply, uint startInterval) {
		TRC = new Truecoin(totalSupply);
		rewardInterval = startInterval;
		mechanismWrappers.length++;
	}

	function createNewMechanism(bytes32 question, bytes32 mechanismType) returns (bool) {
		uint index;
		if (mechanismIndex[msg.sender] == 0) {
			// Create space for new manager
			index = mechanismWrappers.length++;
			mechanismIndex[msg.sender] = index;
		} else {
			index = mechanismIndex[msg.sender];
		}

		// Create new manager and set new index place
		if (mechanismType == 'RBTS') {
			if (mechanismWrappers[index].RBTSIndex[question] != address(0x0)) {
				return false;
			}

			address rbts = new RBTSMechanism(msg.sender, question);
			mechanismWrappers[index].RBTSIndex[question] = rbts;
			return true;
		}

		return false;
	}

	function submitPrediction(address manager, bytes32 mechanismType, bytes32 question, uint128 i, uint128 p) returns (bool) {
		// Assert manager exists
		uint index = mechanismIndex[manager];

		if (mechanismType == 'RBTS') {
			require(mechanismWrappers[index].RBTSIndex[question] != address(0x0));
			RBTSMechanism m = RBTSMechanism(mechanismWrappers[index].RBTSIndex[question]);
			m.submit(i, p, msg.sender);
			return true;
		}

		return false;
	}
}
