#!/bin/bash

# Install httpd (Apache web server)
echo "Installing httpd..."
sudo yum install -y httpd

# Create directory /var/www/html/sa
echo "Creating directory /var/www/html/sa..."
sudo mkdir -p /var/www/html/sa

# Create configuration file for sa directory
echo "Creating directory directive configuration file /etc/httpd/conf.d/sa.conf..."
sudo bash -c 'cat <<EOF > /etc/httpd/conf.d/sa.conf
<Directory "/var/www/html/sa">
    AllowOverride All
    Require all granted
</Directory>
EOF'

# Create .htaccess file with authentication
echo "Creating .htaccess file with authentication..."
sudo bash -c 'cat <<EOF > /var/www/html/sa/.htaccess
AuthType Basic
AuthName "Restricted Access"
AuthUserFile /etc/httpd/.htpasswd
Require valid-user
EOF'

# Prompt user to set username and password for authentication
read -p "Enter username for authentication: " username
read -sp "Enter password for authentication: " password
echo ""
sudo htpasswd -b -c /etc/httpd/.htpasswd "$username" "$password"

# Restart httpd service to apply changes
echo "Restarting httpd service..."
sudo systemctl restart httpd

echo "Installation and configuration completed successfully."
