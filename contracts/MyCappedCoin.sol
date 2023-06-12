// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title A contract for a basic ERC20 coin which is capped at 100 million token
/// @author Patrick Zimmerer
/// @notice This contract is to demo a sample ERC20 capped contract
/// @dev When deploying you can choose a token name & symbol
abstract contract MyCappedCoin is ERC20Capped, Ownable {
    uint256 private constant MAX_SUPPLY = 100_000_000 * 1e18;
    uint256 private constant DECIMALS = 18;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) ERC20Capped(MAX_SUPPLY) {}
}
