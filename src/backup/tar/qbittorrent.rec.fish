#! /usr/bin/fish

set src "/l/backup/raktar/qbittorrent"
set dst "/data/containers/qbittorrent"
set arch (command ls -1dr $src/qbittorrent.*.tgz | head -n1)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t qbittorrent.rec.fish "Archive not found"
    echo "qbittorrent.rec.fish -- Archive not found"
    exit 1
end
echo "qbittorrent.rec.fish -- Using archive: $arch"

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t qbittorrent.rec.fish "Destination already exists"
    echo "qbittorrent.rec.fish -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "qbittorrent.rec.fish -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t qbittorrent.rec.fish "Cannot create missing destination. Exiting..."
    echo "qbittorrent.rec.fish -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
echo "qbittorrent.rec.fish -- Recovering..."
tar --extract --verbose --gzip \
    --file="$arch" \
    --directory="$dst" \
    --strip=1
if test $status -ne 0
    logger -t qbittorrent.rec.fish "Recovery unsuccessful"
    echo "qbittorrent.rec.fish -- Recovery unsuccessful"
    exit 1
end
logger -t qbittorrent.rec.fish "The recovery was successful"
echo "qbittorrent.rec.fish -- The recovery was successful"
