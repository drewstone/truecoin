import { assert } from 'chai';
import setupContracts from '../scripts/deploy';
import p2pConfig from '../config/p2p_config';
import config from '../config/config';

describe('Script tests', () => {
  let networkConfig;

  before(() => {
    networkConfig = p2pConfig({ INFURA_API_KEY: config.INFURA_API_KEY});
  });

  it('', () => {
    return setupContracts({ network: networkConfig })
    .then(fn => {
      return fn.deployBayesianTruthSerumManager();
    });
  });
})