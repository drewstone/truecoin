import React from 'react';

export default function Navbar({}) {
  return (
    <nav className="navbar">
      <div className="navbar-brand">
        <a className="navbar-item">
          <p style={{fontSize: '32px'}}>TRUECOIN</p>
        </a>

        <div className="navbar-burger">
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>
    </nav>
  );
};