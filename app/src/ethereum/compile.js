import Promise from 'bluebird';
import contract from 'truffle-contract';

import TruecoinProtocol from '../contracts/TruecoinProtocol';
import Truecoin from '../contracts/Truecoin';
import RBTSMechanism from '../contracts/RBTSMechanism';

export default function() {
  const contracts = [
    Truecoin,
    TruecoinProtocol,
    RBTSMechanism,
  ];
  
  return Promise.resolve(contracts.map(c => {
    return ({ name: c.contract_name, contract: contract(c)});
  })
  .reduce((prev, curr) => {
    return Object.assign({}, prev, {[curr.name]: curr.contract});
  }, {}));
}