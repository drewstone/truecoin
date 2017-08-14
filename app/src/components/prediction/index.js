import React from 'react';
import Bar from '../bar';
import styled from 'styled-components';

const Button = styled.button`
  margin-left: 5px;
  margin-bottom: 5px;
`;

const Prediction = ({}) => {
  return (
    <div>
      <div className="column">
        <span style={{display: !completed ? 'column' : 'none'}}>
          <Button className="button is-info" onClick={() => onClick(1)}>
            True
          </Button>
        </span>      
        <span style={{display: !completed ? 'column' : 'none'}}>
          <Button className="button is-danger" onClick={() => onClick(0)}>
            False
          </Button>
        </span>
      </div>    
    </div>
  );
}