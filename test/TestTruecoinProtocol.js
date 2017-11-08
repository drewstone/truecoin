const Promise = require('bluebird');

const RBTSMechanism = artifacts.require('./RBTSMechanism');
const TruecoinProtocol = artifacts.require('./TruecoinProtocol');
const Truecoin = artifacts.require('./Truecoin');

contract('TruecoinProtocol', (accounts) => {
  let protocol;
  let result;

  beforeEach(async function() {
    protocol = await TruecoinProtocol.new();
    result = await protocol.initProtocol();
  });

  it('should initialize the protocol', async function() {
    assert.ok(result.logs.length > 0);
    assert.equal(result.logs[0].event, 'Initialized');
  });

  it('should create a new RBTS mechanism', async function() {
    const mechanismId = 1;
    const events = [0,1];
    const name = 'New mechanism name';
    const taskIds = ['taskId'];
    result = await protocol.createNewMechanism(mechanismId, events, name, taskIds);
    assert.ok(result.logs.length > 0);
    assert.equal(result.logs[0].event, 'Creation');
  });

  // it('should submit 3 participants predictions to an RBTS mechanism', async function() {
  //   const manager = accounts[0];
  //   const p1 = accounts[1];
  //   const p2 = accounts[2];
  //   const p3 = accounts[3];

  //   const mechanismId = 1;
  //   const events = [0,1];
  //   const name = 'New mechanism name';
  //   const taskIds = ['taskId'];
  //   await protocol.createNewMechanism(mechanismId, events, name, taskIds);
    
  //   result = await protocol.submitPrediction(manager, mechanismId, name, taskIds[0], 1, web3.toWei(0.5, 'ether'), {from: p1});
  //   assert.ok(result.logs.length > 0);
  //   assert.equal(result.logs[0].event, 'Submission');
  //   assert.equal(result.logs[0].args.manager, manager);
    
  //   result = await protocol.submitPrediction(manager, mechanismId, name, taskIds[0], 1, web3.toWei(0.75, 'ether'), {from: p2});
  //   assert.ok(result.logs.length > 0);
  //   assert.equal(result.logs[0].event, 'Submission');
  //   assert.equal(result.logs[0].args.manager, manager);
    
  //   result = await protocol.submitPrediction(manager, mechanismId, name, taskIds[0], 1, web3.toWei(1.0, 'ether'), {from: p3});
  //   assert.ok(result.logs.length > 0);
  //   assert.equal(result.logs[0].event, 'Submission');
  //   assert.equal(result.logs[0].args.manager, manager);

  //   result = await protocol.getMechanism(manager, mechanismId, name);
  //   const rbts = await RBTSMechanism.at(result);

  //   result = await rbts.info();
  //   assert.equal(result[0].length, 4);
  //   assert.ok(web3.toAscii(result[1][0]).includes('taskId'));
  // });

  // it('should score 3 predictions to an RBTS mechanism', async function() {
  //   const manager = accounts[0];
  //   const p1 = accounts[1];
  //   const p2 = accounts[2];
  //   const p3 = accounts[3];

  //   const mechanismId = 1;
  //   const events = [0,1];
  //   const name = 'New mechanism name';
  //   const taskIds = ['taskId'];
  //   await protocol.createNewMechanism(mechanismId, events, name, taskIds);
  //   await protocol.submitPrediction(manager, mechanismId, name, taskIds[0], 1, web3.toWei(0.5, 'ether'), {from: p1});
  //   await protocol.submitPrediction(manager, mechanismId, name, taskIds[0], 1, web3.toWei(0.75, 'ether'), {from: p2});
  //   await protocol.submitPrediction(manager, mechanismId, name, taskIds[0], 1, web3.toWei(1.0, 'ether'), {from: p3});

  //   result = await protocol.claimScoreByTask(manager, mechanismId, name, taskIds[0], {from: p1});
  //   assert.equal(result.logs[0].args.manager, manager);
  //   assert.equal(result.logs[0].args.participant, p1);
  //   console.log(result.logs[0].args);

  //   result = await protocol.claimScoreByTask(manager, mechanismId, name, taskIds[0], {from: p2});
  //   assert.equal(result.logs[0].args.manager, manager);
  //   assert.equal(result.logs[0].args.participant, p2);
  //   console.log(result.logs[0].args);

  //   result = await protocol.claimScoreByTask(manager, mechanismId, name, taskIds[0], {from: p3});
  //   assert.equal(result.logs[0].args.manager, manager);
  //   assert.equal(result.logs[0].args.participant, p3);
  //   console.log(result.logs[0].args);
  // });

  // it('should create a new Endogenous mechanism', async function() {
  //   const manager = accounts[0];
  //   const p1 = accounts[1];
  //   const p2 = accounts[2];
  //   const p3 = accounts[3];

  //   const mechanismId = 2;
  //   const events = [0,1];
  //   const name = 'New mechanism name';
  //   const taskIds = ['taskId'];

  //   result = await protocol.createNewMechanism(mechanismId, events, name, taskIds);
  //   assert.ok(result.logs.length > 0);
  //   assert.equal(result.logs[0].event, 'Creation');
  // });

  // it('should create a new Endogenous mechanism with 3 tasks', async function() {
  //   const manager = accounts[0];
  //   const p1 = accounts[1];
  //   const p2 = accounts[2];
  //   const p3 = accounts[3];

  //   const mechanismId = 2;
  //   const events = [0,1];
  //   const name = 'New mechanism name';
  //   const taskIds = ['task1', 'task2', 'task3'];

  //   await protocol.createNewMechanism(mechanismId, events, name, taskIds);
  //   await protocol.submitPrediction(manager, mechanismId, name, taskIds[0], 1, 0, {from: p1});
  //   await protocol.submitPrediction(manager, mechanismId, name, taskIds[1], 0, 0, {from: p1});

  //   await protocol.submitPrediction(manager, mechanismId, name, taskIds[1], 1, 0, {from: p2});
  //   await protocol.submitPrediction(manager, mechanismId, name, taskIds[2], 1, 0, {from: p2});

  //   await protocol.submitPrediction(manager, mechanismId, name, taskIds[2], 0, 0, {from: p3});
  //   await protocol.submitPrediction(manager, mechanismId, name, taskIds[0], 0, 0, {from: p3});

  //   result = await protocol.claimScoreByTask(manager, mechanismId, name, taskIds[0], {from: p1});
  //   assert.equal(result.logs[0].args.manager, manager);
  //   assert.equal(result.logs[0].args.participant, p1);
  //   console.log(result.logs[0].args);

  //   result = await protocol.claimScoreByTask(manager, mechanismId, name, taskIds[1], {from: p2});
  //   assert.equal(result.logs[0].args.manager, manager);
  //   assert.equal(result.logs[0].args.participant, p2);
  //   console.log(result.logs[0].args);

  //   result = await protocol.claimScoreByTask(manager, mechanismId, name, taskIds[2], {from: p3});
  //   assert.equal(result.logs[0].args.manager, manager);
  //   assert.equal(result.logs[0].args.participant, p3);
  //   console.log(result.logs[0].args);
  // });
});

const expectThrow = async promise => {
  try {
    await promise;
  } catch (error) {
    // TODO: Check jump destination to destinguish between a throw
    //       and an actual invalid jump.
    const invalidOpcode = error.message.search('invalid opcode') >= 0;
    // TODO: When we contract A calls contract B, and B throws, instead
    //       of an 'invalid jump', we get an 'out of gas' error. How do
    //       we distinguish this from an actual out of gas event? (The
    //       testrpc log actually show an 'invalid jump' event.)
    const outOfGas = error.message.search('out of gas') >= 0;
    assert(invalidOpcode || outOfGas, "Expected throw, got '" + error + "' instead");
    return;
  }
  assert.fail('Expected throw not received');
};