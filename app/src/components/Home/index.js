import React from 'react';
import PredictionPreview from '../prediction-preview';
import Navbar from '../navbar';

export default function Home({ switchTo, screens }) {
  const updatedScreens = Object.assign({}, screens);
  delete updatedScreens.HOME;

  return (
    <div className="home-background">
      <section className="hero is-fullheight">
        <Navbar
          switchTo={switchTo}
          screens={updatedScreens}
        />
      </section>
      <section className="hero is-fullheight is-light">

      </section>
      <footer className="footer" style={{height: '10px'}}>
        <div className="container">
          <div className="has-text-centered">
            <p>
              <strong>Copyright 2017</strong> - <a href="https://github.com/drewstone">Truecoin LLC</a>.
            </p>
            <p>
              <a className="icon" href="https://github.com/drewstone">
                <i className="fa fa-github"></i>
              </a>
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}