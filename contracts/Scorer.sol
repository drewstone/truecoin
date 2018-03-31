pragma solidity ^0.4.13;

/**
 * The Scorer
 */
contract Scorer {
    mapping (address => uint128[]) scoreMap;
    
    function getScoreOfParticipant(address taskAddr, uint participantIndex) public view returns (uint128) {
        return scoreMap[taskAddr][participantIndex];
    }

    function score(bytes32 taskName, address designer) public returns (uint128[] scores);
}

