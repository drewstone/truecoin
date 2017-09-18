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

  it('should create a protocol and a mechanism ', () => {
    return TruecoinProtocol.new(100, 0).then(protocol => {
      const question = 'Is there a bringle in this image?';
      const mechanismType = 'RBTS';

      return protocol.createNewMechanism.call(question, mechanismType, {from: accounts[0]})
      .then(success => {
        assert.ok(success);
        return protocol.createNewMechanism(question, mechanismType, {from: accounts[0]});
      })
      .then(txHash => assert.notEqual(txHash, null))
      .then(() => protocol.createNewMechanism.call(question, mechanismType, {from: accounts[0]}))
      .then(success => assert.notEqual(success, true));
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