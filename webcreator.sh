#!/bin/bash
#
# This script creates a website environment + SSL certificate on the web server
#
echo -n "Enter domain name (zonder www): "
read SITE

# 1. Setting up the site and initial web page
echo "Setting up the site and initial web page"
mkdir /var/www/$SITE
mkdir /var/www/$SITE/logs
touch /var/www/$SITE/logs/error.log
touch /var/www/$SITE/logs/access.log
cp /var/www/initial/* /var/www/$SITE

echo "Setting the rights for the webroot"
chown -R www-data:www-data /var/www/$SITE

# 2. Creating Apache configuration file for virtual host
echo "Creating the Apache configuration file for the virtual host"
cd /etc/apache2/sites-available
cat > $SITE.conf << EOF
<VirtualHost *:80>
     ServerAdmin webmaster@$SITE
     ServerName $SITE
     ServerAlias www.$SITE
     DocumentRoot /var/www/$SITE
     ErrorLog /var/www/$SITE/logs/error.log
     CustomLog /var/www/$SITE/logs/access.log combined
     Options ExecCGI
     AddHandler cgi-script .pl
</VirtualHost>
EOF

#
# 3. Apache enable and reload
echo "Apache enable and reload"
a2ensite $SITE
service apache2 reload

# 4. Setup Letsencrypt SSL certificate
echo "Setting up Letsencrypt SSL certificate"
cd /opt/letsencrypt
./letsencrypt-auto --apache -d $SITE -d www.$SITE

echo ""
echo "-------------------------------------------------------------"
echo "Finished!"
echo "If you set up DNS correctly you should be able to open"
echo "$SITE in a browser!"
echo "Enjoy!"
