#
# Makefile

BINDIR=/usr/bin
ETCDIR=/etc
MANDIR=/usr/share/man
SHEEBANG=/bin/sh

.PHONY: all install clean

dyndnsup: src/dyndnsup.sh
	@sed -e "s|#SHEEBANG#|$(SHEEBANG)|" -e "s|#ETCDIR#|$(ETCDIR)|g" src/dyndnsup.sh > dyndnsup

all: dyndnsup

install: all
	@install -v -D -m 0755 dyndnsup $(BINDIR)/dyndnsup
	@install -v -D -m 0600 src/dyndnsup.conf $(ETCDIR)/dyndnsup.conf
	@install -v -D -m 0644 src/dyndnsup.1 $(MANDIR)/man1/dyndnsup.1

clean:
	@rm -vf dyndnsup
	@rm -vf */*~ *~

uninstall:
	@rm -vf $(BINDIR)/dyndnsup
	@rm -vf $(ETCDIR)/dyndnsup.conf
	@rm -vf $(MANDIR)/man1/dyndnsup.1

# End of file
