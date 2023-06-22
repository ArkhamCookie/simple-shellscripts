#!/bin/sh

usage() {
	printf "shelp print <file>\n"
	exit
}

print() {
	printf "%s\n" "$1" \
	| sed 's/},/\n\n/g' \
	| sed 's/{/\n/g' \
	| sed 's/:/: /g' \
	| sed 's/,/\n/g' \
	| tr -d "\[\]}"
}

# print "$(shellcheck -f json "$1")"

case "$1" in
	'p'|'print')
		if [ -z "$2" ]; then
			usage 'print'
		elif [ ! -r "$2" ]; then
			printf "Error: File '%s' isn't readable.\n" "$2"
			exit 2
		fi
		print "$(shellcheck -f json "$2")"
		printf "\n"
	;;
	*) usage 'print' ;;
esac
