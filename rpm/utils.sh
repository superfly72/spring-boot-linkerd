#!/bin/sh

NO_COLOR='\x1b[0m'
OK_COLOR='\x1b[32;01m'
ERROR_COLOR='\x1b[31;01m'
WARN_COLOR='\x1b[33;01m'
OK=${OK_COLOR}OK${NO_COLOR}
ERROR=${ERROR_COLOR}FAILED${NO_COLOR}
WARN=${WARN_COLOR}WARNING${NO_COLOR}


log_header()        { /bin/echo -e "> $*"; }
log()               { /bin/echo -e "  $*"; }
warn()              { log "${WARN_COLOR}${1}${NO_COLOR}"; }
die()               { log "${ERROR_COLOR}${1}${NO_COLOR}"; log "[${ERROR}]"; exit 111; }
load()              { /bin/echo $(/bin/cat "/opt/env.d/$1" 2>/dev/null) | /usr/bin/tr -d '\r\n' 2>/dev/null; }
run_template()      { /opt/consul/bin/consul-template -template=$1:$2 -once >/dev/null 2>&1; [ $? -eq 0 ] || die "error: failed to run template: $1"; }
create_link()       { /bin/ln -snf $1 $2; [ $? -eq 0 ] || die "error: failed to link file: $2 -> $1"; }
change_ownership()  { /bin/chown -h $1 $2 >/dev/null 2>&1; [ $? -eq 0 ] || warn "warning: failed to change ownership on: $2"; }
change_permission() { /bin/chmod $1 $2 >/dev/null 2>&1; [ $? -eq 0 ] || warn "warning: failed to change permission on: $2"; }
create_directory()  { /bin/mkdir -p $1 >/dev/null 2>&1; [ $? -eq 0 ] || die "error: failed to create directory: $1"; }
check_user()        { /usr/bin/id -u "$1" >/dev/null 2>&1; [ $? -eq 0 ] || warn "warning: missing local account: $1"; }
delete_file()       { /bin/rm -rf $1; [ $? -eq 0 ] || warn "warning: failed to remove directory: $1"; }
diamond_reload()    { /etc/init.d/diamond stop && /etc/init.d/diamond start >/dev/null 2>&1; [ $? -eq 0 ] || warn "warning: failed to restart diamond"; }
port_manage()       { /usr/local/bin/portmanage "$@"; [ $? -eq 0 ] || die "error: port manage failed"; }
sensu_restart()     { /etc/init.d/sensu-client restart >/dev/null 2>&1; [ $? -eq 0 ] || warn "warning: failed to restart sensu"; }
service_restart()   { /sbin/service $1 restart >/dev/null 2>&1; [ $? -eq 0 ] || warn "warning: $1 restart failed - please check log files."; }
service_reload()    { /sbin/service $1 reload >/dev/null 2>&1; [ $? -eq 0 ] || warn "warning: $1 reload failed - please check log files."; }
service_hup()       { /bin/kill -HUP $(/usr/bin/pgrep $1) >/dev/null 2>&1; [ $? -eq 0 ] || warn "warning: $1 HUP failed - please check log files."; }
upstart_start()     { /sbin/initctl reload-configuration && /sbin/start $1 >/dev/null 2>&1; [ $? -eq 0 ] || warn "warning: $1 start failed - please check log files.";}
upstart_stop()      { /sbin/status $1 >/dev/null 2>&1; [ $? -ne 0 ] || /sbin/stop $1 >/dev/null 2>&1;}
add_sensu_check()   {
  check_user sensu
  change_ownership sensu:sensu /etc/sensu/conf.d/checks/$1.json
}

export ENVIRONMENT=$(load HIERA_ENVIRONMENT)
export NAME=@PROJECT_NAME@
