#!/bin/bash

############################################################################
	#Install wordpress shell 
	#Ce script automatise l'installation d'un site wordpres en utilisant wp_cli 
	#Auteur : Thomas Cosmar 
	#Date 24/11/2017 
############################################################################


############################################################################
		# Bannière 
############################################################################
echo 
echo 
echo 
echo 
echo '****************************************************'
echo '****************************************************'
echo '********     WordPress Install v1.0.0       ********'
echo '****************************************************'
echo '****************************************************'
echo 
echo 
echo 
echo 
echo 'Bienvenue dans l`assistant !! '
echo 'Etape 1 : Configuration de la base de données'


read -p 'Name : ' bddName
read -p 'User : ' bddUser
read -p 'Password : ' bddPasswd

#Création de la base de données 
mysql --user="$bddUser" --password="$bddPasswd" --execute="CREATE DATABASE $bddName;"
#Création de l'utilisateur wordpress
read -p 'WP Bdd User : ' wpBddUser
read -p 'WP Bdd Password : ' wpBddPasswd

mysql --user="$bddUser" --password="$bddPasswd" --execute="CREATE USER '$wpBddUser'@'localhost'IDENTIFIED BY '$wpBddPasswd';"
mysql --user="$bddUser" --password="$bddPasswd" --execute="grant all on $bddName.* to '$wpBddUser' identified by '$wpBddPasswd';"


echo
echo 
echo 
echo 'Etape 2 : Configuration apache '

read -p 'Entrez le nom de domaine  : ' domain
#read -p 'Entrez le chemin répertoire '  path
#Création du répertoire apache 
mkdir -p /var/www/html/$domain/public_html
chown -R www-data /var/www/html/$domain/public_html
#Création du vhost apache 
cp /etc/apache2/sites-available/model.conf /etc/apache2/sites-available/$domain.conf
sed -i "s/www.example.com/$domain/g" /etc/apache2/sites-available/$domain.conf
sed -i "s/html/html\/$domain/g" /etc/apache2/sites-available/$domain.conf
cd /etc/apache2/sites-available/
a2ensite "$domain.conf"
service apache2 reload 


echo ' **************************************************** \n'
echo '		Configuration du site  \n'
echo ' **************************************************** \n'

read -p 'Entrez le numero de version [lastest]  : ' version
read -p 'Entrez le nom du site [wordpress]  : ' siteName
read -p 'Entrez le login  : ' login
read -p 'Entrez le passwd  : ' passwd
#Installation du Wordpress
cd /var/www/html/$domain
wp core download --version=$version --locale=fr_FR --force --allow-root
wp core config --dbname=$bddName --dbuser=$wpBddUser --dbpass=$wpBddPasswd --dbhost=localhost --dbprefix=wp_ --allow-root
wp core install --url="http://$domain" --title="$siteName" --admin_user="$login" --admin_password="$passwd" --admin_email="email@$domain" --allow-root
chown www-data:www-data /var/www/html/$domain

echo ' **************************************************** \n'
echo '		Installation terminée  \n'
echo ' **************************************************** \n'
