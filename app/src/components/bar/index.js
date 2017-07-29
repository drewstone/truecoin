import styled, { keyframes } from 'styled-components';
import { colors, gradient } from '../colors';

export default styled.hr`
  margin: 0;
  border: 0;
  height: 5px;
  background-image: ${props => (props.colors) 
                    ? gradient(90, colors[props.colors[0]], colors[props.colors[1]])
                    : gradient(90, colors.cyan, colors.magenta)};
  transform-origin: 0 0;
  animation-name: ${keyframes`from { transform: scaleX(0); } to { transform: scaleX(1); }`};
  animation-duration: 0.5s;
  animation-timing-function: ease-out;
  animation-fill-mode: forwards;
`;