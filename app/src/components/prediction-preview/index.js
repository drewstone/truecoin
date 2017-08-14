import React from 'react';
import Bar from '../bar';

const PredictionPreview = ({ onClick, completed, text, leaning }) => (
  <a onClick={() => console.log('clicked this div yo')}>
    <div className="box">
      <div className="columns">
        <div className="column">
          <li style={{textDecoration: completed ? 'line-through' : 'none'}}>
            {text}
          </li>      
        </div>
      </div>
      <Bar
        twocolor={true}
        colors={['blue', 'red']}
        leaning={leaning}
      />
    </div>
  </a>
);

export default PredictionPreview;