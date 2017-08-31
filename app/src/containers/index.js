import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { screenActions } from '../actions';
import { screens } from '../constants';
import HomeContainer from './HomeContainer';
import DemoContainer from './DemoContainer';

const screenContainerComponent = {
  [screens.HOME]: HomeContainer,
  [screens.DEMO]: DemoContainer,
};

class App extends Component {
  render() {
    const { currentScreen } = this.props;
    const ScreenComponent = screenContainerComponent[currentScreen];
    
    return (
      <ScreenComponent />
    );
  }
}



const mapStateToProps = state => ({
  currentScreen: state.currentScreen,
});

const mapDispatchToProps = dispatch => ({
  screenActions: bindActionCreators(screenActions, dispatch),
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(App);
