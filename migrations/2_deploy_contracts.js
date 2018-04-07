const RBTS = artifacts.require('./RBTS');
const Protocol = artifacts.require('./Protocol');
const Truecoin = artifacts.require('./Truecoin');

module.exports = function(deployer) {
  deployer.deploy(Protocol).then(protocol => {
    return deployer.deploy(RBTS, Protocol.address);
  }).then(() => {
    return deployer.deploy(Truecoin, 0);
  }).then(() => {
    return Protocol.at(Protocol.address).setTruecoinContract(Truecoin.address);
  }).then(() => {
    return Truecoin.at(Truecoin.address).transferOwnership(Protocol.address);
  }).then(() => {
    return Protocol.at(Protocol.address).setScoringContract("rbts", RBTS.address);
  });
};
