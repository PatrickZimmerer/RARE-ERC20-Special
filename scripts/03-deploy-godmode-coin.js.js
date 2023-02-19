const { network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();

    const name = "GodModeCoin";
    const symbol = "GMC";

    const arguments = [name, symbol];

    const godModeCoin = await deploy("ERC20GodMode", {
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
        await verify(godModeCoin.address, arguments);
    }
    log("godModeCoin deployed successfully at:", godModeCoin.address);
    log("-----------------------------------------");
};

module.exports.tags = ["all", "godModeCoin"];
