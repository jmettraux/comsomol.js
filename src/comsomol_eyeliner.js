
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

    if (Array.isArray(r)) {

      var a = line.slice(0, match.index);
      var c = line.slice(match.index + match[1].length);

      return [ a, r[0], c ].join('');
    }

    return r;
  }

  #match(line, regex, opts) {

    return line.match(regex);
  }

  //
  // public

  constructor() {

    //super();

    this.#rules = [];
  }

  add(regex, /* opts,*/ function_or_classname) {

    var opts;

    var a1 = arguments[1];
    var t1 = (typeof a1);
      //
    if (t1 === 'function' || t1 === 'string' || Array.isArray(a1)) {
      opts = {};
    }
    else {
      opts = arguments[1];
      function_or_classname = arguments[2];
    }

    this.#rules.push([ regex, opts, function_or_classname ]);
  }

  highlight(elt) {

    var t = this;
    var rules = this.#rules;

    var r = [];
    var ctx = {};

    elt.innerHTML.split('\n').forEach(function(l, i) {
      rules.forEach(function([ regex, opts, fun_or_classname ]) {
        //var m = l.match(regex);
        var m = t.#match(l, regex, opts);
        if (m) l = t.#doApply(fun_or_classname, l, i, ctx, m);
      });
      r.push(l);
    });

    elt.innerHTML = r.join('<br>');
  }
} // end class ComSomolEyeliner

