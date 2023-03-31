
// https://github.com/jmettraux/comsomol_eyeliner.js


class ComSomolEyeliner {

  "use strict";

  //
  // private

  #rules;

  #doApply(foc, line, i, ctx, match) {

    var r =
      (typeof foc === 'function') ? foc(line, match, i, ctx) :
      foc;

    if (match[1] === undefined) return r;

    var a = line.slice(0, match.index);
    var c = line.slice(match.index + match[1].length);

    return [ a, r, c ].join('');
  }

  //
  // public

  constructor() {

    //super();

    this.#rules = [];
  }

  add(regex, function_or_classname) {

    this.#rules.push([ regex, function_or_classname ]);
  }

  highlight(elt) {

    var t = this;
    var rules = this.#rules;

    var r = [];
    var ctx = {};

    elt.innerHTML.split('\n').forEach(function(l, i) {
      rules.forEach(function([ regex, fun_or_classname ]) {
        var m = l.match(regex);
        if (m) l = t.#doApply(fun_or_classname, l, i, ctx, m);
      });
      r.push(l);
    });

    elt.innerHTML = r.join('<br>');
  }
} // end class ComSomolEyeliner

