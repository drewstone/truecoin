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

	function MechanismManager(address prtcl) {
		protocol = prtcl;
		mechanismWrappers.length++;
	}

	function set(address designer, uint8 mechanismId, bytes32 name, address mechContract, uint256 timeLength) isProtocol returns (bool) {
		if (mechanismIndex[designer] == 0) {
			mechanismIndex[designer] = mechanismWrappers.length++;
		}

		if (mechanismId == 1) {
			require(RBTSMechanism(mechContract).designer() == designer);

			RBTSMechanism(mechContract).setup(msg.sender, this);
			mechanismWrappers[mechanismIndex[designer]].RBTSIndex[name] = mechContract;
		} else if (mechanismId == 2) {
			require(EndogenousMechanism(mechContract).designer() == designer);

			EndogenousMechanism(mechContract).setup(protocol, this);
			mechanismWrappers[mechanismIndex[designer]].ENDGIndex[name] = mechContract;
		} else {
			return false;
		}

		return true;
	}

	function submit(address designer, uint8 mechanismId, bytes32 name, bytes32 taskId, uint128 signal, uint128 posterior, address participant) isProtocol returns (bool) {
		require(mechanismIndex[designer] > 0);

		if (mechanismId == 1) {
			RBTSMechanism(mechanismWrappers[mechanismIndex[designer]].RBTSIndex[name])
			.submit(taskId, signal, posterior, participant);
		} else if (mechanismId == 2) {
			EndogenousMechanism(mechanismWrappers[mechanismIndex[designer]].ENDGIndex[name])
			.submit(taskId, signal, posterior, participant);
		} else {
			return false;
		}

		return true;
	}

	function score(address designer, uint8 mechanismId, bytes32 name, address participant) isProtocol returns (uint128) {
		require(mechanismIndex[designer] > 0);

		if (mechanismId == 1) {
			return RBTSMechanism(mechanismWrappers[mechanismIndex[designer]].RBTSIndex[name])
			.score(participant);
		} else if (mechanismId == 2) {
			return EndogenousMechanism(mechanismWrappers[mechanismIndex[designer]].ENDGIndex[name])
			.score(participant);
		}

		return 0;
	}

	function scoreTask(address designer, uint8 mechanismId, bytes32 name, bytes32 taskId, address participant) isProtocol returns (uint128) {
		require(mechanismIndex[designer] > 0);

		if (mechanismId == 1) {
			return RBTSMechanism(mechanismWrappers[mechanismIndex[designer]].RBTSIndex[name])
			.scoreTask(taskId, participant);
		} else if (mechanismId == 2) {
			return EndogenousMechanism(mechanismWrappers[mechanismIndex[designer]].ENDGIndex[name])
			.scoreTask(taskId, participant);
		}

		return 0;
	}

	function get(address designer, uint8 mechanismId, bytes32 name) returns (address) {
		require(mechanismIndex[designer] > 0);

		if (mechanismId == 1) {
			return mechanismWrappers[mechanismIndex[designer]].RBTSIndex[name];
		} else if (mechanismId == 2) {
			return mechanismWrappers[mechanismIndex[designer]].ENDGIndex[name];
		}

		return address(0x0);
	}

	modifier isProtocol() { 
		require(msg.sender == protocol);
		_;
	}
}
