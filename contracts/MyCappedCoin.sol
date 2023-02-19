// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

/// @title A contract for a basic ERC20 coin which is capped at 100 million token
/// @author Patrick Zimmerer
/// @notice This contract is to demo a sample ERC20 capped contract
/// @dev When deploying you can choose a token name & symbol => deployer == owner
contract MyCappedCoin is ERC20Capped {
    uint256 public constant MAX_SUPPLY = 100_000_000 * 1e18;
    address immutable i_owner;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) ERC20Capped(MAX_SUPPLY) {
        i_owner = payable(msg.sender);
        _mint(msg.sender, 1_000_000 * 10 ** uint256(decimals()));
    }
}
