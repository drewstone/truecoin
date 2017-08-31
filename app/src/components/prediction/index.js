import React from 'react';
import Bar from '../bar';
import styled from 'styled-components';

const Button = styled.button`
  margin-left: 5px;
  margin-bottom: 5px;
`;

const Prediction = ({ active=false }) => {
  return (
    <div id="pred-modal" className={`modal ${(active) ? 'is-active' : ''}`}>
      <div className="modal-background"></div>
      <div className="modal-card">
        <header className="modal-card-head">
          <p className="modal-card-title">Modal title</p>
          <Button className="delete" aria-label="close"></Button>
        </header>
        <section className="modal-card-body">
          Test
        </section>
        <footer className="modal-card-foot">
          <Button className="button is-success">Save changes</Button>
          <Button className="button">Cancel</Button>
        </footer>
      </div>
    </div>
  );
}

export default Prediction;