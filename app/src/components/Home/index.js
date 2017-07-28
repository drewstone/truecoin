import React from 'react';

import { createGradient } from '../background/gradient';

export default function Home({ switchTo }) {
  return (
    <div style={{display: 'flex', flexDirection: 'column'}}>
      <div style={{display: 'inherit'}}>
        <p style={{position: 'absolute'}}>Tests</p>        
        { createGradient({
          first: 'green',
          second: 'blue',
          height: window.innerHeight
        }) }
      </div>
      <div style={{display: 'inherit'}}>
        <p style={{position: 'absolute'}}>Tests</p>      
        { createGradient({
          gradient: 'deepblue',
          height: window.innerHeight,
        }) }
      </div>
    </div>
  );
}