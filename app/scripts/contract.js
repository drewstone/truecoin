import Promise from 'bluebird';
import path from 'path';
import fs from 'fs';
import solc from 'solc';
import Artifactor from 'truffle-artifactor';
import contract from 'truffle-contract';
import config from '../config/contracts_config';

export default function() {
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
    return compile(artifactor);
  } else {
    return Promise.map(fs.readdirSync(dirPath), c => {
      let parsedContract = JSON.parse(fs.readFileSync(path.join(dirPath, c)));
      return artifactor.save(parsedContract);
    });
  }  
}

function compile(artifactor) {
  let data = fs.readdirSync(config.CONTRACTS_DIRECTORY);
  data = data.map(contract => ({
    contract,
    data: fs.readFileSync(`${config.CONTRACTS_DIRECTORY}/${contract}`).toString(),
  }))
  .reduce((prev, curr) => (Object.assign({}, prev, {[curr.contract]: curr.data})), {});
  
  const output = solc.compile({ sources: data }, 1);

  const contracts = Object.keys(output.contracts).map(key => ({
      contract_name: key.split(':')[1],
      abi: JSON.parse(output.contracts[key].interface),
      unlinked_binary: output.contracts[key].bytecode,
      schema_version: "0.0.5",
  }))
  .reduce((prev, curr) => (Object.assign({}, prev, {[curr.contract_name]: curr})), {})

  return artifactor.saveAll(contracts);
}