
#
# spec'ing slipdf.js
#
# Mon Apr  3 11:08:40 JST 2023
#

require 'ferrum'


module Helpers

  def json(x)

    JSON.dump(x)
  end

  def js(s)

    $sources ||=
      begin
        %w[
          web/js/h-1.2.0.min.js
          src/comsomol_eyeliner.js
          spec/helpers.js
        ]
          .collect { |path| File.read(path) }
          .join(';')
      end
    $browser ||=
      begin
        Ferrum::Browser.new(js_errors: true)
      end

    $browser.evaluate("(function() { #{sources}; #{s}; })()")
  end
end
RSpec.configure { |c| c.include(Helpers) }

