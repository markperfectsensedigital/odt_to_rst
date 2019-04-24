#!/bin/bash

if [ "$#" -lt 1 ]; then
  echo -e "Usage: convertit.sh path_to_writer_file.odt"
  exit
fi

if [ ! -e $1 ]; 
    then echo "File does not exist, try again."
    exit
fi

echo "Unzipping..."
unzip -o -d /tmp/ $1
echo "Extracting style info..."
saxon -s:/tmp/styles.xml -xsl:get_list_styles.xsl -o:/tmp/numberedlists.txt
echo "Converting..."
saxon -s:/tmp/content.xml  -xsl:transform.xsl -o:/tmp/output.rst numberedlists=`cat /tmp/numberedlists.txt`
echo "All done! rST file is at /tmp/output.rst"