pragma solidity ^0.4.10;

import './MechanismLib.sol';

/**
 * This contract does this and that...
 */
contract Mechanism {
	using MechanismLib for MechanismLib.M;
	MechanismLib.M mechanism;
	
	address public manager;
	address public designer;
	mapping (bytes32 => uint) participantCount;

	function Mechanism(address mechanismDesigner, uint8[] events, bytes32[] tasks) {
		manager = msg.sender;
		designer = mechanismDesigner;
		mechanism.init(events, tasks);
	}

	function submit(bytes32 taskId, uint128 signal, uint128 posterior, address participant) isManager {
		mechanism.submit(taskId, signal, posterior, participant);
		participantCount[taskId] = participantCount[taskId] + 1;
	}

	function getInfo(bytes32 taskId) constant returns (address[], uint128[], uint128[], uint8[]) {
		var task = mechanism.tasks[mechanism.taskIndex[taskId]];

		return (task.participants, task.binaryPreds, task.metaPreds, mechanism.events);
	}

	modifier isManager() { 
		require(msg.sender == manager); 
		_;
	}
}
