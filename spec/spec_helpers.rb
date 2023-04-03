
#
# spec'ing slipdf.js
#
# Mon Apr  3 11:08:40 JST 2023
#

require 'pp'
require 'yaml'
require 'io/console'
require 'ferrum'


module Helpers

  def make_browser

    sources =
      %w[ src/comsomol_eyeliner.js spec/helpers.js ]
        .collect { |path| File.read(path) }
        .join(';')

    browser = Ferrum::Browser.new(js_errors: true)
    browser.evaluate("JSON.stringify((function() { #{$sources}; })())")

    class << browser
      alias eval evaluate
    end

    browser
  end

#  def js(s)
#
#    sources ||=
#    $browser ||=
#      begin
#        Ferrum::Browser.new(js_errors: true)
#      end
#
#    s = "JSON.stringify((function() { #{$sources}; #{s}; })())"
#    j = $browser.evaluate(s)
#
#    JSON.parse(j)
#  end
end
RSpec.configure { |c| c.include(Helpers) }

