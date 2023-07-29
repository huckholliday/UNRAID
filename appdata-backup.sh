####################################
#
# Backup up and compression of appdata.
# You will need the Discord.sh script saved on your UNRAID server https://github.com/fieu/discord.sh
#
####################################

# Varibles sprinkled in the script
day=$(date +%F)
hostname=$(hostname -s)
archive_file="$hostname-appdata-$day.tgz"

# Folder locations
dest="/mnt/user/Backups/Docker/$day"
dest2="/mnt/user/Backups/Docker"

# Clean up messsage.
echo "Cleaning up 14+ day old backups from $dest2"
date
echo

# Find and remove backups/files older than 30 days.
#find $dest2 -mtime +14 -exec rm {} \;

rsync -auhv --exclude 'Plex-Media-Server' /mnt/user/appdata/* $dest
echo "appdata folder backup excluding PMS and InfluxDB complete"
echo
date
sleep 3

rsync -auhv --exclude 'Library/Application Support/Plex Media Server/Cache' /mnt/user/appdata/Plex-Media-Server $dest
echo "Plex backup complete"
echo
date
sleep 3

echo
echo "tar balling appdata folder"
date
echo

# Compress backed up data
tar cvzf $dest2/$archive_file $dest2/$day

# Print clean up status message.
echo
echo "Removing temp folder $dest2/$day"
date
echo

# Clean up temp folder
rm -rf $dest2/$day

# Print end status message.
echo
echo "Backup completed of appdata"
date
date

# Send Discord alert
# https://github.com/fieu/discord.sh
bash /mnt/user/Backups/Scripts/discord.sh --webhook-url="ADD-DISCORD-WEBHOOK-URL-HERE" --username "APPDATA Backup" --title "$HOSTNAME APPDATA Backup Complete" --description "The backup of appdata on $HOSTNAME has completed." --timestamp
