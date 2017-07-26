import { combineReducers } from 'redux';
import { screenConstants, screenActions } from '../constants';

const screenReducer = (state = screenConstants.HOME, action) => {
  const { type, payload } = action;

  switch (type) {
    case screenActions.SWITCH_TO:
      return payload;
    default:
      return state;

  }
};

export default combineReducers({
  currentScreen: screenReducer,
});