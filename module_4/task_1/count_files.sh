#! /usr/bin/env bash
# uncomment line below to go recursively deep. But it may lag in case deep tree of dirs is encountered
# shopt -s globstar
usage() { echo "Usage: $0 path_to_directory" 1>&2; exit 1; }

directory=$1

if [[ ! -d $directory ]]; then
  echo
  echo "$directory is not a directory"
  usage
  exit 1;
fi

dir_paths=( $directory $directory/**/ )

for dirpath in "${dir_paths[@]}"; do
  declare -i file_count=0;
  while read file;
  do
    ((file_count++))
  done <<< $(ls -l $dirpath | grep "^-")

  echo "Directory: $dirpath has $file_count files"
done;
