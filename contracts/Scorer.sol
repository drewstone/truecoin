pragma solidity ^0.4.13;

/**
 * The Scorer
 */
contract Scorer {
    mapping (address => uint128[]) scoreMap;
    
    function getScoreOfParticipant(address taskAddr, uint participantIndex) constant returns (uint128) {
        return scoreMap[taskAddr][participantIndex];
    }
}

