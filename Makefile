#
# Makefile

DESTDIR=
BINDIR=/usr/bin
ETCDIR=/etc/dyndnsup
MANDIR=/usr/share/man
LOGDIR=/var/log
SHEBANG=/bin/sh

.PHONY: all install clean uninstall

all: dyndnsup dyndnsup.1 ck4dns

dyndnsup: src/dyndnsup.sh
	@sed -e "s|#SHEBANG#|$(SHEBANG)|" \
			 -e "s|#ETCDIR#|$(ETCDIR)|g" \
			 -e "s|#LOGDIR#|$(LOGDIR)|g" \
			 src/dyndnsup.sh > dyndnsup

dyndnsup.1.gz:
	@cp src/dyndnsup.1 .; gunzip dyndnsup.1

ck4dns: src/ck4dns.sh
	@sed -e "s|#SHEBANG#|$(SHEBANG)|" \
			 -e "s|#ETCDIR#|$(ETCDIR)|g" \
			 -e "s|#DYNDNSUP#|$(DESTDIR)$(BINDIR)/dyndnsup|g" \
			 src/ck4dns.sh > ck4dns

install: dyndnsup dyndnsup.1.gz ck4dns
	@install -d $(DESTDIR)$(BINDIR)
	@install -m 0755 dyndnsup $(DESTDIR)$(BINDIR)/dyndnsup
	@install -m 0755 ck4dns $(DESTDIR)$(BINDIR)/ck4dns
	@install -d $(DESTDIR)$(ETCDIR)
	@install -m 0600 src/*.conf.sample $(DESTDIR)$(ETCDIR)
	@install -d $(DESTDIR)$(MANDIR)/man1
	@install -m 0644 src/*.1.gz $(DESTDIR)$(MANDIR)/man1

clean:
	@rm -f dyndnsup dyndnsup.1.gz ck4dns
	@rm -f */*~ *~

# End of file
