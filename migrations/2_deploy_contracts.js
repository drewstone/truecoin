const DSMath = artifacts.require('./DSMath.sol');
const Mechanism = artifacts.require('./Mechanism.sol');
const BayesianTruthMechanism = artifacts.require('./BayesianTruthMechanism');
const BayesianTruthSerumManager = artifacts.require('./BayesianTruthSerumManager');

module.exports = function(deployer) {
  deployer.deploy(DSMath);
  deployer.link(DSMath, Mechanism);
  deployer.deploy(Mechanism);
  deployer.link(DSMath, BayesianTruthMechanism);
  deployer.link(Mechanism, BayesianTruthMechanism);
  deployer.deploy(BayesianTruthMechanism);
  deployer.link(BayesianTruthMechanism, BayesianTruthSerumManager);
  deployer.deploy(BayesianTruthSerumManager);
};
