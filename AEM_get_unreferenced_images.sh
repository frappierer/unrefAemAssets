#!/bin/bash

# script to get the path of all unrelated assets in AEM
# You need to install jq, php and sed
# based on https://experienceleaguecommunities.adobe.com/t5/adobe-experience-manager-assets/query-for-most-used-dam-assets-in-content/qaq-p/320629

# AEM Author URL
aemurl="http://localhost:4502"
# Path to DAM Root Folder
aemcontentpath="/content/dam/weretail"
# AEM Username
aemusername="admin"
# AEM Passwort
aempassword="admin"


# get list of assets, where /content/dam/site/folder is the folder you want to query
curl -s -u "$aemusername:$aempassword" "$aemurl/bin/querybuilder.json?path=$aemcontentpath&type=dam:Asset&p.limit=-1" > assets-in-path.json

# clean up assets-in-path.json with jq, a command line json parser. install jq via brew install jq (or similar)
# jq is the Swiss army knife of json parsing.
cat assets-in-path.json | jq '.hits[].path'|sed 's/^"//g'|sed 's/"$//g' > clean-assets-in-path.txt

# create php file to urlencode asset paths
sed 's/^/echo urlencode("/g' clean-assets-in-path.txt |sed 's/$/"),PHP_EOL;/g' > urlencode-assets-in-path.php
# add opening php script tag to the top of the urlencode-assets-in-path.php

sed -i '1s/^/<?php\n/' urlencode-assets-in-path.php
# add utf-8 encode query parameter (to the curl commands that will be constructed by below script) as the assets may contain utf-8 hex encoded strings,

# this query parameter is necessary to get accurate results back from AEM - without it, the asset will be shown to have no references when in actuality, it may have references
php urlencode-assets-in-path.php > urlencoded-assests-in-path.txt
sed 's/$/\&_charset_=utf-8/g' urlencoded-assests-in-path.txt > dam_assets.txt

# the following is a bash script that executes curl commands against the dam_assets.txt file above - save bash script as get-unreferenced.sh (chmod +x get-unreferenced.sh) and execute as ./get-unreferenced.sh dam_assets.txt

# the generated assets.txt file is overwritten for each curl command result

# when the result is empty, the unreferenced asset is written to unused_dam_assets.txt
input="dam_assets.txt"
while IFS= read -r line; do
dam_asset=$line

curl -s -u "$aemusername:$aempassword" "$aemurl/bin/wcm/references.json?path=$dam_asset" > assets.txt

grep -q '\[\]' assets.txt

if [ $? -eq 0 ]

then

  echo "$dam_asset" >> unused_dam_assets.txt
  echo "$line"

  #exit 0

fi

done < "$input"

# you may want to urldecode the unreferenced assets to view them more easily, etc. I needed to install and use gsed to do on Mac OS X:
/usr/local/bin/gsed 's/^/echo urldecode("/g' unused_dam_assets.txt |gsed 's/$/"),PHP_EOL;/g' > urldecode-unused.php
sed -i '1s/^/<?php\n/' urldecode-unused.php

php urldecode-unused.php > unrelatedassets2.txt

sed 's/&_charset_=utf-8/ /g' unrelatedassets2.txt > unrelatedassets.txt

#write html file

#needed to create direkt link to AEM
input="unrelatedassets.txt"
assetdetail="/assetdetails.html"
while IFS='' read -r LINE || [ -n "${LINE}" ]; do
	linkstart='<a href="'
	minkmid='" target="_blank">'
	linkend='</a>'
	br='<br>'
    echo "$linkstart$aemurl$assetdetail${LINE}$minkmid${LINE}$linkend$br" 
done < "$input" > unrelatedassets.html


sed -i '1s@^@<h2>Unrelated Assets in AEM</h2>\n@' unrelatedassets.html
sed -i '1s@^@<body>\n@' unrelatedassets.html
sed -i '1s@^@<html>\n@' unrelatedassets.html


# clean up cache files
rm assets-in-path.json
rm clean-assets-in-path.txt
rm urlencode-assets-in-path.php
rm urlencoded-assests-in-path.txt
rm dam_assets.txt
rm unused_dam_assets.txt
rm assets.txt
rm urldecode-unused.php
rm unrelatedassets2.txt
