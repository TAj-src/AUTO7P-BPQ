# AUTO7P-BPQ

Initial release into the wild of my auto7p server for BPQMail on the LinBPQ system

It works by exporting messages to AUTO7P to a file.
The req7p.sh scrapper picks this up, checks things and calls the auto7p.sh scripts to create the 7ples parts to import back in.
You will also need a file importer in your forwarding config of BPQMail

Add a crontab for req7p.sh (change /dev/null to /tnp/auto7p.log if you want logging)

0 1 * * * /home/<usr>/linbpq/scrips/req7p.sh > /dev/null 2>&1
