#!/bin/bash

# Documentation: https://docs.splunk.com/Documentation/Splunk/7.3.6/Indexer/Searchablerollingupgrade#6._Upgrade_the_peer_node

AUTH="admin:admin1234"

cluster_state=$(curl -ksu $AUTH 'https://localhost:8089/services/cluster/master/health?output_mode=json')


################################################################################
# Step 1: Run preliminary health checks
################################################################################

echo "pre_flight_check: $(echo $cluster_state | jq '.entry[0].content.pre_flight_check')"
is_ok_pre_flight_check=$(echo $cluster_state | jq '[.entry[0].content | select(.pre_flight_check == "0")] | length')

if [ $is_ok_pre_flight_check -eq 1 ]; then
    echo "Cannot perform a rolling upgrade while pre-flight checks are not OK. Run this command to check the status of the pre-flight checks: splunk show cluster-status --verbose"
    exit 1
fi

echo "all_data_is_searchable: $(echo $cluster_state | jq '.entry[0].content.all_data_is_searchable')"
all_data_is_searchable=$(echo $cluster_state | jq '[.entry[0].content | select(.all_data_is_searchable == "0")] | length')

if [ $all_data_is_searchable -eq 1 ]; then
    echo "Cannot perform a rolling upgrade while all data is not searchable. Run this command to check the status of the searchable data: splunk show cluster-status --verbose"
    exit 1
fi

echo "all_peers_are_up: $(echo $cluster_state | jq '.entry[0].content.all_peers_are_up')"
all_peers_are_up=$(echo $cluster_state | jq '[.entry[0].content | select(.all_peers_are_up == "0")] | length')

if [ $all_peers_are_up -eq 1 ]; then
    echo "Cannot perform a rolling upgrade while all peers are not up. Run this command to check the status of the peers: splunk show cluster-status --verbose"
    exit 1
fi

echo "replication_factor_met: $(echo $cluster_state | jq '.entry[0].content.replication_factor_met')"
replication_factor_met=$(echo $cluster_state | jq '[.entry[0].content | select(.replication_factor_met == "0")] | length')

if [ $replication_factor_met -eq 1 ]; then
    echo "Cannot perform a rolling upgrade while the replication factor is not met. Run this command to check the status of the replication factor: splunk show cluster-status --verbose"
    exit 1
fi

echo "search_factor_met: $(echo $cluster_state | jq '.entry[0].content.search_factor_met')"
search_factor_met=$(echo $cluster_state | jq '[.entry[0].content | select(.search_factor_met == "0")] | length')

if [ $search_factor_met -eq 1 ]; then
    echo "Cannot perform a rolling upgrade while the search factor is not met. Run this command to check the status of the search factor: splunk show cluster-status --verbose"
    exit 1
fi

echo "site_replication_factor_met: $(echo $cluster_state | jq '.entry[0].content.site_replication_factor_met')"
site_replication_factor_met=$(echo $cluster_state | jq '[.entry[0].content | select(.site_replication_factor_met == "0")] | length')

if [ $site_replication_factor_met -eq 1 ]; then
    echo "Cannot perform a rolling upgrade while the site replication factor is not met. Run this command to check the status of the site replication factor: splunk show cluster-status --verbose"
    exit 1
fi

echo "site_search_factor_met: $(echo $cluster_state | jq '.entry[0].content.site_search_factor_met')"
site_search_factor_met=$(echo $cluster_state | jq '[.entry[0].content | select(.site_search_factor_met == "0")] | length')

if [ $site_search_factor_met -eq 1 ]; then
    echo "Cannot perform a rolling upgrade while the site search factor is not met. Run this command to check the status of the site search factor: splunk show cluster-status --verbose"
    exit 1
fi

echo "no_fixup_tasks_in_progress: $(echo $cluster_state | jq '.entry[0].content.no_fixup_tasks_in_progress')"
no_fixup_tasks_in_progress=$(echo $cluster_state | jq '[.entry[0].content | select(.no_fixup_tasks_in_progress == "0")] | length')

if [ $no_fixup_tasks_in_progress -eq 1 ]; then
    echo "Cannot perform a rolling upgrade while fixup tasks are in progress. Run this command to check the status of the fixup tasks: splunk show cluster-status --verbose"
    exit 1
fi

echo "Preliminary health checks passed"
exit 0
