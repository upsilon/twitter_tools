#!/bin/sh

USER_NAME=$1
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

echo "hoge" > ${LIST_FILE}.new

page=1
opt="&${opt}"
while [ -s ${LIST_FILE}.new ]
do
  wget -O $XML_FILE "http://twitter.com/statuses/user_timeline/${XML_FILE}?page=${page}${opt}"
./xml2lst.sed $XML_FILE | perl -CO -mHTML::Entities -lne 'print HTML::Entities::decode($_)' > ${LIST_FILE}.new
  cat ${LIST_FILE}.new >> $LIST_FILE
  page=`expr $page + 1`
done

rm ${LIST_FILE}.new

if [ $append -eq 1 ]
then
  cat ${LIST_FILE}.old >> ${LIST_FILE}
  rm ${LIST_FILE}.old
fi

