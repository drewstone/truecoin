import React from 'react';

export default function Navbar({ switchTo, screens, options = {}, children }) {
  return (
    <section className="hero is-fullheight header-image">
      <div className="hero-head">
        <header className="nav">
          <div className="container">
            <div className="nav-left">
              <a className="nav-item" href="../index.html">
                <p className="nav-title">Truecoin</p>
              </a>
            </div>
            <span className="nav-toggle">
              <span></span>
              <span></span>
              <span></span>
            </span>
            <div className="nav-right nav-menu">
              <span className="nav-item">
                <a id="menu-btn" className="button is-info">
                  <span>Menu</span>
                </a>
              </span>
              <span className="nav-item">
                <a id="predict-btn" className="button is-info is-outlined">
                  <span>Predict</span>
                </a>
              </span>
              <span className="nav-item">
                <a id="about-btn" className="button is-info is-outlined">
                  <span>Post</span>
                </a>
              </span>
            </div>
          </div>
        </header>
      </div>
      { children }
    </section>
  );
};