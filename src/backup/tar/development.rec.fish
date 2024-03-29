#! /usr/bin/fish

set src "/l/backup/raktar/development"
set dst "$HOME/development"
set arch (command ls -1dr $src/development.*.tgz | head -n1)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t development.rec.fish "Archive not found"
    echo "development.rec.fish -- Archive not found"
    exit 1
end
echo "development.rec.fish -- Using archive: $arch"

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
echo "development.rec.fish -- Creating non existent destination"
tar --extract --verbose --gzip \
    --file="$arch" \
    --directory="$dst" \
    --strip=1
if test $status -ne 0
    logger -t development.rec.fish "Recovery unsuccessful"
    echo "development.rec.fish -- Recovery unsuccessful"
    exit 1
end
logger -t development.rec.fish "The recovery was successful"
echo "development.rec.fish -- The recovery was successful"
