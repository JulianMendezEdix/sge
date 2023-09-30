sudo adduser --system --quiet --shell=/bin/bash --home=/opt/odoo --gecos 'odoo' --group odoo
sudo passwd odoo
sudo mkdir /etc/odoo
sudo mkdir /var/log/odoo/
sudo apt update
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt install postgresql postgresql-server-dev-12 build-essential python3-pil python3-lxml python3-ldap3 python3-dev python3-pip python3-setuptools nodejs git libldap2-dev libsasl2-dev libxml2-dev libxslt1-dev libjpeg-dev npm -y
sudo git clone --depth 1 --branch 14.0 https://github.com/odoo/odoo /opt/odoo/odoo
sudo chown odoo:odoo /opt/odoo/ -R
sudo chown odoo:odoo /var/log/odoo/ -R
sudo visudo
# ADD: "odoo ALL=(ALL:ALL) ALL"
# cAMBIAR A USUARIO ODOO
