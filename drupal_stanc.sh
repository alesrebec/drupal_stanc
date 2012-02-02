#!/bin/sh #-x

# Drupal Stanc 0.1-beta1 bash script
# Create a web portal in a minute
# by @alesrebec

echo "\nWelcome to Drupal Stanc 0.1-beta1"
echo "Run this script from your web directory. A new folder will be created in current directory."
echo "Press Enter to continue..."
read key

read -p "Enter installation folder: " DRUPAL_DIR
read -p "Enter db username: " DB_USER
read -s -p "Enter db password: " DB_PASS
echo ""
read -p "Enter db name:" DB_NAME
echo ""

DB_URL="mysql://$DB_USER:$DB_PASS@localhost/$DB_NAME"

#no need to create a database, because it is created in drush si command below
#mysql --user=$DB_USER --password=$DB_PASS --execute="CREATE DATABASE $DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;"
#echo "Created new database: $DB_NAME"

# modules to enable
CONTRIB_MODULES+=" pathauto variable token wysiwyg i18n google_analytics" # default modules
CONTRIB_MODULES+="" # enter extra contrib modules

NEW_DIRS="sites/default/files sites/all/modules/contrib sites/all/modules/custom sites/all/modules/admin"

# commands
DRUSH="drush -v"

# download Drupal core
$DRUSH dl drupal --drupal-project-rename="$DRUPAL_DIR"
echo "Downloaded drupal into folder: $DRUPAL_DIR"
cd "$DRUPAL_DIR" || exit 1 # go to directory (create if doesn't exist)

# configure and install
mkdir -v $NEW_DIRS # create proper folder structure
cp -v sites/default/default.settings.php sites/default/settings.php # create config file
$DRUSH si --db-url="$DB_URL" --site-name="$DRUPAL_DIR"

# change permissions
chmod 777 "sites/default/files"

# download content modules
$DRUSH -y dl $CONTRIB_MODULES

echo "\nInstalled in $DRUPAL_DIR directory."
