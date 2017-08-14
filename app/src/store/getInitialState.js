import { screens } from '../constants';

const developmentFixtures = {
  predictions: [{
    id: 1,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    true: 1,
    false: 10,
  },{
    id: 2,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    true: 2,
    false: 10,
  },{
    id: 3,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    true: 3,
    false: 10,
  },{
    id: 4,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    true: 4,
    false: 10,
  },{
    id: 5,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    true: 5,
    false: 10,
  }]
}

export default function (config) {
  const state = { currentScreen: screens.DEMO };

  if (process.env.NODE_ENV === 'development') {
    return Object.assign({}, state, developmentFixtures);
  }

  return state;
}
