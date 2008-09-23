#
# Makefile

DESTDIR=
BINDIR=/usr/bin
ETCDIR=/etc
MANDIR=/usr/share/man
SHEBANG=/bin/sh

.PHONY: all install clean

dyndnsup: src/dyndnsup.sh
	@sed -e "s|#SHEBANG#|$(SHEBANG)|" -e "s|#ETCDIR#|$(ETCDIR)|g" src/dyndnsup.sh > dyndnsup

all: dyndnsup

install: all
	@install -v -D -m 0755 dyndnsup $(DESTDIR)$(BINDIR)/dyndnsup
	@install -v -D -m 0600 src/dyndnsup.conf $(DESTDIR)$(ETCDIR)/dyndnsup.conf
	@install -v -D -m 0644 src/dyndnsup.1 $(DESTDIR)$(MANDIR)/man1/dyndnsup.1

clean:
	@rm -vf dyndnsup
	@rm -vf */*~ *~

uninstall:
	@rm -vf $(DESTDIR)$(BINDIR)/dyndnsup
	@rm -vf $(DESTDIR)$(ETCDIR)/dyndnsup.conf
	@rm -vf $(DESTDIR)$(MANDIR)/man1/dyndnsup.1

# End of file
