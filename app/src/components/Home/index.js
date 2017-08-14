import React from 'react';
import PredictionPreview from '../prediction-preview';
import Navbar from '../navbar';

export default function Home({ switchTo, screens }) {
  return (
    <section className="home-background hero is-fullheight is-dark">
      <Navbar
        switchTo={switchTo}
        screens={screens}
      />
      <footer className="footer">
        <div className="container">
          <div className="has-text-centered">
            <p>
              <strong>Copyright 2017</strong> - <a href="http://jgthms.com">Truecoin LLC</a>.
            </p>
            <p>
              <a className="icon" href="https://github.com/drewstone">
                <i className="fa fa-github"></i>
              </a>
            </p>
          </div>
        </div>
      </footer>
    </section>
  );
}