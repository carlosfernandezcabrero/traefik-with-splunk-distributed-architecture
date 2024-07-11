import os

from jinja2 import Template

SPLUNK_HOME = os.environ["SPLUNK_HOME"]

Template(
    """[clustering]
mode = master
pass4SymmKey = yoursecretkey
available_sites = site1,site2
multisite = true
site_replication_factor = origin:2,total:3
site_search_factor = origin:1,total:2

[shclustering]
pass4SymmKey = yoursecretkey

[general]
pass4SymmKey = yoursecretkey
serverName = manager
site = site1

[license]"""
).stream().dump("{}/etc/system/local/server.conf".format(SPLUNK_HOME))

Template(
    """[settings]
root_endpoint = /master"""
).stream().dump("{}/etc/system/local/web.conf".format(SPLUNK_HOME))

Template("""[default]

[distributedSearch]
servers = https://shc1:8089,https://shc2:8089,https://shc3:8089

[distributedSearch:dmc_group_cluster_master]
servers = localhost:localhost

[distributedSearch:dmc_group_indexer]
default = true
servers = idxc1:8089,idxc2:8089,idxc3:8089,idxc4:8089

[distributedSearch:dmc_group_search_head]
servers = localhost:localhost,shc1:8089,shc2:8089,shc3:8089

[distributedSearch:dmc_group_license_master]
servers = localhost:localhost

[distributedSearch:dmc_group_deployment_server]
servers = localhost:localhost

[distributedSearch:dmc_group_kv_store]
servers = shc1:8089,shc2:8089,shc3:8089

[distributedSearch:dmc_group_shc_deployer]
servers = localhost:localhost""").stream().dump("{}/etc/system/local/distsearch.conf".format(SPLUNK_HOME))
