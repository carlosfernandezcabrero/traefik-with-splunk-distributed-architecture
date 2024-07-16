import os

from jinja2 import Template

SPLUNK_HOME = os.environ["SPLUNK_HOME"]

Template(
    """[general]
pass4SymmKey = yoursecretkey
serverName = de_sh
site = site0

[clustering]
master_uri = https://master:8089
pass4SymmKey = yoursecretkey
mode = searchhead
multisite = true

[license]
master_uri = https://master:8089"""
).stream().dump("{}/etc/system/local/server.conf".format(SPLUNK_HOME))

Template(
    """[distributedSearch]
servers = https://idx_de:8089"""
).stream().dump("{}/etc/system/local/distsearch.conf".format(SPLUNK_HOME))


Template(
    """[settings]
root_endpoint = /sh_de
httpport = 8001"""
).stream().dump("{}/etc/system/local/web.conf".format(SPLUNK_HOME))
