
// https://github.com/jmettraux/comsomol_eyeliner.js


class ComSomolEyeliner {

  "use strict";

  //
  // private

  #rules;

  #determineClassWrapper(r) {

    var c = r.class;
    if (c.slice(0, 1) === '.') c = c.slice(1);

    return [ `<span class="${c}">`, '</span>' ];
  }

  #remakeLine(line, i, match, r) {

    var [ sta, ned ] = this.#determineClassWrapper(r);

    return `${sta}${line}${ned}`;
  }

  #remakeMatch(line, i, match, r) {

    var [ sta, ned ] = this.#determineClassWrapper(r);

    var a = line.slice(0, match.index);
    var c = line.slice(match.index + match[0].length);

    return [ a, sta, match[0], ned, c ].join('');
  }

  #remake(line, i, match, r) {

    if (r.target === 'line') return this.#remakeLine(line, i, match, r);
    if (r.target === 'match') return this.#remakeMatch(line, i, match, r);
    return r;
  }

  #doApply(foc, line, i, ctx, match) {

    var r =
      (typeof foc === 'function') ? foc(line, match, i, ctx) :
      foc;

    if (typeof r === 'object') return this.#remake(line, i, match, r);
    //if (typeof r === 'string') return r;
    return r;
  }

  #doMatch(line, regex_or_function, opts) {

    if (typeof regex_or_function === 'function')
      return regex_or_function(line, opts);
    else
      return line.match(regex_or_function);
  }

  //
  // public

  constructor() {

    //super();

    this.#rules = [];
  }

  add(regex_or_match_function, /* opts,*/ function_or_classname) {

    var as = Array.from(arguments);
      //
    regex_or_match_function = as.shift();
    function_or_classname = as.pop();
      //
    var opts = {}; as.forEach(function(a) {
      if (typeof a === 'string') { opts[a] = true; }
      else if (typeof a === 'object') { Object.assign(opts, a); } });

    this.#rules.push([ regex_or_match_function, opts, function_or_classname ]);
  }

  highlightText(s) {

    var t = this;

    var r = [];
    var ctx = {};

    s.split('\n').forEach(function(l, i) {
      t.#rules.forEach(function([ regex, opts, fun_or_classname ]) {
        var m = t.#doMatch(l, regex, opts);
        if (m) l = t.#doApply(fun_or_classname, l, i, ctx, m);
      });
      r.push(l);
    });

    return r;
  }

  highlight(elt) {

    elt.innerHTML = this.highlightText(elt.innerHTML).join('<br>');
  }
} // end class ComSomolEyeliner

