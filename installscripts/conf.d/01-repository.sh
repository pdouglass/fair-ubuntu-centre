echo "---------------------------------------"
echo "Configuring apt repository             "
echo "---------------------------------------"

mkdir -p /var/www/

# Create the links to our Ubuntu repository if they don't already exist
if [ ! -L /var/www/ubuntu ]
then
        echo "Creating links for our repository"
        ln -s ${FAIR_ARCHIVE_PATH}/ubuntu /var/www/ubuntu
        ln -s /var/www/ubuntu/pool /var/www/pool
fi

# Configure the server to find software on the local Ubuntu repository
cat ${FAIR_INSTALL_DATA}/sources.list > /etc/apt/sources.list

# We run "configure" to start with because half-installed packages can cause apt-get to fail, and this prevents that...
dpkg --configure -a

# Use the local repository to update the installation...
apt-get update

dpkg --configure -a

apt-get autoremove -y -q
