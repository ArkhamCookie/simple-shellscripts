#!/bin/sh

if [ ! "$(command -v python3)" ]; then
	printf "Python3 is required but not installed.\n"
	exit 2
fi

if [ ! -d /usr/local/bin/sherlock/sherlock ]; then
	printf "Sherlock not found!\n"
	exit 2
fi
	
python3 /usr/local/bin/sherlock/sherlock "$@"
