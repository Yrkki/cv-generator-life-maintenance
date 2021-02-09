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

apps=(cv-generator-fe cv-generator-fe-eu)

report() {
  heroku config:get -a $app ERROR_PAGE_URL
  heroku config:get -a $app MAINTENANCE_PAGE_URL
}

for i in "${!apps[@]}"; do
  app=${apps[$i]}
  echo $'\033[1;30m'Processing the $'\033[0;35m'$app$'\033[1;30m' app...$'\033[0m'

  report
  echo

  maintenanceIsOff=$(heroku maintenance -a $app)

  if [ $maintenanceIsOff == "off" ]; then
    heroku maintenance:on -a $app
  fi

  heroku config:set -a $app \
    ERROR_PAGE_URL=$pages/application-error.html \
    MAINTENANCE_PAGE_URL=$pages/maintenance-mode.html

  if [ $maintenanceIsOff == "off" ]; then
    heroku maintenance:off -a $app
  fi

  report
  echo
done

echo
echo $'\033[1;32m'Maintenance pages installer finished...$'\033[0m'

echo
# read  -n 1 -p "x" input
# exit
