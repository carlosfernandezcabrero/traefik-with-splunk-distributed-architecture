#!/bin/bash

# Documentation: https://docs.splunk.com/Documentation/Splunk/7.3.6/Indexer/Searchablerollingupgrade#6._Upgrade_the_peer_node

AUTH="admin:admin1234"

if [ ! -f /tmp/splunk_8.1.latest.tgz ]; then
    echo "splunk_8.1.latest.tgz not found in /tmp"
    exit 1
fi


################################################################################
# Step 6: Upgrade the peer node
################################################################################

perform_upgrade.sh /tmp/splunk_8.1.latest.tgz


################################################################################
# Step 7: Bring the peer online
################################################################################

$SPLUNK_HOME/bin/splunk start


################################################################################
# Step 8: Validate version upgrade
################################################################################

echo "Rolling upgrade completed successfully"
exit 0
