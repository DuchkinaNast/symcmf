#!/usr/bin/env bash

service mysql start
mysql -h localhost --user=homestead --password=secret -e "CREATE DATABASE IF NOT EXISTS homestead CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h localhost --user=homestead --password=secret homestead < tests/_data/dump.sql
composer install

echo "Get libraries for project"
php composer.phar install --prefer-source --no-scripts

echo "Set config file with params"
cp app/config/parameters.gitlab-ci.yml app/config/parameters.yml

echo "Install DB and seeders for it"
bash app/db-update.sh

echo "Run scripts"
php composer.phar install

echo "Setup Symfony CMF"
bash app/setup.sh

echo "Generate build_bootstrap for testing"
php vendor/sensio/distribution-bundle/Resources/bin/build_bootstrap.php
