yum install -y wget
wget -nv --no-check-certificate --no-cache --no-cookies -O - "https://download.splunk.com/products/$1" | tar -xzf -
yum autoremove -y wget