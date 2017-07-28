import { combineReducers } from 'redux';
import { screens, screenActions } from '../constants';

const screenReducer = (state = screens.HOME, action) => {
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