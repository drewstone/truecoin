import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { screenActions } from '../actions';
import { screens } from '../constants';
import NavbarContainer from './NavbarContainer';
import MenuContainer from './MenuContainer';

const screenContainerComponent = {
  [screens.MENU]: MenuContainer,
};

class App extends Component {
  render() {
    const { currentScreen } = this.props;
    const ScreenComponent = screenContainerComponent[currentScreen];
    
    return (
      <NavbarContainer>
        <ScreenComponent />
      </NavbarContainer>
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
