var DSMath = artifacts.require("./DSMath.sol");
var Mechanism = artifacts.require("./Mechanism.sol");

module.exports = function(deployer) {
  deployer.deploy(DSMath);
  deployer.link(DSMath, Mechanism);
  deployer.deploy(Mechanism);
};
