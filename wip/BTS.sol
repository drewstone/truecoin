pragma solidity ^0.4.11;

import './MechanismLib.sol';

contract BTS {
    address public owner;
    using MechanismLib for MechanismLib.Mechanism;
    MechanismLib.Mechanism m;
    
    event MechanismInfo(address[] participants, uint8[] events, uint start, uint expiration);

    function BTS() {
        owner = msg.sender;
        m.init();
    }
    
    function submitVote(uint i, uint num, uint den) {
        m.submit(msg.sender, i, num, den);
        MechanismInfo(m.participants, m.events, m.initiationTime, m.expirationTime);
    }

    function arithmeticMean(uint256[] a) internal returns (uint256, uint256) {
        uint256 sum = 0;
        uint256 rest = 0;

        for (uint i = 0; i < a.length; i++) {
            sum = sum.add(a[i] / a.length);
            rest = rest.add(a[i] % a.length);
            sum = sum.add(rest / a.
                length);
            rest = rest % a.length;
        }

        return (sum, rest);
    }    
}