#! /usr/bin/fish

set src "/data/automation"
set dst "/l/backup/raktar/automation"
set arch "$dst/automation."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"
set log "/var/log/automation/automation.tar.log"
set nb_max 1
set dir (dirname "$src")
set base (basename "$src")

echo "


-------------------------------------
 "(date -Ins)" 
-------------------------------------
" | tee -a $log

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t automation.bkp.fish "Source folder does not exist"
    echo "automation.bkp.fish -- Source folder does not exist" | tee -a $log
    exit 1
end

# if the destination folder does not exist, create it
if test ! -d "$dst"
    echo "automation.bkp.fish -- Creating non-existent destination" | tee -a $log
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t automation.bkp.fish "Cannot create missing destination. Exiting..."
        echo "automation.bkp.fish -- Cannot create missing destination. Exiting..."
        exit 1
    end
end

echo "automation.bkp.fish -- Creating archive" | tee -a $log
tar --create --verbose --gzip \
    --file="$arch" \
    --directory="$dir" "$base"  2>&1 | tee -a $log
if test $status -ne 0
    logger -t automation.bkp.fish "Backup unsuccessful"
    echo "automation.bkp.fish -- Backup unsuccessful" | tee -a $log
    exit 1
end
logger -t automation.bkp.fish "The backup was successful"
echo "automation.bkp.fish -- The backup was successful" | tee -a $log

alias backups="command ls -1trd $dst/automation.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo "automation.bkp.fish -- Removing older archives" | tee -a $log
    backups | head -n$nb_diff | tee -a $log
    backups | head -n$nb_diff | xargs rm -f > /dev/null 
end
echo \n---------------------------------------------- | tee -a $log
