pragma solidity ^0.4.10;

library PredictionStore {
	struct Prediction {
		address creator;
		bytes32 ipfsHash
	}

	struct Store {
		bytes32[] predictions;
	}

	function init(Store storage self) {
		
	}
}