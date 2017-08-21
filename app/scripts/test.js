const setupContracts = require('../scripts/deploy');
const p2pConfig = require('../config/p2p_config');
const config = require('../config/config');
const networkConfig = p2pConfig({ INFURA_API_KEY: config.INFURA_API_KEY});

setupContracts({ network: networkConfig.LOCALHOST })
.then(fn => fn.deployBayesianTruthSerumManager())
.then(console.log);