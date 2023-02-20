const { network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();

    const name = "SimpleCoin";
    const symbol = "SMC";

    const arguments = [name, symbol];

    const simpleCoin = await deploy("ERC20SimpleSale", {
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
        await verify(simpleCoin.address, arguments);
    }
    log("simpleCoin deployed successfully at:", simpleCoin.address);
    log("-----------------------------------------");
};

module.exports.tags = ["all", "simpleCoin"];
