#!/bin/sh

FILES=*.epub
for f in $FILES
do

FILENAME=`(echo $f)|rev|cut -f2- -d'.'|rev`
FILEEXTENSION=`echo "$f" | cut -d'.' -f2-`
FILENAME_EDITED_ZIP=$FILENAME"_EDITED.zip"
FILENAME_EDITED_EPUB=$FILENAME"_EDITED.epub"
echo "Processing $FILENAME_EDITED_ZIP ......"

#make of copy of our file to .zip
cp $f $FILENAME_EDITED_ZIP

#make tmp directory and unzip the file there
mkdir tmp
mv $FILENAME_EDITED_ZIP tmp
cd tmp
unzip $FILENAME_EDITED_ZIP
rm $FILENAME_EDITED_ZIP

# remove feedbooks stuff .xml and logos
#rm OPS/feedbooks.xml
rm OPS/images/logo-feedbooks*

#edit the files to remove reference to feedbooks logos
sed --in-place 's/<div class="logo"><img src="images\/logo-feedbooks-tiny.png" alt=//p' OPS/title.xml
sed --in-place 's/"Feedbooks" title="Feedbooks" \/><\/div>//p' OPS/title.xml
sed --in-place 's/gutenberg.org/johanbrown.com/' OPS/title.xml
sed --in-place '/Published/,1d' OPS/title.xml

sed --in-place 's/<div class="logo2"><img  src="images\/logo-feedbooks.png" alt="FeedBooks" title="FeedBooks"\/><\/div>//p' OPS/feedbooks.xml
sed --in-place 's/<div class="texttitle"><b>www.feedbooks.com<\/b><\/div>//p' OPS/feedbooks.xml
sed --in-place 's/<div style="text-align: center;">Food for the mind<\/div>//p' OPS/feedbooks.xml

#edit the fp.opf reference to the feedbooks files
#sed --in-place '/<item id="feedbooks"/,+2d' OPS/fb.opf
sed --in-place '/<item id="logo-feedbooks-tiny"/,+2d' OPS/fb.opf
sed --in-place '/<item id="logo-feedbooks"/,+2d' OPS/fb.opf

#rezip the files
echo "Creating New Epub ..... $FILENAME_EDITED_EPUB"
zip -r $FILENAME_EDITED_EPUB *
mv $FILENAME_EDITED_EPUB ../

#comeout and delete the tmp directory
cd ..
rm -rf tmp

done
