PROG = keylock

INSTALL ?= install
RM      ?= rm -f
MKDIR   ?= install -d

PREFIX ?= /usr/local
BINDIR = ${DESTDIR}${PREFIX}/bin

OBJDIR = .build
RELDIR = ${OBJDIR}/release

all: build

bootstrap:
	${MKDIR} ${BINDIR}

build:
	swift build -c release

debug:
	swift build -c debug

install: bootstrap build
	${INSTALL} ${RELDIR}/${PROG} ${BINDIR}/${PROG}

uninstall:
	${RM} ${BINDIR}/${PROG}

clean:
	${RM} -r ${OBJDIR}

.DEFAULT:
	@echo "Usage: make [target]"
	@echo
	@echo "Targets:"
	@echo "  build       Build the project in release mode"
	@echo "  debug       Build the project in debug mode"
	@echo "  install     Install the project"
	@echo "  uninstall   Uninstall the project"
	@echo "  clean       Clean the project"

.PHONY: all bootstrap build debug install uninstall clean
