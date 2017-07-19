pragma solidity ^0.4.11;

library MechanismLib {    
    struct Mechanism {
        address parentContract;
        uint8[] events;
        mapping (address => uint) pOrdering;
        address[] participants;
        uint[] informationValues;
        uint[] numeratorPreds;
        uint[] denominatorPreds;
        uint initiationTime;
        uint expirationTime;
        bytes32 predictedOutcome;
    }

    function init(Mechanism storage self) {
        if (self.initiationTime == 0) {
            self.parentContract = this;
            self.events = [0,1];
            self.initiationTime = now;
            self.expirationTime = now + 1 weeks;
            self.participants.length++;
        }
    }

    function submit(Mechanism storage self, address voter, uint i, uint pNum, uint pDen) isParent(self) {
        if (self.pOrdering[voter] == 0 && now <= self.expirationTime) {
            self.pOrdering[voter] = self.participants.length++;
            self.participants.push(voter);
            self.informationValues.push(i);
            self.numeratorPreds.push(pNum);
            self.denominatorPreds.push(pDen);
        }
    }

    modifier isParent(Mechanism self) {
        if (msg.sender == self.parentContract) {
            _;
        }
    }
}