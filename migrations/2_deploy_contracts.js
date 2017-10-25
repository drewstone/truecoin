const MathLib = artifacts.require('./Math');
const MechanismLib = artifacts.require('./MechanismLib');
const MechanismManager = artifacts.require('./MechanismManager');
const RBTSMechanism = artifacts.require('./RBTSMechanism');
const EndogenousMechanism = artifacts.require('./EndogenousMechanism');
const TruecoinProtocol = artifacts.require('./TruecoinProtocol');

module.exports = function(deployer) {
  // Libraries
  deployer.deploy(MathLib);
  deployer.deploy(MechanismLib);

  // Linked mechanisms and libraries
  deployer.link(MathLib, RBTSMechanism);
  deployer.link(MathLib, EndogenousMechanism);
  deployer.link(MathLib, MechanismManager);
  deployer.link(MathLib, TruecoinProtocol);
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
