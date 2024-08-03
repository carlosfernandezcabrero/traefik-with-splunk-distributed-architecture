#!/bin/bash

# Documentation: https://docs.splunk.com/Documentation/Splunk/7.3.6/DistSearch/SHCrollingupgrade

AUTH="admin:admin1234"

if [ ! -f /tmp/splunk_8.1.latest.tgz ]; then
    echo "splunk_8.1.latest.tgz not found in /tmp"
    exit 1
fi


################################################################################
# Step 3: Put a member into manual detention mode
################################################################################

$SPLUNK_HOME/bin/splunk edit shcluster-config -manual_detention on -auth $AUTH


################################################################################
# Step 4: Confirm the member is ready for upgrade
################################################################################

is_member_ready=$($SPLUNK_HOME/bin/splunk list shcluster-member-info -auth $AUTH | grep "active" | grep 0 | wc -l)

if [ $is_member_ready -ne 2 ]; then
    echo "The member have historical searches or realtime searches active. Run this command to check active historical searches and realtime searches: $SPLUNK_HOME/bin/splunk list shcluster-member-info | grep \"active\""
    exit 1
fi


################################################################################
# Step 5: Upgrade the member
################################################################################

$SPLUNK_HOME/bin/splunk stop

perform_upgrade.sh /tmp/splunk_8.1.latest.tgz


################################################################################
# Step 6: Bring the member back online
################################################################################

$SPLUNK_HOME/bin/splunk start
$SPLUNK_HOME/bin/splunk edit shcluster-config -manual_detention off -auth $AUTH


################################################################################
# Step 7: Check cluster health status
################################################################################

echo "Rolling upgrade completed successfully"
echo "shcluster status:"
$SPLUNK_HOME/bin/splunk show shcluster-status --verbose -auth $AUTH
exit 0
