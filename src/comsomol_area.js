
// https://github.com/jmettraux/comsomol.js


class ComSomolArea extends HTMLDivElement {

  "use strict";

  //
  // private

  //
  // public

  constructor() {

    super();
  }

  connectedCallback() {
  }

  get klass() { return customElements.get(H.att(this, 'is')); }

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

