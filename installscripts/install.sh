#!/bin/bash

# PJD: Important design consideration:  This script should be able to upgrade an existing server, therefore all operations must start by removing and old crap and ensuring a complete overwrite of the contents.  This feature can be especially handy when developing too :).  Could consider starting script with a warning WILL ERASE EXISTING INSTALLATION, ARE YOU SURE...

set -o errexit

# Include variables defined externally
. ./config/default_cfg.sh

echo "---------------------------------------"
echo "Starting FAIR install"
echo "---------------------------------------"

# Check dependancies- permissions, and access to media drive 
if !(whoami | grep "root" -q)
then
	echo "Only root can run this!"
	echo ""
	echo "Run the program as root, ie.:"
	echo "sudo bash install.sh"
	exit 1
fi

if [ ! -d $FAIR_ARCHIVE_PATH ]
then
	echo "FAIR USB drive not detected in $FAIR_ARCHIVE_PATH"
	exit 1
fi

echo "---------------------------------------"
echo "Installing config files"
echo "---------------------------------------"

# If the script was called with a command line parameter, the parameter must be the name of a script in Conf.d.  Only that script is excuted
if [ ! "$1" = "" ]
then
	echo "Running $1"
	. "$FAIR_INSTALL_CONF_D/$1"
else
	# If no parameters were used when calling this script, all files in conf.d are executed.
	for file in `ls "$FAIR_INSTALL_CONF_D"`
	do
		if [ -f "$FAIR_INSTALL_CONF_D/$file" ]; then
			skip="no"

			# Check the list of files to skip...
			for fskip in "${FAIR_CONF_D_SKIP[@]}"
			do
				if [ "$fskip" == "$file" ]; then
					skip="yes"
				fi
			done

			if [ $skip = "no" ] ; then
				. $FAIR_INSTALL_CONF_D/$file
			else
				echo "Skipping $file"
			fi
		fi
	done
fi


apt-get -y -q upgrade


echo "---------------------------------------"
echo "Adding local overlay                   "
echo "---------------------------------------"

./config/local.sh

echo "---------------------------------------"
echo "Creating client postinstall package    "
echo "---------------------------------------"
./postinstall/make_postinstall.sh
