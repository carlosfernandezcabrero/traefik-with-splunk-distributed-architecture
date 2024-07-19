import os

from jinja2 import Template

SPLUNK_HOME = os.environ["SPLUNK_HOME"]

Template(
    """[general]
pass4SymmKey = yoursecretkey
serverName = {{ env['SERVER_NAME'] }}
site = {{ env['SITE'] }}

[clustering]
master_uri = https://master:8089
pass4SymmKey = yoursecretkey
mode = searchhead
multisite = true

[replication_port://9888]

[shclustering]
conf_deploy_fetch_url = https://master:8089
disabled = 0
pass4SymmKey = yoursecretkey
replication_factor = 2
election=false
captain_uri=https://shc1:8089
{% if 'PREFFERED_CAPTAIN' in env -%}
    mode=captain
{% else -%}
    mode=member
{% endif -%}
mgmt_uri = https://{{ env['SERVER_NAME'] }}:8089
shcluster_label=CLUSTER_PRO

[license]
master_uri = https://master:8089"""
).stream(env=os.environ).dump("{}/etc/system/local/server.conf".format(SPLUNK_HOME))

Template(
    """[settings]
root_endpoint = /{{ env['SERVER_NAME'] }}
httpport = {{ env['HTTP_PORT'] }}"""
).stream(env=os.environ).dump("{}/etc/system/local/web.conf".format(SPLUNK_HOME))
