#!/bin/sh

export ENVIRONMENT=$(load HIERA_ENVIRONMENT)

log_header "postInstall script for @PROJECT_NAME@..."

echo "run app started"

# UPSTART
upstart_start @PROJECT_NAME@

echo "run app completed"

# SENSU
log "Creating Sensu checks...."
check_user sensu
change_ownership sensu:sensu /opt/@PROJECT_NAME@/current/etc/sensu/conf.d/checks/@PROJECT_NAME@_check_health_http.json
change_ownership sensu:sensu /etc/sensu/conf.d/checks/@PROJECT_NAME@_check_health_http.json
change_ownership sensu:sensu /opt/@PROJECT_NAME@/current/etc/sensu/conf.d/checks/@PROJECT_NAME@_check_process.json
change_ownership sensu:sensu /etc/sensu/conf.d/checks/@PROJECT_NAME@_check_process.json
sensu_restart

#TODO: CREATE PROPER FUNCTION WHICH PARSE INPUT AND OUTPUT LINK FROM /etc/facter/facts.d/ports.yaml
log "Opening required ports...."
port_manage -i -s /opt/@PROJECT_NAME@/current/etc/facter/facts.d/ports.yaml -d /etc/facter/facts.d/ports.yaml
/sbin/iptables -A INPUT -p tcp  --match multiport --dports 1338 -j ACCEPT

# DIAMOND
log "Reloading Diamond process...."
diamond_reload

# REMOTE SYSLOG
log "Templating rsyslog configuration file...."
run_template /opt/@PROJECT_NAME@/current/etc/rsyslog.d/@PROJECT_NAME@.ctmpl       /opt/@PROJECT_NAME@/current/etc/rsyslog.d/@PROJECT_NAME@.conf

# Local SYSLOG
log "Restarting local syslog process...."
service_hup syslog

log "[${OK}]"

exit 0