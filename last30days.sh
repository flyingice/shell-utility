#!/usr/bin/env bash

if [ -z "$TOPICS" ]; then
    echo "Error: TOPICS is not set" >&2
    exit 1
fi

IFS=',' read -ra topics <<< "$TOPICS"
topic=${topics[$((RANDOM % ${#topics[@]}))]}

if [ -z "$DISCORD_WEBHOOK_URL" ]; then
    echo "Error: DISCORD_WEBHOOK_URL is not set" >&2
    exit 1
fi

echo "Researching: $topic"
result=$(claude -p "/last30days $topic --days=1 --agent --include-web" --output-format text)

# Truncate everything after the first ---
result=$(echo "$result" | sed '/^---$/,$d')

# Split and send in chunks (Discord has a 2000 char limit per message)
limit=1800
offset=0
total=${#result}

while [ $offset -lt $total ]; do
    chunk="${result:$offset:$limit}"
    curl -s -H "Content-Type: application/json" \
        -d "$(jq -n --arg content "$chunk" '{content: $content}')" \
        "$DISCORD_WEBHOOK_URL"
    offset=$((offset + limit))
    # Rate limit: Discord allows 5 requests per 2 seconds
    sleep 1
done

echo "Sent to Discord ($(( (total + limit - 1) / limit )) messages)"
