pragma solidity ^0.4.10;

/**
 * The Scorer contract maintains the logic
 * for all scoring functions of mechanisms
 */
contract Scorer {
    address public protocol;
    function Scorer() {
        protocol = msg.sender;
    }

    function binaryrbts(uint128[] predictions, uint128[] metapreds) constant returns (uint128[]) {
        return new uint128[](0);
    }

    function endogenous(uint128[] predictions) constant returns (uint128[]) {
        return new uint128[](0);
    }
}
