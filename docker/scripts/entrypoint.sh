#!/bin/sh

python3 /usr/local/bin/data_receiver.py &
exec nginx -g "daemon off;"