#!/bin/sh

log_header "preInstall script for @PROJECT_NAME@..."

[ -d "/opt/env.d" ] || die 'error: target environment not configured: /opt/env.d'

export ENVIRONMENT=$(load HIERA_ENVIRONMENT)

echo "environment set is: $ENVIRONMENT"

[ -z "${ENVIRONMENT}" ] && (die '$ENVIRONMENT is not defined.')

# USER
id -u @RPM_USER@ &>/dev/null || useradd @RPM_USER@

upstart_stop @PROJECT_NAME@

exit 0