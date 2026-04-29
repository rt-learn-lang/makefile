#!/bin/sh
# Build *.applescript files in a directory, or in each immediate subfolder tree of a root.
# Used by the Makefile (ex-07, ex-12) and can be run by hand.
#
#   sh build-applescript-dirs.sh one   "<title>" "<path>"
#   sh build-applescript-dirs.sh subfolders "<root_dir>"
#
# Titles, paths, and .applescript filenames may contain spaces (NUL + read -d '').
# From another target with a different root, call the subfolders (or one) subcommand
# the same way; only the root (or path) changes.

# build_applescript_dir_one <title> <path>
# Builds all *.applescript in <path> (maxdepth 1).
build_applescript_dir_one() {
	_t="$1"
	_d="$2"
	echo "Building $_t scripts..."
	find "$_d" -maxdepth 1 -type f -name '*.applescript' -print0 2>/dev/null | sort -z |
		while IFS= read -r -d '' _f; do
			_n="${_f%.applescript}"
			echo "Building $_f ($_n)"
		done
	echo "Done building $_t scripts"
	echo
}

# build_applescript_in_subfolders <root>
# For each directory under <root> (mindepth 1), if it has a .applescript, run build_applescript_dir_one.
build_applescript_in_subfolders() {
	root="$1"
	if [ ! -d "$root" ]; then
		echo "DIRECTORIES_ROOT: $root does not exist" >&2
		exit 1
	fi
	find "$root" -mindepth 1 -type d -print0 2>/dev/null | sort -z |
		while IFS= read -r -d '' p; do
			b=${p##*/}
			if find "$p" -maxdepth 1 -type f -name '*.applescript' 2>/dev/null | read -r r; then
				build_applescript_dir_one "$b" "$p"
			else
				printf 'skip %s (no *.applescript in directory)\n' "$p" >&2
			fi
		done
}

case $1 in
	one)
		shift
		build_applescript_dir_one "$1" "$2"
		;;
	subfolders)
		shift
		build_applescript_in_subfolders "$1"
		;;
	*)
		echo "Usage: $0 one <title> <path>  |  $0 subfolders <root_dir>" >&2
		exit 1
		;;
esac
