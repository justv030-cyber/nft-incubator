// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol";

abstract contract staking is IERC721Receiver {
    IERC721 immutable NFT;
    IERC20 immutable Token;

    uint256 public reward;
    uint256 public time;

    mapping(address => mapping(uint256 => uint256)) public stakes;

    constructor(address _NFT, address _Token) {
        NFT = IERC721(_NFT);
        Token = IERC20(_Token);
    }

    function calculateRate(uint256 _time) private pure returns (uint256) {
        if (_time < 1 minutes) {
            return 0;
        } else if (_time < 3 minutes) {
            return 3;
        } else if (_time < 4 minutes) {
            return 4;
        } else {
            return 10;
        }
    }

    function stake(uint256 _tokenId) public {
        require(
            NFT.ownerOf(_tokenId) == msg.sender,
            "You Are Not Owner Of This NFT!"
        );
        stakes[msg.sender][_tokenId] = block.timestamp;
        NFT.transferFrom(msg.sender, address(this), _tokenId);
    }

    function calculateReward(uint256 _tokenId) public returns (uint256) {
        require(stakes[msg.sender][_tokenId] > 0, "You Dont Have NFT");
        time = block.timestamp - stakes[msg.sender][_tokenId];
        reward = (calculateRate(time) * time * (10 ** 18)) / 1 minutes; //18 decimals
        return reward;
    }

    function unstake(uint256 _tokenId) public {
        uint256 rewardAmt = calculateReward(_tokenId);
        delete stakes[msg.sender][_tokenId];
        NFT.transferFrom(address(this), msg.sender, _tokenId);
        Token.transfer(msg.sender, rewardAmt);
    }
    
}
