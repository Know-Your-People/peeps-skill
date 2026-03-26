---
name: Know Your People
description: Private people intelligence — track who you know, what they're good at, and who should meet who. Built for finding the right person at the right time. Use when adding people contacts or searching your network by skill or interest, considering introductions.
metadata: { "clawdbot": { "emoji": "👥", "os": ["linux", "darwin", "win32"] } }
---

## Data Location

All contact files live in `~/.clawbot/workspace/people/` - inside the workspace. On first use, create it: `mkdir -p ~/.clawbot/workspace/people/`

## Owner self-entry

The owner's own contact file (slug derived from `.peopleconfig.yml` `owner` field without .md) is intentional — it's used as a reference profile for crafting introductions, bios, and context when introducing the user to others.

## Actions File

`~/.clawbot/workspace/people/actions.md` — the pending actions queue. Check this during morning briefings.

- **Catch-ups:** people `owner` wants to reconnect with. Add when he says "we should catch up with David" or similar.
- **Introductions:** intros to facilitate. Always include a pre-generated draft intro message (using ilya-belikin.md + both contact files for context). Format: `Person A → Person B — reason` followed by the intro text as a plain indented paragraph (no "Draft:" label, no quotes, no formatting).
- Move completed items to `## Completed` with a date.
- Keep it short — if it's not actionable, it shouldn't be here.

### Housekeeping (run automatically when reading actions.md)

To keep context lean as the file grows:

- **Completed items:** delete after 3 days
- **Completed section:** rolling 7-day window — anything older than 7 days is removed
- **Stale catch-ups:** if a pending catch-up has been sitting for 10+ days with no update, move it to Completed as "(not pursued)" with today's date
- **Pending intros:** keep until explicitly marked done or cancelled — intro intent doesn't expire
- Apply this cleanup silently on every read. No need to announce.

## Dataset Config — `.peopleconfig.yml`

`~/.clawbot/workspace/people/.peopleconfig.yml` is the dataset config file. Read it at the start of any session involving this skill.

```yaml
owner: jane-smith # slug of the owner's contact file (without .md)

# Enclave is optional — only needed if you join peepsapp.ai
enclaves: []
endpoint: null
```

- **`owner`** — identifies whose dataset this is. Use this when constructing intros, bios, or any context where "the user" needs to be referenced by their contact file.
- **`enclaves`** — optional. Only relevant if the user has joined a Peeps Enclave at peepsapp.ai for network requests federation.

### Enclave — Optional Network Feature

The enclave is an opt-in feature. The skill works fully without it.

If the user has joined a Peeps Enclave (peepsapp.ai), the enclave allows federation of requests in a trusted circle and querying across the group. All of this is optional, consensual, and revocable.

## Core Behavior

- User mentions a person → check if people contact exists, offer to create/update
- User asks "who do I know in [domain/skill/location]?" → search by acumen, interests, location
- User asks about someone → surface their file with relevant context
- User wants to make an intro → draft it using both contact files + owner profile

## When User Mentions Someone

- "Had coffee with Maria" → ask if any updates from her, update if anything important
- "John's daughter is Sofia" → add to personal details
- "Sarah loves hiking" → add to interests/notes

## Creating a New Contact — Search First, Then Ask

Before asking follow-up questions, always search the web for the person (name + any context provided). Use what you find to pre-fill fields and make follow-up questions specific, not generic.

Example: "Found Peter on LinkedIn — design strategist, ex-Steelcase Asia Pacific in HK, now in SF. How do you know him, and is he open to intros?"

## Follow-Up Questions

After searching and pre-filling what you can, ask about the gaps:

1. **Relationship closeness** — How close are you? (e.g., close friend, acquaintance, professional contact, mentor)
2. **Open to introductions?** — Is this person open to being introduced to others? Any caveats?
3. **How you met** — if not already provided
4. **Interests** — hobbies, sports, lifestyle? (helps match people for non-work reasons)

Ask these as a short grouped follow-up (not one by one). Skip any that were already answered in the original message.

## Contact Structure

- One Markdown file per person like: `maria-garcia.md`
- Name first (nickname or any naming note in brackets)

### Fields

- **Pronounce:** a pronunce
- **LinkedIn:** link to LinkedIn
- **How we met:** one sentence   
- **Acumen:** skills and expertise, what person known for
- **Relationship:** (Close / Warm / Colleague / Acquaintance / Estranged / Family)
- **Intro willingness:** (Open / Closed / Unknown)
- **Interests:** — hobbies, sports, lifestyle 
- **Bio** — one concise narrative paragraph

### Notes 
- Each note starts with a date “1 Mar 2026: note details”
- Use **Notes** for general context worth remembering
- Use **Private Notes 🔒** for sensitive info (debts, conflicts, things not to share) — always separate
- Birthday, anniversary, important dates → Notes
- Family members, kids, sensitive info → Private Notes 🔒
- Keep it human-readable — this is about relationships, not data entry

## Logging Interactions

Don't create an interaction history. Instead, update the person's Notes with whatever is worth remembering long-term. If it's not worth keeping, don't write it down.

Examples:

- "Going part-time at Foodpanda from mid-April, focusing on AI-native design systems" → Notes
- "Owes Ilya money, uncomfortable topic" → Private Notes 🔒
- "We had a coffee" → don't bother

## Progressive Enhancement

- Start by creating contacts as they come up naturally
- Enrich over time: add acumen, interests, intro willingness as you learn more
- Periodically review sparse contacts and fill the gaps by asking questions
- Capture details during conversations — don't wait for a "data entry session"

## What To Surface Proactively

- "Alex mentioned job hunting last time" — relevant context resurfacing
- "You haven't connected with Basel in a while" — if user wants relationship nudges

## Details Worth Remembering

- How you can help them / how they can help you
- Kids/spouse names and ages
- Recent life events: new job, moved, health issues
- Preferences: vegetarian, doesn't drink, early riser
- Sensitive topics to avoid

## What NOT To Suggest

- Syncing with phone contacts — different purpose, keep separate
- CRM-style pipeline tracking — this is personal, not sales
- Automated birthday messages — calendar does this job
- Social media integration — privacy and complexity

## Folder Structure

```
~/.clawbot/workspace/people/
├── maria-garcia.md
├── john-smith.md
└── deceased/         # for people who have passed
```

All contact files live directly in `~/.clawbot/workspace/people/`. Move people who passed to `deceased/`.

## Search and Retrieval

Use `grep` for fast fuzzy scanning across all contact files:

```bash
# Find anyone matching a name or keyword (case-insensitive)
grep -ril "keyword" ~/.clawbot/workspace/people/

# Show matching lines with context
grep -i "keyword" ~/.clawbot/workspace/people/*.md

# Find by company
grep -ril "hsbc" ~/.clawbot/workspace/people/

# Find open-to-intro contacts
grep -rl "Intro willingness.*Open" ~/.clawbot/workspace/people/

# Full text search with filename
grep -iH "keyword" ~/.clawbot/workspace/people/*.md
```

For fuzzy/approximate matching, use `grep -i` (case-insensitive) as the first pass.
