pragma solidity ^0.4.10;

import '../math/DSMath.sol';
import './Mechanism.sol';

contract EndogenousMechanism {
	address protocol;
	address[] mechanisms;
	mapping (bytes32 => uint) mechanismIndex;
	
	function EndogenousMechanism(address manager, bytes32[] tasks) {
		protocol = msg.sender;
		mechanisms.length++;
		for (uint i = 0; i < tasks.length; i++) {
			mechanismIndex[tasks[i]] = mechanisms.length;
			mechanisms[mechanisms.length++] = new Mechanism();
		}
	}

	function submit(bytes32 task, uint128 prediction, address submitter) isProtocol {
		address mechAddress = mechanisms[mechanismIndex[task]];
		Mechanism m = Mechanism(mechAddress);

		require(m.pOrdering[submitter] == 0);
		m.submit(prediction, 0, submitter);
	}

	modifier isProtocol() { 
		require(msg.sender == protocol); 
		_;
	}
}
