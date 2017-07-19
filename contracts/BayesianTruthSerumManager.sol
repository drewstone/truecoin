pragma solidity ^0.4.4;

import './Mechanism.sol';

contract BayesianTruthSerumManager {
    using Mechanism for Mechanism.M;
    Mechanism.M mechanism;
    
    address public owner;
    event VoteSubmission(address sender, uint128 binary, uint128 meta);

    function BTS() {
        owner = msg.sender;
    }

    function startMechanism() {
        mechanism.init(60);
    }
    
    function submitVote(uint128 i, uint128 p) {
        mechanism.submit(msg.sender, i, p);
        VoteSubmission(msg.sender, i, p);
    }
}