SHELL := /bin/bash

.venv:
	virtualenv --python=python3 .venv
	source .venv/bin/activate
	pip3 install -r requirements.txt

.PHONY: clean
clean:
	rm -rf .venv
	rm /tmp/backpack.sock

secrets/django_secret_key:
	echo "I'll need sudo access to make secrets."
	sudo echo "Thanks!" || exit 1
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 \
		> secrets/django_secret_key
	sudo chown :www-data secrets/django_secret_key
	sudo chmod 640 secrets/django_secret_key

.PHONY: start_django
start_django: .venv secrets/django_secret_key
	echo "I'll need sudo access to start uWSGI."
	sudo echo "Thanks!" || exit 1
	sudo bash -c "source .venv/bin/activate && \
		cd backpack_py && \
		yes yes | python manage.py collectstatic && \
		uwsgi --ini uwsgi.ini --uid www-data --gid www-data &"

.PHONY: stop_django
stop_django:
	echo "I'll need sudo access to stop uWSGI."
	sudo echo "Thanks!" || exit 1
	sudo pkill -9 uwsgi
	sudo rm /tmp/backpack.sock

.PHONY: setup_database_perms
setup_database_perms:
	echo "I'll need sudo access to setup database permissions."
	sudo echo "Thanks!" || exit 1
	sudo chown :www-data backpack_py
	sudo chown :www-data backpack_py/db.sqlite3
	sudo chmod 775 backpack_py
	sudo chmod 660 backpack_py/db.sqlite3

.PHONY: install_apt_packages
install_apt_packages:
	echo "I'll need sudo access to install packages."
	sudo echo "Thanks!" || exit 1
	sudo apt-get -y install \
		hostapd \
		dnsmasq \
		nginx \
		python3 \
		python3-pip \
		python3-virtualenv

.PHONY: install_nginx_config
install_nginx_config:
	echo "I'll need sudo access to install configs."
	sudo echo "Thanks!" || exit 1
	sudo cp conf/etc/nginx/sites-available/backpack /etc/nginx/sites-available/.
	sudo ln -sf /etc/nginx/sites-available/backpack /etc/nginx/sites-enabled/.

.PHONY: uninstall_nginx_config
uninstall_nginx_config:
	echo "I'll need sudo access to uninstall configs."
	sudo echo "Thanks!" || exit 1
	sudo rm -v /etc/nginx/sites-available/backpack /etc/nginx/sites-enabled/backpack

.PHONY: install_hostapd
install_hostapd:
	echo "I'll need sudo access to install hostapd."
	sudo echo "Thanks!" || exit 1
	sudo ln -sf `pwd`/conf/etc/hostapd/backpack.conf /etc/hostapd/backpack.conf

.PHONY: uninstall_hostapd
uninstall_hostapd:
	echo "I'll need sudo access to uninstall hostapd."
	sudo echo "Thanks!" || exit 1
	sudo rm /etc/hostapd/backpack.conf

.PHONY: install_dnsmasq
install_dnsmasq:
	echo "I'll need sudo access to install dnsmasq."
	sudo echo "Thanks!" || exit 1
	sudo ln -sf `pwd`/conf/etc/dnsmasq.conf /etc/.

.PHONY: install_systemd
install_systemd:
	echo "I'll need sudo access to install systemd configs."
	sudo echo "Thanks!" || exit 1
	sudo ln -sf `pwd`/bin/backpack.sh /usr/local/bin/.
	sudo ln -sf `pwd`/conf/etc/systemd/system/multi-user.target.wants/backpack.service \
		/lib/systemd/system/.
	sudo ln -sf /lib/system/system/backpack.service \
		/etc/systemd/system/multi-user.target.wants/.

.PHONY: uninstall_systemd
uninstall_systemd:
	echo "I'll need sudo access to uninstall systemd configs."
	sudo echo "Thanks!" || exit 1
	sudo rm /etc/systemd/system/multi-user.target.wants/backpack.service
	sudo rm /lib/systemd/system/backpack.service
	sudo rm /usr/local/bin/backpack.sh
