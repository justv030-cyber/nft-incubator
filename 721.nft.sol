// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.7.0
pragma solidity ^0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Pausable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";

contract GenerateNFT is ERC721, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;

    uint256 public constant maxSupply = 10000;

    uint256 public constant mintPrice = 0.01 ether;

    uint256 public requiredPrice;

    // mappping

    mapping(address => bool) public whitelist;

    mapping(address => uint256) public whiteListMinted;

    // events

    event NFTMinted(address indexed _user, uint256 _quantity);

    event AddWhiteListUser(address indexed _user);

    event RemovedFromWhitelist(address indexed user);

    constructor(
        address initialOwner
    ) ERC721("GenerateNFT", "GNFT") Ownable(initialOwner) {
        _nextTokenId = 1;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) public onlyOwner returns (uint256) {
        require(_nextTokenId <= maxSupply, "max Supply Reached");
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        return tokenId;
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Pausable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function mint(uint256 _quantity) external payable {
        require(_quantity > 0, "Quantity must be greater than 0");
        require(_quantity <= 5, "Max 5 NFTs");
        require(
            _nextTokenId + _quantity - 1 <= maxSupply,
            "Max supply reached"
        );

        requiredPrice = _quantity * mintPrice;
        require(msg.value == requiredPrice, "Incorrect payment");

        for (uint256 i = 1; i <= _quantity; i++) {
            uint256 tokenId = _nextTokenId;
            _safeMint(msg.sender, tokenId);
            _nextTokenId++;
        }

        emit NFTMinted(msg.sender, _quantity);
    }

    function whitelistUser(address _user) external onlyOwner {
        whitelist[_user] = true;
        emit AddWhiteListUser(_user);
    }

    function removeWhiteListUser(address _user) external onlyOwner {
        whitelist[_user] = false;
        emit RemovedFromWhitelist(_user);
    }

    function whiteListMint(uint256 _quantity) public payable {
        require(
            whitelist[msg.sender] == true,
            "You're Not On The Whitelist Mine Thanks!"
        );
        require(_quantity > 0, "Invalid quantity");

        require(
            whiteListMinted[msg.sender] + _quantity <= 2,
            "Whitelist max 2 NFTs"
        );
        require(
            _nextTokenId + _quantity - 1 <= maxSupply,
            "Max supply reached"
        );

        requiredPrice = _quantity * mintPrice;
        require(msg.value == requiredPrice, "Incorrect payment");

        for (uint256 i = 0; i < _quantity; i++) {
            uint256 tokenId = _nextTokenId;
            _safeMint(msg.sender, tokenId);
            _nextTokenId++;
        }

        whiteListMinted[msg.sender] += _quantity;
    }

    function withdraw() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No ETH in contract");
        (bool sucess, ) = payable(msg.sender).call{value: contractBalance}("");
        require(sucess, "Transfer Failed");
    }
}
