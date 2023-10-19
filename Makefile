# Makefile for keylock
PROGNAME = keylock

# Variables
PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

# Targets
all: build

build:
	swift build -c release

install: build
	mkdir -p $(BINDIR)
	cp -f .build/release/$(PROGNAME) $(BINDIR)/$(PROGNAME)

uninstall:
	rm -f $(BINDIR)/$(PROGNAME)

clean:
	rm -rf .build

.PHONY: all build install clean

