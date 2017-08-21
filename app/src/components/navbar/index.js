import React from 'react';

export default function Navbar({ switchTo, screens, demoBool=true, names=[] }) {
  return (
    <div className="hero-head">
      <div>
        <nav className="nav is-transparent">
          <div className="container" style={{height: '30px'}}>
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
              {
                names.map((n, inx) => (
                  <a key={inx} className="nav-item">{n}</a>
                ))
              }
              {
                (demoBool) ? (
                  <span className="nav-item">
                  <a className="button is-default" onClick={() => switchTo(screens.DEMO)}>
                    DEMO
                  </a>
                </span>
                ) : (<div></div>)
              }
            </div>
          </div>
        </nav>
      </div>
    </div>
  );
};