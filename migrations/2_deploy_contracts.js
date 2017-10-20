const DSMath = artifacts.require('./DSMath');
const MechanismLib = artifacts.require('./MechanismLib');
const MechanismManager = artifacts.require('./MechanismManager');
const RBTSMechanism = artifacts.require('./RBTSMechanism');
const EndogenousMechanism = artifacts.require('./EndogenousMechanism');
const TruecoinProtocol = artifacts.require('./TruecoinProtocol');

module.exports = function(deployer) {
  // Libraries
  deployer.deploy(DSMath);
  deployer.deploy(MechanismLib);

  // Linked mechanisms and libraries
  deployer.link(DSMath, RBTSMechanism);
  deployer.link(DSMath, EndogenousMechanism);
  deployer.link(DSMath, MechanismManager);
  deployer.link(DSMath, TruecoinProtocol);
  deployer.link(MechanismLib, RBTSMechanism);
  deployer.link(MechanismLib, EndogenousMechanism);
  deployer.link(MechanismLib, MechanismManager);
  deployer.link(MechanismLib, TruecoinProtocol);
  
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
