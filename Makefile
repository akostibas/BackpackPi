SHELL := /bin/bash

.venv:
	virtualenv --python=python3 .venv
	source .venv/bin/activate
	pip3 install -r requirements.txt

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

start_django: .venv secrets/django_secret_key
	echo "I'll need sudo access to start uWSGI."
	sudo echo "Thanks!" || exit 1
	sudo bash -c "source .venv/bin/activate && \
		cd backpack_py && \
		uwsgi --ini uwsgi.ini --uid www-data --gid www-data &"

stop_django:
	echo "I'll need sudo access to stop uWSGI."
	sudo echo "Thanks!" || exit 1
	sudo pkill -9 uwsgi
	sudo rm /tmp/backpack.sock

install_apt_packages:
	echo "I'll need sudo access to install packages."
	sudo echo "Thanks!" || exit 1
	sudo apt-get -y install \
		dnsmasq \
		nginx \
		python3 \
		python3-pip \
		python3-virtualenv

install_nginx_config:
	echo "I'll need sudo access to install configs."
	sudo echo "Thanks!" || exit 1
	sudo cp conf/etc/nginx/sites-available/backpack /etc/nginx/sites-available/.
	sudo ln -sf /etc/nginx/sites-available/backpack /etc/nginx/sites-enabled/.

uninstall_nginx_config:
	echo "I'll need sudo access to uninstall configs."
	sudo echo "Thanks!" || exit 1
	sudo rm -v /etc/nginx/sites-available/backpack /etc/nginx/sites-enabled/backpack

install_systemd:
	echo "I'll need sudo access to install systemd configs."
	sudo echo "Thanks!" || exit 1
	sudo ln -sf `pwd`/bin/backpack.sh /usr/local/bin/.
	sudo ln -sf `pwd`/conf/etc/systemd/system/multi-user.target.wants/backpack.service \
		/lib/systemd/system/.
	sudo ln -sf /lib/system/system/backpack.service \
		/etc/systemd/system/multi-user.target.wants/.

uninstall_systemd:
	echo "I'll need sudo access to uninstall systemd configs."
	sudo echo "Thanks!" || exit 1
	sudo rm /etc/systemd/system/multi-user.target.wants/backpack.service
	sudo rm /lib/systemd/system/backpack.service
	sudo rm /usr/local/bin/backpack.sh
