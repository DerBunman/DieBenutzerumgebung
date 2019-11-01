#!/bin/sh

inbox=$(curl -sfk --netrc-file ~/.netrc -X 'STATUS INBOX (UNSEEN)' 'imaps://nsa.bunnybase.de/INBOX' | tr -d -c "[:digit:]")

if [ "$inbox" ] && [ "$inbox" -gt 0 ]; then
    echo "$inbox"
else
    echo ""
fi
