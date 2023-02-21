#! /usr/bin/env bash

usage() { echo "Usage: $0 [-t <1-100>]" 1>&2; exit 1; }

declare -i treshhold

while getopts :t: option; do
  case $option in
    t) treshhold=$OPTARG;;
    ?) echo "Unknown flag $OPTARG"; usage
  esac
done

if [[ -z $treshhold ]]; then
  treshhold=50;
  echo
  echo -e "No value for -t is specified \nUsing default treshhold: $treshhold"
  echo
elif [[ $treshhold -le 0 || $treshhold -ge 100 ]]; then
  echo "Invalid value for treshhold 1-100 is expected"
  exit 1;
fi

while true
  do
    df -Ph | awk 'NR>1 {print $1, $5}' | while read used_line
  do
    disk_name=$(echo $used_line | awk '{print $1}')
    used=$(echo $used_line | awk '{print $2}' | sed s/%//g)

    if [[ $used =~ ^[0-9]+$ && $used -ge $treshhold ]]; then
      echo "WARNING: disk $disk_name used $used% of disk space"
    fi
  done

  sleep 1;
done
