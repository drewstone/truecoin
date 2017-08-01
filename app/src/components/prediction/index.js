import React from 'react';
import Bar from '../bar';
import styled from 'styled-components';
import { colors, gradient, twocolor } from '../colors';

const Button = styled.a`
  margin-left: 5px;
  margin-bottom: 5px;
  &:hover {
    background: grey;
  }
  background: ${props => {
    if (props.twocolor && props.colors) {
      return twocolor(props.colors[0], props.colors[1], props.leaning);
    } else if (props.colors) {
      return gradient(90, colors[props.colors[0]], colors[props.colors[1]]);
    }

    return gradient(90, colors.lightgrey, colors.lightgrey);
  }};
`;

const Div = styled.div`
  float: center;
`;

const Prediction = ({ onClick, completed, text, leaning }) => (
  <div>
    <li style={{textDecoration: completed ? 'line-through' : 'none'}}>
      {text}
      <Div>
        <span style={{display: !completed ? 'column' : 'none'}}>
          <Button
            colors={['red', 'red']}
            className="pure-button"
            onClick={() => onClick(0)}
          />
        </span>      
        <span style={{display: !completed ? 'column' : 'none'}}>
          <Button
            colors={['blue', 'blue']}        
            className="pure-button"
            onClick={() => onClick(1)}
          />
        </span>
      </Div>
    </li>
    <Bar
      twocolor={true}
      colors={['red', 'blue']}
      leaning={leaning}
    />
  </div>
);

export default Prediction;