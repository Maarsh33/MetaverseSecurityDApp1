require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  solidity: "0.8.0",
  networks: {
    sepolia: {
      url: process.env.ALCHEMY_API_KEY, // Directly access the environment variable
      accounts: [process.env.PRIVATE_KEY], // Directly access the environment variable
      chainId: 11155111,
    },
  },
};
