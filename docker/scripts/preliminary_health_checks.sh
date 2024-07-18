#!/bin/bash

# Documentation: https://docs.splunk.com/Documentation/Splunk/7.3.6/DistSearch/SHCrollingupgrade

AUTH="admin:admin1234"

cluster_state=$(curl -ksu $AUTH 'https://localhost:8089/services/shcluster/status?output_mode=json&advanced=1')
mgmt_captain_uri=$(echo $cluster_state | jq -r '.entry[0].content.captain.mgmt_uri')
mgmt_member_uri=$($SPLUNK_HOME/bin/splunk btool server list | grep mgmt_uri | sed -e "s/mgmt_uri = //g")


################################################################################
# Step 1: Run preliminary health checks
################################################################################

if [ "$mgmt_captain_uri" = "$mgmt_member_uri" ]; then
    echo "Cannot perform a rolling upgrade on the captain, To transfer captaincy to a different member, run this command: splunk transfer shcluster-captain -mgmt_uri <URI>:<management_port> -auth <username>:<password>"
    exit 1
fi

members_out_of_sync=$(echo $cluster_state | jq '[.entry[0].content.peers[] | select(.out_of_sync_node != false)] | length')

if [ $members_out_of_sync -gt 0 ]; then
    echo "Cannot perform a rolling upgrade while members are out of sync. Run this command to check the status of the out-of-sync members: splunk show shcluster-status --verbose"
    exit 1
fi

has_stable_captain=$(echo $cluster_state | jq '[.entry[0].content.captain | select(.stable_captain != false)] | length')

if [ $has_stable_captain -eq 0 ]; then
    echo "Cannot perform a rolling upgrade while the captain is not stable. Run this command to check the status of the captain: splunk show shcluster-status --verbose"
    exit 1
fi

is_service_ready=$(echo $cluster_state | jq '[.entry[0].content.captain | select(.service_ready_flag != false)] | length')

if [ $is_service_ready -eq 0 ]; then
    echo "Cannot perform a rolling upgrade while the captain is not ready. Run this command to check the status of the captain: splunk show shcluster-status --verbose"
    exit 1
fi

echo "Preliminary health checks passed"
exit 0
