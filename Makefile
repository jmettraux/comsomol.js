
N = comsomol
RUBY = ruby
VERSION != grep VERSION src/$(N).js | $(RUBY) -e "puts gets.match(/VERSION = '([\d\.]+)/)[1]"
SHA != git log -1 --format="%h"
NOW != date
COPY != grep Copyright LICENSE.txt
COMPACT = $(RUBY) mak/compacter.rb


version:
	@echo $(VERSION)
v: version

concat:
	cat src/comsomol_*.js > web/js/comsomol.js
	cat src/comsomol_*.css > web/css/comsomol.css
c: concat

pkg_plain: concat
	#
	mkdir -p pkg
	#
	cp web/js/$(N).js pkg/$(N)-$(VERSION).js
	echo "/* MIT Licensed */" >> pkg/$(N)-$(VERSION).js
	echo "/* $(COPY) */" >> pkg/$(N)-$(VERSION).js
	echo "" >> pkg/$(N)-$(VERSION).js
	echo "/* from commit $(SHA) on $(NOW) */" >> pkg/$(N)-$(VERSION).js
	cp pkg/$(N)-$(VERSION).js pkg/$(N)-$(VERSION)-$(SHA).js
	#
	cp web/css/$(N).css pkg/$(N)-$(VERSION).css
	echo "/* MIT Licensed */" >> pkg/$(N)-$(VERSION).css
	echo "/* $(COPY) */" >> pkg/$(N)-$(VERSION).css
	echo "" >> pkg/$(N)-$(VERSION).css
	echo "/* from commit $(SHA) on $(NOW) */" >> pkg/$(N)-$(VERSION).css
	cp pkg/$(N)-$(VERSION).css pkg/$(N)-$(VERSION)-$(SHA).css
	#
	$(COMPACT) web/js/$(N).js > pkg/$(N)-$(VERSION).com.js
	echo "/* MIT Licensed */" >> pkg/$(N)-$(VERSION).com.js
	echo "/* $(COPY) */" >> pkg/$(N)-$(VERSION).com.js
	echo "" >> pkg/$(N)-$(VERSION).com.js
	echo "/* from commit $(SHA) on $(NOW) */" >> pkg/$(N)-$(VERSION).com.js
	cp pkg/$(N)-$(VERSION).com.js pkg/$(N)-$(VERSION)-$(SHA).com.js
	#
	$(COMPACT) web/css/$(N).css > pkg/$(N)-$(VERSION).com.css
	echo "/* MIT Licensed */" >> pkg/$(N)-$(VERSION).com.css
	echo "/* $(COPY) */" >> pkg/$(N)-$(VERSION).com.css
	echo "" >> pkg/$(N)-$(VERSION).com.css
	echo "/* from commit $(SHA) on $(NOW) */" >> pkg/$(N)-$(VERSION).com.css
	cp pkg/$(N)-$(VERSION).com.css pkg/$(N)-$(VERSION)-$(SHA).com.css
	#
	@echo
	ls -al pkg/$(N)-$(VERSION)*
	@echo

pkg: pkg_plain

clean:
	rm -fR pkg/

serve:
	$(RUBY) -run -ehttpd web/ -p8001
s: serve


.PHONY: serve version concat pkg clean

