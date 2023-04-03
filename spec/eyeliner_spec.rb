
#
# Spec'ing Slipdf
#
# Mon Apr  3 11:11:58 JST 2023
#

require 'spec_helpers'

describe 'ComSomolEyeliner' do

  before :all do

    @text = json(%{
Team Tigers
  12345 Toto Manju
  34521 Ruflacon Meremy

Team Bears
  12452 Sea Teremony
  34421 Humpfcol Schulz
    }.strip)
  end

  it 'highlights whole lines' do

    expect(js(%{

      var eyeliner = new ComSomolEyeliner();
      eyeliner.add(/^team\\s/i, function(s) {
        return { target: 'line', class: '.csel-label' };
      });
      return eyeliner.highlightText(#{@text});

    }).join("\n")).to eq(%{

<span class="csel-label">Team Tigers</span>
  12345 Toto Manju
  34521 Ruflacon Meremy

<span class="csel-label">Team Bears</span>
  12452 Sea Teremony
  34421 Humpfcol Schulz

    }.strip)
  end
end

