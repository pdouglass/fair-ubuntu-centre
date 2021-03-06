#!/bin/bash

if [ -n "${SCRIPT_ROOT}" ]; then

        echo "Globals already defined"
else
        SCRIPT="`readlink -e $0`"
        SCRIPTPATH="`dirname $SCRIPT`"
        echo "Including global variables"
        export SCRIPT_ROOT=$SCRIPTPATH/..
        . $SCRIPTPATH/../config/default_cfg.sh
fi

echo "---------------------------------------"
echo "Installing apache2 http server         "
echo "---------------------------------------"

apt-get install -y -q apache2

# Modules for apache
apt-get install -y -q libapache2-mod-wsgi

echo "---------------------------------------"
echo "Setting up local web server"
echo "---------------------------------------"

# Note: Creating the link to the Ubuntu directory is done in repository.sh as well

# PDO: Don't know why the script at one time terminated here?
# echo "stop and die"
# exit

if [ ! -L /var/www/ubuntu ]
then
	echo "Creating links for our repository"
	ln -s ${FAIR_ARCHIVE_PATH}/ubuntu /var/www/ubuntu
	ln -s /var/www/ubuntu/pool /var/www/pool
fi

if [ ! -f /var/www/ubuntu/ubuntu ] && [ ! -d /var/www/ubuntu/ubuntu ] 
then
	ln -s /var/www/ubuntu/ /var/www/ubuntu/ubuntu
fi

echo "Copying Kickstart configuration file"
# These files automate the Ubuntu installation process by selecting which packages to install, and by running our custom 'post-install' script. 
cp ${FAIR_INSTALL_DATA}/ks*.cfg /var/www/
cp ${FAIR_INSTALL_DATA}/edubuntu.seed /var/www/

echo "Installing default index.html"
cp ${FAIR_INSTALL_DATA}/index.html /var/www

echo "Copying intranet"
if [ -f /var/www/intranet ]; then rm /var/wwwintranet; fi
mkdir -p /var/www/intranet
cp -rf ${FAIR_INSTALL_DATA}/intranet/* /var/www/intranet
chown -R root.root /var/www/intranet
chmod -R o+r /var/www/intranet
chmod -R o+X /var/www/intranet

echo "Creating virtual hosts for the repository and the intranet..."
# PDO: We have several sub-domains on the server because it helps us ....??
cat ${FAIR_INSTALL_DATA}/etc.apache2.sites-available.000-default.conf > /etc/apache2/sites-available/000-default.conf
cat ${FAIR_INSTALL_DATA}/etc.apache2.sites-available.repo.conf > /etc/apache2/sites-available/repo.conf
cat ${FAIR_INSTALL_DATA}/etc.apache2.sites-available.intranet.conf > /etc/apache2/sites-available/intranet.conf
a2ensite repo
a2ensite intranet

service apache2 reload

echo "---------------------------------------"
echo "Movies"
echo "---------------------------------------"

if [ ! -d /var/www/movies ] && [ -d ${FAIR_ARCHIVE_PATH}/data/movies ]
then
        echo "Creating links for Movies"
	chmod -R o+r ${FAIR_ARCHIVE_PATH}/data/movies
	chmod -R o+X ${FAIR_ARCHIVE_PATH}/data/movies
        ln -s ${FAIR_ARCHIVE_PATH}/data/movies /var/www/movies
else
	echo "Movies directory already symlinked (or the directory does not exist in the FAIR archive)"
fi

echo "---------------------------------------"
echo "Camara"
echo "---------------------------------------"


if [ ! -d /var/www/camara ] && [ -d ${FAIR_ARCHIVE_PATH}/data/camara ]
then
        echo "Creating links for Camara"
	chmod -R o+r ${FAIR_ARCHIVE_PATH}/data/camara
	chmod -R o+X ${FAIR_ARCHIVE_PATH}/data/camara
        ln -s ${FAIR_ARCHIVE_PATH}/data/camara /var/www/camara
else
	echo "Camara directory already symlinked (or the directory does not exist in the FAIR archive)"
fi

echo "---------------------------------------"
echo "Distro folder (iso images of other linux)"
echo "---------------------------------------"


if [ ! -d /var/www/distros ] && [ -d ${FAIR_ARCHIVE_PATH}/data/distros ]
then
        echo "Creating links for linux distros"
	chmod -R o+r ${FAIR_ARCHIVE_PATH}/data/distros
	chmod -R o+X ${FAIR_ARCHIVE_PATH}/data/distros
        ln -s ${FAIR_ARCHIVE_PATH}/data/distros /var/www/distros
else
	echo "Linux distros directory already symlinked (or the directory does not exist in the FAIR archive)"
fi

