import React from 'react';
import { colors, gradients } from '../colors';

let convertToRGB = (hex) => {
  if (typeof hex !== 'string') {
    throw new TypeError('Expected a string');
  }

  hex = hex.replace(/^#/, '');

  if (hex.length === 3) {
    hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
  }

  var num = parseInt(hex, 16);

  // eslint-disable-next-line
  return `rgb(${num >> 16}, ${num >> 8 & 255}, ${num & 255})`;
};

let Background = ({ firstColor, secondColor, gradient, height }) => {
  let firstColorCodes; 
  let secondColorCodes;

  if (gradient) {
    firstColorCodes = convertToRGB(gradients[gradient][0]);
    secondColorCodes = convertToRGB(gradients[gradient][1])
  } else if (firstColor && secondColor) {
    firstColorCodes = convertToRGB(colors[firstColor]);
    secondColorCodes = convertToRGB(colors[secondColor]);
  } else {
    firstColorCodes = "rgb(89,189,255)";
    secondColorCodes = "rgb(191,255,239)";
  }

  const style = (height) ? { width: "100%", height } : { width: "100%" }

  return (
    <svg xmlns="http://www.w3.org/2000/svg" style={style}>
      <defs> 
        <linearGradient id={`lgrad${firstColor}${secondColor}`} x1="0%" y1="100%" x2="100%" y2="0%" > 
          <stop offset="0%" style={{
            stopColor: firstColorCodes,
            stopOpacity: 1,
          }} />
          <stop offset="100%" style={{
            stopColor: secondColorCodes,
            stopOpacity: 1,
          }} />
        </linearGradient> 
      </defs>
      <rect x="0" y="0" width="100%" height="100%" fill={`url(#lgrad${firstColor}${secondColor})`}/>
    </svg>
  );
}

export function createGradient({ first, second, gradient, height}) {
  return (first && second) ? <Background firstColor={first} secondColor={second} height={height}/>
                           : <Background gradient={gradient} height={height}/>;

}