// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Web3Builders is ERC721, ERC721Enumerable, Pausable, Ownable {

    uint256 public maxSupply = 2000;
    uint256 private _tokenIdCounter;

    bool public publicMintOpen = false;
    bool public allowListMintOpen = false;

    mapping(address => bool) public allowList;

    constructor()
        ERC721("Web3Builders", "WE3")
        Ownable(msg.sender)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmSN6EEN7HvRRkiAygZK7ua121UVE69z9KJF6Ztmq7n3S9/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function editMintWindows(
        bool _publicMintOpen,
        bool _allowListMintOpen
    ) external onlyOwner {
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }

    function allowListMint() public payable whenNotPaused {
        require(allowListMintOpen, "Allowlist Mint Closed");
        require(allowList[msg.sender], "You are not on the allow list");
        require(msg.value == 0.001 ether, "Not Enough Funds");

        internalMint();
    }

    function publicMint() public payable whenNotPaused {
        require(publicMintOpen, "Public Mint Closed");
        require(msg.value == 0.01 ether, "Not Enough Funds");

        internalMint();
    }

    function internalMint() internal {
        require(_tokenIdCounter < maxSupply, "We Sold Out!");

        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;

        _safeMint(msg.sender, tokenId);
    }

    function withdraw(address _addr) external onlyOwner {
        uint256 balance = address(this).balance;

        (bool success, ) = payable(_addr).call{value: balance}("");
        require(success, "Transfer Failed");
    }

    function setAllowList(
        address[] calldata addresses
    ) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            allowList[addresses[i]] = true;
        }
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    )
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}