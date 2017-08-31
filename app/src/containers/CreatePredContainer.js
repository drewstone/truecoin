import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { screens } from '../constants';
import { screenActions } from '../actions';
import Prediction from '../components/prediction';

class PredictionContainer extends Component {
  render() {
    return (
      <Prediction
        switchTo={this.props.screenActions.switchTo}
        screens={screens}
      />
    );
  }
}

const mapStateToProps = state => ({
});

const mapDispatchToProps = dispatch => ({
  screenActions: bindActionCreators(screenActions, dispatch),
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(CreatePredContainer);
