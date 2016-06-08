#!/usr/bin/env bash

get_talk_links()
{
    start=$1
    end=$2
    for year in $(seq $start $end)
    do
        for month in 04 10
        do
            url="https://www.lds.org/general-conference/${year}/${month}?lang=eng"
            filename="${year}-${month}.html"
            curl $url \
                | grep lumen-tile__link \
                | grep 'a href' \
                | grep -v '/media/' \
                | perl -ne 'm/href="\/general-conference\/([^"]+)"/ and print "$1\n"' \
                | sed 's/&#x3D;/=/'
        done
    done
}

get_talks()
{
    talklinks=$1
    talkdir=$2
    mkdir -p $talkdir
    while read line
    do
        url="https://www.lds.org/general-conference/$line"
        filename=$(echo $line | tr '/' '-' | sed 's/?lang=eng/.html/')
        curl -L --connect-timeout 60 --retry 4 $url > $talkdir/$filename
    done < $talklinks
}

parse_talk()
{
    speaker=$(< $1 perl -ne 'm/meta name="author" content="([^"]+)"/ and print "$1\n"')
    title=$(< $1 perl -ne 'm/<h1 class="title"><div>([^\<]+)/ and print "$1\n"')
    title=$(echo $title | tr -d '“”')
    audio=$(< $1 grep source | grep mp3 | perl -ne 'm/src="([^"]+)"/ and print "$1\n"')
    year=$(echo $1 | cut -f 1 -d '-' | cut -f 2 -d '/')
    month=$(echo $1 | cut -f 2 -d '-')

    echo -e "$year\t$month\t$speaker\t$title\t$audio"
}
