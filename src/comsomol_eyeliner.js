
// https://github.com/jmettraux/comsomol_eyeliner.js


class ComSomolEyeliner {

  "use strict";

  //
  // private

  #rules;

  //
  // public

  constructor() {

    //super();

    this.#rules = [];
  }

  add(regex, function_or_classname) {

    this.#rules.push(regex, function_or_classname);
  }

  highlight(elt) {

clog('elt', elt);
  }
} // end class ComSomolEyeliner

