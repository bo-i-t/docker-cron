#!/bin/bash

set -e
echo "Running ${0}"

CRONTAB_PATH=/etc/cron.d/crontab
CRONLOG_PATH=/var/log/cron.log

# Variables from container environment should to be available in cron jobs
printenv > /etc/environment

echo "Looking for crontab file in ${CRONTAB_PATH}"
crontab $CRONTAB_PATH
echo "Successfully installed the following crontab:"
echo "---------------------------------------------"
crontab -l
echo "---------------------------------------------"

# Make sure the expected log file exists
>>$CRONLOG_PATH

echo "Starting cron"
cron

echo "Following logs in ${CRONLOG_PATH}"
tail -f $CRONLOG_PATH
