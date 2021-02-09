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

# servers
# s3
s3Log=cv-generator-life-log.s3-eu-west-1.amazonaws.com
s3Maintenance=cv-generator-life-maintenance.s3-eu-west-1.amazonaws.com
s3="$s3Maintenance"
# cdn
cdnLog=d1ezniuvzgl2qb.cloudfront.net
cdnMaintenance=d3v2pfjkkulyt1.cloudfront.net
cdn="$cdnMaintenance"

# Toggle. Switch between Log and Manitenance data pond by uncommenting only one of them:
# server="$s3"
server="$cdn"

# deployments
apps=(
  cv-generator-fe-eu
  cv-generator-fe
  cv-generator-life-map
  cv-generator-project-server
  cv-generator-life-adapter
)

# status reporter
report() {
  echo -ne '    '$'\033[1;30m'ERROR_PAGE_URL: $'\033[1;31m'
  heroku config:get ERROR_PAGE_URL -a "$app"
  echo -ne '    '$'\033[1;30m'MAINTENANCE_PAGE_URL: $'\033[1;33m'
  heroku config:get MAINTENANCE_PAGE_URL -a "$app"
  echo -ne $'\033[0m'
}

# Old state
for i in "${!apps[@]}"; do
  app=${apps[$i]}
  echo $'\033[1;30m'Processing the $'\033[0;35m'"$app"$'\033[1;30m' app... $'\033[0;37m'Old state: $'\033[0m'
  report
  echo
done

# Changing state
for i in "${!apps[@]}"; do
  app=${apps[$i]}
  echo $'\033[1;30m'Processing the $'\033[0;35m'"$app"$'\033[1;30m' app... $'\033[0;37m'Changing state: $'\033[0m'

  maintenanceIsOff=$(heroku maintenance -a "$app")

  if [ "$maintenanceIsOff" == "off" ]; then
    heroku maintenance:on -a "$app"
  fi

  echo $'\033[0;37m'Changing state: $'\033[0m'
  heroku config:set -a "$app" \
    ERROR_PAGE_URL=//"$server"/application-error.html \
    MAINTENANCE_PAGE_URL=//"$server"/maintenance-mode.html

  if [ "$maintenanceIsOff" == "off" ]; then
    heroku maintenance:off -a "$app"
  fi

  echo
done

# New state
for i in "${!apps[@]}"; do
  app=${apps[$i]}
  echo $'\033[1;30m'Processing the $'\033[0;35m'"$app"$'\033[1;30m' app... $'\033[1;32m'New state: $'\033[0m'
  report
  echo
done

echo
echo $'\033[1;32m'Maintenance pages installer finished...$'\033[0m'

echo
# read  -n 1 -p "x" input
# exit
