#!/bin/sh

log_header "uninstalling @PROJECT_NAME@"

# UPSTART
upstart_stop @PROJECT_NAME@


exit 0