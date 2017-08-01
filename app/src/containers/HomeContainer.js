import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { screenActions, predictionActions } from '../actions';
import Home from '../components/home';

class HomeContainer extends Component {
  render() {
    return (
      <Home
        data={this.props.predictions}
        switchTo={this.props.screenActions.switchTo}
        vote={this.props.predictionActions.binaryVote}
      />
    );
  }
}

const mapStateToProps = state => ({
  predictions: state.predictions,
});

const mapDispatchToProps = dispatch => ({
  screenActions: bindActionCreators(screenActions, dispatch),
  predictionActions: bindActionCreators(predictionActions, dispatch),
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(HomeContainer);
