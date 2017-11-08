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

	function create(address designer, uint8 mechanismId, uint8[] events, bytes32 name, bytes32[] taskIds) isProtocol returns (bool) {
		if (mechanismIndex[designer] == 0) {
			mechanismIndex[designer] = mechanismWrappers.length++;
		}

		MechanismWrapper w = mechanismWrappers[mechanismIndex[designer]];

		if (mechanismId == 1) {
			RBTSMechanism r = new RBTSMechanism(designer, events, taskIds);
			w.RBTSIndex[name] = r;
		} else if (mechanismId == 2) {
			EndogenousMechanism e = new EndogenousMechanism(designer, events, taskIds);
			w.ENDGIndex[name] = e;
		} else {
			return false;
		}

		return true;
	}

	function submit(address designer, uint8 mechanismId, bytes32 name, bytes32 taskId, uint128 signal, uint128 posterior, address participant) isProtocol returns (bool) {
		require(mechanismIndex[designer] > 0);
		MechanismWrapper w = mechanismWrappers[mechanismIndex[designer]];

		if (mechanismId == 1) {
			RBTSMechanism r = RBTSMechanism(w.RBTSIndex[name]);
			r.submit(taskId, signal, posterior, participant);
		} else if (mechanismId == 2) {
			EndogenousMechanism e = EndogenousMechanism(w.ENDGIndex[name]);
			e.submit(taskId, signal, posterior, participant);
		} else if (mechanismId == 3) {

		} else if (mechanismId == 4) {

		} else if (mechanismId == 5) {

		} else if (mechanismId == 6) {

		} else {
			return false;
		}

		return true;
	}

	function score(address designer, uint8 mechanismId, bytes32 name, address participant) isProtocol returns (uint128) {
		require(mechanismIndex[designer] > 0);
		MechanismWrapper w = mechanismWrappers[mechanismIndex[designer]];

		if (mechanismId == 1) {
			RBTSMechanism r = RBTSMechanism(w.RBTSIndex[name]);
			return r.score(participant);
		} else if (mechanismId == 2) {
			EndogenousMechanism e = EndogenousMechanism(w.ENDGIndex[name]);
			return e.score(participant);
		} else if (mechanismId == 3) {

		} else if (mechanismId == 4) {

		} else if (mechanismId == 5) {

		} else if (mechanismId == 6) {

		}

		return 0;
	}

	function scoreTask(address designer, uint8 mechanismId, bytes32 name, bytes32 taskId, address participant) isProtocol returns (uint128) {
		require(mechanismIndex[designer] > 0);
		MechanismWrapper w = mechanismWrappers[mechanismIndex[designer]];

		if (mechanismId == 1) {
			RBTSMechanism r = RBTSMechanism(w.RBTSIndex[name]);
			return r.scoreTask(taskId, participant);
		} else if (mechanismId == 2) {
			EndogenousMechanism e = EndogenousMechanism(w.ENDGIndex[name]);
			return e.scoreTask(taskId, participant);
		} else if (mechanismId == 3) {

		} else if (mechanismId == 4) {

		} else if (mechanismId == 5) {

		} else if (mechanismId == 6) {

		}

		return 0;
	}

	function get(address designer, uint8 mechanismId, bytes32 name) returns (address) {
		require(mechanismIndex[designer] > 0);
		MechanismWrapper w = mechanismWrappers[mechanismIndex[designer]];

		if (mechanismId == 1) {
			return w.RBTSIndex[name];
		} else if (mechanismId == 2) {
			return w.ENDGIndex[name];
		} else if (mechanismId == 3) {

		} else if (mechanismId == 4) {

		} else if (mechanismId == 5) {

		} else if (mechanismId == 6) {

		}

		return address(0x0);
	}

	modifier isProtocol() { 
		require(msg.sender == protocol);
		_;
	}
}
