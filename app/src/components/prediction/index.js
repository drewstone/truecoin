import React from 'react';
import Bar from '../bar';

const Prediction = ({ onClick, completed, text }) => (
  <div>
    <li
      onClick={onClick}
      style={{
        textDecoration: completed ? 'line-through' : 'none'
      }}
    >
      {text}
    </li>
    <Bar />  
  </div>
);

export default Prediction;