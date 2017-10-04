const Promise = require('bluebird');

const RBTSMechanism = artifacts.require('./RBTSMechanism');
const TruecoinProtocol = artifacts.require('./TruecoinProtocol');
const Truecoin = artifacts.require('./Truecoin');

contract('TruecoinProtocol', (accounts) => {
  it('should ensure a blank protocol creates a defunct Truecoin token', () => {
    return TruecoinProtocol.deployed().then(protocol => {
      return protocol.TRC.call()
      .then(address => {
        assert.notEqual(null, address);
        return Truecoin.at(address);
      })
      .then(trc => {
        return trc.totalSupply.call()
        .then(supply => {
          assert.equal(supply.toNumber(), 0);
        });
      });
    });
  });

  it('should create a protocol with 100 TRC', () => {
    return TruecoinProtocol.new(100, 0).then(protocol => {
      return protocol.TRC.call()
      .then(address => {
        assert.notEqual(null, address);
        return Truecoin.at(address);
      })
      .then(trc => {
        return trc.totalSupply.call()
        .then(supply => {
          assert.equal(supply.toNumber(), 100);
        });
      });
    });
  });

  it('should create a protocol and a mechanism only once', () => {
    return TruecoinProtocol.new(100, 0).then(protocol => {
      const question = 'Is there a bringle in this image?';
      const mechanismType = 'RBTS';

      return protocol.createNewMechanism.call(mechanismType, question, {from: accounts[0]})
      .then(success => {
        assert.ok(success);
        return protocol.createNewMechanism(mechanismType, question, {from: accounts[0]});
      })
      .then(txHash => assert.notEqual(txHash, null))
      .then(() => protocol.createNewMechanism.call(mechanismType, question, {from: accounts[0]}))
      .then(success => assert.notEqual(success, true));
    });
  });

  it('should create an RBTSMechanism and submit 1 RBTS prediction', () => {
    return TruecoinProtocol.new(100, 0).then(protocol => {
      const mechanismType = 'RBTS';
      const question = 'Is there a bringle in this image?';
      const manager = accounts[0];
      const player = accounts[1];
      const binaryPred = 1;
      const metaPred = web3.toWei(1, 'ether');
      const playerOneOpts = [
        manager,
        mechanismType,
        question,
        binaryPred,
        metaPred,
        {from: player}
      ];

      return protocol.createNewMechanism(mechanismType, question)
      .then(txHash => assert.notEqual(txHash, null))
      .then(() => protocol.submitPrediction.call(...playerOneOpts))
      .then(success => assert.ok(success))
      .then(() => protocol.submitPrediction(...playerOneOpts))
      .then(txHash => assert.notEqual(txHash, null))
      .then(() => protocol.getMechanism.call(manager, mechanismType, question))
      .then(addr => {
        assert.notEqual(addr, null);
        return RBTSMechanism.at(addr);
      })
      .then(rbts => {
        assert.notEqual(rbts, null);
        return rbts.getInfo.call();
      })
      .then(info => {
        assert.notEqual(info, null);
        assert.equal(info[0][0].toString(), player);
        assert.equal(info[1][0].toNumber(), 1);
        assert.equal(info[2][0].toNumber(), web3.toWei(1, 'ether'));
      });
    });
  });

  it('should create and submit an RBTSMechanism with 3 voters', () => {
    return TruecoinProtocol.new(100, 0).then(protocol => {
      const mechanismType = 'RBTS';
      const question = 'Is there a bringle in this image?';
      const manager = accounts[0];

      const playerOne = accounts[1];
      const binaryPredOne = 1;
      const metaPredOne = web3.toWei(1, 'ether');

      const playerOneOpts = [
        manager,
        mechanismType,
        question,
        binaryPredOne,
        metaPredOne,
        {from: playerOne}
      ];

      const playerTwo = accounts[2];
      const binaryPredTwo = 0;
      const metaPredTwo = web3.toWei(0.25, 'ether');

      const playerTwoOpts = [
        manager,
        mechanismType,
        question,
        binaryPredTwo,
        metaPredTwo,
        {from: playerTwo}
      ];

      const playerThree = accounts[3];
      const binaryPredThree = 1;
      const metaPredThree = web3.toWei(0.75, 'ether');

      const playerThreeOpts = [
        manager,
        mechanismType,
        question,
        binaryPredThree,
        metaPredThree,
        {from: playerThree}
      ];

      return protocol.createNewMechanism(mechanismType, question)
      .then(txHash => assert.notEqual(txHash, null))
      .then(() => protocol.submitPrediction(...playerOneOpts))
      .then(txHash => assert.notEqual(txHash, null))
      .then(() => protocol.submitPrediction(...playerTwoOpts))
      .then(txHash => assert.notEqual(txHash, null))
      .then(() => protocol.submitPrediction(...playerThreeOpts))
      .then(txHash => assert.notEqual(txHash, null))
      .then(() => protocol.getMechanism.call(manager, mechanismType, question))
      .then(addr => {
        assert.notEqual(addr, null);
        return RBTSMechanism.at(addr);
      })
      .then(rbts => {
        assert.notEqual(rbts, null);
        return rbts.getInfo.call();
      })
      .then(info => {
        assert.notEqual(info, null);
        assert.equal(info[0][0].toString(), playerOne);
        assert.equal(info[1][0].toNumber(), 1);
        assert.equal(info[2][0].toNumber(), web3.toWei(1, 'ether'));
        assert.equal(info[0][1].toString(), playerTwo);
        assert.equal(info[1][1].toNumber(), 0);
        assert.equal(info[2][1].toNumber(), web3.toWei(0.25, 'ether'));
        assert.equal(info[0][2].toString(), playerThree);
        assert.equal(info[1][2].toNumber(), 1);
        assert.equal(info[2][2].toNumber(), web3.toWei(0.75, 'ether'));
      });
    });
  });

  it('should score an RBTSMechanism with 3 voters', () => {
    return TruecoinProtocol.new(100, 0).then(protocol => {
      const mechanismType = 'RBTS';
      const question = 'Is there a bringle in this image?';
      const rewards = [1.75, 1.1875, 0.4375];
      const manager = accounts[0];

      const playerOne = accounts[1];
      const binaryPredOne = 1;
      const metaPredOne = web3.toWei(1, 'ether');

      const playerOneOpts = [
        manager,
        mechanismType,
        question,
        binaryPredOne,
        metaPredOne,
        {from: playerOne}
      ];

      const playerTwo = accounts[2];
      const binaryPredTwo = 0;
      const metaPredTwo = web3.toWei(0.25, 'ether');

      const playerTwoOpts = [
        manager,
        mechanismType,
        question,
        binaryPredTwo,
        metaPredTwo,
        {from: playerTwo}
      ];

      const playerThree = accounts[3];
      const binaryPredThree = 1;
      const metaPredThree = web3.toWei(0.75, 'ether');

      const playerThreeOpts = [
        manager,
        mechanismType,
        question,
        binaryPredThree,
        metaPredThree,
        {from: playerThree}
      ];

      return protocol.createNewMechanism(mechanismType, question)
      .then(() => protocol.submitPrediction(...playerOneOpts))
      .then(() => protocol.submitPrediction(...playerTwoOpts))
      .then(() => protocol.submitPrediction(...playerThreeOpts))
      .then(() => Promise.all([
        protocol.claimReward.call(manager, mechanismType, question, {from: playerOne}),
        protocol.claimReward.call(manager, mechanismType, question, {from: playerTwo}),
        protocol.claimReward.call(manager, mechanismType, question, {from: playerThree})
      ]))
      .then(result => result.map(elt => web3.fromWei(elt.toNumber(), 'ether')))
      .then(result => {
        assert.equal(result[0], rewards[0]);
        assert.equal(result[1], rewards[1]);
        assert.equal(result[2], rewards[2]);
      });
    });
  });

  it('should score 3 voters and mint new tokens from an RBTSMechanism', () => {
    return TruecoinProtocol.new(0, 0).then(protocol => {
      const mechanismType = 'RBTS';
      const question = 'Is there a bringle in this image?';
      const manager = accounts[0];

      const playerOne = accounts[1];
      const binaryPredOne = 1;
      const metaPredOne = web3.toWei(1, 'ether');

      const playerOneOpts = [
        manager,
        mechanismType,
        question,
        binaryPredOne,
        metaPredOne,
        {from: playerOne}
      ];

      const playerTwo = accounts[2];
      const binaryPredTwo = 0;
      const metaPredTwo = web3.toWei(0.25, 'ether');

      const playerTwoOpts = [
        manager,
        mechanismType,
        question,
        binaryPredTwo,
        metaPredTwo,
        {from: playerTwo}
      ];

      const playerThree = accounts[3];
      const binaryPredThree = 1;
      const metaPredThree = web3.toWei(0.75, 'ether');

      const playerThreeOpts = [
        manager,
        mechanismType,
        question,
        binaryPredThree,
        metaPredThree,
        {from: playerThree}
      ];

      return protocol.createNewMechanism(mechanismType, question)
      .then(() => protocol.submitPrediction(...playerOneOpts))
      .then(() => protocol.submitPrediction(...playerTwoOpts))
      .then(() => protocol.submitPrediction(...playerThreeOpts))
      .then(() => Promise.all([
        protocol.claimReward(manager, mechanismType, question, {from: playerOne}),
        protocol.claimReward(manager, mechanismType, question, {from: playerTwo}),
        protocol.claimReward(manager, mechanismType, question, {from: playerThree})
      ]))
      .then(result => result.map(res => assert.notEqual(res, null)))
      .then(() => protocol.TRC.call())
      .then(address => Truecoin.at(address))
      .then(trc => trc.totalSupply.call())
      .then(supply => assert.ok(supply.toNumber() > 0));
    });
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