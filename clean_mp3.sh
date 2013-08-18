#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo -e "USAGE: $0 location";
  exit 1;
fi

##########################################################################################################
## CONFIG
##########################################################################################################

EXT="
M3U
LOG
CUE
SFV
NFO
PLS
HTML
HTM
"

IMG="
FOLDER.JPG
ALBUMARTSMALL.JPG
FRONT.JPG
COVER.JPG
"

##########################################################################################################
## CLEAN UP FILES WE DON'T WANT
##########################################################################################################

echo -e "`date`: Cleaning up unwanted files...\n"

for i in $EXT;
do
  count=`find "$1" -iname *.$i | wc -l`;
  echo -e "`date`: Removing .$i files ($count in total):"
  find "$1" -iname *.$i -exec rm -v {} \;
  echo -ne "\n"
done

##########################################################################################################
## CLEAN UP TAGS
##########################################################################################################

echo -e "`date`: Cleaning up ID3 tags...\n"

count=`find "$1" -iname *.mp3 | wc -l`;
echo -e "`date`: Cleaning out comment tags ($count in total):\n"

IFS="
"
for i in `find "$1" -iname "*.mp3"`; 
do

  dir=`dirname $i`;

  # first convert to v2.4
  echo -e "`date`: eyeD3 --no-color --to-v2.4 --remove-all-images \"$i\"\n"
  eyeD3 --no-color --to-v2.4 --remove-all-images "$i";

  # add image tag from current dir
  for j in `find $dir -maxdepth 1 -iname "*.jpg"`; 
  do
    for k in $IMG;
    do
      if [[ `basename $j | tr [:lower:] [:upper:]` = $k ]]; then
        echo -e "`date`: convert -thumbnail 150 $i \"$dir/cover_thumb.jpg\";\n"
        convert -thumbnail 150 $j "$dir/cover_thumb.jpg";
        
        echo -e "`date`: eyeD3 --add-image=\"$dir/cover_thumb.jpg:FRONT_COVER\" $i\n";
        eyeD3 --no-color --add-image="$dir/cover_thumb.jpg:FRONT_COVER" "$i";
      fi;
    done;
  done;

  cmd="eyeD3 --no-color --remove-all-lyrics --remove-all-comments --url-frame=\"WCOM:\" --user-url-frame=\"WXXX:\" --remove-frame PRIV";

  # remove all user text frames
  for l in `eyeD3 --no-color "$i" | grep "UserTextFrame" | cut -d":" -f3 | cut -d"]" -f1 | sed -e 's/^ //g'`;
  do
    cmd="$cmd --user-text-frame=\"$l:\" ";
  done

  # remove unique file ids
  for m in `eyeD3 --no-color "$i" | grep "Unique File ID" | cut -d"[" -f2 | cut -d"]" -f1 | sed -e 's/^ //g'`;
  do
    cmd="$cmd --unique-file-id=\"$m:\" ";
  done
 
  cmd="$cmd \"$i\"";
  echo -e "`date`: $cmd\n";
  eval $cmd;

  #rename -- prob only want to do this if we can verify the tags some how
  echo -e "eyeD3 --no-color --rename \"\$track:num - \$title\" \"$i\""
  eyeD3 --no-color --rename="\$track:num - \$title" "$i"

done
