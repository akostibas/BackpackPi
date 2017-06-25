virtualenv:
	virtualenv --python=python3 .venv
	source .venv/bin/activate
	pip3 install -r requirements.txt

clean:
	rm -rf .venv

install_nginx_config:
	echo "I'll need sudo access to install configs."
	sudo echo "Thanks!" || exit 1
	sudo cp conf/etc/nginx/sites-available/backpack /etc/nginx/sites-available/.
	sudo ln -sf /etc/nginx/sites-available/backpack /etc/nginx/sites-enabled/.

uninstall_nginx_config:
	echo "I'll need sudo access to uninstall configs."
	sudo echo "Thanks!" || exit 1
	sudo rm -v /etc/nginx/sites-available/backpack /etc/nginx/sites-enabled/backpack
