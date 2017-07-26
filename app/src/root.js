import React from 'react'
import { render } from 'react-dom'
import { Provider } from 'react-redux'
import { createStore } from 'redux'
import todoApp from './reducers'
import App from './components/App'

let store = createStore(todoApp)

const Root = (
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
);

export default Root;