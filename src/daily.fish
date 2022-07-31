set backup "/data/automation/backup/"
set scripts "$backup/restic/"{development,documents}".bkp.fish"
set -a scripts "$backup/tar/"{development,documents}".bkp.fish"

for script in $scripts
    echo "Running: $script"
    # script &
end