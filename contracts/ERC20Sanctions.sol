// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./MyCappedCoin.sol";

/**
 * @title A contract for a basic ERC20 coin where specific users can be banned from using it
 * @author Patrick Zimmerer
 * @notice This contract is to demo a sample ERC20 token with sanctions
 * @dev When deploying you can choose a token name & symbol => deployer == owner
 * @dev the owner also is the admin who can ban and unban addresses
 */
contract ERC20Sanctions is MyCappedCoin {
    mapping(address => uint256) bannedUsers; // using uint instead of bool to reduce gas cost

    /**
     * @notice Custom Modifier to check if a user is banned
     */
    modifier onlyUnbanned() {
        require(bannedUsers[msg.sender] != 1, "You are banned");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol
    ) MyCappedCoin(_name, _symbol) {
        _mint(msg.sender, 1_000_000 * 10 ** uint256(decimals()));
    }

    /**
     * @notice Only admin can ban/unban users from using the contract
     * @dev If you want to ban a User pass in the number 1 if you want to unban the user
     * @dev it is recommended to pass in a number > 1 like 2 since setting
     * @dev a non-zero to a non-zero value costs only 5000 gas instead of 20_000gas
     */
    function banOrUnbanUser(
        address _userAddress,
        uint256 _banStatus
    ) external onlyOwner {
        bannedUsers[_userAddress] = _banStatus;
    }

    /**
     * @notice Checks if one of the addresses is banned by the admin
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(
            bannedUsers[from] != 1,
            "The address you are trying to send from is banned"
        );
        require(
            bannedUsers[to] != 1,
            "The address you are trying to send to is banned"
        );
        super._beforeTokenTransfer(from, to, amount);
    }

    /**
     * @notice Only admin can ban/unban users from using the contract
     * @dev If you want to ban a User pass in the number 1 if you want to unban the user
     * @dev it is recommended to pass in a number > 1 like 2 since setting
     * @dev a non-zero to a non-zero value costs only 5000 gas instead of 20_000gas
     */
    function showBannedStatus(
        address _address
    ) external view returns (uint256) {
        return bannedUsers[_address];
    }
}
