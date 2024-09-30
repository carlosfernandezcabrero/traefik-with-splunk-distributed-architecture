FROM centos:centos7 AS splunkenterprise
ENV SPLUNK_HOME=/usr/local/splunk

WORKDIR /tmp
COPY scripts/fix_mirror_error.sh .
COPY scripts/download_splunk.sh .
COPY scripts/clean_system.sh .
COPY scripts/install_jq.sh .

WORKDIR /usr/local
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
	&& sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
	&& yum install -y python-jinja2 wget dos2unix \
	&& dos2unix /tmp/download_splunk.sh /tmp/clean_system.sh /tmp/install_jq.sh \
	&& chmod +x /tmp/download_splunk.sh && /tmp/download_splunk.sh "splunk/releases/7.3.6/linux/splunk-7.3.6-47d8552a4d84-Linux-x86_64.tgz" \
	&& chmod +x /tmp/install_jq.sh && /tmp/install_jq.sh \
	&& yum autoremove -y wget \
	&& chmod +x /tmp/clean_system.sh && /tmp/clean_system.sh

WORKDIR /usr/local/splunk
COPY splunk-launch.enterprise.conf etc/splunk-launch.conf
COPY Splunk.License ./etc/licenses/enterprise/Splunk.License.lic

WORKDIR /usr/bin
COPY scripts/perform_upgrade.sh .
COPY scripts/perform_upgrade_shc.sh . 
COPY scripts/preliminary_health_checks_shc.sh .
COPY scripts/perform_upgrade_idxc.sh . 
COPY scripts/preliminary_health_checks_idxc.sh .
RUN dos2unix perform_upgrade.sh perform_upgrade_shc.sh preliminary_health_checks_shc.sh perform_upgrade_idxc.sh preliminary_health_checks_idxc.sh \
	&& chmod +x perform_upgrade.sh perform_upgrade_shc.sh preliminary_health_checks_shc.sh perform_upgrade_idxc.sh preliminary_health_checks_idxc.sh

CMD python /tmp/bootstrap.py \
	&& ${SPLUNK_HOME}/bin/splunk start --answer-yes --accept-license --no-prompt --seed-passwd admin1234 \
	&& tail -f /dev/null


FROM centos:centos7 AS splunkforwarder-base

WORKDIR /tmp
COPY scripts/fix_mirror_error.sh .
COPY scripts/download_splunk.sh .
COPY scripts/clean_system.sh .

WORKDIR /usr/local	
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
	&& sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
	&& yum install -y wget dos2unix \
	&& dos2unix /tmp/download_splunk.sh /tmp/clean_system.sh \
	&& chmod +x /tmp/download_splunk.sh && /tmp/download_splunk.sh "universalforwarder/releases/7.3.6/linux/splunkforwarder-7.3.6-47d8552a4d84-Linux-x86_64.tgz" \
	&& yum autoremove -y wget \
	&& chmod +x /tmp/clean_system.sh && /tmp/clean_system.sh


FROM centos:centos7 AS splunkforwarder
ENV SPLUNK_HOME=/usr/local/splunkforwarder

WORKDIR /tmp
COPY scripts/fix_mirror_error.sh .
COPY scripts/clean_system.sh .
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
	&& sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
	&& yum install -y python-jinja2 dos2unix \
	&& dos2unix /tmp/clean_system.sh \
	&& chmod +x /tmp/clean_system.sh && /tmp/clean_system.sh

WORKDIR /usr/local/splunkforwarder
COPY --from=splunkforwarder-base /usr/local/splunkforwarder .
COPY splunk-launch.forwarder.conf etc/splunk-launch.conf

CMD python /tmp/bootstrap.py \
	&& ./bin/splunk start --answer-yes --accept-license --no-prompt --seed-passwd admin1234 \
	&& tail -f /dev/null


FROM splunkenterprise AS master
COPY config/master/bootstrap.py /tmp

FROM splunkenterprise AS sh_de
COPY config/sh/bootstrap.py /tmp

FROM splunkenterprise AS idx_de
COPY inputs.conf etc/system/local/
COPY config/idx/bootstrap.py /tmp

FROM splunkenterprise AS hf
COPY inputs.conf etc/system/local/
COPY config/hf/bootstrap.py /tmp

FROM splunkenterprise AS idxc
COPY inputs.conf etc/system/local/
COPY config/idxc/bootstrap.py /tmp

FROM splunkenterprise AS shc
COPY config/shc/bootstrap.py /tmp

FROM splunkforwarder AS fwd
COPY config/fwd/bootstrap.py /tmp
