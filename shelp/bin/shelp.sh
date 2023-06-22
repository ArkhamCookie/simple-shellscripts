#!/bin/sh

if [ ! "$(command -v shellcheck)" ]; then
	printf "Error: shellcheck is not installed.\n"
	exit 10
fi

if [ ! "$(command -v shellcheck)" ]; then
	printf "Error: jq is not installed.\n"
	exit 10
fi

usage() {
	case "$1" in
		'filter')
			# printf "Usage: shelp filter <error-num>\n"
			printf "Usage: shelp filter <error-num> <file>\n"
		;;
		"*")
			printf "Usage: shelp { filter | lookup }"
		;;
	esac
}

print() {
	printf "%s\n" "$1"

	printf "%s" "$1" \
	| sed 's/},/\n\n/g' \
	| sed 's/{/\n/g' \
	| sed 's/:/: /g' \
	| sed 's/,/,\n/g' \
	| tr -d "\[\]}"
}

clean() {
	printf "%s" "$1" \
	| tr -d '"' \
	| tr -d ':' \
	| tr -d ' ' \
	| tr '\n' ','
	# | tr '\n' ' '
	printf "\n"
	# | sed 's/,$/\n/g'
}

filter() {
	# printf "%s\n" "$@"
	if [ ! -r "$4" ]; then
		printf "Error: Couldn't find file '%s'\n" "$4"
		exit 3
	fi

	# output="$(shellcheck -f json "$4" | jq .)"
	output=$(print "$(shellcheck -f json "$4")")
	# printf "%s\n" "$output"

	case "$1" in
		'code')
			output=$(
			printf "%s" "$output" \
			| grep "\"code\": $3" -B 5 \
			| grep 'line' \
			| sed 's/line//g'
			)
		;;
		"*")
			output=$(
				printf "%s" "$output" \
				grep --line-number "$3"
			)
		;;
	esac

	if [ -n "$output" ]; then
		# printf "%s\n" "$output"
		clean "$output" \
		| sed 's/,,/, /g' \
		| sed 's/,$//g'
	else
		printf "Not found.\n"
	fi

	exit 0
}

[ "$#" = 0 ] && usage 'filter'

case "$1" in
	'f'|'filter')
		if [ "$2" ]; then
			filter 'code' "$@"
		elif [ -z "$2" ]; then
			usage 'filter'
		else
			printf "Error\n"
			exit 2
		fi
	;;
	'p'|'print')
		print "$(shellcheck -f json "$2")"
		printf "\n"
	;;
	"*") usage ;;
esac
