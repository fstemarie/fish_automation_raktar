#! /usr/bin/fish

set dst "$HOME/development"

if test -z $RESTIC_REPOSITORY
    logger -t development.rec.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "development.rec.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit 1
end

if test -z $RESTIC_PASSWORD
    logger -t development.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "development.rec.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit 1
end

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t development.rec.fish "Destination already exists"
    echo "development.rec.fish -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "development.rec.fish -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t development.rec.fish "Cannot create missing destination. Exiting..."
    echo "development.rec.fish -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
restic restore latest \
    --host=raktar \
    --tag=development \
    --target "$dst"
if test $status -ne 0
    logger -t development.rec.fish "Could not restore snapshot"
    echo "development.rec.fish -- Could not restore snapshot"
    exit 1
end
logger -t development.rec.fish "Snapshot restoration successful"
echo "development.rec.fish -- Snapshot restoration successful"
