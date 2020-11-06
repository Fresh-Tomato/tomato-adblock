#!/usr/bin/env bash

file_path=$(realpath $0)
script_dir=$(dirname ${file_path})
root_dir=$(dirname ${script_dir})

cache_dir="${root_dir}/cache"

adblock_list_file='adblock-list.txt'
adblock_list_file_path="${root_dir}/${adblock_list_file}"

adblock_bad_file='adblock-bad.txt'
adblock_bad_file_path="${root_dir}/${adblock_bad_file}"

adblock_tmp_file='adblock-tmp.txt'
adblock_tmp_file_path="${root_dir}/${adblock_tmp_file}"

i=0

while read line || [ -n "$line" ]; do

    # echo "line: $line"

    # SKIP EMPTY LINES
    if [ -z "$line" ]; then
        continue
    fi

    url_line=$(echo $line | grep -Eo '(http|https)://(.*)$')

    # SKIP LINES THAT DO NOT START WITH http/https
    if [ -z "$url_line" ]; then
        continue
    fi

    list_url=$(echo $url_line | cut -f 1 -d " ")

    if [ -z "$list_url" ]; then
        continue
    fi

    # echo "list_url: ${list_url}"
    echo "${list_url}"

    http_code=$(curl -IL --silent $list_url | grep HTTP | tail -n 1 | cut -f 2 -d " ")

    if [ $http_code != "200" ]; then

        # date_iso=$(date +"%Y-%m-%d %H:%M:%S")
        echo "${http_code}, ${list_url}" >> $adblock_tmp_file_path

    fi
    
done < $adblock_list_file_path

cat $adblock_tmp_file_path | sort | uniq > $adblock_bad_file_path