
// https://github.com/jmettraux/comsomol_area.js


class ComSomolArea extends HTMLDivElement {

  "use strict";

  //
  // private

  #textarea;
  #pre;
  #code;

  #highlight = function() {};

  #onInput(ev) {

    this.#code.innerText = this.#textarea.value;
    this.#highlight(this.#code);
  }

  //
  // public

  constructor() {

    super();
  }

  connectedCallback() {

    this.#textarea = H.c(this, 'textarea', { spellcheck: 'false' });
    this.#pre = H.c(this, 'pre');
    this.#code = H.c(this.#pre, 'code');

    this.on(this.#textarea, 'input', this.#onInput);
  }

  //get klass() { return customElements.get(H.att(this, 'is')); }

  set text(t) {

    this.#textarea.value = t;
    this.#onInput();
  }

  set highlight(f) {

    this.#highlight = f.bind(this);
  }

  //on(event_s, callback) {
  //on(sel, event_s, callback) {
  //
  on() {

    var t = this;

    var as = Array.from(arguments).map(function(a) {
      if (typeof a === 'function') return a.bind(t);
      return a;
    });
    if ( ! H.isElt(as[0])) as.unshift(t);

    H.on.apply(null, as);
  }
} // end class ComSomolArea

customElements.define('comsomol-area', ComSomolArea, { extends: 'div' });

