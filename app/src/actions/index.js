import { screenConstants } from '../constants';

export const screenActions = {
  switchTo: screen => ({
    type: screenConstants.switchTo,
    payload: screen,
  }),
};