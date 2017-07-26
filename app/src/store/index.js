import { createStore, applyMiddleware, compose } from 'redux';
import { middleware as reduxPackMiddleware } from 'redux-pack';
import thunk from 'redux-thunk';
import DevTools from '../containers/DevTools';

// import { createLogger } from 'redux-logger';
import rootReducer from '../reducers';

const middleware = [ thunk, reduxPackMiddleware ]

if (process.env.NODE_ENV === 'development') {
  // middleware.push(createLogger());
}

export default (initialState, history) => {
  if (history) middleware.push(history);

  const enhancer = compose(applyMiddleware(...middleware), DevTools.instrument());

  return createStore(
    rootReducer,
    initialState,
    enhancer,
  );
}