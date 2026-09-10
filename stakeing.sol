// ⚠️ Bonus Challenge

// Owner ek function banave:

// function fundRewards(uint256 amount) external onlyOwner

// Owner contract ma reward tokens deposit kari shake.

// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.7.0
pragma solidity ^0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract StakeToken is
    ERC20,
    ERC20Burnable,
    ERC20Pausable,
    Ownable,
    ERC20Permit
{
    struct StakeInfo {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => StakeInfo) public stakes;

    uint256 public max_wallet = 100000 * 10 ** 18;

    uint256 public constant Min_Stake_Amount = 100 * 10 ** 18;

    uint256 public constant APY = 10;

    event Staked(address indexed user, uint256 amount);

    event Unstake(address indexed _user, uint256 _amount);

    event RewardClaimed(address indexed user, uint256 reward);


    constructor(
        address initialOwner
    )
        ERC20("StakeToken", "STK")
        Ownable(initialOwner)
        ERC20Permit("StakeToken")
    {
        _mint(initialOwner, 1000000 * 10 ** decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Pausable) {
        if (from != address(0) && to != address(0)) {
            require(
                balanceOf(to) + value <= max_wallet,
                "Maximum Limit Reacheed"
            );
        }
        super._update(from, to, value);
    }

    function transferTokens(address from, address to, uint256 amount) external {
        super._transfer(from, to, amount);
    }

    function stake(uint256 _amount) external {
        require(_amount >= Min_Stake_Amount, "Minimum 100 STK");
        transferFrom(msg.sender, address(this), _amount);

        stakes[msg.sender].amount = _amount;

        stakes[msg.sender].startTime = block.timestamp;

        emit Staked(msg.sender, _amount);
    }

    function unstake() public {
        uint256 stakeAmt = stakes[msg.sender].amount;

        require(stakeAmt > 0, "No Staked Thanks!");

        _transfer(address(this), msg.sender, stakeAmt);

        stakes[msg.sender].amount = 0;

        stakes[msg.sender].startTime = 0;

        emit Unstake(msg.sender, stakeAmt);
    }

    function calculateReward(address _user) public view returns (uint256) {
        require(stakes[_user].amount > 0, "No Token Staked");

        uint256 timePassed = block.timestamp - stakes[_user].startTime;
        uint256 Reward = (stakes[_user].amount * APY * timePassed) /
            (100 * 365 days);
        return Reward;
    }

    function claimreward() external {
        uint256 Reward = calculateReward(msg.sender);
        require(Reward > 0, "No Reward Thank You!");
        _transfer(address(this), msg.sender, Reward);
        stakes[msg.sender].startTime = block.timestamp;
        emit RewardClaimed(msg.sender, Reward);
    }

    function fundRewards(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        transferFrom(msg.sender, address(this), amount);
    }
}
