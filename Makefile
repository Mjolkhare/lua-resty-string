OPENRESTY_PREFIX=/usr/local/openresty

PREFIX ?=          /usr/local
LUA_INCLUDE_DIR ?= $(PREFIX)/include
LUA_LIB_DIR ?=     $(PREFIX)/lib/lua/$(LUA_VERSION)
INSTALL ?= install

GBRANCH = $(shell git rev-parse --abbrev-ref HEAD)
GCOMMIT = $(shell git rev-parse HEAD)

.PHONY: all test install rpm

all: ;

install: all
	$(INSTALL) -d $(DESTDIR)/$(LUA_LIB_DIR)/resty
	$(INSTALL) lib/resty/*.lua $(DESTDIR)/$(LUA_LIB_DIR)/resty

test: all
	PATH=$(OPENRESTY_PREFIX)/nginx/sbin:$$PATH prove -I../test-nginx/lib -r t

rpm:
	tar cvfz ~/rpmbuild/SOURCES/lua-resty-string.tar.gz --transform "s/^lib/lua-resty-string/" lib
	rpmbuild -ba rpm.spec --define="GBRANCH $(GBRANCH)"  --define="GCOMMIT $(GCOMMIT)"
