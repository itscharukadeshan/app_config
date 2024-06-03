 GNU nano 7.2                                                                      ./webhook.sh                                                                               
#!/bin/bash

# Container name (replace with your actual container)
CONTAINER_NAME="watchtower"

# Webhook URL (replace with your actual Discord webhook URL)
# **IMPORTANT**: Keep this URL private
WEBHOOK_URL=""  # Don't expose the full URL

# Capture container logs (including stderr)
LOGS=$(docker logs $CONTAINER_NAME 2>&1)


# Extract image names from logs
IMAGE_NAMES=$(echo "$LOGS" | grep -o 'Found new \S\+' | cut -d' ' -f3)

# Add line numbers to the image names
IMAGE_NAMES=$(awk '{ printf "%d. %s\n", NR, $0 }' <<< "$IMAGE_NAMES")

# Build the JSON payload with image names as a list
PAYLOAD=$(jq -n --arg images "$IMAGE_NAMES" '{"content": "List of updated images:\n\n\($images)"}')

# Send the payload to the Discord webhook
curl -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "$WEBHOOK_URL"
echo "Logs sent to Discord webhook for container: $CONTAINER_NAME"












