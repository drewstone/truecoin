const BayesianTruthSerumManager = artifacts.require('./BayesianTruthSerumManager');

contract('BayesianTruthSerumManager', (accounts) => {
  return BayesianTruthSerumManager.deployed().then(instance => {
    return instance.owner.call().then(owner => {
      assert.equal(owner, accounts[0]);
    });
  });
});