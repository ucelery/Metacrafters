// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FunctionsAndErrors {
    address public owner;
    uint256 public balance;

    constructor() {
        owner = msg.sender;
        balance = 0;
    }

    // Function to deposit funds with a require statement
    function deposit(uint256 amount) public payable {
        require(
            msg.value == amount,
            "Amount does not match, please try again."
        );
        balance += amount;
    }

    // Function to withdraw funds with a revert statement
    function withdraw(uint256 amount) public {
        if (amount > balance) revert("There are no enough balance");

        balance -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Function to check balance with an assert statement
    function checkBalance() public view returns (uint256) {
        assert(balance >= 0);
        return balance;
    }

    // Function to change the owner with a require statement
    function changeOwner(address newOwner) public {
        require(msg.sender == owner, "Invalid owner, the sender is not owner");
        owner = newOwner;
    }
}
