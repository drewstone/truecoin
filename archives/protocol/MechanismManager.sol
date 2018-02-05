pragma solidity ^0.4.10;

import '../mechanism/RBTSMechanism.sol';
import '../mechanism/EndogenousMechanism.sol';

contract MechanismManager {
	address public protocol;
	address[] public openMechanisms;

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

	// function create(address designer, uint8 mechanismId, bytes32 taskName, uint8[] events, bytes32[] questions, uint256 timeLength) isProtocol returns (address) {
	// 	if (mechanismIndex[designer] == 0) {
	// 		mechanismIndex[designer] = mechanismWrappers.length++;
	// 	}

	// 	address contractAddress;
	// 	if (mechanismId == 1) {
	// 		contractAddress = new RBTSMechanism(events, questions);
	// 		RBTSMechanism(contractAddress).setup(protocol, this, timeLength);
	// 		mechanismWrappers[mechanismIndex[designer]].RBTSIndex[taskName] = contractAddress;
	// 	} else if (mechanismId == 2) {
	// 		contractAddress = new EndogenousMechanism(events, questions);
	// 		EndogenousMechanism(contractAddress).setup(protocol, this, timeLength);
	// 		mechanismWrappers[mechanismIndex[designer]].ENDGIndex[taskName] = contractAddress;
	// 	} else {
	// 		revert();
	// 	}

	// 	return contractAddress;
	// }

	function setup(address designer, uint8 mechanismId, bytes32 taskName, address mechContract, uint256 timeLength) isProtocol returns (bool) {
		if (mechanismIndex[designer] == 0) {
			mechanismIndex[designer] = mechanismWrappers.length++;
		}

		if (mechanismId == 1) {
			require(RBTSMechanism(mechContract).designer() == designer);

			RBTSMechanism(mechContract).setup(msg.sender, this, timeLength);
			mechanismWrappers[mechanismIndex[designer]].RBTSIndex[taskName] = mechContract;
		} else if (mechanismId == 2) {
			require(EndogenousMechanism(mechContract).designer() == designer);

			EndogenousMechanism(mechContract).setup(protocol, this, timeLength);
			mechanismWrappers[mechanismIndex[designer]].ENDGIndex[taskName] = mechContract;
		} else {
			return false;
		}

		openMechanisms.push(mechContract);
		return true;
	}

	function settle(address designer, uint8 mechanismId, bytes32 taskName, address mechContract) isProtocol returns (bool) {
		require(mechanismIndex[designer] != 0);

		uint128[] memory scores;
		address[] memory participants;
		uint[] memory binaryPreds;

		if (mechanismId == 1) {
			require(RBTSMechanism(mechContract).designer() == designer);
			require(RBTSMechanism(mechContract).terminationTime() < now);
		} else if (mechanismId == 2) {
			require(EndogenousMechanism(mechContract).designer() == designer);
			require(EndogenousMechanism(mechContract).terminationTime() < now);
		} else {
			return false;
		}

		return true;
	}

	function submit(address designer, uint8 mechanismId, bytes32 taskName, bytes32 questionId, uint128 signal, uint128 posterior, address participant) isProtocol returns (bool) {
		require(mechanismIndex[designer] != 0);

		if (mechanismId == 1) {
			RBTSMechanism(mechanismWrappers[mechanismIndex[designer]].RBTSIndex[taskName])
			.submit(questionId, signal, posterior, participant);
		} else if (mechanismId == 2) {
			EndogenousMechanism(mechanismWrappers[mechanismIndex[designer]].ENDGIndex[taskName])
			.submit(questionId, signal, posterior, participant);
		} else {
			return false;
		}

		return true;
	}

	/*
	 *	------------------------ VERSION 1 software - LEGACY functionality ------------------------
	 */

	function score(address designer, uint8 mechanismId, bytes32 taskName, address participant) isProtocol returns (uint128) {
		require(mechanismIndex[designer] != 0);

		if (mechanismId == 1) {
			return RBTSMechanism(mechanismWrappers[mechanismIndex[designer]].RBTSIndex[taskName])
			.scoreParticipant(participant);
		} else if (mechanismId == 2) {
			return EndogenousMechanism(mechanismWrappers[mechanismIndex[designer]].ENDGIndex[taskName])
			.scoreParticipant(participant);
		}

		return 0;
	}

	function scoreQuestionByParticipant(address designer, uint8 mechanismId, bytes32 taskName, bytes32 questionId, address participant) isProtocol returns (uint128) {
		require(mechanismIndex[designer] != 0);

		if (mechanismId == 1) {
			return RBTSMechanism(mechanismWrappers[mechanismIndex[designer]].RBTSIndex[taskName])
			.scoreQuestionByParticipant(questionId, participant);
		} else if (mechanismId == 2) {
			return EndogenousMechanism(mechanismWrappers[mechanismIndex[designer]].ENDGIndex[taskName])
			.scoreQuestionByParticipant(questionId, participant);
		}

		return 0;
	}

	/*
	 * --------------------------------------------------------------------------------------------
	 */

	function getOpenMechanisms() constant returns (address[]) {
		if (openMechanisms.length == 0) {
			return new address[](0);
		} else {
			return openMechanisms;
		}
	}
	

	function get(address designer, uint8 mechanismId, bytes32 taskName) constant returns (address) {
		require(mechanismIndex[designer] > 0);

		if (mechanismId == 1) {
			return mechanismWrappers[mechanismIndex[designer]].RBTSIndex[taskName];
		} else if (mechanismId == 2) {
			return mechanismWrappers[mechanismIndex[designer]].ENDGIndex[taskName];
		}

		return address(0x0);
	}

	modifier isProtocol() { 
		require(msg.sender == protocol);
		_;
	}
}
