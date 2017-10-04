pragma solidity ^0.4.10;

library Designer {
	struct Task {
		bytes32 question;
		address[] workers;
		bool[] predictions;
	}

	struct D {
		Task[] tasks;
		uint budget;
	}
}