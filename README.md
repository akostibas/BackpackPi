# BackpackPi
Put a RaspberryPi in your backpack, see who connects.

# Installation

* Clone this repo into `/var/www/BackpackPi`
* Run all following commands in that directory.
* Install required packages: `make install_apt_packages`
* Install nginx configuration: `make install_nginx_config`
* Setup proper permissions on the database file: `make setup_database_perms`
* Start the webserver! `make start_django`
