# detach_from_home.sh
MY_CLOUD_FOLDER=$PWD
echo "MY_CLOUD_FOLDER $MY_CLOUD_FOLDER"
MY_HOME_FOLDER=/home/$USER
echo "MY_HOME_FOLDER $MY_HOME_FOLDER"
MY_BACKUP_ID=$(date +"%Y-%m-%dT%H:%M:%S%z")
MY_TEMP_FOLDER=$MY_HOME_FOLDER/Temp/$MY_BACKUP_ID
echo "MY_TEMP_FOLDER"=$MY_TEMP_FOLDER
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
    my_home_entry=$MY_HOME_FOLDER/$my_entry
    echo "------------"
    echo "my_home_entry $my_home_entry"
    # if entry not excluded
    if [[ ! "${my_excluded_entries[*]}" =~ "${my_entry}" ]]; then
        echo "my_path " $my_path
        # check if symlink and if points to cloud folder
        if [[ -L $my_home_entry ]]; then
            echo "is symlink"
            my_link_destination=$(readlink -f "$my_home_entry")
            echo "my_link_destination $my_link_destination"
            if [[ "$my_link_destination" == *"$MY_CLOUD_FOLDER"* ]]; then
                echo "it points to cloud folder"
                my_entry_tmp=$MY_TEMP_FOLDER/$my_entry
                echo "my_entry_tmp $my_entry_tmp"
                if [[ -d "$my_link_destination" ]]; then
                    mkdir -p $my_entry_tmp
                    rsync -avrh $my_home_entry/ $my_entry_tmp/
                    rm $my_home_entry
                    mkdir $my_home_entry
                    rsync -avrh $my_entry_tmp/ $my_home_entry/
                fi
                if [[ -f "$my_link_destination" ]]; then
                    cp $my_home_entry $my_entry_tmp
                    rm $my_home_entry
                    cp $my_link_destination $my_home_entry
                fi
            fi
        fi


    fi
done
shopt -u dotglob # disable hidden files
