import os

from jinja2 import Template

SPLUNK_HOME = os.environ["SPLUNK_HOME"]


Template(
    """[replication_port://8080]

[clustering]
master_uri = https://master:8089
pass4SymmKey = yoursecretkey
mode = slave

[general]
serverName = {{ env['SERVER_NAME'] }}
site = {{ env['SITE'] }}

[license]
master_uri = https://master:8089"""
).stream(env=os.environ).dump("{}/etc/system/local/server.conf".format(SPLUNK_HOME))

Template(
    """[settings]
root_endpoint = /{{ env['SERVER_NAME'] }}
httpport = {{ env['HTTP_PORT'] }}"""
).stream(env=os.environ).dump("{}/etc/system/local/web.conf".format(SPLUNK_HOME))
