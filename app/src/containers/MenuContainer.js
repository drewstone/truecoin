import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { screenActions, predictionActions } from '../actions';
import Menu from '../components/menu';

class MenuContainer extends Component {
  componentDidMount() {
    return ['post-tile', 'predict-tile'].forEach(id => {
      document.getElementById(id).style.borderRadius = '25px';
      document.getElementById(id).addEventListener('mouseover', (e) => {
        document.getElementById(id).style.background = 'white';
        document.getElementById(id).style.borderColor = '#276cda';
        document.getElementById(id).style.color = '#276cda';
        document.getElementById(id).style.borderStyle = 'solid';
      });

      document.getElementById(id).addEventListener('mouseleave', (e) => {
        document.getElementById(id).style.background = '#276cda';
        document.getElementById(id).style.borderColor = 'transparent';
        document.getElementById(id).style.color = 'white';
      });
    });
  }

  render() {
    return (
      <Menu screenActions={this.props.screenActions}/>
    );
  }
}

const mapStateToProps = state => ({
});

const mapDispatchToProps = dispatch => ({
  screenActions: bindActionCreators(screenActions, dispatch),
  predictionActions: bindActionCreators(predictionActions, dispatch),
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(MenuContainer);
