// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20CappedUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @title A contract for a basic ERC20 coin where the admin can copntroll all tokens
 * @author Patrick Zimmerer
 * @notice This contract is a simple ERC20 token where the admin has control over every token
 * @dev When deploying you can choose a token name & symbol => deployer == owner / admin
 * @dev the admin is able to transfer tokens between addresses at will.
 */
contract ERC20GodMode is
    ERC20Upgradeable,
    ERC20CappedUpgradeable,
    OwnableUpgradeable
{
    uint256 private constant MAX_SUPPLY = 100_000_000 * 1e18;
    uint256 private constant DECIMALS = 18;

    function initialize(
        string memory _name,
        string memory _symbol,
        uint256 _cap
    ) public initializer {
        __ERC20_init(_name, _symbol);
        __ERC20Capped_init(_cap);
        __Ownable_init();
    }

    /**
     * @notice Admin function to transfer tokens between addresses at will
     * @param _from Address to transfer tokens from
     * @param _to Address to transfer tokens to
     * @param _amount Amount of tokens to transfer
     */
    function onlyAdminTransfer(
        address _from,
        address _to,
        uint256 _amount
    ) external onlyOwner {
        _transfer(_from, _to, _amount);
    }

    /**
     * @notice Admin function to withdraw ETH from the contract
     */
    function adminWithdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function _mint(
        address account,
        uint256 amount
    ) internal virtual override(ERC20Upgradeable, ERC20CappedUpgradeable) {
        super._mint(account, amount);
    }
}
