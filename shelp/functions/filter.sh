#!/bin/sh

if [ ! "$(command -v shellcheck)" ]; then
	printf "Error: shellcheck is not installed.\n"
	exit 10
fi

usage() {
	case "$1" in
		'filter')
			printf "Usage: shelp filter <error-num> <file>\n"
		;;
	esac
	exit
}

pretty() {	
	printf "%s\n" "$1" \
	| sed 's/},/\n\n/g' \
	| sed 's/{/\n/g' \
	| sed 's/:/: /g' \
	| sed 's/,/\n/g' \
	| tr -d "\[\]}"
}

filter() {
	if [ ! -r "$3" ]; then
		printf "Error: File '%s' isn't readable.\n" "$3"
		exit 2
	fi

	output=$(
		pretty "$(shellcheck -f json "$3")" \
		| grep "\"code\": $2" -B 5 \
		| grep '"line":' \
		| tr -d "\"line\":"
	)

	# printf "%s\n" "$output"
	if [ -n "$output" ]; then
		printf "Lines: "

		printf "%s" "$output" \
		| tr "\n" "," \
		| sed 's/^ //g'

		printf "\n"
	else
		printf "Not found.\n"
	fi
}

if [ "$#" -le 2 ]; then
	usage "filter"
fi

case "$1" in
	'f'|'filter') filter "$@" ;;
	"*") usage 'filter' ;;
esac
