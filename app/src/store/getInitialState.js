import { screens } from '../constants';

const developmentFixtures = {
  predictions: [{
    id: 1,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    left: 1,
    right: 10,
  },{
    id: 2,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    left: 2,
    right: 10,
  },{
    id: 3,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    left: 3,
    right: 10,
  },{
    id: 4,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    left: 4,
    right: 10,
  },{
    id: 5,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    left: 5,
    right: 10,
  }]
}

export default function (config) {
  const state = { currentScreen: screens.HOME };

  if (process.env.NODE_ENV === 'development') {
    return Object.assign({}, state, developmentFixtures);
  }

  return state;
}
