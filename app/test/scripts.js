import compile from '../scripts/contract';

describe('Script tests', () => {
  it('', () => {
    return compile()
    .then(contracts => {
      console.log(Object.keys(contracts));
    });
  });
})