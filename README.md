# attach-detach-folder-to-home

Using cloud files and want to make them available on multiple machines as as cloud folders?

attach_to_home.sh script creates symlinks at home pointing to your cloud folder.

detach_from_home.sh script replaces symlinks at home with the actual files if the link points to your cloud folder.

My use case:

To store files and configurations Linux uses by defaults in folders like:

```
/home/myuser/Desktop/
/home/myuser/Documents/
/home/myuser/.bashrc
/home/myuser/.profile
/home/myuser/.ssh/
/home/myuser/.vim/
/home/myuser/.config/
/home/myuser/.kde/
...
```

But I want those files at:

```
/home/myuser/cloud.mydomain.com/myuser/Personal/Desktop/
/home/myuser/cloud.mydomain.com/myuser/Personal/Documents/
/home/myuser/cloud.mydomain.com/myuser/Personal/.bashrc
...
```

Then I run the script for it to:
  - backup my current home files for each folder and file present on cloud Personal folder
  - copy current home files into cloud Personal folder
  - replace home files and folders with symlinks pointing to cloud Personal folder

Automate everything!