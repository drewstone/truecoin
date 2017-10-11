pragma solidity ^0.4.10;

import '../math/DSMath.sol';
import './Mechanism.sol';

contract EndogenousMechanism is Mechanism {	
	function EndogenousMechanism(address designer, uint8[] events, bytes32[] tasks) Mechanism(designer, events, tasks) {

	}

	function score() isManager returns (bool) {
		return true;
	}
}
