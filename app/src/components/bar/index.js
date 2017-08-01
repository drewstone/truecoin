import styled, { keyframes } from 'styled-components';
import { colors, gradient, twocolor } from '../colors';

export default styled.div`
  margin: 0;
  border: 0;
  height: 10px;
  text-align: center;
  margin-bottom: 30px;
  background-image: ${props => {
    if (props.twocolor && props.colors) {
      return twocolor(colors[props.colors[0]], colors[props.colors[1]], props.leaning);
    } else if (props.colors) {
      return gradient(90, colors[props.colors[0]], colors[props.colors[1]]);
    }

    return gradient(90, colors.cyan, colors.magenta);
  }};
  transform-origin: 0 0;
  animation-name: ${keyframes`from { transform: scaleX(0); } to { transform: scaleX(1); }`};
  animation-duration: 0.5s;
  animation-timing-function: ease-out;
  animation-fill-mode: forwards;
`;