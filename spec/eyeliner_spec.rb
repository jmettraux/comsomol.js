
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
  34421 (leaver)
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
  34421 (leaver)

    }.strip)
  end

  it 'highlights parts of lines' do

    expect(js(%{

      var eyeliner = new ComSomolEyeliner();
      eyeliner.add(/\\d+/, function(s) {
        return { target: 'match', class: '.csel-number' };
      });
      return eyeliner.highlightText(#{@text});

    }).join("\n")).to eq(%{

Team Tigers
  <span class="csel-number">12345</span> Toto Manju
  <span class="csel-number">34521</span> Ruflacon Meremy

Team Bears
  <span class="csel-number">12452</span> Sea Teremony
  <span class="csel-number">34421</span> (leaver)

    }.strip)
  end

  it 'highlights parts of lines (2)' do

    expect(js(%{

      var eyeliner = new ComSomolEyeliner();
      eyeliner.add(/^Team\s+(.+)$/, function(s) {
        return { target: 'match', class: '.csel-string' };
      });
      return eyeliner.highlightText(#{@text});

    }).join("\n")).to eq(%{

Team <span class="csel-string">Tigers</span>
  12345 Toto Manju
  34521 Ruflacon Meremy

Team <span class="csel-string">Bears</span>
  12452 Sea Teremony
  34421 (leaver)

    }.strip)
  end

  it 'highlights parts of lines (3)' do

    expect(js(%{

      var eyeliner = new ComSomolEyeliner();
      eyeliner.add(/\\d{2}/, function(s) {
        return { target: 'match', class: '.csel-num' };
      });
      return eyeliner.highlightText(#{@text});

    }).join("\n")).to eq(%{

Team Tigers
  <span class="csel-num">12</span><span class="csel-num">34</span>5 Toto Manju
  <span class="csel-num">34</span><span class="csel-num">52</span>1 Ruflacon Meremy

Team Bears
  <span class="csel-num">12</span><span class="csel-num">45</span>2 Sea Teremony
  <span class="csel-num">34</span><span class="csel-num">42</span>1 (leaver)

    }.strip)
  end
end

