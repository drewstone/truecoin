const Promise = require('bluebird');
const TestHelper = require('../util/testhelpers');
const OpenMechanism = artifacts.require('./OpenMechanism');

contract('EndogenousMechanism', (accounts) => {
  let mechanism;
  const mechanismDesigner = accounts[0];
  const events = [0,1];
  const tasks = ['task1','task2','task3'];

  beforeEach(async function() {
    mechanism = await OpenMechanism.new();
  });

  it('should intialize and setup a new mechanism', async function() {
    let result = await mechanism._init(events, tasks, { from: mechanismDesigner });
    assert.notEqual(result, null);

    result = await mechanism.setup(accounts[9], mechanismDesigner);
    assert.notEqual(result, null);

    result = await mechanism._info.call();
    for (var i = result[0].length - 1; i >= 0; i--) {
      assert.equal(web3.toAscii(result[0][i]).substring(0,5), `task${i+1}`);
    }
  });

  it('should submit a prediction to the mechanism', async function() {
    await mechanism._init(events, tasks, { from: mechanismDesigner });
    await mechanism.setup(accounts[9], mechanismDesigner);
    let result = await mechanism._submit(tasks[0], 1, 1, accounts[1], { from: mechanismDesigner });
    assert.notEqual(result, null);

    result = await mechanism._info.call();
    assert.equal(result[1][1], accounts[1]);

    result = await mechanism.getBinaryPred.call(accounts[1], tasks[0]);
    assert.equal(result.toNumber(), 1);

    result = await mechanism.getBinaryPreds.call(accounts[1], tasks);
    result.map(res => res.toNumber()).map(res => )
  });
});