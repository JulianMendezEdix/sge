#!/bin/bash

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
sudo echo "odoo    ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers.d/custom-file

# Ejecutar los comandos como el usuario 'odoo'
sudo -u odoo bash << EOF
cd /opt/odoo/odoo
pip3 install -r requirements.txt
pip install PyPDF2==1.26.0
pip install Werkzeug==2.0.2
pip install Babel==2.9.1
pip install passlib==1.7.1
pip install decorator==4.3.0
pip install polib==1.1.0
pip install psycopg2==2.8.5
pip install psutil==5.6.6
pip install MarkupSafe==1.1.0
pip install docutils==0.14
pip install num2words==0.5.6
pip install Jinja2==2.11.2
npm install -g less less-plugin-clean-css -y
ln -s /usr/bin/nodejs /usr/bin/node
node -v
sudo apt install xfonts-base xfonts-75dpi -y
cd /tmp
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
sudo dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6-1.focal_amd64.deb
ln -s /usr/local/bin/wkhtmltopdf /usr/bin/
ln -s /usr/local/bin/wkhtmltoimage /usr/bin/
EOF

# Continuar con los comandos restantes fuera del usuario 'odoo'
sudo mv /opt/odoo/.odoorc /etc/odoo/odoo.conf
sudo sed -i "s,^\(logfile = \).*,\1"/var/log/odoo/odoo-server.log"," /etc/odoo/odoo.conf
sudo sed -i "s,^\(proxy_mode = \).*,\1"True"," /etc/odoo/odoo.conf
sudo cp /opt/odoo/odoo/debian/init /etc/init.d/odoo
sudo chmod +x /etc/init.d/odoo
sudo ln -s /opt/odoo/odoo/odoo-bin /usr/bin/odoo
sudo update-rc.d -f odoo start 20 2 3 4 5 .
sudo update-rc.d odoo defaults
sudo service odoo start

