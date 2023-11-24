// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenGamez is ERC20, Ownable, ERC20Burnable
{
    mapping(string => uint) public itemPrices;
    event ItemRedeem(address indexed player, string item);

    constructor() ERC20("Degen", "DGN") {
        mintTokens(msg.sender, 100*10**decimals());
    }

    function mintTokens(address to, uint amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferTokens(address receiver, uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient GOLD!");
        approve(msg.sender, amount);
        transferFrom(msg.sender, receiver, amount);
    }

    function checkBalance() external view returns(uint) {
       return balanceOf(msg.sender);
    }

    function addItem(string memory item, uint price) public onlyOwner  {
        require(price > 0, "CANNOT be free!");
        itemPrices[item] = price;
    }

    function getPrice(string memory item) public view returns (uint)  {
        return itemPrices[item];
    }

    function burnTokens(uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient GOLD!");
        _burn(msg.sender, amount);
    }

    function redeem(string memory item) public  {
        require(itemPrices[item] > 0, "Redemption not available.");
        require(balanceOf(msg.sender) >= itemPrices[item], "Insufficient GOLD!");

        _transfer(msg.sender, owner(), itemPrices[item]);
        emit ItemRedeem(msg.sender, item);
    }

}
