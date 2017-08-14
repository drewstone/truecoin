import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { screens } from '../constants';
import { screenActions } from '../actions';
import Home from '../components/home';

class HomeContainer extends Component {
  render() {
    return (
      <Home
        switchTo={this.props.screenActions.switchTo}
        screens={screens}
      />
    );
  }
}

const mapStateToProps = state => ({});

const mapDispatchToProps = dispatch => ({
  screenActions: bindActionCreators(screenActions, dispatch),
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(HomeContainer);
