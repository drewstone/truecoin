const Promise = require('bluebird');
const path = require('path');
const fs = require('fs');
const solc = require('solc');
const Artifactor = require('truffle-artifactor');
const contract = require('truffle-contract');
const config = require('../config/contracts_config');

module.exports = function() {
  const dirPath = path.join(path.resolve('./'), '/contracts');
  const artifactor = new Artifactor(dirPath);

  return initialize(dirPath, artifactor)
  .then(res => {
    let files = fs.readdirSync(dirPath);
    return files.map(f => {
      return {
        [f.split('.')[0]]: contract(JSON.parse(fs.readFileSync(path.join(dirPath, f))))
      };
    }).reduce((prev, curr) => (Object.assign({}, prev, curr)));
  });
}

function initialize(dirPath, artifactor) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath);
  } 

  if (fs.readdirSync(dirPath).length == 0) {
    return compile(artifactor, config.CONTRACTS_DIRECTORY);
  } else {
    return Promise.map(fs.readdirSync(dirPath), c => {
      let parsedContract = JSON.parse(fs.readFileSync(path.join(dirPath, c)));
      return artifactor.save(parsedContract);
    });
  }
}

function compileDirectory(dirPath) {
  let data = fs.readdirSync(dirPath);
  return data.map(ctc => {
    return { ctc, data: fs.readFileSync(`${dirPath}/${ctc}`).toString() };
  });
}

function compile(artifactor, dirpath) {
  let data = fs.readdirSync(dirpath);
  
  let contractData = [];
  for (ctc in data) {
    if (data[ctc].split('.').length > 1) {
      contractData.push({ ctc: data[ctc], data: fs.readFileSync(`${dirpath}/${data[ctc]}`).toString() });
    } else {
      compileDirectory(`${dirpath}/${data[ctc]}`).forEach(elt => {
        contractData.push(elt);
      });
    }
  }

  // console.log(contractData);
  contractData = contractData.reduce((prev, curr) => (Object.assign({}, prev, {[curr.ctc]: curr.data})), {});
  
  const output = solc.compile({ sources: contractData }, 1);

  const contracts = Object.keys(output.contracts).map(key => ({
      contract_name: key.split(':')[1],
      abi: JSON.parse(output.contracts[key].interface),
      unlinked_binary: output.contracts[key].bytecode,
      schema_version: "0.0.5",
  }))
  .reduce((prev, curr) => (Object.assign({}, prev, {[curr.contract_name]: curr})), {})

  return artifactor.saveAll(contracts);
}