const { network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();

    const name = "BondingCoin";
    const symbol = "BOC";

    const arguments = [name, symbol];

    const bondingCoin = await deploy("ERC20Bonding", {
        from: deployer,
        args: arguments,
        logs: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    });

    // only verify the code when not on development chains as hardhat
    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        log("Verifying...");
        await verify(bondingCoin.address, arguments);
    }
    log("bondingCoin deployed successfully at:", bondingCoin.address);
    log("-----------------------------------------");
};

module.exports.tags = ["all", "bondingCoin"];
