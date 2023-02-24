// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./MyCappedCoin.sol";

// QUESTION: I always see people using Solidity 0.8.7 so what is the recommended version to use when creating a new contract?
// ANSWER: Generally latest version, look at release notes for bug fix / improvements for compiler efficiency => maybe look out for bugs wait a few days/weeks

// QUESTION: About floating pragma: When should I use a version like ^0.8.0 just when building a library or smth like that?
// ANSWER: if you deploy / compile chose a fixed version just if you build a library where you don't know what version is going to be used

// QUESTION: What happens to the excess tokens if for some reason a customer would send a weird number like
//          like 1.00009 ETH we can't give them a token for the excess 0.00009 ETH which is
//          why we remove that in the buyToken => amount variable
// ANSWER: Could be refunded if it's even worth it

/**
 * @title A contract for a basic ERC20 coin where you can buy tokens at a fixed price
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

    /**
     * @notice This function just gives back the amount of Tokens you would get for sending X ETH
     */
    function buyTokens() external payable {
        require(msg.value > 0, "Send some ETH to buy tokens");
        uint256 amount = (msg.value / 10 ** 18) * 10 ** 18; // remove excess which is insufficient for a token like 0.00009 ETH since
        _mint(msg.sender, amount * TOKENS_PER_ETH); // 1 token is 0.0001 ETH => can we return the excess ether somehow?
    }
}
