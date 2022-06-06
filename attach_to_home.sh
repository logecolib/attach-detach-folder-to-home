# attach_to_home.sh
MY_CLOUD_FOLDER=$PWD
echo "MY_CLOUD_FOLDER $MY_CLOUD_FOLDER"
MY_HOME_FOLDER=/home/$USER
echo "MY_HOME_FOLDER $MY_HOME_FOLDER"
MY_BACKUP_ID=$(date +"%Y-%m-%dT%H:%M:%S%z")
echo "MY_BACKUP_ID $MY_BACKUP_ID"
my_excluded_entries=(".sync_journal.db", ".sync_journal.db-wal", "Temp", "local", "Downloads")
echo "my_excluded_entries $my_excluded_entries"
# enable hidden files
shopt -s dotglob
# fore each folder and file at Personal folder
for my_path in $MY_CLOUD_FOLDER/Personal/*; do
    # get the entry folder or file name ... use replace instead!!!!
    my_entry=${my_path/$MY_CLOUD_FOLDER\/Personal/""}
    my_entry=${my_entry%/}
    my_entry=${my_entry/\//}
    echo "my_entry $my_entry"
    # if entry not excluded
    if [[ ! "${my_excluded_entries[*]}" =~ "${my_entry}" ]]; then
        echo "my_path " $my_path
        # check if is folder
        if [[ -d $my_path ]]; then
            echo "processing directory"
            # create the folder at home if not exists
            mkdir -p "$MY_HOME_FOLDER/$my_entry/"
            # if folder at home is not symlink
            if [[ -L "$MY_HOME_FOLDER/$my_entry" ]]; then
                if [[ -e "$MY_HOME_FOLDER/$my_entry" ]]; then
                echo "$MY_HOME_FOLDER/$my_entry is a link, skipping"
                fi
            else
                # create a backup of the folder at home
                my_backup_folder="$MY_CLOUD_FOLDER/Personal/Backups/home/$MY_BACKUP_ID/$my_entry/"
                echo "creating $my_backup_folder"
                mkdir -p "$my_backup_folder"
                # rsync recursively folder at home into backup
                rsync -avrh "$MY_HOME_FOLDER/$my_entry/" "$my_backup_folder"
                # rsync recursively folder at home into Personal folder, skipping existing files
                rsync --ignore-existing -avrh "$MY_HOME_FOLDER/$my_entry/" "$MY_CLOUD_FOLDER/Personal/$my_entry/"
                # empty the folder at home
                rm -rf "$MY_HOME_FOLDER/$my_entry/"
                # symlink Personal folder entry into home
                ln -s "$MY_CLOUD_FOLDER/Personal/$my_entry/" "$MY_HOME_FOLDER/."
            fi
        # check if is file
        elif [[ -f $my_path ]]; then
            echo "processing file"
            # check if not symlink
            if [[ -L "$MY_HOME_FOLDER/$my_entry" ]]; then
                if [[ -e "$MY_HOME_FOLDER/$my_entry" ]]; then
                    echo "$MY_HOME_FOLDER/$my_entry is a link, skipping"
                fi
            else
                # create a backup of the file
                my_backup_folder="$MY_CLOUD_FOLDER/Personal/Backups/home/$MY_BACKUP_ID/"
                echo "creating $my_backup_folder"
                mkdir -p "$my_backup_folder"
                cp "$MY_HOME_FOLDER/$my_entry" "$my_backup_folder$my_entry"
                # delete file at home
                rm "$MY_HOME_FOLDER/$my_entry"
                # symlink file from Personal into home
                ln -s "$MY_CLOUD_FOLDER/Personal/$my_entry" "$MY_HOME_FOLDER/."
            fi
        fi

    fi
done
shopt -u dotglob # disable hidden files