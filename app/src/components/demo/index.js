import React from 'react';
import Navbar from '../navbar';
import PredictionPreview from '../prediction-preview';

const PredictionList = ({ data, vote }) => (
  <ul className="prediction-previews">{
    data.map((datum, inx) => (
      <PredictionPreview
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
  const style = {height: `${window.innerHeight}px`, padding: '20px'};
  return (
    <div style={{maxHeight: `${window.innerHeight}px`, overflow: 'hidden'}}>
      <Navbar
        demoBool={false}
        names={['test', 'testrer']}
      />
      <section className="hero is-fullheight is-light">
        <div className="columns" style={style}>
          <div className="column is-8 is-offset-2 is-centered" style={{display: 'inherit'}}>
            <div style={{overflow: 'scroll', paddingLeft: '20px', width: '100%'}}>
              <PredictionList
                data={data}
                vote={vote}
              />
            </div>
          </div>
        </div>
      </section>
      <div id="mod"></div>
    </div>
  );
};

export default Demo;