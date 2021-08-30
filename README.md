# unrefAemAssets
The bash script will help you to get all AEM Assets which are not related to a page.

This can be helpful to delete images you don't need or just for other debugging purposes.

The outcome will be 
-   unrelatedassets.txt -> Full path of all images as text file
-   unrelatedassets.html -> HTML File with a direct link to the asset

Based on https://experienceleaguecommunities.adobe.com/t5/adobe-experience-manager-assets/query-for-most-used-dam-assets-in-content/qaq-p/320629.

# Groovy alternative
The nice thing about my solution is that it also works from the outside with AEM Admin access. If you have the possibility to install the Groovy Console, the following alternative is also interesting:

The script is based on:
https://github.com/hashimkhan786/aem-groovy-scripts/blob/master/findUnusedAssets.groovy
but i did a little modification.

I tried to install the new groovy AEM Cloud Version -> https://github.com/CID15/aem-groovy-console but i got build issues.

Trying groovy version 15.1 https://github.com/icfnext/aem-groovy-console/releases/tag/15.1.0 worked even in the latest cloud Version.

More on the groovy console: https://labs.tadigital.com/index.php/2018/12/18/groovy-script-in-aem/


## Before usage of the bash script
I am a REALLY BAD Coder (but a much better Architect), so please be nice to me. I know that there are much nicer ways to approach this problem, but it works and i had lack of time. :)

If there is anybody out there who wants to make the script nice, be my guest.

## Bash script requirements
I tried this on my mac, so maybe some changes need to be done in order to make it work on Windows etc.

You need to install *jq*, *php* and *sed*
-   jq: http://macappstore.org/jq/
-   sed: http://gridlab-d.sourceforge.net/wiki/index.php/Mac_OSX/Gsed

## Before running the bash script
Edit the first lines of the script:

-   aemurl="http://localhost:4502" -> Path to your AEM Instance
-   aemcontentpath="/content/dam/weretail" -> DAM Root Path
-   aemusername="admin" -> Admin User Name
-   aempassword="admin"-> Admin Password 

## Running the bash script
Clone the repo, cd into the folder and run

```
bash AEM_get_unreferenced_images.sh
```


