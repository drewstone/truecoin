pragma solidity ^0.4.10;

import '../mechanism/RBTSMechanism.sol';
import '../mechanism/EndogenousMechanism.sol';

contract MechanismManager {
	address public protocol;

	struct MechanismWrapper {
		mapping (bytes32 => address) RBTSIndex;
		mapping (bytes32 => address) ENDGIndex;
	}

	MechanismWrapper[] mechanismWrappers;
	mapping (address => uint) mechanismIndex;

	function MechanismManager() {
		protocol = msg.sender;
		mechanismWrappers.length++;
	}

	function create(address designer, uint8 mechanismId, uint8[] events, bytes32 taskId, bytes32[] tasks) returns (bool) {
		if (mechanismIndex[designer] == 0) {
			mechanismIndex[designer] = mechanismWrappers.length++;
		}

		MechanismWrapper w = mechanismWrappers[mechanismIndex[designer]];

		if (mechanismId == 1) {
			RBTSMechanism r = new RBTSMechanism(designer, events, tasks);
			w.RBTSIndex[taskId] = r;
		} else if (mechanismId == 2) {
			EndogenousMechanism e = new EndogenousMechanism(designer, events, tasks);
			w.ENDGIndex[taskId] = e;
		} else {
			return false;
		}

		return true;
	}

	function submit(address designer, uint8 mechanismId, bytes32 taskId, uint128 i, uint128 p, address participant) returns (bool) {
		require(mechanismIndex[designer] > 0);
		MechanismWrapper w = mechanismWrappers[mechanismIndex[designer]];

		if (mechanismId == 1) {
			RBTSMechanism r = RBTSMechanism(w.RBTSIndex[taskId]);
			r.submit(taskId, i, p, participant);
		} else if (mechanismId == 2) {
			EndogenousMechanism e = EndogenousMechanism(w.ENDGIndex[taskId]);
			e.submit(taskId, i, p, participant);
		} else if (mechanismId == 3) {

		} else if (mechanismId == 4) {

		} else if (mechanismId == 5) {

		} else if (mechanismId == 6) {

		} else {
			return false;
		}

		return true;
	}
}