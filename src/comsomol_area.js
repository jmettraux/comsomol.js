
//
// https://github.com/jmettraux/comsomol_area.js
//
// based on https://css-tricks.com/creating-an-editable-textarea-that-supports-syntax-highlighted-code/
//


class ComSomolArea extends HTMLDivElement {

  "use strict";

  //
  // private

  #textarea;
  #pre;
  #code;

  #highlight = function() {};

  #onScroll(ev) {

    this.#pre.scrollTop = this.#textarea.scrollTop;
    this.#pre.scrollLeft = this.#textarea.scrollLeft;
  }

  #onInput(ev) {

    var t = this.#textarea.value;
    if (t[t.length - 1] === '\n') t = t + ' ';
    //t = t.replace(/&/g, '&').replace(/</g, '<');

    this.#code.innerHTML = t;
    this.#highlight(this.#code);

    this.#onScroll();
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
    this.on(this.#textarea, 'scroll', this.#onScroll);
  }

  //get klass() { return customElements.get(H.att(this, 'is')); }

  set text(t) {

    this.#textarea.value = t;
    this.#onInput();
  }

  set value(t) { this.text = t; }

  get text() { return this.#textarea.value; }
  get value() { return this.text; }

  set highlight(f) {

    this.#highlight = f;
  }

  //addEventListener(/* type, listener, options */) {
  //  return this.#textarea.addEventListener.apply(null, Array.from(arguments));
  //}
    // not necessary

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

