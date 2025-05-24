#!/usr/bin/env zsh

set -o pipefail
set -eu
# set -x

machine=$(hostname -s)
list_file="$machine/_list"


if [ ! -d "$machine" ]; then
	print "Machine directory \"$machine\" does not exists."
	exit 1
fi

if [ ! -f "$list_file" ]; then
	print "\"$list_file\" file does not exists."
	exit 1
fi

list=$(cat $list_file)
print "OK: \"$list_file\" loaded, starting backup..."
print "============================================="

for ff in $(cat $list_file)
do
	eval src=$ff
	if [ ! -e $src ]; then
		print "WARN: not found: $src"
		continue
	fi

	dir_name=$(dirname $src)
	base_name=$(basename $src)
	# remove leading slash from an absolute path,
	# e.g. "/root/.ssh" becomes "root/.ssh"
	related=$(echo $dir_name | sed s/.//1)
	target=$machine/$related
    prefix=" DIR"
	if [ -f "$src" ];then
        prefix="FILE"
		# full path for files, otherwise target directory for directories,
		# this prevents copy directory to itself during the second run.
		target=$machine/$related/$base_name
	fi

	mkdir -p $machine/$related
	cp -Rp $src $target
    print "$prefix: $src"
done
