const Promise = require('bluebird');

const RBTSMechanism = artifacts.require('./RBTSMechanism');
const TruecoinProtocol = artifacts.require('./TruecoinProtocol');
const Truecoin = artifacts.require('./Truecoin');

contract('TruecoinProtocol', (accounts) => {
  let protocol;

  beforeEach(async function() {
    protocol = await TruecoinProtocol.new();
  });

  it('should initialize the protocol', async function() {
    let result = await protocol.initProtocol();
    assert.ok(result.logs.length > 0);
    assert.equal(result.logs[0].event, 'Initialized');
  });

  it('should create a new RBTS Mechanism', async function() {
    let result = await protocol.initProtocol();
    assert.notEqual(result, null);

    const mechanismId = 1;
    const events = [0,1];
    const taskId = 1;
    const tasks = ['This is a task'];
    result = await protocol.createNewMechanism(mechanismId, events, taskId, tasks);
    assert.ok(result.logs.length > 0);
    assert.equal(result.logs[0].event, 'Creation');
  });
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