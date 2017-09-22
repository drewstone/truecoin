import { combineReducers } from 'redux';
import { screens, screenActions, userActions } from '../constants';

const screenReducer = (state = screens.MENU, action) => {
  const { type, payload } = action;

  switch (type) {
    case screenActions.SWITCH_TO:
      return payload;
    default:
      return state;
  }
};

const predictionReducer = (state = [], action) => {
  const { type, payload } = action;

  switch (type) {
    case userActions.ADD_PREDICTION:
      return state.map(elt => {
        if (elt.id === payload.data.id) {
          if (payload.value) {
            payload.data.true += 1;
          } else {
            payload.data.false += 1;
          }

          return Object.assign({}, payload.data, {
            voted: payload.value,
          });
        } else {
          return Object.assign({}, elt);
        }
      });

    default:
      return state;
  }
};

export default combineReducers({
  currentScreen: screenReducer,
  predictions: predictionReducer,
});