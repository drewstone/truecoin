import { screens } from '../constants';

const developmentFixtures = {
  questions: [{
    id: 1,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    leaning: 30,
  },{
    id: 1,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    leaning: 30,
  },{
    id: 1,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    leaning: 30,
  },{
    id: 1,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    leaning: 30,
  },{
    id: 1,
    type: 'PREDICTION',
    q: 'Is this a quality article?',
    leaning: 30,
  }]
}

export default function (config) {
  const state = { currentScreen: screens.HOME };

  if (process.env.NODE_ENV === 'development') {
    return Object.assign({}, state, developmentFixtures);
  }

  return state;
}
