const Promise = require('bluebird');
const TestHelper = require('../util/testhelpers');

const TruecoinProtocol = artifacts.require('./TruecoinProtocol');
const MechanismManager = artifacts.require('./MechanismManager');
const RBTSMechanism = artifacts.require('./RBTSMechanism');

contract('RBTSMechanism', (accounts) => {
  let protocol;
  let manager;
  const timeLength = 1000
  const mechanismDesigner = accounts[0];
  const mechanismId = 1;
  const mechanismName = 'Test Mechanism';
  const events = [0,1];
  const tasks = ['task1'];
  const posterior = web3.toWei(1, 'ether');

  beforeEach(async function() {
    protocol = await TruecoinProtocol.new();
    manager = await MechanismManager.new(protocol.address);
    await protocol.initProtocol(manager.address);
  });

  it('should set a new RBTS mechanism', async function() {
    const rbts = await RBTSMechanism.new(events, tasks, { from: mechanismDesigner });
    let result = await protocol.setNewMechanism(mechanismId, mechanismName, rbts.address, timeLength, { from: mechanismDesigner });
    assert.ok(result.logs.length > 0);
    assert.equal(result.logs[0].event, 'Setting');
    assert.equal(result.logs[0].args.mechContract.toString(), rbts.address);
  });

  it('should submit votes to a task in an RBTS mechanism', async function() {
    const rbts = await RBTSMechanism.new(events, tasks, { from: mechanismDesigner });
    await protocol.setNewMechanism(mechanismId, mechanismName, rbts.address, timeLength, { from: mechanismDesigner });

    let result = await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, 1, { from: accounts[1] });
    assert.equal(result.logs[0].event, 'Submission');
    assert.equal(result.logs[0].args.participant.toString(), accounts[1]);

    result = await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, 1, { from: accounts[2] });
    assert.equal(result.logs[0].event, 'Submission');
    assert.equal(result.logs[0].args.participant.toString(), accounts[2]);

    result = await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, 1, { from: accounts[3] });
    assert.equal(result.logs[0].event, 'Submission');
    assert.equal(result.logs[0].args.participant.toString(), accounts[3]);
  });

  it('should score votes to a task in an RBTS mechanism', async function() {


    const rbts = await RBTSMechanism.new(events, tasks, { from: mechanismDesigner });
    await protocol.setNewMechanism(mechanismId, mechanismName, rbts.address, timeLength, { from: mechanismDesigner });
    await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, posterior, { from: accounts[1] });
    await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, posterior, { from: accounts[2] });
    await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, posterior, { from: accounts[3] });
    let result = await protocol.claimScoreByTask(mechanismDesigner, mechanismId, mechanismName, tasks[0], { from: accounts[1] });
    assert.ok(result.logs[0].args.score.toNumber(), web3.toWei(2, 'ether'));
  });

  it('should submit votes to a task in an RBTS mechanism using general score function', async function() {
    const rbts = await RBTSMechanism.new(events, tasks, { from: mechanismDesigner });
    await protocol.setNewMechanism(mechanismId, mechanismName, rbts.address, timeLength, { from: mechanismDesigner });

    await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, posterior, { from: accounts[1] });
    await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, posterior, { from: accounts[2] });
    await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, posterior, { from: accounts[3] });
    let result = await protocol.claimScore(mechanismDesigner, mechanismId, mechanismName, { from: accounts[1] });
    assert.ok(result.logs[0].args.score.toNumber(), web3.toWei(2, 'ether'));
  });
});