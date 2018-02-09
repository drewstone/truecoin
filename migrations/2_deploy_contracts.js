const Mechanism = artifacts.require('./Mechanism');
// const Scorer = artifacts.require('./Scorer');
const Protocol = artifacts.require('./Protocol');

module.exports = function(deployer) {
  deployer.deploy(Mechanism);
  // deployer.deploy(Scorer);
  deployer.link(Mechanism, Protocol);
  // deployer.link(Scorer, Protocol);
  deployer.deploy(Protocol);
};
