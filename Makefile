#
# Makefile

DESTDIR=
BINDIR=/usr/bin
ETCDIR=/etc/dyndnsup
MANDIR=/usr/share/man
LOGDIR=/var/log
SHEBANG=/bin/sh

.PHONY: all install clean uninstall

all: dyndnsup ck4dns

dyndnsup: src/dyndnsup.sh
	@sed -e "s|#SHEBANG#|$(SHEBANG)|" \
			 -e "s|#ETCDIR#|$(ETCDIR)|g" \
			 -e "s|#LOGDIR#|$(LOGDIR)|g" \
			 src/dyndnsup.sh > dyndnsup

ck4dns: src/ck4dns.sh
	@sed -e "s|#SHEBANG#|$(SHEBANG)|" \
			 -e "s|#ETCDIR#|$(ETCDIR)|g" \
			 -e "s|#DYNDNSUP#|$(DESTDIR)$(BINDIR)/dyndnsup|g" \
			 src/ck4dns.sh > ck4dns

install: all
	@install -d $(DESTDIR)$(BINDIR)
	@install -m 0755 dyndnsup $(DESTDIR)$(BINDIR)/dyndnsup
	@install -m 0755 ck4dns $(DESTDIR)$(BINDIR)/ck4dns
	@install -d $(DESTDIR)$(ETCDIR)
	@install -m 0600 src/dyndnsup.conf $(DESTDIR)$(ETCDIR)/dyndnsup.conf
	@install -m 0600 src/ck4dns.conf $(DESTDIR)$(ETCDIR)/ck4dns.conf
	@install -d $(DESTDIR)$(MANDIR)/man1
	@install -m 0644 src/dyndnsup.1 $(DESTDIR)$(MANDIR)/man1/dyndnsup.1

clean:
	@rm -f dyndnsup ck4dns
	@rm -f */*~ *~

uninstall:
	@rm -f $(DESTDIR)$(BINDIR)/{dyndnsup,ck4dns}
	@rm -f $(DESTDIR)$(ETCDIR)/dyndnsup.conf,ck4dns.conf}
	@rm -f $(DESTDIR)$(MANDIR)/man1/dyndnsup.1

# End of file
