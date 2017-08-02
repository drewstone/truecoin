import React from 'react';
import Prediction from '../prediction';
import Navbar from '../navbar';

export default function Home({ vote, switchTo, data = [] }) {
  return (
      <div className="hero is-small is-light is-bold">
        <Navbar />
        <div className="hero-body">
          <div className="columns">
            <div className="column">
              <ul>
                {
                  data.map((datum, inx) => (
                    <Prediction
                      onClick={(binary) => vote(datum, binary)}
                      key={inx}
                      // eslint-disable-next-line
                      completed={datum.voted == true || datum.voted == false}
                      text={datum.q}
                      leaning={(datum.true / (datum.true + datum.false)) * 100}
                    />
                  ))
                }
              </ul>
            </div>
          </div>
        </div>
      </div>
  );
}