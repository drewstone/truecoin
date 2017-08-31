import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Web3Provider } from 'react-web3';

import { screens, options } from '../constants';
import { screenActions, predictionActions } from '../actions';
import Demo from '../components/demo';

class DemoContainer extends Component {
  render() {
    return (
      <Web3Provider>
        <Demo
          data={this.props.predictions}
          switchTo={this.props.screenActions.switchTo}
          vote={this.props.predictionActions.binaryVote}
          screens={screens}
          options={options}
        />
      </Web3Provider>
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
)(DemoContainer);
