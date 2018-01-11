const Promise = require('bluebird');
const TestHelper = require('../util/testhelpers');

const TruecoinProtocol = artifacts.require('./TruecoinProtocol');
const MechanismManager = artifacts.require('./MechanismManager');
const EndogenousMechanism = artifacts.require('./EndogenousMechanism');

contract('EndogenousMechanism', (accounts) => {
  let protocol;
  let manager;
  const timeLength = 1000
  const mechanismDesigner = accounts[0];
  const mechanismId = 2;
  const mechanismName = 'Test Mechanism';
  const events = [0,1];
  const tasks = ['task1','task2','task3'];

  beforeEach(async function() {
    protocol = await TruecoinProtocol.new();
    manager = await MechanismManager.new(protocol.address);
    await protocol.initProtocol(manager.address);
  });

  it('should set a new Endogenous mechanism', async function() {
    const endg = await EndogenousMechanism.new(events, tasks, { from: mechanismDesigner });
    let result = await protocol.setNewMechanism(mechanismId, mechanismName, endg.address, timeLength, { from: mechanismDesigner });
    assert.ok(result.logs.length > 0);
    assert.equal(result.logs[0].event, 'Setting');
    assert.equal(result.logs[0].args.mechContract.toString(), endg.address);
  });

  it('should submit votes to a task in an Endogenous mechanism', async function() {
    const endg = await EndogenousMechanism.new(events, tasks, { from: mechanismDesigner });
    await protocol.setNewMechanism(mechanismId, mechanismName, endg.address, timeLength, { from: mechanismDesigner });

    let result = await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, 1, { from: accounts[1] });
    assert.equal(result.logs[0].event, 'Submission');
    assert.equal(result.logs[0].args.participant.toString(), accounts[1]);

    result = await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[1], 1, 1, { from: accounts[1] });
    assert.equal(result.logs[0].event, 'Submission');
    assert.equal(result.logs[0].args.participant.toString(), accounts[1]);

    result = await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[1], 1, 1, { from: accounts[2] });
    assert.equal(result.logs[0].event, 'Submission');
    assert.equal(result.logs[0].args.participant.toString(), accounts[2]);
    
    result = await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[2], 1, 1, { from: accounts[2] });
    assert.equal(result.logs[0].event, 'Submission');
    assert.equal(result.logs[0].args.participant.toString(), accounts[2]);
});

  it('should score votes to a task in an Endogenous mechanism', async function() {
    const endg = await EndogenousMechanism.new(events, tasks, { from: mechanismDesigner });
    await protocol.setNewMechanism(mechanismId, mechanismName, endg.address, timeLength, { from: mechanismDesigner });
    await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[0], 1, 1, { from: accounts[1] });
    await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[1], 1, 1, { from: accounts[1] });
    await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[1], 1, 1, { from: accounts[2] });
    await protocol.submitPrediction(mechanismDesigner, mechanismId, mechanismName, tasks[2], 1, 1, { from: accounts[2] });

    let result = await protocol.claimScoreByTask(mechanismDesigner, mechanismId, mechanismName, tasks[0], { from: accounts[1] });
    result = await protocol.claimScoreByTask(mechanismDesigner, mechanismId, mechanismName, tasks[1], { from: accounts[1] });
    result = await protocol.claimScoreByTask(mechanismDesigner, mechanismId, mechanismName, tasks[2], { from: accounts[1] });
  });
});