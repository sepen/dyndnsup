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
	@install -m 0600 src/*.conf.sample $(DESTDIR)$(ETCDIR)
	@install -d $(DESTDIR)$(MANDIR)/man1
	@install -m 0644 src/*.1 $(DESTDIR)$(MANDIR)/man1
	@cd $(DESTDIR)$(MANDIR)/man1; for i in *; do gzip -9 $$i; done

clean:
	@rm -f dyndnsup ck4dns
	@rm -f */*~ *~

uninstall:
	@rm $(DESTDIR)$(BINDIR)/{dyndnsup,ck4dns}
	@rm -r $(DESTDIR)$(ETCDIR)
	@rm $(DESTDIR)$(MANDIR)/man1/{dyndnsup.1,ck4dns.1}

# End of file
