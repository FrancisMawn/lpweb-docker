# Install craft using admin credentials defined in the .env file
./craft install \
    --interactive=0 \
    --email="$ADMIN_EMAIL" \
    --username="$ADMIN_USERNAME" \
    --password="$ADMIN_PASSWORD" \
    --language="en" > /dev/null

# Run content migrations
./craft migrate/all > /dev/null
