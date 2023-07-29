#!/bin/bash
# Backup of Raspberry Pi systems as img files remotely from UNRAID, compresses img files and does cleanup of older backups.
# You will need the Discord.sh script saved on your UNRAID server https://github.com/fieu/discord.sh

# Declare vars and set standard value
backup_path=/mnt/user/Backups/Pi # Update to be the path on your UNRAID Sever
retention_days=14 #Set this based on how old of a backup you want to keep
date=$(date +%Y%m%d)
USERNAME=pi
HOSTS="10.0.0.4 10.0.0.5 10.0.0.6" # Update to the ip addresses of the Raspberry Pis


# Perform backup of remote Raspberry Pi
for HOSTNAME in ${HOSTS} ; do
    ssh -l ${USERNAME} ${HOSTNAME} "sudo dd if=/dev/mmcblk0 bs=1M" | dd of=${backup_path}/${HOSTNAME}.${date}.img
done

#Compress and tar backup
IMG=$(find $backup_path/*.img)

for file in $IMG; do
    # Check if files exist
    if [ -e "$file" ] ; then 
        #     # Create tar file of a single file
             tar cvzf $file.tgz $file
        #     # Remove the old file
             rm "$file"
        # fi
    fi
done

# Delete old backups for cleanup
find $backup_path/*.tgz -mtime +$retention_days -type f -delete

# Discord notification when completed.
bash /mnt/user/Backups/Scripts/discord.sh --webhook-url="ADD-DISCORD-WEBHOOK-URL-HERE" --username "Pi Backup" --title "Pi Backups Complete" --description "The backup of all Pi hosts has completed." --timestamp
