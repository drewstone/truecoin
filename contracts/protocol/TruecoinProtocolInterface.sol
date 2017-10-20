pragma solidity ^0.4.10;

/**
 * This contract handles the Truecoin protocol
 */
contract TruecoinProtocolInterface {
	function createNewMechanism(uint8 mechanismId, uint8[] events, bytes32 id, bytes32[] questions) returns (bool);
	function submitPrediction(address manager, string mechanismType, bytes32 id, bytes32 question, uint128 i, uint128 p) returns (bool);
	function claimReward(address manager, string mechanismType, bytes32 id, bytes32 question) returns (uint256);
	function getMechanism(address manager, string mechanismType, bytes32 question) constant returns (address);
	function determineMintedTokens(uint128 score) constant returns (uint256);
}
