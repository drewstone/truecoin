const BayesianTruthSerumManager = artifacts.require('./BayesianTruthSerumManager');

contract('BayesianTruthSerumManager', (accounts) => {
  it('should ensure the owner of the manager is correct', () => {
    return BayesianTruthSerumManager.deployed().then(instance => {
      return instance.owner.call().then(owner => {
        assert.equal(owner, accounts[0], "Account is not the same as owner");
      });
    });
  });
});