const Promise = require('bluebird');
const Protocol = artifacts.require('./Protocol');
const Mechanism = artifacts.require('./Mechanism');

contract('Protocol', (accounts) => {
  let protocol;

  beforeEach(async function() {
    protocol = await Protocol.new();
  });

  it('should initialize a protocol and create a task', async function() {
    const taskName = 'Test';
    const events = [0, 1];
    const questions = ['will AAPL go up?'];
    const timeLength = 1;

    let result = await protocol.owner.call();
    assert.equal(result.toString(), accounts[0]);
    
    const args = [taskName, events, questions, timeLength];
    result = await protocol.createTask.call(...args, { from: accounts[0] });
    assert.ok(result);
    result = await protocol.createTask(...args, { from: accounts[0] });
    assert.equal(result.logs[0].event, 'Creation');

    let address = await protocol.getTask.call(taskName, accounts[0]);
    mechanism = Mechanism.at(address);
    result = await mechanism.manager.call();
    assert.equal(result.toString(), protocol.address);
  });

  it('should submit many answers', async function() {
    const designer = accounts[0];
    const taskName = 'Test';
    const events = [0, 1];
    const questions = ['will AAPL go up?'];
    const timeLength = 1;

    let args = [taskName, events, questions, timeLength];
    await protocol.createTask(...args, { from: accounts[0] });

    let submitArgs = [taskName, designer, questions[0], 0, [1]]

    const promises = [...Array(9).keys()].map(i => {
      return protocol.submitQuestion(...submitArgs, { from: accounts[i+1] })
    });

    let result = await Promise.all(promises);
    assert.equal(result.length, 9);
    result.forEach(result => assert.equal(result.logs[0].event, 'Submission'));

    let address = await protocol.getTask.call(taskName, accounts[0]);
    mechanism = Mechanism.at(address);
    result = await mechanism.getAnswers.call(0);
    assert.equal(result.length, 9);
  });

  it('should create many questions and fetch all task designers', async function() {
    const designers = accounts;
    const taskName = 'Test';
    const events = [0, 1];
    const questions = ['will AAPL go up?'];
    const timeLength = 1;

    let args = [taskName, events, questions, timeLength];
    let promises = designers.map(designer => {
      return protocol.createTask(...args, { from: designer });
    });

    let result = await Promise.all(promises);
    assert.ok(result);
    assert.equal(result.length, 10)
    result.forEach(res => assert.equal(res.logs[0].event, 'Creation'));

    result = await protocol.getDesignerCount.call();
    assert.equal(result.toNumber(), designers.length);

    result = await protocol.getTasks.call();
    promises = result.map(addr => Mechanism.at(addr));

    result = await Promise.all(promises);

    promises = result.map(mech => {
      return {
        name: mech.name.call(),
        manager: mech.manager.call(),
        questions: mech.getQuestions.call(),
      }
    });

    result = await Promise.all(promises.map(Promise.props));
    result.forEach(res => {
      assert.equal(web3.toAscii(res.name.toString()).replace(new RegExp('\u0000', 'g'), ''), taskName);
      assert.equal(web3.toAscii(res.questions[0].toString()).replace(new RegExp('\u0000', 'g'), ''), questions[0]);
      assert.equal(res.manager, protocol.address);
    })
  });
});