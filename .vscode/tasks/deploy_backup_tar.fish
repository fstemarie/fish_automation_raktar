#! /usr/bin/fish
# This script will deploy the backup scripts.

set dst /data/automation/backup/tar
set s (basename (status current-filename))

if test ! -d "$dst"
    echo "$s -- Creating non existing destination"
    mkdir -p $dst
    if test $status -ne 0
        echo "$s -- Error while creating destination. Unable to proceed..."
        exit
    end
end

echo "$s -- Copying backup scripts to destination"
cp --remove-destination ./src/backup/tar/* $dst
if test $status -ne 0
    echo "$s -- Error while copying backup scripts"
    exit
end

set dst /data/automation/
echo "$s -- Copying scheduled scripts to destination"
cp --remove-destination ./src/*.fish $dst
if test $status -ne 0
    echo "$s -- Error while copying scheduled scripts"
    exit
end

echo "$s -- Scripts copied successfully"
