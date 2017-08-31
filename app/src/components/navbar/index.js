import React from 'react';

export default function Navbar({ switchTo, screens = {}, options = {} }) {
  return (
    <div>
      <nav className="navbar" style={{backgroundColor: 'transparent'}}>
        <div className="container" style={{height: '30px'}}>
          <div className="navbar-brand" href="../index.html">
            <a className="navbar-item" href="../index.html">
              <h1 style={{color: "#333", fontSize: '36px' }}>Truecoin</h1>
            </a>
          </div>
          <div className="navbar-menu">
            <div className="navbar-start">
              {
                Object.keys(options).map((n, inx) => (
                  <span className="navbar-item">
                    <a key={inx} className="is-primary"onClick={() => switchTo(screens[n])}>{n}</a>
                  </span>                  
                ))
              }
            </div>
            <div className="navbar-end">
              {
                Object.keys(screens).map((n, inx) => (
                  <span className="navbar-item">
                    <a key={inx} className="is-primary"onClick={() => switchTo(screens[n])}>{n}</a>
                  </span>                  
                ))
              }
            </div>
          </div>
          <span className="nav-toggle">
            <span></span>
            <span></span>
            <span></span>
          </span>
        </div>
      </nav>
    </div>
  );
};