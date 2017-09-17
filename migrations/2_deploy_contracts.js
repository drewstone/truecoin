const DSMath = artifacts.require('./DSMath.sol');
const Mechanism = artifacts.require('./Mechanism.sol');
const RBTSMechanism = artifacts.require('./RBTSMechanism');
const TruecoinProtocol = artifacts.require('./TruecoinProtocol');

module.exports = function(deployer) {
  deployer.deploy(DSMath);
  deployer.deploy(Mechanism);
  deployer.link(Mechanism, RBTSMechanism);
  deployer.link(DSMath, RBTSMechanism);
  deployer.deploy(RBTSMechanism);
  deployer.link(DSMath, TruecoinProtocol);
  deployer.link(RBTSMechanism, TruecoinProtocol);
  deployer.deploy(TruecoinProtocol);
};
