import { useState, useEffect } from "react";
import { ethers } from "ethers";
import atm_abi from "../artifacts/contracts/Assessment.sol/Assessment.json";

export default function HomePage() {
  const [ethWallet, setEthWallet] = useState(undefined);
  const [account, setAccount] = useState(undefined);
  const [atm, setATM] = useState(undefined);
  const [balance, setBalance] = useState(undefined);
  const [savingsBalance, setSavingsBalance] = useState(undefined);

  const contractAddress = "0xB7f8BC63BbcaD18155201308C8f3540b07f84F5e";
  const atmABI = atm_abi.abi;

  const getWallet = async () => {
    if (window.ethereum) {
      setEthWallet(window.ethereum);
    }

    if (ethWallet) {
      const account = await ethWallet.request({ method: "eth_accounts" });
      handleAccount(account);
    }
  }

  const handleAccount = (account) => {
    if (account) {
      console.log("Account connected: ", account);
      setAccount(account[0]);
    } else {
      console.log("No account found");
    }
  }

  const connectAccount = async () => {
    if (!ethWallet) {
      alert('MetaMask wallet is required to connect');
      return;
    }

    const accounts = await ethWallet.request({ method: 'eth_requestAccounts' });
    handleAccount(accounts);

    // once wallet is set we can get a reference to our deployed contract
    getATMContract();
  };

  const getATMContract = () => {
    const provider = new ethers.providers.Web3Provider(ethWallet);
    const signer = provider.getSigner();
    const atmContract = new ethers.Contract(contractAddress, atmABI, signer);

    setATM(atmContract);
  }

  const getBalance = async () => {
    if (atm) {
      const balanceWei = await atm.getBalance();
      const balanceEth = ethers.utils.formatEther(balanceWei);
      setBalance(balanceEth);
    }
  }

  const getSavingsBalance = async () => {
    if (atm) {
      const savingsBalanceWei = await atm.getSavingsBalance();
      const savingsBalanceEth = ethers.utils.formatEther(savingsBalanceWei);
      setSavingsBalance(savingsBalanceEth);
    }
  }

  const deposit = async () => {
    if (atm) {
      const amountWei = ethers.utils.parseEther("1"); // 1 ETH
      let tx = await atm.deposit(amountWei);
      await tx.wait();
      getBalance();
    }
  }

  const withdraw = async () => {
    if (atm) {
      const amountWei = ethers.utils.parseEther("1"); // 1 ETH
      let tx = await atm.withdraw(amountWei);
      await tx.wait();
      getBalance();
    }
  }

  const depositToSavings = async () => {
    if (atm) {
      const amountWei = ethers.utils.parseEther("1"); // 1 ETH
      let tx = await atm.depositToSavings(amountWei);
      await tx.wait();
      getSavingsBalance();
      getBalance();
    }
  }

  const withdrawFromSavings = async () => {
    if (atm) {
      const amountWei = ethers.utils.parseEther("1"); // 1 ETH
      let tx = await atm.withdrawFromSavings(amountWei);
      await tx.wait();
      getSavingsBalance();
      getBalance();
    }
  }

  const calculateInterest = async () => {
    if (atm) {
      let tx = await atm.calculateInterest();
      await tx.wait();
      getSavingsBalance();
    }
  }

  const initUser = () => {
    // Check to see if user has Metamask
    if (!ethWallet) {
      return <p>Please install Metamask in order to use this ATM.</p>
    }

    // Check to see if user is connected. If not, connect to their account
    if (!account) {
      return <button onClick={connectAccount}>Please connect your Metamask wallet</button>
    }

    if (balance === undefined) {
      getBalance();
    }

    if (savingsBalance === undefined) {
      getSavingsBalance();
    }

    return (
      <div>
        <p>Your Account: {account}</p>
        <p>Your Balance: {balance} ETH</p>
        <p>Your Savings Balance: {savingsBalance} ETH</p>
        <button onClick={deposit}>Deposit 1 ETH</button>
        <button onClick={withdraw}>Withdraw 1 ETH</button>
        <button onClick={depositToSavings}>Deposit 1 ETH to Savings</button>
        <button onClick={withdrawFromSavings}>Withdraw 1 ETH from Savings</button>
        <button onClick={calculateInterest}>Calculate Interest</button>
      </div>
    )
  }

  useEffect(() => { getWallet(); }, []);

  return (
    <main className="container">
      <header><h1>Welcome to the Metacrafters ATM!</h1></header>
      {initUser()}
      <style jsx>{`
        .container {
          text-align: center
        }
      `}
      </style>
    </main>
  )
}
