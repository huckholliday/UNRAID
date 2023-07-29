#!/bin/bash
####################################
#
# Backup InfluxDB databases from Docker container.
# This will require you to mount a directory/volume to your InfluxDB container
# You will also need the Discord.sh script saved on your UNRAID server https://github.com/fieu/discord.sh
#
####################################

day=$(date +%F)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz" # Create archive filename.
contrainerid=$(docker ps -aqf "name=Influxdb-1.8") # Update name field if your contianer has a different name
dest=/backups/$day # This is the path mounted in your InfluxDB docker container
dest2="/mnt/user/Backups/Influx" # Local path on your UNRAID server

# Find and remove backups/files older than 14 days.
find $dest2 -mtime +14 -exec rm {} \;

# Backup the files using Influx command.
docker exec -i $contrainerid influxd backup -portable $dest

# Compress backed up data
tar czf $dest2/$archive_file $dest2/$day

# Clean up temp backup folder
rm -rf $dest2/$day


# Send Discord alert
bash /mnt/user/Backups/Scripts/discord.sh --webhook-url="ADD-DISCORD-WEBHOOK-URL-HERE" --username "InfluxDB Backup" --title "$HOSTNAME InfluxDB Backup Complete" --description "The backup of InfluxDB container on $HOSTNAME has completed." --timestamp
