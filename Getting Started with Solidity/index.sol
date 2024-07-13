// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract MyToken {
    string public name; // Token Name
    string public symbol; // Token Abbreviation
    uint256 public totalSupply; // Total Supply

    // Mapping variable here
    mapping(address => uint256) public balances;

    // Constructor to initialize the token details
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        totalSupply = _initialSupply;
        balances[msg.sender] = _initialSupply; // Assign initial supply to contract creator
    }

    // Mint function
    function mint(address _to, uint256 _amount) public {
        totalSupply += _amount;
        balances[_to] += _amount;
    }

    // Burn function
    function burn(address _from, uint256 _amount) public {
        require(balances[_from] >= _amount, "Insufficient balance to burn");
        totalSupply -= _amount;
        balances[_from] -= _amount;
    }
}
