#!/bin/bash
if [[ $# -eq 1 ]]
then
    readonly NAME=$1
else
    echo "Name of backup required"
    exit 1
fi

conf_file=/home/giorgos/.config/rclone/rclone.conf



# Download backup by name
rclone --config="${conf_file}" copy sled_backup:stronglens01-backup/${NAME} ${NAME}

# Run tar and move to _tar directory
mkdir ${NAME}_tar
tar cjf ${NAME}.tar.gz ${NAME}
mv ${NAME}.tar.gz ${NAME}_tar/${NAME}_tar.gz

# Upload to S3 backup
rclone --config="${conf_file}" copy ${NAME}_tar sled_backup:stronglens01-backup/${NAME}_tar

# Clean up
rm -r ${NAME}
rm -r ${NAME}_tar
