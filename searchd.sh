#!/bin/sh

# start searchd without exiting shell
exec searchd --nodetach "$@"
