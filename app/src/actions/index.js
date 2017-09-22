import * as constants from '../constants';

export const screenActions = {
  switchTo: screen => ({
    type: constants.screenActions.SWITCH_TO,
    payload: screen,
  }),
};

export const predictionActions = {
  binaryVote: (data, value) => ({
    type: constants.userActions.ADD_PREDICTION,
    payload: { data, value },
  }),
};