#!/bin/bash -xv
#
# Get rss-feed from DLF24 and converts it to JSON
#
DLF24="https://www.deutschlandfunk.de/die-nachrichten.353.de.rss"
XML="dlf.xml"
JSON="dlf.json"

XML_PARSE=xmlstarlet

# get:
curl $DLF24 -o $XML

# get number of news:
N=$( $XML_PARSE select -t -v rss/channel/item/title $XML | wc -l)

# write JSON:
echo "{"                  > $JSON

KOMMA=","
for (( I=1; I<=$N; I++ )) ; do
  TITLE="$($XML_PARSE select -t -v rss/channel/item/title $XML | sed -n ${I}p | sed 's/"/ /g')"
  DATE="$($XML_PARSE select -t -v rss/channel/item/pubDate $XML | sed -n ${I}p)"
  LINK="$($XML_PARSE select -t -v rss/channel/item/link $XML | sed -n ${I}p)"
  DESCR="$($XML_PARSE select -t -v rss/channel/item/description $XML | sed -n ${I}p  | sed 's/"/ /g' | grep -o '^.*&lt;a href' | sed s'/&lt;a href//')"
  if [[ $I -eq $N ]] ; then
    KOMMA=""
  fi

  echo "    \"$I\":"                           >> $JSON
  echo "    {"                                 >> $JSON
  echo "        \"title\": \"$TITLE\","        >> $JSON
  echo "        \"date\":  \"$DATE\","         >> $JSON
  echo "        \"link\":  \"$LINK\","         >> $JSON
  echo "        \"description\": \"$DESCR\""   >> $JSON
  echo "    }$KOMMA"                           >> $JSON
done
echo "}"                                       >> $JSON
