// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.7.0/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.7.0/contracts/token/ERC20/IERC20.sol";

contract NftStake {
    IERC721 public NFT;

    IERC20 public Token;

    uint256 public constant RewardPerYear = 10 ether;

    constructor(address _NFT, address _Token) {
        NFT = IERC721(_NFT);
        Token = IERC20(_Token);
    }

    struct stakeInfo {
        address staked;
        uint256 stakeTime;
        uint256 lastClaimTime;
    }

    mapping(uint256 => stakeInfo) public stakeNft;

    function stake(uint256 _tokenId) public {
        require(
            NFT.ownerOf(_tokenId) == msg.sender,
            "You Are Not Owner Of This NFT"
        );
        require(stakeNft[_tokenId].staked == address(0), "Already Staked");

        NFT.transferFrom(msg.sender, address(this), _tokenId);

        stakeNft[_tokenId] = stakeInfo({
            staked: msg.sender,
            stakeTime: block.timestamp,
            lastClaimTime: block.timestamp
        });
    }

    function unstake(uint256 _tokenId) public {
        require(
            stakeNft[_tokenId].staked == msg.sender,
            "You Are Not The Staker"
        );

        claimReward(_tokenId);

        NFT.transferFrom(address(this), msg.sender, _tokenId);

        delete stakeNft[_tokenId];
    }

    function stakingTime(uint256 _tokenId) public view returns (uint256) {
        uint256 stakedTime = block.timestamp - stakeNft[_tokenId].lastClaimTime;

        return stakedTime;
    }

    function calculateReward(uint256 _tokenId) public view returns (uint256) {
        uint256 Time = stakingTime(_tokenId);

        uint256 Reward = (RewardPerYear * Time) / 365 days;

        return Reward;
    }

    function claimReward(uint256 _tokenId) public {
        require(
            stakeNft[_tokenId].staked == msg.sender,
            "You Are Not The Staker"
        );

        uint256 CalReward = calculateReward(_tokenId);

        require(Token.transfer(msg.sender, CalReward), "Transfer Failed");

        stakeNft[_tokenId].lastClaimTime = block.timestamp;
    }
}
