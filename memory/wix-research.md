# Wix Setup Change to Allow Event Data Access — Research Notes

## How Wix Auth Actually Works (from live testing)

There are 2 separate auth systems:

### 1. API Keys (IST format)
- Generated from Wix Dashboard → Settings → API Keys
- Account-level only — no site-level distinction available in the UI
- Even "All site permissions" doesn't give access to Orders endpoints
- Wix Bookings catalogue works, but orders/sales return 401/403
- **Verdict: Cannot access order/signup data with API keys**

### 2. OAuth (Headless clients)
- Generated from Wix Dashboard → Settings → Headless Settings → Create client
- `grantType: "anonymous"` — works for public catalogue data only
- `grantType: "client_credentials"` — would work for orders, but needs a client secret
- The Wix Headless UI does NOT expose a "Generate Secret" button for OAuth apps
- **Verdict: Anonymous OAuth can't access orders; client_credentials unavailable**

## What We Could Access
- ✅ Bookings Services (50 courses, 5 visible)
- ✅ Wix Events (6 test events, all cancelled)
- ❌ Bookings with participant/order data (always returns 0)
- ❌ Stores Orders (403 Forbidden on every endpoint)
- ❌ Sessions (404 Not Found)

## The Real Answer

Wix's REST APIs use three different auth methods, and they're not all accessible to external tools:

1. **Wix REST API** → Uses OAuth 2.0 with client_credentials grant → needs a client secret that Wix Headless doesn't expose
2. **Wix SDK (JavaScript)** → Uses site visitor/member tokens → needs a Wix site with the JS SDK installed
3. **Wix Automations** → Webhooks triggered by Wix events → easiest approach for external tools

## Recommended Path Forward

**Option A: Wix Automations (Easiest)**
- Wix Dashboard → Automations → Create Automation
- Trigger: "New booking" or "New order"
- Action: "Send webhook" → point to a URL we host
- No API auth needed — Wix pushes data to us
- Set up once and forget

**Option B: Wix Velo (backend code)**
- Wix Dashboard → Dev Mode → Turn on Velo
- Write a small backend function that exposes booking data via HTTP endpoint
- Can query the internal Wix database directly
- More powerful but requires coding inside Wix

**Option C: CSV Export (quickest to test)**
- Wix Dashboard → Booking Services → Export
- Manual but works immediately
- Good for proving the daily summary workflow works before wiring up automation

## What Liam Should Do

Pick one:
1. Set up Wix Automations webhook → fastest to real data
2. Export CSV of current bookings → test the summary workflow right now
3. Enable Wix Velo → more flexible long-term