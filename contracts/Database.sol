pragma solidity ^0.4.10;

import './Math.sol';

/**
 * The Database contract does this and that...
 */
library Database {    
    struct DB {
        address[] participants;
        address[] designers;
        address[] tasks;
        mapping (address => address) designerByTaskMechanism;
        mapping (address => bytes32[]) taskHashesByDesigner;
        mapping (bytes32 => bytes32[]) questionsByTaskHash;
        mapping (bytes32 => bytes32) descriptionByTaskHash;
        mapping (bytes32 => bytes32[]) tagsByTaskHash;
        mapping (address => address[]) answeredTasksByParticipant;
        mapping (address => mapping (address => uint)) hasAnsweredTaskByParticipant;
    }

    function addTaskMechanism(DB storage self, address taskMechanism, bytes32 taskName, bytes32[] questions, bytes32 description, bytes32[] tags) internal {
        require(self.designerByTaskMechanism[taskMechanism] == address(0));

        if (self.taskHashesByDesigner[msg.sender].length == 0) {
            self.designers.push(msg.sender);
        }

        self.tasks.push(taskMechanism);
        self.designerByTaskMechanism[taskMechanism] = msg.sender;

        bytes32 taskHash = keccak256(msg.sender, taskName);
        self.taskHashesByDesigner[msg.sender].push(taskHash);
        self.questionsByTaskHash[taskHash] = questions;
        self.descriptionByTaskHash[taskHash] = description;
        self.tagsByTaskHash[taskHash] = tags;
    }

    function getDistinctTasks(DB storage self, address _p1, address _p2) public view returns (address[], address[]) {
        uint[4] memory counters;

        address[] memory p1TaskAddresses = new address[](self.answeredTasksByParticipant[_p1].length);
        address[] memory p2TaskAddresses = new address[](self.answeredTasksByParticipant[_p2].length);

        for (uint i = 0; i < Math.min(p1TaskAddresses.length, p2TaskAddresses.length); i++) {
            // If participant 2 has not answered participant 1's i'th task, then it is distinct
            if (self.hasAnsweredTaskByParticipant[_p2][self.answeredTasksByParticipant[_p1][i]] == 0) {
                p1TaskAddresses[counters[1]] = self.answeredTasksByParticipant[_p1][i];
                counters[1] += 1;
            } else {
                counters[0] += 1;
            }

            // If participant 2 has not answered participant 1's i'th task, then it is distinct
            if (self.hasAnsweredTaskByParticipant[_p1][self.answeredTasksByParticipant[_p2][i]] == 0) {
                p2TaskAddresses[counters[3]] = self.answeredTasksByParticipant[_p2][i];
                counters[3] += 1;
            } else {
                counters[2] += 1;
            }
        }

        if (counters[0] == Math.min(p1TaskAddresses.length, p2TaskAddresses.length)
                || counters[2] == Math.min(p1TaskAddresses.length, p2TaskAddresses.length)) {
            return (new address[](0), new address[](0));
        } else {
            address[] memory p1 = new address[](counters[1]);
            address[] memory p2 = new address[](counters[3]);

            for (i = 0; i < counters[1]; i++) {
                p1[i] = p1TaskAddresses[i];
            }

            for (i = 0; i < counters[3]; i++) {
                p2[i] = p2TaskAddresses[i];
            }

            return (p1, p2);
        }
    }
}
