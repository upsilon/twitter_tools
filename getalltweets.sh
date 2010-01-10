#!/bin/sh

USER_NAME=kim_upsilon
XML_FILE=${USER_NAME}.xml
LIST_FILE=${USER_NAME}.lst

opt="count=200"
append=0

if [ -e "$LIST_FILE" ]
then
  since_id=`head -n1 $LIST_FILE | sed -e 's/^\(.*\):.*/\1/'`
  opt="${opt}&since_id=${since_id}"
  mv $LIST_FILE $LIST_FILE.old
  append=1
fi

wget -O $XML_FILE "http://twitter.com/statuses/user_timeline/${XML_FILE}?${opt}"

./xml2lst.sed $XML_FILE | perl -CO -mHTML::Entities -lne 'print HTML::Entities::decode($_)' > $LIST_FILE

if [ $append -eq 1 ]
then
  cat ${LIST_FILE}.old >> ${LIST_FILE}
  rm ${LIST_FILE}.old
fi

