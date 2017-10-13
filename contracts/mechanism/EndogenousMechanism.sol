pragma solidity ^0.4.10;

import '../math/DSMath.sol';
import './MechanismLib.sol';

contract EndogenousMechanism {	
	using MechanismLib for MechanismLib.M;
	MechanismLib.M mechanism;
	
	address public manager;
	address public designer;
	mapping (bytes32 => uint) participantCount;

	function EndogenousMechanism(address mechanismDesigner, uint8[] events, bytes32[] tasks) {
		manager = msg.sender;
		designer = mechanismDesigner;
		mechanism.init(events, tasks);
	}

	function submit(bytes32 taskId, uint128 signal, uint128 posterior, address participant) {
		mechanism.submit(taskId, signal, posterior, participant);
		participantCount[taskId] = participantCount[taskId] + 1;
	}

	function score() returns (bool) {
		return true;
	}
}
