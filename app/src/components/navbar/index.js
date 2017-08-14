import React from 'react';

export default function Navbar({ switchTo, screens }) {
  return (
    <div className="hero-head">
      <div className="container">
        <nav className="nav">
          <div className="container">
            <div className="nav-left">
              <a className="nav-item" href="../index.html">
                <h1 style={{fontSize: '36px'}}>Truecoin</h1>
              </a>
            </div>
            <span className="nav-toggle">
              <span></span>
              <span></span>
              <span></span>
            </span>
            <div className="nav-right nav-menu">
              <span className="nav-item">
                <a className="button is-default" onClick={() => switchTo(screens.DEMO)}>
                  DEMO
                </a>
              </span>
            </div>
          </div>
        </nav>
      </div>
    </div>
  );
};