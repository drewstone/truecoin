const compile = require('./compile');
const Web3 = require('web3');


module.exports = function({ addresses, provider }) {
  return compile()
  .then(contracts => {
    const BTM = contracts.BayesianTruthSerumManager;
    BTM.setProvider(provider);

    return {
      BayesianTruthSerumManager: BTM.at(addresses.BayesianTruthSerumManager),
    }
  });
}
