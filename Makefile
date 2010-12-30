#
# Makefile
#

DYNDNSUP_VERSION="0.3"

DESTDIR=
BINDIR=/usr/bin
ETCDIR=/etc/dyndnsup
MANDIR=/usr/share/man
LOGDIR=/var/log
SHEBANG=/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

.PHONY: all install clean uninstall

all: clean dyndnsup ck4dns

dyndnsup.1.gz: src/dyndnsup.1.in
	@sed -e "s|#ETCDIR#|$(ETCDIR)|g" \
		-e "s|#APPVERSION#|$(DYNDNSUP_VERSION)|g" \
		src/dyndnsup.1.in > dyndnsup.1
	@gzip -9 dyndnsup.1

dyndnsup: src/dyndnsup.in dyndnsup.1.gz
	@sed -e "s|#SHEBANG#|$(SHEBANG)|" \
		-e "s|#ETCDIR#|$(ETCDIR)|g" \
		-e "s|#LOGDIR#|$(LOGDIR)|g" \
		-e "s|#PATH#|$(PATH)|g" \
		-e "s|#APPVERSION#|$(DYNDNSUP_VERSION)|g" \
		src/dyndnsup.in > dyndnsup
	@chmod +x dyndnsup

ck4dns: src/ck4dns.in
	@sed -e "s|#SHEBANG#|$(SHEBANG)|" \
		-e "s|#ETCDIR#|$(ETCDIR)|g" \
		-e "s|#DYNDNSUP#|$(DESTDIR)$(BINDIR)/dyndnsup|g" \
		-e "s|#PATH#|$(PATH)|g" \
		-e "s|#APPVERSION#|$(DYNDNSUP_VERSION)|g" \
		src/ck4dns.in > ck4dns
	@chmod +x ck4dns

install: dyndnsup ck4dns
	@install -d $(DESTDIR)$(BINDIR)
	@install -m 0755 dyndnsup $(DESTDIR)$(BINDIR)/dyndnsup
	@install -m 0755 ck4dns $(DESTDIR)$(BINDIR)/ck4dns
	@ln -sf dyndnsup $(DESTDIR)$(BINDIR)/ddup
	@install -d $(DESTDIR)$(ETCDIR)
	@install -m 0600 src/*.conf.sample $(DESTDIR)$(ETCDIR)
	@install -d $(DESTDIR)$(MANDIR)/man1
	@install -m 0644 *.1.gz $(DESTDIR)$(MANDIR)/man1
	@ln -sf dyndnsup.1.gz $(DESTDIR)$(MANDIR)/man1/ddup.1.gz

clean:
	@rm -f dyndnsup dyndnsup.1.gz ck4dns
	@rm -f */*~ *~

# End of file
