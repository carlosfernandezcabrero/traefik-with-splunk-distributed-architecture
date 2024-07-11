FROM centos:centos7 as splunkenterprise-base

WORKDIR /tmp
COPY scripts/fix_mirror_error.sh .
COPY scripts/download_splunk.sh .
COPY scripts/clean_system.sh .

WORKDIR /usr/local
RUN chmod +x /tmp/fix_mirror_error.sh && /tmp/fix_mirror_error.sh \
	&& chmod +x /tmp/download_splunk.sh && /tmp/download_splunk.sh "splunk/releases/7.3.6/linux/splunk-7.3.6-47d8552a4d84-Linux-x86_64.tgz" \
	&& chmod +x /tmp/clean_system.sh && /tmp/clean_system.sh

FROM centos:centos7 as splunkforwarder-base

WORKDIR /tmp
COPY scripts/fix_mirror_error.sh .
COPY scripts/download_splunk.sh .
COPY scripts/clean_system.sh .

WORKDIR /usr/local	
RUN chmod +x /tmp/fix_mirror_error.sh && /tmp/fix_mirror_error.sh \
	&& chmod +x /tmp/download_splunk.sh && /tmp/download_splunk.sh "universalforwarder/releases/7.3.6/linux/splunkforwarder-7.3.6-47d8552a4d84-Linux-x86_64.tgz" \
	&& chmod +x /tmp/clean_system.sh && /tmp/clean_system.sh

FROM centos:centos7 as splunkenterprise
ENV SPLUNK_HOME=/usr/local/splunk

WORKDIR /tmp
COPY scripts/fix_mirror_error.sh .
COPY scripts/clean_system.sh .
RUN	chmod +x fix_mirror_error.sh && ./fix_mirror_error.sh \
	&& yum install -y python-jinja2 \
	&& chmod +x /tmp/clean_system.sh && /tmp/clean_system.sh

WORKDIR /usr/local/splunk
COPY --from=splunkenterprise-base /usr/local/splunk .
COPY splunk-launch.enterprise.conf etc/splunk-launch.conf
COPY Splunk.License ./etc/licenses/enterprise/Splunk.License.lic

CMD python /tmp/bootstrap.py \
	&& ./bin/splunk start --answer-yes --accept-license --no-prompt --seed-passwd admin1234 \
	&& tail -f /dev/null

FROM centos:centos7 as splunkforwarder
ENV SPLUNK_HOME=/usr/local/splunkforwarder

WORKDIR /tmp
COPY scripts/fix_mirror_error.sh .
COPY scripts/clean_system.sh .
RUN chmod +x fix_mirror_error.sh && ./fix_mirror_error.sh \
	&& yum install -y python-jinja2 \
	&& chmod +x /tmp/clean_system.sh && /tmp/clean_system.sh

WORKDIR /usr/local/splunkforwarder
COPY --from=splunkforwarder-base /usr/local/splunkforwarder .
COPY splunk-launch.forwarder.conf etc/splunk-launch.conf

CMD python /tmp/bootstrap.py \
	&& ./bin/splunk start --answer-yes --accept-license --no-prompt --seed-passwd admin1234 \
	&& tail -f /dev/null

FROM splunkenterprise as master
COPY config/master/bootstrap.py /tmp

FROM splunkenterprise as sh_de
COPY config/sh/bootstrap.py /tmp

FROM splunkenterprise as idx_de
COPY inputs.conf etc/system/local/
COPY config/idx/bootstrap.py /tmp

FROM splunkenterprise as hf
COPY inputs.conf etc/system/local/
COPY config/hf/bootstrap.py /tmp

FROM splunkenterprise as idxc
COPY inputs.conf etc/system/local/
COPY config/idxc/bootstrap.py /tmp

FROM splunkenterprise as shc
COPY config/shc/bootstrap.py /tmp

FROM splunkforwarder as fwd
COPY config/fwd/bootstrap.py /tmp
