const TestHelpers = require('../helpers');
const Mechanism = artifacts.require('./Mechanism');

contract('Mechanism', (accounts) => {
  let mechanism;
  const events = ['up', 'down'];
  const questions = ['will AAPL go up?'];
  const timeLength = 1;
  const name = 'Test';
  const description = 'Test Description';
  const tags = ['Finance'];

  beforeEach(async function() {
    mechanism = await Mechanism.new(events, questions, timeLength, name, description, tags);
  });

  it('should initialize a mechanism', async function() {
    let result = await mechanism.getQuestions.call();
    assert.equal(questions[0], web3.toAscii(result.toString()).replace(new RegExp('\u0000', 'g'), ''));
  });

  it('should submit votes to a mechanism', async function() {
    let result = await mechanism.submit.sendTransaction(questions[0], 0, [1], accounts[1], { from: accounts[1] });
    assert.notEqual(result, null);
  });

  it('should not allow the same account to submit more than 1 vote', async function() {
    let result = await mechanism.submit(questions[0], 0, [1], accounts[1], { from: accounts[1] });
    
    try {
      await mechanism.submit(questions[0], 0, [1], accounts[1], { from: accounts[1] });
      throw new Error();
    } catch(e) {
      return;
    }
  });

  it('should not allow a different account to submit votes on behalf of', async function() {    
    try {
      await mechanism.submit(questions[0], 0, [1], accounts[2], { from: accounts[1] });
      throw new Error();
    } catch(e) {
      return;
    }
  });

  it('should only allow the manager or same account to submit votes', async function() {
    await mechanism.submit(questions[0], 0, [1], accounts[1], { from: accounts[1] });
    await mechanism.submit(questions[0], 0, [1], accounts[2], { from: accounts[0] });

    try {
      await mechanism.submit(questions[0], 0, [1], accounts[1], { from: accounts[0] });
      throw new Error();
    } catch(e) {
      return;
    }
  });

  it('should submit many votes', async function() {
    const promises = [...Array(9).keys()].map(i => {
      return mechanism.submit(questions[0], 0, [1], accounts[i+1], { from: accounts[i+1] })
    });

    let result = await Promise.all(promises);
    assert.ok(result);
    assert.equal(result.length, 9)
  });
});