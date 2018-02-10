const Mechanism = artifacts.require('./Mechanism');
const RBTS = artifacts.require('./RBTS');
const Protocol = artifacts.require('./Protocol');

module.exports = function(deployer) {
  deployer.deploy(Mechanism);
  deployer.deploy(RBTS);
  deployer.link(Mechanism, Protocol);
  deployer.deploy(Protocol);
};
