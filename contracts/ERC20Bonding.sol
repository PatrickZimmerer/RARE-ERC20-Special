// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./MyCappedCoin.sol";

/**
 * @title A contract for a basic ERC20 coin where the admin can copntroll all tokens
 * @author Patrick Zimmerer
 * @notice This contract is a simple ERC20 token where the admin has control over every token
 * @dev When deploying you can choose a token name & symbol => deployer == owner / admin
 * @dev the admin is able to transfer tokens between addresses at will.
 */
contract ERC20Bonding is MyCappedCoin {
    uint256 private constant MAX_SUPPLY = 100_000_000 * 1e18;

    constructor(
        string memory _name,
        string memory _symbol
    ) MyCappedCoin(_name, _symbol) {
        _mint(msg.sender, 1_000_000 * 10 ** uint256(decimals()));
    }

    /**
     * @notice Admin function to withdraw ETH from the contract
     */
    function adminWithdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
