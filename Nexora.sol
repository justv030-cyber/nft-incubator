
// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.7.0
pragma solidity ^0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Nexora is
    ERC20,
    ERC20Burnable,
    ERC20Pausable,
    Ownable,
    ERC20Permit
{
    uint256 public initalSupply = 1000000;

    uint256 public maxWallet = 50_000 * 10 ** decimals();

    event Mint(address indexed to, uint256 value);

    constructor(
        address initialOwner
    )
        ERC20("Nexora", "NXR")
        Ownable(initialOwner)
        ERC20Permit("PracticeToken")
    {
        _mint(initialOwner, initalSupply * 10 ** decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
        emit Mint(_to, _amount);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Pausable) {
        if (from != address(0) && to != address(0)) {
            require(balanceOf(to) + value <= maxWallet, "Limit Reached");
        }
        super._update(from, to, value);
    }

    function transferToken(address _to, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Insufficient Balance");
        require(balanceOf(_to) + _value <= maxWallet, "Receiver Limit Reached");
        super.transfer(_to, _value);
    }
}
