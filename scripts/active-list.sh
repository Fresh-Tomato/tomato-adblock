#!/usr/bin/env bash

file_path=$(realpath $0)
script_dir=$(dirname ${file_path})
root_dir=$(dirname ${script_dir})

cache_dir="${root_dir}/cache"

adblock_list_file='adblock-list.txt'
adblock_list_file_path="${root_dir}/${adblock_list_file}"

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

    printf -v j "%02d" $i
    
    cache_file="host-list_${j}.txt"
    cache_file_path="${cache_dir}/${cache_file}"

    # echo "cache_file_path: ${cache_file_path}"

    wget $list_url -o $cache_file_path

    ((i+=1))

    # echo ""
    
done < $adblock_list_file_path