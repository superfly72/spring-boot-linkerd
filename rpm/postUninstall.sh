#!/bin/sh

log_header "running post-uninstall tasks for @PROJECT_NAME@..."

# CLEAN UP
delete_file /opt/@PROJECT_NAME@/current
delete_file /var/log/@PROJECT_NAME@


retval=$?
[ $retval -eq 0 ] && /bin/echo "  [OK]" || /bin/echo "  [FAILED]"
exit 0