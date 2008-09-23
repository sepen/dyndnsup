#
# Makefile

DESTDIR=
BINDIR=/usr/bin
ETCDIR=/etc
MANDIR=/usr/share/man
SHEBANG=/bin/sh

.PHONY: all install clean uninstall

dyndnsup: src/dyndnsup.sh
	@sed -e "s|#SHEBANG#|$(SHEBANG)|" -e "s|#ETCDIR#|$(ETCDIR)|g" src/dyndnsup.sh > dyndnsup

all: dyndnsup

install: all
	@install -d $(DESTDIR)$(BINDIR)
	@install -m 0755 dyndnsup $(DESTDIR)$(BINDIR)/dyndnsup
	@install -d $(DESTDIR)$(ETCDIR)
	@install -m 0600 src/dyndnsup.conf $(DESTDIR)$(ETCDIR)/dyndnsup.conf
	@install -d $(DESTDIR)$(MANDIR)/man1
	@install -m 0644 src/dyndnsup.1 $(DESTDIR)$(MANDIR)/man1/dyndnsup.1

clean:
	@rm -f dyndnsup
	@rm -f */*~ *~

uninstall:
	@rm -f $(DESTDIR)$(BINDIR)/dyndnsup
	@rm -f $(DESTDIR)$(ETCDIR)/dyndnsup.conf
	@rm -f $(DESTDIR)$(MANDIR)/man1/dyndnsup.1

# End of file
