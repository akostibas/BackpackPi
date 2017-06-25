SHELL := /bin/bash

.venv:
	virtualenv --python=python3 .venv
	source .venv/bin/activate
	pip3 install -r requirements.txt

clean:
	rm -rf .venv
	rm /tmp/backpack.sock

start_django: .venv
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

install_nginx_config:
	echo "I'll need sudo access to install configs."
	sudo echo "Thanks!" || exit 1
	sudo cp conf/etc/nginx/sites-available/backpack /etc/nginx/sites-available/.
	sudo ln -sf /etc/nginx/sites-available/backpack /etc/nginx/sites-enabled/.

uninstall_nginx_config:
	echo "I'll need sudo access to uninstall configs."
	sudo echo "Thanks!" || exit 1
	sudo rm -v /etc/nginx/sites-available/backpack /etc/nginx/sites-enabled/backpack
