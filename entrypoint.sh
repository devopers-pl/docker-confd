#!/bin/sh
export CONFD_ARGS="${CONFD_ARGS:--onetime -backend env}"
/bin/confd ${CONFD_ARGS} &
exec /usr/bin/env "$@"

