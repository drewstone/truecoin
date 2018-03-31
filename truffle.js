const HDWalletProvider = require("truffle-hdwallet-provider");
const INFURA_API_KEY = "z3IRXB0sVV5ueV4zln3A"
const mnemonic = "usual dream clay mimic dad suspect mercy amused leader save trip chase";

module.exports = {
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 4700000,
    },
    ropsten:  {
      network_id: 3,
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/" + INFURA_API_KEY),
      gas: 4500000,
    },
    rinkeby: {
      network_id: "4",
      provider: new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/" + INFURA_API_KEY),
      gas: 6721975,
    }
  }
};
