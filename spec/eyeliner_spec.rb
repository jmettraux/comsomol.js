
#
# Spec'ing Slipdf
#
# Mon Apr  3 11:11:58 JST 2023
#

require 'spec_helpers'

describe 'ComSomolEyeliner' do

  it 'highlights' do

    t = %{
Team Tigers
  12345 Toto Manju
  34521 Ruflacon Meremy

Team Bears
  12452 Sea Teremony
  34421 Humpfcol Schulz
    }

    expect(js(%{
      var eyeliner = new ComSomolEyeliner();
      //eyeliner.add();
      return eyeliner.highlightText(#{json(t)});
    })).to eq([
      "xyz"
    ])
  end
end

