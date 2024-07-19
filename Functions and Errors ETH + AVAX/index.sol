// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract EnhancedFunctionsAndErrors {
    address public contractOwner;
    uint256 public contractBalance;

    constructor() {
        contractOwner = msg.sender;
        contractBalance = 0;
    }

    // Function to check balance with an assert statement
    function getBalance() public view returns (uint256) {
        // Check Balance
        assert(contractBalance >= 0);
        return contractBalance;
    }

    // Function to deposit funds with a require statement
    function depositFunds(uint256 amt) public payable {
        // Additional check if specified amount matches the value
        require(
            msg.value == amt,
            "Sent amount does not match the specified amount."
        );
        contractBalance += amt;
    }

    // Function to withdraw funds with a revert statement
    function withdrawFunds(uint256 amt) public {
        // Checks if user have enough balance to withdraw
        if (amt > contractBalance)
            revert("You do not have enough balance to withdraw.");

        contractBalance -= amt;
        payable(msg.sender).transfer(amt);
    }

    // Function to change the owner with a require statement
    function updateOwner(address newOwner) public {
        require(
            msg.sender == contractOwner,
            "You are not the owner, Only the current owner can change the ownership."
        );
        contractOwner = newOwner;
    }
}
