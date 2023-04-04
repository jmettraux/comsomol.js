
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

  context 'with rules returning hashes' do

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
        eyeliner.add(/\\d{2}/g, function(s) {
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

    it 'highlights parts of lines (4)' do

      expect(js(%{

        var eyeliner = new ComSomolEyeliner();
        eyeliner.add(/(\\d{2})/g, function(s) {
          return { target: 'match', class: 'num' };
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

    it 'highlights parts of lines (5)' do

      expect(js(%{

        var eyeliner = new ComSomolEyeliner();
        eyeliner
          .add(/\\d{2}/g, function(s) {
            return { target: 'match', class: 'num2' }; })
          .add(/\\d{3}/g, function(s) {
            return { target: 'match', class: 'num3' }; });
        return eyeliner.highlightText(#{@text});

      }).join("\n")).to eq(%{

Team Tigers
  <span class="csel-num2">12</span><span class="csel-num2">34</span>5 Toto Manju
  <span class="csel-num2">34</span><span class="csel-num2">52</span>1 Ruflacon Meremy

Team Bears
  <span class="csel-num2">12</span><span class="csel-num2">45</span>2 Sea Teremony
  <span class="csel-num2">34</span><span class="csel-num2">42</span>1 (leaver)

      }.strip)
    end

    it 'highlights parts of lines (6)' do

      expect(js(%{

        var eyeliner = new ComSomolEyeliner();
        eyeliner
          .add(/\\d{2}/, function(s) {
            return { target: 'match', class: 'num2' }; })
          .add(/\\d{3}/g, function(s) {
            return { target: 'match', class: 'num3' }; });
        return eyeliner.highlightText(#{@text});

      }).join("\n")).to eq(%{

Team Tigers
  <span class="csel-num2">12</span><span class="csel-num3">345</span> Toto Manju
  <span class="csel-num2">34</span><span class="csel-num3">521</span> Ruflacon Meremy

Team Bears
  <span class="csel-num2">12</span><span class="csel-num3">452</span> Sea Teremony
  <span class="csel-num2">34</span><span class="csel-num3">421</span> (leaver)

      }.strip)
    end
  end

  context 'with options and a classname' do

    it 'highlights whole lines' do

      expect(js(%{

        var eyeliner = new ComSomolEyeliner();
        eyeliner.add(/^team\\s/i, 'line', '.csel-label');

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
        eyeliner.add(/\\d+/, '.csel-number');

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
        eyeliner.add(/^Team\s+(.+)$/, 'string');

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

    it 'highlights parts of lines (6)' do

      expect(js(%{

        var eyeliner = new ComSomolEyeliner();
        eyeliner
          .add(/\\d{2}/, 'num2')
          .add(/\\d{3}/g, 'num3')

        return eyeliner.highlightText(#{@text});

      }).join("\n")).to eq(%{

Team Tigers
  <span class="csel-num2">12</span><span class="csel-num3">345</span> Toto Manju
  <span class="csel-num2">34</span><span class="csel-num3">521</span> Ruflacon Meremy

Team Bears
  <span class="csel-num2">12</span><span class="csel-num3">452</span> Sea Teremony
  <span class="csel-num2">34</span><span class="csel-num3">421</span> (leaver)

      }.strip)
    end
  end
end

