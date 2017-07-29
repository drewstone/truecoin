import React from 'react';
import Prediction from '../prediction';

export default function Home({ switchTo, data = [] }) {
  return (
    <div className={"container"}>
      <ul>
        {
          data.map((datum, inx) => (
            <Prediction
              key={inx}
              onClick={() => console.log('clicked')}
              completed={false}
              text={datum.q}
            />
          ))
        }
      </ul>
    </div>
  );
}