import React, { Component } from 'react';
import { Provider } from 'react-redux';

import configureStore from './store';
import getInitialState from './store/getInitialState';
import App from './containers';
import DevTools from './containers/DevTools';

const store = configureStore(getInitialState());

export default class Root extends Component {
  render() {
    return (
      <Provider store={store}>
        <div>
          <App />
          <DevTools />
        </div>
      </Provider>
    );
  }
}
