# 🖼️ NFT Staking Platform

A decentralized **NFT Staking Platform** built using **Solidity** and developed directly in **Remix IDE**.

This project allows users to stake their ERC-721 NFTs in a smart contract and earn rewards based on the duration their NFTs remain staked.

## 🚀 Features

* 🖼️ ERC-721 NFT staking
* 🔐 Secure NFT ownership management
* ⏱️ Time-based staking
* 💰 Earn staking rewards
* 🎁 Claim accumulated rewards
* 📤 Unstake NFTs
* 👤 Track user staking information
* 🛡️ Owner-controlled configuration
* 🔗 Compatible with EVM-compatible blockchains

## 🛠️ Technologies Used

* **Solidity**
* **Remix IDE**
* **OpenZeppelin**
* **ERC-721**
* **MetaMask**
* **EVM-compatible Blockchain**

## 🏗️ How It Works

The platform follows a simple staking process:

```text
User
  │
  │ Owns NFT
  ▼
ERC-721 NFT
  │
  │ Approve Staking Contract
  ▼
NFT Staking Contract
  │
  │ Stake NFT
  ▼
NFT Locked
  │
  │ Rewards Accumulate
  ▼
Claim Rewards
  │
  ▼
Unstake NFT
  │
  ▼
NFT Returned to User
```

## 🔄 Staking Process

### 1. Own an NFT

The user must own an ERC-721 NFT before staking.

### 2. Approve the Staking Contract

The NFT owner gives the staking contract permission to transfer the NFT.

```solidity
approve(stakingContract, tokenId);
```

### 3. Stake NFT

The user calls the staking function with the NFT's token ID.

```solidity
stake(tokenId);
```

The contract records important staking information such as:

* NFT owner
* Token ID
* Staking timestamp
* Reward information

### 4. Earn Rewards

Rewards accumulate while the NFT remains staked.

A basic reward model can be:

```text
Reward = Staking Duration × Reward Rate
```

### 5. Claim Rewards

Users can claim their accumulated rewards.

```solidity
claimReward();
```

### 6. Unstake NFT

The user can unstake the NFT when allowed.

```solidity
unstake(tokenId);
```

The NFT is transferred back to the user.

## 💰 Reward Mechanism

The staking contract calculates rewards based on how long the NFT has been staked.

Example:

```text
Staking Duration = Current Time - Staking Time

Reward = Staking Duration × Reward Rate
```

The actual reward calculation depends on the implementation of the smart contract.

## 🔐 Security

The smart contract uses common Solidity and OpenZeppelin security practices, including:

* ERC-721 safe transfers
* Ownership validation
* Access control
* Permission checks
* Secure NFT staking and withdrawal
* Protection against unauthorized operations

> ⚠️ This project is for learning and development purposes. A professional security audit is recommended before using the contract with real assets.

## 🧪 Deployment Using Remix

This project is developed and deployed using **Remix IDE**.

### Step 1 — Open Remix

Open Remix IDE and create your Solidity contract.

### Step 2 — Compile

Select the appropriate Solidity compiler version and compile the contract.

### Step 3 — Deploy

Go to:

```text
Deploy & Run Transactions
```

Select your desired environment, such as:

```text
Injected Provider - MetaMask
```

Connect MetaMask and select the blockchain/network where you want to deploy.

### Step 4 — Interact With Contract

After deployment, use Remix's contract interface to:

* Approve NFTs
* Stake NFTs
* Check staking information
* Calculate rewards
* Claim rewards
* Unstake NFTs

## 🦊 MetaMask

MetaMask can be used to connect your wallet with Remix and interact with the deployed staking contract.

```text
MetaMask
    ↓
Connect Wallet
    ↓
Remix IDE
    ↓
NFT Staking Contract
    ↓
Stake / Claim / Unstake
```

## 📜 Smart Contract Components

### NFT Contract

The NFT contract follows the **ERC-721** standard and manages NFT ownership and transfers.

### NFT Staking Contract

The staking contract manages:

* NFT staking
* NFT unstaking
* Staking timestamps
* Reward calculations
* Reward claims
* User staking records
* Access control

## 🔮 Future Improvements

* [ ] ERC-20 reward token
* [ ] Multiple NFT collections
* [ ] NFT rarity-based rewards
* [ ] Reward multipliers
* [ ] Locking periods
* [ ] Early unstaking penalties
* [ ] Emergency withdrawal
* [ ] APY-based rewards
* [ ] Frontend dashboard
* [ ] NFT staking analytics
* [ ] Multi-chain support
* [ ] Smart contract security audit

## 📚 Learning Objectives

This project demonstrates practical implementation of:

* Solidity
* ERC-721
* NFT ownership
* NFT transfers
* Smart contract inheritance
* OpenZeppelin contracts
* `approve()` and `transferFrom()`
* Staking mechanisms
* Reward calculations
* `block.timestamp`
* Access control
* Smart contract security

## ⚠️ Disclaimer

This project is created for **educational and experimental purposes**. Do not use it with valuable NFTs or real funds without proper testing and a professional security audit.

## 👨‍💻 Author

**Harshil Thummar**

Blockchain / Smart Contract Developer

---

⭐ If you found this project useful, consider giving the repository a star!
