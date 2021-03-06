const Promise = require('bluebird');
const Protocol = artifacts.require('./Protocol');
const Mechanism = artifacts.require('./Mechanism');
const RBTS = artifacts.require('./RBTS');
const Truecoin = artifacts.require('./Truecoin');

contract('Protocol', (accounts) => {
  let protocol;

  beforeEach(async function() {
    protocol = await Protocol.new();
  });

  it('should initialize a protocol and create a task', async function() {
    const taskName = 'Test';
    const events = ['up', 'down'];
    const questions = ['will AAPL go up?'];
    const timeLength = 1;
    const description = 'Test Description';
    const tags = ['Finance'];

    let result = await protocol.owner.call();
    assert.equal(result.toString(), accounts[0]);
    
    const args = [taskName, events, questions, timeLength, description, tags];
    result = await protocol.createTask.call(...args, { from: accounts[0] });
    assert.ok(result);
    result = await protocol.createTask(...args, { from: accounts[0] });
    assert.equal(result.logs[0].event, 'Creation');

    let address = await protocol.getTask.call(taskName, accounts[0]);
    mechanism = Mechanism.at(address);
    result = await mechanism.protocol.call();
    assert.equal(result.toString(), protocol.address);
  });

  it('should submit many answers', async function() {
    const designer = accounts[0];
    const taskName = 'Test';
    const events = ['up', 'down'];
    const questions = ['will AAPL go up?'];
    const timeLength = 1;
    const description = 'Test Description';
    const tags = ['Finance'];

    let args = [taskName, events, questions, timeLength, description, tags];
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
    const events = ['up', 'down'];
    const questions = ['will AAPL go up?'];
    const timeLength = 1;
    const description = 'Test Description';
    const tags = ['Finance'];

    let args = [taskName, events, questions, timeLength, description, tags];
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
        protocol: mech.protocol.call(),
        questions: mech.getQuestions.call(),
      }
    });

    result = await Promise.all(promises.map(Promise.props));
    result.forEach(res => {
      assert.equal(web3.toAscii(res.name.toString()).replace(new RegExp('\u0000', 'g'), ''), taskName);
      assert.equal(web3.toAscii(res.questions[0].toString()).replace(new RegExp('\u0000', 'g'), ''), questions[0]);
      assert.equal(res.protocol, protocol.address);
    })
  });

  it('should submit a batch of answers to all questions', async function() {
    const designer = accounts[0];
    const taskName = 'Financial predictions';
    const description = 'Test Description';
    const tags = ['Finance'];
    const events = ['up', 'down'];
    const questions = ['A', 'B', 'C', 'D', 'E', 'F', 'G'].map(l => `Will ${l} go up?`);
    const questionIndices = [...Array(7).keys()];
    const timeLength = 1;
    const predictions = [[0], [1], [0], [1], [0], [1], [0]];

    let args = [taskName, events, questions, timeLength, description, tags];
    let result = await protocol.createTask(...args, { from: designer });
    assert.equal(result.logs[0].event, 'Creation');

    let submitter = accounts[1];
    args = [taskName, designer, questions, questionIndices, predictions];
    result = await protocol.submitBatch(...args, { from: submitter });
    assert.ok(result);
    assert.equal(result.logs[0].event, 'BatchSubmission');
    assert.equal(result.logs[0].args.designer, designer);
    assert.equal(result.logs[0].args.participant, submitter);
    assert.equal(web3.toAscii(result.logs[0].args.taskName.toString()).replace(new RegExp('\u0000', 'g'), ''), taskName);
  });

  it('should score a task with answers to all questions', async function() {
    const designer = accounts[0];
    const taskName = 'Financial predictions';
    const description = 'Test Description';
    const tags = ['Finance'];
    const events = ['up', 'down'];
    const questions = ['A', 'B', 'C', 'D', 'E', 'F', 'G'].map(l => `Will ${l} go up?`);
    const questionIndices = [...Array(7).keys()];
    const timeLength = 100;

    const predictions1 = [[0], [1], [0], [1], [0], [1], [0]];
    const predictions2 = [[1], [1], [0], [1], [0], [0], [1]];
    const predictions3 = [[0], [1], [0], [0], [1], [1], [0]];

    let args = [taskName, events, questions, timeLength, description, tags];
    let result = await protocol.createTask(...args, { from: designer });
    const task = await Mechanism.at(result.logs[0].args.mechContract);
    assert.equal(result.logs[0].event, 'Creation');

    let submitter1 = accounts[1];
    let submitter2 = accounts[2];
    let submitter3 = accounts[3];

    args1 = [taskName, designer, questions, questionIndices, predictions1];
    args2 = [taskName, designer, questions, questionIndices, predictions2];
    args3 = [taskName, designer, questions, questionIndices, predictions3];
    await protocol.submitBatch(...args1, { from: submitter1 });
    await protocol.submitBatch(...args2, { from: submitter2 });
    await protocol.submitBatch(...args3, { from: submitter3 });

    const rbts = await RBTS.new(protocol.address);
    const truecoin = await Truecoin.new(0);

    await protocol.setTruecoinContract(truecoin.address);
    await truecoin.transferOwnership(protocol.address);
    await protocol.setScoringContract("rbts", rbts.address);

    result = await task.getParticipants.call();
    result = await rbts.score(taskName, designer);
    assert.equal(result.logs[0].event, 'ScoreTask');

    result = await protocol.mintForTask("rbts", task.address);
    assert.equal(result.receipt.logs.length, 7);
  });
});