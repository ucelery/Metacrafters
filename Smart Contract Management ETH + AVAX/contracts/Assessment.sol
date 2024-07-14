// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//import "hardhat/console.sol";

contract Assessment {
    address payable public owner;
    uint256 public balance;
    uint256 public savingsBalance;
    uint256 public interestRate; // Interest rate in percentage
    uint256 public lastInterestCalculation;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);
    event SavingsDeposit(uint256 amount);
    event SavingsWithdraw(uint256 amount);
    event InterestCalculated(uint256 interest);
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    constructor(uint initBalance, uint _interestRate) payable {
        owner = payable(msg.sender);
        balance = initBalance;
        interestRate = _interestRate;
        lastInterestCalculation = block.timestamp;
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function getSavingsBalance() public view returns (uint256) {
        return savingsBalance;
    }

    function deposit(uint256 _amount) public payable {
        uint _previousBalance = balance;

        // make sure this is the owner
        require(msg.sender == owner, "You are not the owner of this account");

        // perform transaction
        balance += _amount;

        // assert transaction completed successfully
        assert(balance == _previousBalance + _amount);

        // emit the event
        emit Deposit(_amount);
    }

    // custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        uint _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // withdraw the given amount
        balance -= _withdrawAmount;

        // assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // emit the event
        emit Withdraw(_withdrawAmount);
    }

    function depositToSavings(uint256 _amount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        require(balance >= _amount, "Insufficient balance to deposit to savings");

        uint _previousBalance = balance;
        uint _previousSavingsBalance = savingsBalance;

        // transfer to savings
        balance -= _amount;
        savingsBalance += _amount;

        // assert transaction completed successfully
        assert(balance == _previousBalance - _amount);
        assert(savingsBalance == _previousSavingsBalance + _amount);

        // emit the event
        emit SavingsDeposit(_amount);
    }

    function withdrawFromSavings(uint256 _amount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        require(savingsBalance >= _amount, "Insufficient savings balance to withdraw");

        // Calculate interest before withdrawing
        calculateInterest();

        uint _previousSavingsBalance = savingsBalance;
        savingsBalance -= _amount;
        balance += _amount;

        // assert transaction completed successfully
        assert(savingsBalance == _previousSavingsBalance - _amount);

        // emit the event
        emit SavingsWithdraw(_amount);
    }

    function calculateInterest() public {
        require(msg.sender == owner, "You are not the owner of this account");

        uint timeElapsed = block.timestamp - lastInterestCalculation;
        uint interest = (savingsBalance * interestRate * timeElapsed) / (100 * 365 * 24 * 60 * 60); // Annual interest

        savingsBalance += interest;
        lastInterestCalculation = block.timestamp;

        // emit the event
        emit InterestCalculated(interest);
    }

    // SetOwner function to allow the owner to change ownership of the contract
    function setOwner(address payable _newOwner) public {
        require(msg.sender == owner, "You are not the owner of this account");

        address oldOwner = owner;
        owner = _newOwner;

        // emit the event
        emit OwnerChanged(oldOwner, _newOwner);
    }
}
