import React from 'react';
import Bar from '../bar';

class PredictionPreview extends React.Component {
  constructor(props) {
    super();
    this.state = {
      completed: props.completed,
      text: props.text,
      leaning: props.leaning,
      active: false
    };
  }

  toggleActive() {
    let str = `
      <div id="pred-modal" class="modal is-active">
        <div class="modal-background"></div>
        <div class="modal-card">
          <header class="modal-card-head">
          <p class="modal-card-title">${this.state.text}</p>
          <Button class="delete" aria-label="close"></Button>
          </header>
          <section class="modal-card-body">THIS IS INDEED</section>
          <footer class="modal-card-foot">
            <Button class="button is-success">Save changes</Button>
            <Button class="button" id="pred-modal-cancel-btn">Cancel</Button>
          </footer>
        </div>
      </div>
    `;
    let div = document.getElementById('mod');
    div.innerHTML = str;
    document.getElementById("pred-modal-cancel-btn").addEventListener("click", function() {
      document.getElementById('pred-modal').remove();
    });    
  }

  render() {
    return (
      <a className="modal-button" onClick={() => this.toggleActive()}>
        <div>
          <div className="box">
            <p className="title is-5">Flexible column</p>
            <p className="subtitle">This column will take up the remaining space available.</p>
            <Bar
              twocolor={true}
              colors={['blue', 'red']}
              leaning={this.state.leaning}
            />
          </div>
        </div>
      </a>
    );
  }
}

export default PredictionPreview;