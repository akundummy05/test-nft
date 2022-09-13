require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-chai-matchers");
const dotenv= require("dotenv")
const { task } = require('hardhat/config')
// const ethers = require('ethers')


task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});

dotenv.config()
/** @type import('hardhat/config').HardhatUserConfig */
let mnemonic = process.env.MNEMONIC
if (!mnemonic) {
  mnemonic = 'test test test test test test test test test test test junk'
}
const mnemonicAccounts = {
  mnemonic,
}

const account = {
  Localnet: process.env.LOCALNET_PRIVATE_KEY,
  Devnet: process.env.DEVNET_PRIVATE_KEY,
  Mainnet: process.env.MAINNET_PRIVATE_KEY,
}

module.exports = {
  solidity: "0.8.9",
  networks: {
    rinkeby: {
      url: process.env.REACT_APP_RINKEBY_RPC_URL,
      accounts: [process.env.REACT_APP_PRIVATE_KEY]
    },
    goerly: {
      url: 'https://eth-goerli.g.alchemy.com/v2/n_3iOTilxoIoC-b82wN-VbCFFGd0BIoj',
      accounts: ['d6f31360d50777219dba8360452e5c51332a97f96dc186e75846d249463cd811'],
    },
    harmony: {
      url: 'https://api.s0.t.hmny.io',
      chainId: 1666600000,
      accounts: ["dd16aa381812a28025c86edef8e7e3e9b728412df65036c34ed2569f4ab08ae8"],
      live: true,
      saveDeployments: true,
    },
    harmonyDev: {
      url: 'https://api.s0.ps.hmny.io',
      chainId: 1666900000,
      accounts: account.Devnet ? [account.Devnet] : mnemonicAccounts,
    },
  },
  etherscan: {
    apiKey: process.env.REACT_APP_ETHERSCAN_KEY,
  },
};
