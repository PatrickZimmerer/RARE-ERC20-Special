// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./MyCappedCoin.sol";

// QUESTION: What happens to the excess tokens if for some reason a customer would send a weird number like
//          like 1.00009 ETH we can't give them a token for the excess 0.00009 ETH which is
//          why we remove that in the buyToken => amount variable

/**
 * @title A contract for a basic ERC20 coin where specific users can be banned from using it
 * @author Patrick Zimmerer
 * @notice This contract is to demo a sample ERC20 token with sanctions
 * @dev When deploying you can choose a token name & symbol => deployer == owner
 * @dev the owner also is the admin who can ban and unban addresses
 */
contract ERC20SimpleSale is MyCappedCoin {
    uint256 public constant TOKENS_PER_ETH = 10000;

    constructor(
        string memory _name,
        string memory _symbol
    ) MyCappedCoin(_name, _symbol) {
        _mint(msg.sender, 1_000_000 * 10 ** uint256(decimals()));
    }

    function buyTokens() external payable {
        require(msg.value > 0, "Send some ETH to buy tokens");
        uint256 amount = (msg.value / 10 ** 18) * 10 ** 18; // remove excess which is insufficient for a token
        _mint(msg.sender, amount * TOKENS_PER_ETH);
        // can we return the excess ether somehow?
    }
}
