import os

from jinja2 import Template

SPLUNK_HOME = os.environ["SPLUNK_HOME"]

Template(
    """[replication_port://8080]

[general]
serverName = idx_de

[license]
master_uri = https://master:8089"""
).stream().dump("{}/etc/system/local/server.conf".format(SPLUNK_HOME))

Template(
    """[settings]
root_endpoint = /idx
httpport = 8002"""
).stream().dump("{}/etc/system/local/web.conf".format(SPLUNK_HOME))
