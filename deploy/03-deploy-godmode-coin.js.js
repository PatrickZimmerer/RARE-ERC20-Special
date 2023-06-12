const { network, ethers, upgrades } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");
const { BigNumber } = require("ethers");

module.exports = async function ({ deployments }) {
    const { log } = deployments;

    const name = "GodModeCoin";
    const symbol = "GMC";
    const cap = BigNumber.from(1000000000000);

    const arguments = [name, symbol, cap];

    const GodModeCoin = await ethers.getContractFactory("ERC20GodMode");
    const godModeCoin = await upgrades.deployProxy(GodModeCoin, arguments, {
        initializer: "initialize",
    });

    // only verify the code when not on development chains as hardhat
    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        log("Verifying UPGRADEABLE contract...");
        await verify(godModeCoin.address, arguments);
    }
    log(
        "UPGRADEABLE contract godModeCoin deployed successfully at:",
        godModeCoin.address
    );
    log("-----------------------------------------");
};

module.exports.tags = ["all", "godModeCoin"];
