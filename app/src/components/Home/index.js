import React from 'react';
import Prediction from '../prediction';

export default function Home({ vote, switchTo, data = [] }) {
  return (
    <div className="pure-g">
      <div className="pure-u-1-1">
        <ul style={{marginRight: 40}}>
          <h2>Truecoin Predictions</h2>
          {
            data.map((datum, inx) => (
              <Prediction
                onClick={(binary) => vote(datum, binary)}
                key={inx}
                // eslint-disable-next-line
                completed={datum.voted == true || datum.voted == false}
                text={datum.q}
                leaning={(datum.left / (datum.left + datum.right)) * 100}
              />
            ))
          }
        </ul>
      </div>
    </div>
  );
}