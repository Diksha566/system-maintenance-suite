PREFIX ?= /usr/local
ETCDIR ?= /etc/maintenance-suite
VARDIR ?= /var/log/maintenance-suite

BIN = bin/backup.sh bin/update_clean.sh bin/log_watch.sh bin/suite.sh

install:
	install -d "$(PREFIX)/bin" "$(ETCDIR)" "$(VARDIR)"
	install -m 0755 $(BIN) "$(PREFIX)/bin/"
	install -d /etc/systemd/system
	install -m 0644 etc/systemd/maintenance-*.service /etc/systemd/system/
	install -m 0644 etc/systemd/maintenance-*.timer /etc/systemd/system/
	[ -f "$(ETCDIR)/env" ] || install -m 0644 etc/.env.example "$(ETCDIR)/env"
	systemctl daemon-reload

enable:
	systemctl enable --now maintenance-backup.timer
	systemctl enable --now maintenance-logwatch.timer

disable:
	- systemctl disable --now maintenance-backup.timer
	- systemctl disable --now maintenance-logwatch.timer

uninstall: disable
	- rm -f /etc/systemd/system/maintenance-backup.service
	- rm -f /etc/systemd/system/maintenance-backup.timer
	- rm -f /etc/systemd/system/maintenance-logwatch.service
	- rm -f /etc/systemd/system/maintenance-logwatch.timer
	systemctl daemon-reload
	- rm -f "$(PREFIX)/bin/backup.sh" "$(PREFIX)/bin/update_clean.sh" "$(PREFIX)/bin/log_watch.sh" "$(PREFIX)/bin/suite.sh"
	- rmdir "$(ETCDIR)" 2>/dev/null || true

.PHONY: install enable disable uninstall
