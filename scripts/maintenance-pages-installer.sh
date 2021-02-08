#!/bin/bash

echo $'\033[1;33m'Running script maintenance-pages-installer
echo ------------------------------------------------------$'\033[1;33m'
echo

echo $'\033[0;33m'Maintenance pages installer starting...$'\033[0m'
echo
pwd=$(pwd)
pwd
ls -aF --color=always
echo

s3=//cv-generator-life-maintenance.s3-eu-west-1.amazonaws.com
cdn=//d3v2pfjkkulyt1.cloudfront.net

# pages=$s3
pages=$cdn

heroku config:get -a cv-generator-fe ERROR_PAGE_URL
heroku config:get -a cv-generator-fe MAINTENANCE_PAGE_URL
heroku config:set -a cv-generator-fe \
  ERROR_PAGE_URL=$pages/application-error.html \
  MAINTENANCE_PAGE_URL=$pages/maintenance-mode.html
heroku config:get -a cv-generator-fe ERROR_PAGE_URL
heroku config:get -a cv-generator-fe MAINTENANCE_PAGE_URL
echo

heroku config:get -a cv-generator-fe-eu ERROR_PAGE_URL
heroku config:get -a cv-generator-fe-eu MAINTENANCE_PAGE_URL
heroku config:set -a cv-generator-fe-eu \
  ERROR_PAGE_URL=$pages/application-error.html \
  MAINTENANCE_PAGE_URL=$pages/maintenance-mode.html
heroku config:get -a cv-generator-fe-eu ERROR_PAGE_URL
heroku config:get -a cv-generator-fe-eu MAINTENANCE_PAGE_URL


echo
echo $'\033[1;32m'Maintenance pages installer finished...$'\033[0m'

echo
# read  -n 1 -p "x" input
# exit
