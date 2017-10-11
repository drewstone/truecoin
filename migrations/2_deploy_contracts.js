const DSMath = artifacts.require('./DSMath');
const Mechanism = artifacts.require('./Mechanism');
const MechanismLib = artifacts.require('./MechanismLib');
const MechanismManager = artifacts.require('./MechanismManager');
const RBTSMechanism = artifacts.require('./RBTSMechanism');
const EndogenousMechanism = artifacts.require('./EndogenousMechanism');
const TruecoinProtocol = artifacts.require('./TruecoinProtocol');

module.exports = function(deployer) {
  // Libraries
  deployer.deploy(DSMath);
  deployer.deploy(MechanismLib);
  deployer.link(MechanismLib, Mechanism);

  // Linked mechanisms and libraries
  deployer.deploy(Mechanism);
  deployer.link(DSMath, RBTSMechanism);
  deployer.link(DSMath, EndogenousMechanism);
  deployer.link(DSMath, MechanismManager);
  deployer.link(DSMath, TruecoinProtocol);
  deployer.link(Mechanism, RBTSMechanism);
  deployer.link(Mechanism, EndogenousMechanism);
  
  // Mechanisms
  deployer.deploy(RBTSMechanism);
  deployer.deploy(EndogenousMechanism);
  deployer.link(RBTSMechanism, MechanismManager);
  deployer.link(EndogenousMechanism, MechanismManager);

  // Protocol
  deployer.deploy(MechanismManager);
  deployer.link(MechanismManager, TruecoinProtocol);
  deployer.deploy(TruecoinProtocol);
};
