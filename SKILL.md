---
name: Peeps
description: Private people intelligence — track who you know, what they're good at, and who should meet who. Built for finding the right person at the right time. Use when adding people contacts or searching your network by skill or interest, considering introductions.
metadata: { "openclaw": { "emoji": "👥", "os": ["linux", "darwin", "win32"] } }
---

## Data Location

All contact files live in `~/.openclaw/workspace/peeps/` - inside the workspace. On first use, create it: `mkdir -p ~/.openclaw/workspace/peeps/`

## Owner self-entry

The owner's own contact file (slug derived from `peepsconfig.yml` `owner` field without .md) is intentional — it's used as a reference profile for crafting introductions, bios, and context when introducing the user to others.

## Actions File

`~/.openclaw/workspace/peeps/actions.md` — the pending actions queue. Check this during morning briefings.

- **Catch-ups:** people `owner` wants to reconnect with. Add when he says "we should catch up with David" or similar.
- **Introductions:** intros to facilitate. Always include a pre-generated draft intro message (using `owner` and both contact files for context). Format: `Person A → Person B — reason` followed by the intro text as a plain indented paragraph (no "Draft:" label, no quotes, no formatting).
- Move completed items to `## Completed` with a date.
- Keep it short — if it's not actionable, it shouldn't be here.

### Housekeeping (run automatically when reading actions.md)

To keep context lean as the file grows:

- **Completed items:** delete after 3 days
- **Completed section:** rolling 7-day window — anything older than 7 days is removed
- **Stale catch-ups:** if a pending catch-up has been sitting for 10+ days with no update, move it to Completed as "(not pursued)" with today's date
- **Pending intros:** keep until explicitly marked done or cancelled — intro intent doesn't expire
- Apply this cleanup silently on every read. No need to announce.

## Dataset Config — `peepsconfig.yml`

`~/.openclaw/workspace/peeps/peepsconfig.yml` is the dataset config file. Read it at the start of any session involving this skill.

```yaml
owner: jane-smith # slug of the owner's contact file (without .md)

# Enclave is optional — only needed if you join dispatch.peepsapp.ai
enclaves: []
endpoint: null
```

- **`owner`** — identifies whose dataset this is. Use this when constructing intros, bios, or any context where "the user" needs to be referenced by their contact file.
- **`enclaves`** — optional. Only relevant if the user has joined a Peeps Dispatch at dispatch.peepsapp.ai

### Dispatch — Extent you reach

The dispatch is an opt-in feature. The skill works fully without it.

If the user has joined a Peeps Dispatch (dispatch.peepsapp.ai), the dispatch allows querying trussted friends AIs. All of this is optional, consensual, and revocable.

## Core Behavior

- User mentions a person → check if people contact exists, search the web if it is not, offer to create/update
- User asks "who do I know in [domain/skill/location]?" → search by acumen, interests, location
- User asks about someone → surface insights from their file with relevant context
- User wants to make an intro → draft it using both contact files + owner profile

## When User Mentions Someone

- "Had coffee with Maria" → ask if any updates from her, update if anything important
- "John's daughter is Sofia" → add to personal details
- "Sarah loves hiking" → add to interests/notes

## Creating a New Contact — Search First, Then Ask

Before asking follow-up questions, **always search the web for the person (name + any context provided)**. Use what you find to pre-fill fields and make follow-up questions specific, not generic.

Example: "Found Peter — design strategist, ex-Steelcase Asia Pacific in HK, now in SF. How do you know him, and is he open to intros?"

## Follow-Up Questions

After searching web and pre-filling what you can, ask about the gaps:

1. **What they really good at?** - Acumen clarificaiton
2. **Relationship closeness** — How close are you?
3. **How open to intos?** — Is this person open to being introduced to others?
4. **How you know them** — if not already provided
5. **Interests** — hobbies, sports, lifestyle?

Ask these as a short grouped follow-up (not one by one). Skip any that were already answered in the original message.

## Contact Structure

- One Markdown file per person like: `maria-garcia.md`

### Fields

```markdown
# Full Name (nickname or any naming note in brackets)

- **Pronouns:** guess, if unclear - ask
- **LinkedIn:** link to LinkedIn search web for it, start with https://
- **Website:** personal or company website if you found any, star with https://
- **How I know them:** one sentence
- **Acumen:** skills and expertise, what person known for, based on your search + any user input
- **Relationship:** (Close / Warm / Colleague / Acquaintance / Estranged / Family)
- **Intro willingness:** (Open / Closed / Cautious / Unknown)
- **Interests:** — hobbies, sports, lifestyle, anything you found
- **Bio:** — one concise narrative paragraph based on your search and user input about them

## Notes

1 Mar 2026: note details

## Private Notes

1 Mar 2026: private note detials

## Contacts

Mobile:
Email:
Instagram:
etc.
```

## Notes

- Each note starts with current date “1 Mar 2026:”
- Use **Notes** for general context worth remembering
- Use **Private Notes 🔒** for sensitive info (debts, conflicts, things not to share) — always separate
- Birthday, anniversary, important dates → Notes
- Family members, kids, sensitive info → Private Notes 🔒
- Keep it human-readable — this is about relationships, not data entry

## Logging Interactions

Update the person's Notes with whatever is worth remembering long-term. If it's not worth keeping, don't write it down.

Examples:

- "Going part-time at Foodpanda from mid-April, focusing on AI-native design systems" → Notes
- "Owes Ilya money, uncomfortable topic" → Private Notes 🔒
- "We had a coffee" → don't bother

## Progressive Enhancement

- Start by creating contacts as they come up naturally
- Enrich over time: add acumen, interests, intro willingness as you learn more
- Capture details during conversations — don't wait for a "data entry session"
- Ask about anyone mentioned in conversation and suggest to add them

## Heartbeat Check

If it is not already there, ask you human if they want to add:

On every heartbeat, check the oldest contact file in `peeps/`, check the web with their name and location and see if any updates about the person available. If anything significant add to the file.

Surface proactivly in DM or appropriate channel:

- "Alex mentioned job hunting last time" — relevant context resurfacing
- "You haven't connected with Basel in a while" — if user wants relationship nudges

If nothing intersting skip.

## Details Worth Remembering

- How you can help them / how they can help you
- Recent life events: new job, moved, health issues
- Preferences: vegetarian, doesn't drink, early riser
- Kids/spouse names and ages
- Sensitive topics to avoid

## What NOT To Suggest

- Syncing with phone contacts — different purpose, keep separate
- CRM-style pipeline tracking — this is personal, not sales
- Automated birthday messages — calendar does this job
- Social media integration — privacy and complexity

## Folder Structure

```
~/.openclaw/workspace/peeps/
├── maria-garcia.md
├── john-smith.md
└── deceased/         # for people who have passed
```

All contact files live directly in `~/.openclaw/workspace/peeps/`. Move people who passed to `deceased/`.

## Search and Retrieval

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
