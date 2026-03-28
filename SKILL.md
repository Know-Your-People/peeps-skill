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

# Enclave keys — optional; used only for Dispatch API (see Appendix)
enclaves: [key1, key2, key3]
```

- **`owner`** — identifies whose dataset this is. Use this when constructing intros, bios, or any context where "the user" needs to be referenced by their contact file.
- **`enclaves`** — optional. Dispatch HTTP calls require **64-character lowercase hex** keys; placeholders like `key1` are not valid. Full outbound/inbound behavior is in **Appendix: Dispatch**.

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

- Each note starts with current date “1 Mar 2026:”
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

### Heartbeat Check

If it is not already there, ask your human if they want to add:

**Dispatch (outbound + inbound):** Follow **Appendix: Dispatch** — one poll/fetch pass per heartbeat; row removal only as specified there.

On every heartbeat, check the oldest contact file in `peeps/`, check the web with their name and location and see if any updates about the person are available. If anything significant, add to the file.

Surface proactively in DM or appropriate channel:

- "Alex mentioned job hunting last time" — relevant context resurfacing
- "You haven't connected with Basel in a while" — if user wants relationship nudges

If nothing interesting, skip.

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

Dispatch is optional — Peeps works fully without it. **Enrollment / early access:** **[peepsapp.ai](https://peepsapp.ai)** (see project README). **API base:** `https://api.peepsapp.ai`.

### OpenAPI anchor (machine truth)

**Request/response field names, path details, query parameters, status enums, SSE vs poll URLs, and HTTP error bodies** live in the spec — do not duplicate them here. Use:

**`GET https://api.peepsapp.ai/openapi.json`** (or **`/openapi.json`** on the API host if that is how it is mounted — confirm in the repo README if needed).

If you can fetch and parse OpenAPI, prefer it over this prose for anything that looks like a schema.

**If OpenAPI is unreachable:** outbound = create a dispatch job per spec, persist whatever the create response needs to **poll until terminal** (e.g. poll URL id in `dispatch-pending.md`); inbound = **list pending jobs**, then **respond** or **decline** per spec — never invent JSON keys; common mistake is putting the user’s words in a field the spec does not define.

### Client policy (not in OpenAPI)

**Local first:** search `peeps/` (grep + reads) before any Dispatch call.

**When to escalate outbound:** only if local search finds **no good match** or **only one** contact that fits **and** at least one valid enclave key exists (see **`enclaves`** above). Otherwise answer locally and, if appropriate, mention that the network can widen results after enrollment.

**Key choice:** use the **first** valid **`[0-9a-f]{64}`** key in `peepsconfig.yml` **`enclaves`** order per outbound job. One HTTP request uses one key; there is no merge-across-keys in one call unless a future policy says so.

**Owner identity:** the slug in **`owner`** (no `.md`) must be sent in the outbound create body **exactly as the OpenAPI schema names and types it** — do not guess field names from this SKILL.

**Pending row cap:** at most **3** open rows in **`dispatch-pending.md`** and at most **3** in **`dispatch-inbound.md`** — client policy only. If at cap, defer new work until a row clears.

**Heartbeat cadence:** **no tight loops.** Do outbound poll / inbound fetch **once per heartbeat** (or SSE per spec if the runtime uses that instead of repeated GETs — details in OpenAPI). Do not spin between heartbeats.

### Federation & answer presentation (UX, not schema)

- **Stub rule:** if the completed job indicates **stub** / **`answerSource: "stub"`** (exact fields per OpenAPI), **do not** phrase the answer as a live federated peer-network match — it is placeholder until real federation applies.
- **`federationLive`:** use only for **product / deployment messaging** (e.g. federation not fully live). Do not duplicate the stub rule; strength of claims comes from stub / **answerSource**, not from **`federationLive`** alone.

### Outbound — operational ledger & queue

**`dispatch-pending.md`:** append when you start an outbound job — **ISO time**, the user’s question (for your own log), and whatever identifiers / URLs the create response requires to **poll until done** (per OpenAPI). **Remove a row only on a terminal outcome:** success → show the user (apply **Stub rule**), then delete; hard failure → notify once, then delete; ambiguous → retry on the **next heartbeat**, not in a loop.

**Queue steps:** (1) first valid key; (2) respect **Pending row cap**; (3) one poll pass per heartbeat (or SSE if implemented per spec); (4) terminal removal only as above.

### Inbound — consent & operational ledger

**Consent:** draft answers **only** from **`peeps/`** files. **Never** auto-send. Show the human the draft and ask **send or discard** before calling the API to submit.

**Discard:** call the spec’s **decline** operation (optional reason in body per OpenAPI), then remove the ledger row. **Do not** only delete locally — that leaves orphaned server-side jobs.

**`dispatch-inbound.md`:** one block per job — **ISO time**, stable **job id** from the API, the asker’s question text, status (`pending_run` → `awaiting_send_confirm` → done), **draft answer**, and user decision.

**Inbound steps:** (1) fetch pending per OpenAPI on heartbeat (first valid key); (2) **`pending_run`** → local draft → **`awaiting_send_confirm`**; (3) explicit user choice; (4) **respond** or **decline** then ledger cleanup; (5) on bad keys / revoked enrollment, stop and surface once per **OpenAPI** / README guidance.
