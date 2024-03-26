#!/bin/bash
####################################
#
# Backup up and compression of appdata folder on UNRAID.
# You will need the Discord.sh script saved on your UNRAID server https://github.com/fieu/discord.sh
#
####################################

# Varibles sprinkled in the script
day=$(date +%F)
hostname=$(hostname -s)
archive_file="$hostname-appdata-$day.tgz" #What you want the file to be named
dest="/mnt/user/Backups/Docker/$day" #First save location for rsync
dest2="/mnt/user/Backups/Docker" #Main location used for tar compression of rsync folder

# Find and remove backups/files older than 30 days.
echo "Cleaning up 30+ day old backups from $dest2"
find $dest2 -mtime +30 -exec rm {} \;

#Copy appdata folder and skip Plex so it does not hold up other container folders
echo "Starting backup of appdata folder"
rsync -auh --exclude 'Plex-Media-Server' /mnt/user/appdata/* $dest
echo "Backup of appdata folder complete"
sleep 3

# Copy Plex folder but exclude cache since that is data can be rebuilt after a restore
echo "Starting backup of Plex-Media-Server"
rsync -auh --exclude 'Library/Application Support/Plex Media Server/Cache' /mnt/user/appdata/Plex-Media-Server $dest
echo "Backup of Plex-Media-Server complete"
sleep 3

# Compress backed up data
echo "Starting tar balling appdata folder"
tar czf $dest2/$archive_file $dest2/$day
echo "Tar balling of appdata folder complete"

# Clean up temp folder
echo "Removing temp folder $dest2/$day"
rm -rf $dest2/$day

# Send Discord alert
echo "Backup completed of appdata"
bash /mnt/user/Backups/Scripts/discord.sh --webhook-url="ADD-DISCORD-WEBHOOK-URL-HERE" --username "APPDATA Backup" --title "$HOSTNAME APPDATA Backup Complete" --description "The backup of appdata on $HOSTNAME has completed." --timestamp
