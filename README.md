# unrefAemAssets
The Bash Script will help you to get all AEM Assets which are not related to a page.

This can be helpfull to delete images you dont need or just for other debugging purposes.

The outcome will be 
unrelatedassets.txt -> Full path of all images as text file
unrelatedassets.html -> HTML File with a direct link to the asset

Based on https://experienceleaguecommunities.adobe.com/t5/adobe-experience-manager-assets/query-for-most-used-dam-assets-in-content/qaq-p/320629.

## Before usage
I am a REALLY BAD Coder (but a much better Architect), so please be nice to me. I know that there are much nicer ways to approach this problem, but it works and i had lack of time. :)

If there is anybody out there who wants to make the Sript nice, be my guest.

## Requirements
I tried this on my mac, so maybe some changes need to be done in order to make it work on Windows etc.

You need to install jq, php and sed
jq: http://macappstore.org/jq/
sed: http://gridlab-d.sourceforge.net/wiki/index.php/Mac_OSX/Gsed

## Before running the script
Edit the first lines of the script:

aemurl="http://localhost:4502" -> Path to your AEM Instance
aemcontentpath="/content/dam/weretail" -> DAM Root Path
aemusername="admin" -> Admin User Name
aempassword="admin"-> Admin Password 

## Running the Script
Clone the repo, cd into the folder and run

```
bash AEM_get_unreferenced_images.sh
```


