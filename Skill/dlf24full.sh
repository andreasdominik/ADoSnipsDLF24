#!/bin/bash -xv
#
# Get rss-feed from DLF24 and converts it to JSON
#
NUM=$1
shift
LINK=$@

HTML="dlf_${NUM}.html"
TXT="dlf_${NUM}.txt"

# get:
curl $LINK -o $HTML

# extract text only:
cat $HTML | tr '\n' ' ' | \
  grep -Po '(?<=<meta property="og:description" content=").*?(?=">)' \
  > $TXT
