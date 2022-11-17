//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PresaleDAYL is ERC20, Ownable {
    address public presale;
    address[] internal holders;

    constructor() ERC20("Presale Daylight", "DAYL") {
        // _transferOwnership(owner);
    }

    function setPresale(address _presale) public onlyOwner {
        require(_presale != address(0), "Invalid Presale Address");
        presale = _presale;
    }

    function mint(address dest, uint256 amount) external returns (bool) {
        require(
            msg.sender == presale || msg.sender == owner(),
            "Only Owner and Presale contract Mintable"
        );
        _mint(dest, amount);
        return true;
    }

    function burn(uint256 amount) public returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        if (from != address(0) && balanceOf(from) == 0) {
            uint256 i;
            uint256 length = holders.length;
            for (i = 0; i < length && holders[i] != from; ++i) {}
            holders[i] = holders[length - 1];
            holders.pop();
        }
        if (balanceOf(to) == amount) {
            holders.push(to);
        }
    }

    function getTokenDistribution()
        external
        view
        returns (address[] memory addresses, uint256[] memory amounts)
    {
        addresses = holders;
        uint256 i;
        uint256 length = addresses.length;
        amounts = new uint256[](length);
        for (i = 0; i < length; ++i) {
            amounts[i] = balanceOf(addresses[i]);
        }
    }
}
