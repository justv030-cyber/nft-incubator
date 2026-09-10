// Custom function:

// Owner contractમાંથી collected ETH withdraw કરી શકે

// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.7.0
pragma solidity ^0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract SaleToken is
    ERC20,
    ERC20Burnable,
    ERC20Pausable,
    Ownable,
    ERC20Permit
{
    uint256 public constant max_wallet = 25000 * 10 ** 18;

    uint256 public token_price = 0.001 ether;

    constructor(
        address initialOwner
    ) ERC20("SaleToken", "SLT") Ownable(initialOwner) ERC20Permit("SaleToken") {
        _mint(initialOwner, 500000 * 10 ** decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function setTokenPrice(uint256 _tokenPrice) external onlyOwner {
        token_price = _tokenPrice;
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
                "Max Wallet Limit Reached"
            );
        }
        super._update(from, to, value);
    }

    function transferTokens(address _to, uint256 _amount) external {
        super.transfer(_to, _amount);
    }

    function buyTokens() public payable {
        require(msg.value > 0, "Send ETH");

        uint256 SLTprice = (msg.value*10**18)/token_price;

        super._transfer(address(this), msg.sender, SLTprice);
    }

    function withdraw() public  onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No ETH to withdraw");
        (bool sucess, ) = payable(msg.sender).call{value: contractBalance}("");
        require(sucess, "Transfer Failed");
    }
}
