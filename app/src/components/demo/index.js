import React from 'react';

import Navbar from '../navbar';
import PredictionPreview from '../prediction-preview';

const PredictionList = ({ data, vote }) => (
  <ul>{
    data.map((datum, inx) => (
      <PredictionPreview
        onClick={(binary) => vote(datum, binary)}
        key={inx}
        // eslint-disable-next-line
        completed={datum.voted == true || datum.voted == false}
        text={datum.q}
        leaning={(datum.true / (datum.true + datum.false)) * 100}
      />
    ))
  }</ul>
);

const Demo = ({ vote, data = [], switchTo, screens }) => {
  const style = {maxHeight: `${window.innerHeight}px`};
  return (
    <section className="hero is-fullheight is-light">
      <div className="columns">
        <aside className="column is-2 aside hero is-fullheight is-hidden-mobile">
          <div>
            <div className="main">
              <div className="title">Truecoin</div>
              <a href="#" className="item">
                <span className="icon"><i className="fa fa-home"></i>
                </span>
                  <span className="name">Dashboard</span>
                </a>
              <a href="#" className="item">
                <span className="icon"><i className="fa fa-map-marker"></i>
                </span>
                  <span className="name">Activity</span>
                </a>
              <a href="#" className="item">
                <span className="icon"><i className="fa fa-th-list"></i>
                </span>
                  <span className="name">Timeline</span>
                </a>
              <a href="#" className="item">
                <span className="icon"><i className="fa fa-folder-o"></i>
                </span>
                  <span className="name">Folders</span>
                </a>
            </div>
          </div>
        </aside>
        <div className="column is-10 admin-panel">
          <section className="hero is-light is-clipped" style={Object.assign({padding: '40px'}, style)}>
            <div className="columns">
              <div className="column">
                <p style={{fontSize: '30px', marginBottom: '30px'}}>Predictions</p>
              </div>
            </div>
            <div className="columns">
              <div className="column" style={{overflow: 'auto'}}>
                <table className="table is-fullwidth">
                  <thead>
                    <tr>
                      <th style={{height: '50px'}}>One</th>
                      <th>Two</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Three</td>
                      <td>Four</td>
                    </tr>
                    <tr>
                      <td>Five</td>
                      <td>Six</td>
                    </tr>
                    <tr>
                      <td>Seven</td>
                      <td>Eight</td>
                    </tr>
                    <tr>
                      <td>Nine</td>
                      <td>Ten</td>
                    </tr>
                    <tr>
                      <td>Eleven</td>
                      <td>Twelve</td>
                    </tr>
                    <tr>
                      <td>Three</td>
                      <td>Four</td>
                    </tr>
                    <tr>
                      <td>Five</td>
                      <td>Six</td>
                    </tr>
                    <tr>
                      <td>Seven</td>
                      <td>Eight</td>
                    </tr>
                    <tr>
                      <td>Nine</td>
                      <td>Ten</td>
                    </tr>
                    <tr>
                      <td>Eleven</td>
                      <td>Twelve</td>
                    </tr>
                    <tr>
                      <td>Three</td>
                      <td>Four</td>
                    </tr>
                    <tr>
                      <td>Five</td>
                      <td>Six</td>
                    </tr>
                    <tr>
                      <td>Seven</td>
                      <td>Eight</td>
                    </tr>
                    <tr>
                      <td>Nine</td>
                      <td>Ten</td>
                    </tr>
                    <tr>
                      <td>Eleven</td>
                      <td>Twelve</td>
                    </tr>
                    <tr>
                      <td>Three</td>
                      <td>Four</td>
                    </tr>
                    <tr>
                      <td>Five</td>
                      <td>Six</td>
                    </tr>
                    <tr>
                      <td>Seven</td>
                      <td>Eight</td>
                    </tr>
                    <tr>
                      <td>Nine</td>
                      <td>Ten</td>
                    </tr>
                    <tr>
                      <td>Eleven</td>
                      <td>Twelve</td>
                    </tr>
                    <tr>
                      <td>Three</td>
                      <td>Four</td>
                    </tr>
                    <tr>
                      <td>Five</td>
                      <td>Six</td>
                    </tr>
                    <tr>
                      <td>Seven</td>
                      <td>Eight</td>
                    </tr>
                    <tr>
                      <td>Nine</td>
                      <td>Ten</td>
                    </tr>
                    <tr>
                      <td>Eleven</td>
                      <td>Twelve</td>
                    </tr>
                    <tr>
                      <td>Eleven</td>
                      <td>Twelve</td>
                    </tr>
                    <tr>
                      <td>Eleven</td>
                      <td>Twelve</td>
                    </tr>
                  </tbody>
                </table>                
              </div>
            </div>
            </section>
          </div>
        </div>
    </section>
  );
};

export default Demo;