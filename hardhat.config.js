require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: {
    compilers : [
      {
        version : "0.8.15",
        settings : {
          optimizer: {
            enabled: true
          }
        }
      }
    ]
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency : "USD",
    token : "ETH",
    gasPriceApi : "https://api.etherscan.io/api?module=proxy&action=eth_gasPrice", 
    showTimeSpent : true,
    coinmarketcap : process.env.GAS_KEY
  }
};
