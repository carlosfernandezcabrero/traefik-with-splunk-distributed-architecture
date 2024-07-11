import os

from jinja2 import Template

SPLUNK_HOME = os.environ["SPLUNK_HOME"]

Template(
    """[general]
serverName = hf

[license]
master_uri = https://master:8089"""
).stream().dump("{}/etc/system/local/server.conf".format(SPLUNK_HOME))

Template(
    """[tcpout]
defaultGroup = de_group

[tcpout:de_group]
server = idx_de:9997

[tcpout:pr_group]
server = {{ env['PR_INDEXERS'] }}"""
).stream(env=os.environ).dump("{}/etc/system/local/outputs.conf".format(SPLUNK_HOME))
