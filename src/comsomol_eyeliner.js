
// https://github.com/jmettraux/comsomol_eyeliner.js


class ComSomolEyeliner {

  "use strict";

  //
  // private

  #rules;

  #determineClassWrapper(r) {

    var c = r.class;
    if (c.slice(0, 1) === '.') c = c.slice(1);
    else c = 'csel-' + c;

    return [ `<span class="${c}">`, '</span>' ];
  }

  #remakeLine(line, i, matches, r) {

    var [ sta, ned ] = this.#determineClassWrapper(r);

    return `${sta}${line}${ned}`;
  }

  #remakeMatch(index, match) {

    if (typeof match[1] === 'string') {
      var i = match.input.indexOf(match[1], index);
      return [ match.input.substring(index, i), match[1] ];
    }
    return [ match.input.substring(index, match.index), match[0] ];
  }

  #remakeMatches(line, i, matches, r) {

    var t = this;
    var index = 0;
      //
    var a = matches.map(function(m) {
      var x = t.#remakeMatch(index, m);
      index = index + x[0].length + x[1].length;
      return x; });

    var [ sta, ned ] = t.#determineClassWrapper(r);

    var ra = [];
      a.forEach(function([ pre, match ]) { ra.push(pre, sta, match, ned); });
      ra.push(line.slice(index)); // tail...

    return ra.join('');
  }

  #remake(line, i, matches, r) {

    if (r.target === 'line') return this.#remakeLine(line, i, matches, r);
    if (r.target === 'match') return this.#remakeMatches(line, i, matches, r);
    return r;
  }

  #doApply(foc, line, i, ctx, matches) {

    var r =
      (typeof foc === 'function') ? foc(line, matches, i, ctx) :
      foc;

    if (typeof r === 'object') return this.#remake(line, i, matches, r);
    //if (typeof r === 'string') return r;
    return r;
  }

  #doMatch(line, regex_or_function, opts) {

    if (typeof regex_or_function === 'function')
      return regex_or_function(line, opts);

    if (regex_or_function.global) {
      var ms = Array.from(line.matchAll(regex_or_function));
      return ms.length > 0 ? ms : false;
    }

    var m = line.match(regex_or_function);
    return m ? [ m ] : false;
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

    return this;
  }

  highlightText(s) {

    var t = this;

    var r = [];
    var ctx = {};

    s.split('\n').forEach(function(l, i) {

      t.#rules.forEach(function([ regex, opts, fun_or_classname ]) {

        var ms = t.#doMatch(l, regex, opts);
        if (ms) l = t.#doApply(fun_or_classname, l, i, ctx, ms);
      });

      r.push(l);
    });

    return r;
  }

  highlight(elt) {

    elt.innerHTML = this.highlightText(elt.innerHTML).join('<br>');
  }
} // end class ComSomolEyeliner

