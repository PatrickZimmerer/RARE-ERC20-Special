const { network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();

    const name = "SanctionsCoin";
    const symbol = "SAC";

    const arguments = [name, symbol];

    const sanctionsCoin = await deploy("ERC20Sanctions", {
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
        await verify(sanctionsCoin.address, arguments);
    }
    log("sanctionsCoin deployed successfully at:", sanctionsCoin.address);
    log("-----------------------------------------");
};

module.exports.tags = ["all", "sanctionsCoin"];
