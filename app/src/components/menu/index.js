import React from 'react';
import styled from 'styled-components';

const Tile = styled.div`
  height: 300px;
`;

export default function Menu({ screenActions }) {
  return (
    <div className="hero hero-body is-large">
      <div className="container">
        <div className="columns">
          <div className="column is-half has-text-centered">
            <a>
              <Tile className="tile is-parent">
                <article id="predict-tile" className="tile is-child is-info notification">
                  <p className="title is-1">Predictors</p>
                  <div className="tile is-child box has-text-left">
                    <p>Answer active questions on the Truecoin platform and get paid in <strong>TRC</strong>. Maximize your reward by providing your truthful answer to each question.</p>
                  </div>
                </article>
              </Tile>
            </a>
          </div>
          <div className="column is-half has-text-centered"> 
            <a>
              <Tile className="tile is-parent">
                <article id="post-tile" className="tile is-child is-info notification">
                  <p className="title is-1">Posters</p>
                  <div className="tile is-child box has-text-left">
                    <p>Post questions to the Truecoin platform to crowdsource the collection of labelled data. The data is truthful by design, using Truecoin's innovative peer prediction mechanisms.</p>
                  </div>
                </article>
              </Tile>
            </a>
          </div>
        </div>
      </div>
    </div>
  );
}