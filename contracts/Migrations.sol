// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Migrations {
    address public owner;
    uint public lastCompletedMigration;

    modifier restricted() {
        require(msg.sender == owner, "Access restricted to owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setCompleted(uint completed) public restricted {
        lastCompletedMigration = completed;
    }

    function upgrade(address newAddress) public restricted {
        Migrations upgraded = Migrations(newAddress);
        upgraded.setCompleted(lastCompletedMigration);
    }
}