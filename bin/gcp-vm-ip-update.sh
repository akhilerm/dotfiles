#! /bin/bash

# script to update the IP address of dev-machine in GCP in /etc/hosts
# this script can be run as a cron job, may be every day in the morning

IP=`gcloud compute instances list --format=json | jq '.[]|select(.name=="dev-machine" and .status=="RUNNING")|.networkInterfaces[0].accessConfigs[0].natIP' | tr -d '"'`
if [ -z "$IP" ];then
        exit 1
fi
# additional '' added after -i to make this work on Mac. On GNU sed, its not needed
sed -i '' "s/.*gcp-dev-machine/${IP} gcp-dev-machine/" /etc/hosts
