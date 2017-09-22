import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { screens } from '../constants';
import { screenActions, predictionActions } from '../actions';
import Navbar from '../components/navbar';

class NavbarContainer extends Component {
  render() {
    return (
      <Navbar screens={screens} switchTo={this.props.screenActions.switchTo}>
        { this.props.children }
      </Navbar>
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
)(NavbarContainer);
