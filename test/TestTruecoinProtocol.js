const Promise = require('bluebird');
const TestHelper = require('../util/testhelpers');

const TruecoinProtocol = artifacts.require('./TruecoinProtocol');
const MechanismManager = artifacts.require('./MechanismManager');
const RBTSMechanism = artifacts.require('./RBTSMechanism');

contract('TruecoinProtocol', (accounts) => {
  let protocol;

  beforeEach(async function() {
    protocol = await TruecoinProtocol.new();
  });

  it('should initialize the protocol', async function() {
    const m = await MechanismManager.new(protocol.address);
    let result = await protocol.initProtocol(m.address);
    assert.ok(result.logs.length > 0);
    assert.equal(result.logs[0].event, 'Initialized');
  });

  it('should set a new RBTS mechanism', async function() {
    const mechanismDesigner = accounts[0];
    const mechanismId = 1;
    const mechanismName = 'Test Mechanism';
    const events = [0,1];
    const tasks = ['task1','task2','task3'];

    const m = await MechanismManager.new(protocol.address, { from: mechanismDesigner });
    const r = await RBTSMechanism.new(events, tasks, { from: mechanismDesigner });

    await protocol.initProtocol(m.address);
    let result = await protocol.setNewMechanism(mechanismId, mechanismName, r.address, { from: mechanismDesigner });
    assert.ok(result.logs.length > 0);
    assert.equal(result.logs[0].event, 'Setting');
    assert.equal(result.logs[0].args.mechContract.toString(), r.address);
  });

  it('should fail to set a new RBTS mechanism from a different account than the designer', async function() {
    const mechanismDesigner = accounts[0];
    const mechanismId = 1;
    const mechanismName = 'Test Mechanism';
    const events = [0,1];
    const tasks = ['task1','task2','task3'];

    const m = await MechanismManager.new(protocol.address, { from: mechanismDesigner });
    const r = await RBTSMechanism.new(events, tasks, { from: mechanismDesigner });

    await protocol.initProtocol(m.address);
    TestHelper.expectThrow(protocol.setNewMechanism(mechanismId, mechanismName, r.address, { from: accounts[1] }));
  });
});