import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { screenActions } from '../actions';
import Home from '../components/home';

class HomeContainer extends Component {
  render() {
    return (
      <Home
        data={this.props.questions}
        switchTo={this.props.screenActions.switchTo}
      />
    );
  }
}

const mapStateToProps = state => ({
  questions: state.questions,
});

const mapDispatchToProps = dispatch => ({
  screenActions: bindActionCreators(screenActions, dispatch),
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(HomeContainer);
