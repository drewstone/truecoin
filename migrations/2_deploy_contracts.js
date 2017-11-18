const MathLib = artifacts.require('./MathLib');
const OpenMechanism = artifacts.require('./OpenMechanism');
const Mechanism = artifacts.require('./Mechanism');
const MechanismManager = artifacts.require('./MechanismManager');
const RBTSMechanism = artifacts.require('./RBTSMechanism');
const EndogenousMechanism = artifacts.require('./EndogenousMechanism');
const TruecoinProtocol = artifacts.require('./TruecoinProtocol');

module.exports = function(deployer) {
  // Libraries
  deployer.deploy(MathLib);
  deployer.deploy(Mechanism);
  deployer.deploy(OpenMechanism);

  // Linked mechanisms and libraries
  deployer.link(MathLib, RBTSMechanism);
  deployer.link(MathLib, EndogenousMechanism);
  deployer.link(MathLib, MechanismManager);
  deployer.link(MathLib, TruecoinProtocol);
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
