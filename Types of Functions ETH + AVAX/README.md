# MyERC20Token

## Overview

`MyERC20Token` is an ERC20 token contract that allows the contract owner to mint tokens, and any user to transfer and burn tokens.

## Features

- **Minting**: Only the contract owner can mint new tokens.
- **Transferring**: Any user can transfer tokens to another address.
- **Burning**: Any user can burn their own tokens.

## Deployment

1. **Using HardHat**:
   - Install dependencies: `npm install @openzeppelin/contracts @nomiclabs/hardhat-ethers ethers`
   - Create a deployment script and deploy using `npx hardhat run scripts/deploy.js --network localhost`.

## Interaction

1. **Mint Tokens**: Only the owner can call `mint(address to, uint256 amount)`.
2. **Transfer Tokens**: Any user can call `transfer(address recipient, uint256 amount)`.
3. **Burn Tokens**: Any user can call `burn(uint256 amount)`.

## License

This project is licensed under the MIT License.
