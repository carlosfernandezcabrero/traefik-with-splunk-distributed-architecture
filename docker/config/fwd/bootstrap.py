import os

from jinja2 import Template

SPLUNK_HOME = os.environ["SPLUNK_HOME"]

Template(
    """[deployment-client]
phoneHomeIntervalInSecs = 180

[target-broker:deploymentServer]
targetUri = master:8089"""
).stream().dump("{}/etc/system/local/deploymentclient.conf".format(SPLUNK_HOME))

Template(
    """[general]
serverName = {{ env['SERVER_NAME'] }}"""
).stream(env=os.environ).dump("{}/etc/system/local/server.conf".format(SPLUNK_HOME))

Template(
    """[tcpout]
defaultGroup = de_group

[tcpout:de_group]
server = idx_de:9997

[tcpout:pr_group]
server = {{ env['PR_INDEXERS'] }}"""
).stream(env=os.environ).dump("{}/etc/system/local/outputs.conf".format(SPLUNK_HOME))

Template(
    """[default]
host = {{ env['SERVER_NAME'] }}"""
).stream(env=os.environ).dump("{}/etc/system/local/inputs.conf".format(SPLUNK_HOME))
