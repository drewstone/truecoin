pragma solidity ^0.4.10;

/**
 * The Database contract does this and that...
 */
library Database {    
    struct DB {
        address[] designers;
        address[] tasks;
        mapping (address => address) designerByTaskMechanism;
        mapping (address => bytes32[]) taskHashesByDesigner;
        mapping (bytes32 => bytes32[]) questionsByTaskHash;
    }

    function addTaskMechanism(DB storage self, address taskMechanism, bytes32 taskName, bytes32[] questions) internal {
        require(self.designerByTaskMechanism[taskMechanism] == address(0));

        if (self.taskHashesByDesigner[msg.sender].length == 0) {
            self.designers.push(msg.sender);
        }

        self.tasks.push(taskMechanism);
        self.designerByTaskMechanism[taskMechanism] = msg.sender;

        bytes32 taskHash = sha3(msg.sender, taskName);
        self.taskHashesByDesigner[msg.sender].push(taskHash);
        self.questionsByTaskHash[taskHash] = questions;
    }
}
