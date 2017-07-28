import * as constants from '../constants';

export const screenActions = {
  switchTo: screen => ({
    type: constants.screenActions.SWITCH_TO,
    payload: screen,
  }),
};