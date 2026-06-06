#!/bin/bash
# Wix Bookings Daily Summary - fetches all signups and calculates deltas
# Usage: ./wix-bookings-summary.sh [--quiet] [--json]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

# Load env
if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

CLIENT_ID="${WIX_CLIENT_ID:-}"
TOKEN_URL="${WIX_OAUTH_TOKEN_URL:-https://www.wixapis.com/oauth2/token}"
STATE_FILE="$SCRIPT_DIR/../memory/wix-bookings-state.json"

QUIET=false
JSON_OUT=false
for arg in "$@"; do
  case "$arg" in
    --quiet) QUIET=true ;;
    --json) JSON_OUT=true ;;
  esac
done

# --- 1. Get access token ---
if ! $QUIET; then echo "🔑 Getting Wix access token..." >&2; fi

TOKEN_RESP=$(curl -s --location "$TOKEN_URL" \
  -H 'Content-Type: application/json' \
  -d "{\"clientId\": \"$CLIENT_ID\", \"grantType\": \"anonymous\"}")

TOKEN=$(echo "$TOKEN_RESP" | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])" 2>/dev/null)
if [ -z "$TOKEN" ]; then
  echo "❌ Failed to get Wix token" >&2
  exit 1
fi

if ! $QUIET; then echo "✅ Token obtained" >&2; fi

# --- 2. Fetch all services ---
if ! $QUIET; then echo "📋 Fetching services..." >&2; fi

SERVICES=$(curl -s -X POST 'https://www.wixapis.com/bookings/v2/services/query' \
  -H 'Content-Type: application/json' \
  -H "Authorization: $TOKEN" \
  -d '{"query": {"paging": {"limit": 100}}}')

# Get visible services
VISIBLE_SERVICES=$(echo "$SERVICES" | python3 -c "
import sys,json
data = json.load(sys.stdin)
services = [s for s in data.get('services', []) if not s.get('hidden')]
for s in services:
    print(json.dumps({'id': s['id'], 'name': s['name'], 'type': s.get('type'), 'capacity': s.get('defaultCapacity', 0)}))
")

VISIBLE_COUNT=$(echo "$VISIBLE_SERVICES" | grep -c . 2>/dev/null || echo 0)

if [ "$VISIBLE_COUNT" -eq 0 ]; then
  if $JSON_OUT; then
    echo '{"services":0,"bookings":0,"total_bookings":0,"new_since_yesterday":0,"services_detail":[]}'
  else
    echo "📊 No visible courses. $($QUIET || echo 'All courses are hidden or offline.')"
  fi
  exit 0
fi

# --- 3. Fetch bookings for visible services ---
if ! $QUIET; then echo "📦 Fetching bookings..." >&2; fi

BOOKINGS=$(curl -s -X POST 'https://www.wixapis.com/bookings/v2/bookings/query' \
  -H 'Content-Type: application/json' \
  -H "Authorization: $TOKEN" \
  -d '{"query": {"paging": {"limit": 500}}}')

# --- 4. Build current state ---
NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
CURRENT_STATE=$(python3 << PYEOF
import json, sys

services_json = """$VISIBLE_SERVICES"""
bookings_json = """$BOOKINGS"""

# Parse services
services = {}
for line in services_json.strip().split('\n'):
    if line.strip():
        s = json.loads(line)
        services[s['id']] = s

# Parse bookings
bookings_data = json.loads(bookings_json)
all_bookings = bookings_data.get('bookings', [])

# Count by service
service_counts = {}
for b in all_bookings:
    sid = b.get('serviceId', '')
    if sid in services:
        service_counts[sid] = service_counts.get(sid, 0) + 1

# Build summary
summary = {
    'timestamp': '$NOW',
    'services_count': len(services),
    'total_bookings': len(all_bookings),
    'services': []
}

for sid, svc in services.items():
    count = service_counts.get(sid, 0)
    summary['services'].append({
        'id': sid,
        'name': svc['name'],
        'type': svc['type'],
        'capacity': svc['capacity'],
        'bookings': count,
        'percent': round(count / svc['capacity'] * 100, 1) if svc['capacity'] > 0 else 0
    })

print(json.dumps(summary))
PYEOF
)

# --- 5. Compare with previous state ---
NEW_SINCE_YESTERDAY=0
if [ -f "$STATE_FILE" ]; then
  PREV_TOTAL=$(python3 -c "import json; d=json.load(open('$STATE_FILE')); print(d.get('total_bookings',0))")
  NEW_SINCE_YESTERDAY=$((CURRENT_TOTAL - PREV_TOTAL))
fi

# Save current state
echo "$CURRENT_STATE" > "$STATE_FILE"

# --- Output ---
if $JSON_OUT; then
  # Add delta and output  
  echo "$CURRENT_STATE" | python3 -c "
import json,sys
d = json.load(sys.stdin)
d['new_since_yesterday'] = $NEW_SINCE_YESTERDAY
print(json.dumps(d))
"
else
  CURRENT_TOTAL=$(echo "$CURRENT_STATE" | python3 -c "import json,sys; print(json.load(sys.stdin)['total_bookings'])")
  
  echo ""
  echo "📊 Skillz Camps — Daily Booking Summary"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$(echo "$CURRENT_STATE" | python3 -c "
import json,sys
d = json.load(sys.stdin)
for s in d['services']:
    bar = '█' * int(s['percent'] / 10) + '░' * (10 - int(s['percent'] / 10))
    print(f\"  {s['name'][:45]}\")
    print(f\"    {s['bookings']}/{s['capacity']} booked ({s['percent']}%) [{bar}]\")
print()
print(f'Total: {d[\"total_bookings\"]} bookings across {d[\"services_count\"]} active courses')
")"
  if [ "$NEW_SINCE_YESTERDAY" -gt 0 ]; then
    echo "  🆕 +$NEW_SINCE_YESTERDAY new since yesterday"
  elif [ "$NEW_SINCE_YESTERDAY" -lt 0 ]; then
    echo "  ⚠️ $NEW_SINCE_YESTERDAY fewer than yesterday"
  else
    echo "  ➖ No change from yesterday"
  fi
fi