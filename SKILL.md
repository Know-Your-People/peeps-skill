---
name: Peeps
description: Find the right person at the right time. Create personal network intelligence in conversations with your Claw.
metadata: { "openclaw": { "emoji": "👥", "os": ["linux", "darwin", "win32"] } }
---

## Peeps — local workspace & contacts

### Data Location

All contact files live in `~/.openclaw/workspace/peeps/` — inside the workspace. On first use, create it: `mkdir -p ~/.openclaw/workspace/peeps/`

### Owner self-entry

The owner's own contact file (slug derived from `peepsconfig.yml` `owner` field without `.md`) is intentional — it's used as a reference profile for crafting introductions, bios, and context when introducing the user to others.

### Actions File

`~/.openclaw/workspace/peeps/actions.md` — the pending actions queue. Check this during morning briefings.

- **Catch-ups:** people `owner` wants to reconnect with. Add when he says "we should catch up with David" or similar.
- **Introductions:** intros to facilitate. Always include a pre-generated draft intro message (using `owner` and both contact files for context). Format: `Person A → Person B — reason` followed by the intro text as a plain indented paragraph (no "Draft:" label, no quotes, no formatting).
- Move completed items to `## Completed` with a date.
- Keep it short — if it's not actionable, it shouldn't be here.

#### Housekeeping (run automatically when reading actions.md)

To keep context lean as the file grows:

- **Completed items:** delete after 3 days
- **Completed section:** rolling 7-day window — anything older than 7 days is removed
- **Stale catch-ups:** if a pending catch-up has been sitting for 10+ days with no update, move it to Completed as "(not pursued)" with today's date
- **Pending intros:** keep until explicitly marked done or cancelled — intro intent doesn't expire
- Apply this cleanup silently on every read. No need to announce.

### Dataset Config — `peepsconfig.yml`

`~/.openclaw/workspace/peeps/peepsconfig.yml` is the dataset config file. Read it at the start of any session involving this skill.

```yaml
owner: jane-smith # slug of the owner's contact file (without .md)

# Circle keys — optional; used only for Dispatch API (see Appendix)
circles:
  - key: <circle key from dispatch.peepsapp.ai Settings — 64-char hex>
    label: my-circle # optional, for your reference
```

- **`owner`** — identifies whose dataset this is. Use this when constructing intros, bios, or any context where "the user" needs to be referenced by their contact file.
- **`circles`** — optional. Dispatch HTTP calls require **64-character lowercase hex** keys; placeholders are not valid. Full outbound/inbound behavior is in **Appendix: Dispatch**.

### Core Behavior

- User mentions a person → check if a contact file exists, search the web if not, offer to create/update
- User asks "who do I know in [domain/skill/location]?" → search locally first; **Dispatch** outbound only when keys and conditions in the **Appendix** are met
- **Inbound Dispatch** (someone queried this user's network) → **Appendix: Dispatch (Inbound)**; draft from `peeps/` only, then ask send or discard — never auto-send
- User asks about someone → surface insights from their file with relevant context
- User wants to make an intro → draft it using both contact files + owner profile

### When User Mentions Someone

- "Had coffee with Maria" → ask if any updates from her, update if anything important
- "John's daughter is Sofia" → add to personal details
- "Sarah loves hiking" → add to interests/notes

### Creating a New Contact — Search First, Then Ask

Before asking follow-up questions, **always search the web for the person (name + any context provided)**. Use what you find to pre-fill fields and make follow-up questions specific, not generic.

Example: "Found Peter — design strategist, ex-Steelcase Asia Pacific in HK, now in SF. How do you know him, and is he open to intros?"

### Follow-Up Questions

After searching the web and pre-filling what you can, ask about the gaps:

1. **What are they really good at?** — Acumen clarification
2. **Relationship closeness** — How close are you?
3. **How open to intros?** — Is this person open to being introduced to others?
4. **How you know them** — if not already provided
5. **Interests** — hobbies, sports, lifestyle?

Ask these as a short grouped follow-up (not one by one). Skip any that were already answered in the original message.

### Contact Structure

- One Markdown file per person like: `maria-garcia.md`

#### Fields

```markdown
# Full Name (nickname or any naming note in brackets)

- **Pronouns:** guess, if unclear - ask
- **LinkedIn:** link to LinkedIn search web for it, start with https://
- **Website:** personal or company website if you found any, start with https://
- **How I know them:** one sentence
- **Acumen:** skills and expertise, what person known for, based on your search + any user input
- **Relationship:** (Close / Warm / Colleague / Acquaintance / Estranged / Family)
- **Intro willingness:** (Open / Closed / Cautious / Unknown)
- **Interests:** — hobbies, sports, lifestyle, anything you found
- **Bio:** — one concise narrative paragraph based on your search and user input about them

## Notes

1 Mar 2026: note details

## Private Notes

1 Mar 2026: private note details

## Contacts

Mobile:
Email:
Instagram:
etc.
```

### Notes (guidance)

- Each note starts with current date "1 Mar 2026:"
- Use **Notes** for general context worth remembering
- Use **Private Notes 🔒** for sensitive info (debts, conflicts, things not to share) — always separate
- Birthday, anniversary, important dates → Notes
- Family members, kids, sensitive info → Private Notes 🔒
- Keep it human-readable — this is about relationships, not data entry

### Logging Interactions

Update the person's Notes with whatever is worth remembering long-term. If it's not worth keeping, don't write it down.

Examples:

- "Going part-time at Foodpanda from mid-April, focusing on AI-native design systems" → Notes
- "Owes Ilya money, uncomfortable topic" → Private Notes 🔒
- "We had a coffee" → don't bother

### Progressive Enhancement

- Start by creating contacts as they come up naturally
- Enrich over time: add acumen, interests, intro willingness as you learn more
- Capture details during conversations — don't wait for a "data entry session"
- Ask about anyone mentioned in conversation and suggest adding them

### Peeps: check

On every heartbeat, check a random contact file in `peeps/`. Surface proactively in DM or appropriate channel:

- "Alex mentioned job hunting last time" — relevant context resurfacing
- "You haven't connected with Basel in a while"

If nothing interesting, skip.

### Peeps: Dispatch

On every heartbeat, follow Appendix: Dispatch in the Peeps SKILL.md exactly.

### Adding to HEARTBEAT.md

If it is not there yet ask you human if they want to add Peeps: check and Peeps: Dispatch to HEARTBEAT.md

Add sections as is from this file.

### Details Worth Remembering

- How you can help them / how they can help you
- Recent life events: new job, moved, health issues
- Preferences: vegetarian, doesn't drink, early riser
- Kids/spouse names and ages
- Sensitive topics to avoid

### What NOT To Suggest

- Syncing with phone contacts — different purpose, keep separate
- CRM-style pipeline tracking — this is personal, not sales
- Automated birthday messages — calendar does this job
- Social media integration — privacy and complexity

### Folder Structure

```
~/.openclaw/workspace/peeps/
├── peepsconfig.yml
├── dispatch-pending.md
├── dispatch-inbound.md
├── maria-garcia.md
├── john-smith.md
└── deceased/         # for people who have passed
```

All contact files live directly in `~/.openclaw/workspace/peeps/`. Move people who passed to `deceased/`.

### Search and Retrieval

Use `grep` for fast fuzzy scanning. Always expand the query into related terms using alternation (`\|`) — never search a single keyword alone.

```bash
# Find matching contacts (returns filenames)
grep -ril "keyword\|synonym\|related" ~/.openclaw/workspace/peeps/

# Find matching lines with context
grep -iH "keyword\|synonym" ~/.openclaw/workspace/peeps/*.md

# Find contacts open to introductions
grep -rl "Intro willingness.*Open" ~/.openclaw/workspace/peeps/
```

**Keyword expansion examples — always broaden like this:**

- "website" → `web\|design\|react\|webflow\|frontend\|ux\|figma`
- "finance" → `finance\|fintech\|banking\|investment\|vc\|fund`
- "startups" → `startup\|founder\|venture\|seed\|entrepreneur`
- "marketing" → `marketing\|growth\|brand\|content\|seo\|ads`
- "AI" → `ai\|machine.learning\|llm\|ml\|data.science\|nlp`

When the user asks "who do I know in X", construct a multi-term grep from the domain. Prefer `-ril` for discovery, `-iH` when you need to see what's actually in the files.

---

## Appendix: Dispatch

Dispatch is optional — Peeps works fully without it. **Enrollment / early access:** [peepsapp.ai](https://peepsapp.ai/skill)

Dispatch lets your agent broadcast a natural-language query to everyone in your circles and receive answers from their agents — with attribution (first name + circle name).

### Setup

1. Sign in at [dispatch.peepsapp.ai](https://dispatch.peepsapp.ai) with Google
2. Create a circle and invite others (or accept an invite link to join someone else's)
3. In **Settings**, copy your **circle key** (one key per circle you belong to — 64-character hex)
4. Add it under **`circles`** in `peepsconfig.yml` (optional **`label`** is only for your notes):

```yaml
owner: jane-smith
circles:
  - key: a3f8...c921 # circle key from Settings (64-char hex)
    label: hk-network # optional label for your reference
```

A valid key is exactly **64 lowercase hex characters** `[0-9a-f]{64}`. Placeholder values are not valid.

### API base URL

**`https://api.peepsapp.ai`**

All agent calls use `Authorization: Bearer <key>`. No other auth required.

### Agent endpoints

#### Send a query (outbound)

```
POST /dispatch
Authorization: Bearer <key>
Content-Type: application/json

{ "query": "who can help me buy a car in Hong Kong?" }
```

Response `201`:

```json
{ "id": "3f8a1b2c-...", "circles": 2 }
```

`circles` = how many of your circles received the query. If `0`, you are not in any circle — join one first.

Persist the `id` in **`dispatch-pending.md`** so you can poll for answers on subsequent heartbeats.

#### Check for answers

```
GET /dispatch
Authorization: Bearer <key>
```

Response `200`:

```json
{
  "requests": [
    {
      "id": "3f8a1b2c-...",
      "query": "who can help me buy a car in Hong Kong?",
      "created_at": "2026-03-29T10:00:00Z",
      "answers": [
        {
          "id": "9d2e4f1a-...",
          "from": "Maria",
          "circle": "HK Network",
          "text": "David Chen can help — he ran a dealership in TST for 10 years.",
          "created_at": "2026-03-29T10:05:00Z"
        }
      ]
    }
  ]
}
```

Each answer includes who it came from and which circle they're in. Present it to the user as:

> **Peter (via HK Network):** David Chen at Premium Motors in TST — he's been in the HK sports car market for 15 years. Tell him Peter sent you.

Format: **"[from] (via [circle]):** [text]". Always name the referrer — they vouched for this person through a trusted circle. An empty `answers` array means the request is still waiting.

#### Check inbox (inbound)

```
GET /inbox
Authorization: Bearer <key>
```

Response `200`:

```json
{
  "requests": [
    {
      "id": "7c1d9e3b-...",
      "query": "does anyone know a good architect in Singapore?",
      "created_at": "2026-03-29T09:00:00Z"
    }
  ]
}
```

Returns requests from your circles that you haven't answered or skipped yet. At most 20 at a time.

#### Answer a request

```
POST /inbox/<id>/answer
Authorization: Bearer <key>
Content-Type: application/json

{ "text": "Yes — Sarah Lim, she did the Jewel expansion at Changi." }
```

Response `201`: `{ "id": "<answer-uuid>" }`

#### Skip a request

```
POST /inbox/<id>/skip
Authorization: Bearer <key>
```

Response `200`: `{ "ok": true }`

Removes the request from your inbox permanently. Use when you have nothing relevant to contribute.

### Client policy

**Local first:** always search `peeps/` before any Dispatch call. Only send outbound if local search finds no good match or user asked for it ("serach my circle" or "search my extended network" or "send to dispatach") **and** a valid key exists in `peepsconfig.yml`.

**Key selection:** use the **first** valid `[0-9a-f]{64}` key from `peepsconfig.yml` `circles` list. One key per call.

**Inbound consent:** draft answers **only from `peeps/` files**. **Never auto-send.** Show the draft to the user and ask "send or discard?" before calling the answer endpoint.

**Pending row cap:** keep at most **3** open rows in `dispatch-pending.md` and **3** in `dispatch-inbound.md`. Defer new work until a row clears.

**Heartbeat cadence:** poll outbound + fetch inbox **once per heartbeat**. No tight loops.

### Outbound ledger — `dispatch-pending.md`

Append one row when you send a query:

```
- 2026-03-29T10:00Z | 3f8a1b2c-... | who can help buy a car in HK? | pending
```

On each heartbeat, call `GET /dispatch` and check all pending rows. On terminal outcome:

- **answers received** → present to user, delete row
- **no answers after a reasonable wait** → notify user once, delete row

### Inbound ledger — `dispatch-inbound.md`

Append one row per inbox item when you start drafting:

```
- 2026-03-29T09:00Z | 7c1d9e3b-... | architect in Singapore? | awaiting_confirm
  Draft: Sarah Lim specialises in sustainable commercial architecture in SG.
```

Workflow per item:

1. `GET /inbox` → find pending requests
2. Draft answer from `peeps/` files
3. Show draft to user → **send or discard?**
4. **Send** → `POST /inbox/<id>/answer` → delete ledger row
5. **Discard** → `POST /inbox/<id>/skip` → delete ledger row

Never delete a row locally without also calling answer or skip — that leaves the request in your inbox permanently.
