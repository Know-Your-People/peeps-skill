---
name: Know Your People
description: Private people intelligence — track who you know, what they're good at, and who should meet who. Built for finding the right person at the right time. Use when adding contacts, logging interactions, searching your network by skill or interest, or drafting introductions.
metadata: {"clawdbot":{"emoji":"👥","os":["linux","darwin","win32"]}}
---

## Actions File
`~/people/actions.md` — the pending actions queue. Check this during morning briefings.
- **Catch-ups:** people Ilya wants to reconnect with. Add when he says "we should catch up" or similar.
- **Introductions:** intros to facilitate. Always include a pre-generated draft intro message (using ilya-belikin.md + both contact files for context). Format: `Person A → Person B — reason` followed by the intro text as a plain indented paragraph (no "Draft:" label, no quotes, no formatting).
- Move completed items to `## Completed` with a date.
- Keep it short — if it's not actionable, it shouldn't be here.

### Housekeeping (run automatically when reading actions.md)
To keep context lean as the file grows:
- **Completed items:** delete after 3 days
- **Completed section:** rolling 7-day window — anything older than 7 days is removed
- **Stale catch-ups:** if a pending catch-up has been sitting for 90+ days with no update, move it to Completed as "(not pursued)" with today's date
- **Pending intros:** keep until explicitly marked done or cancelled — intro intent doesn't expire
- Apply this cleanup silently on every read. No need to announce unless something was pruned.

## Self-Entry
The owner's own contact file (slug derived from `.peopleconfig.yml` `owner` field) is intentional — it's used as a reference profile for crafting introductions, bios, and context when introducing the user to others. Read it using the `owner` slug from config. Keep it up to date.

## Data Location
All contact files live in `~/people/` — **not** inside the workspace or skill folder.
On first use, create it: `mkdir -p ~/people/`
Keeping data outside the workspace ensures it persists across skill updates and reinstalls, and avoids mixing personal data with skill code.

## Dataset Config — `.peopleconfig.yml`
`~/people/.peopleconfig.yml` is the dataset config file. Read it at the start of any session involving this skill.

```yaml
owner: ilya-belikin       # slug of the owner's contact file (without .md)
enclave:
  id: null                # assigned by KYP cloud when registered
  api_key: null           # KYP cloud API key
  endpoint: null          # KYP cloud API endpoint
```

- **`owner`** — identifies whose dataset this is. Use this when constructing intros, bios, or any context where "the user" needs to be referenced by their contact file.
- **`enclave.*`** — KYP cloud credentials. When populated, the agent can push/pull enclave profiles and query the shared network. Until then, treat as local-only.
- If the file doesn't exist, operate in local-only mode and offer to create it.

### Enclave Profile — What Gets Synced
The enclave profile is the shareable subset of a contact file — describes the **person**, not your relationship with them.

**Shared to enclave:** Name, pronouns, location, Acumen, Interests, Bio, Intro willingness, Notes (freeform)
**Stays local:** Interaction history, Tags, Private Notes 🔒, Relationship/how you know them

### Sync Behavior
- **First sync:** always show all profiles for user audit before uploading anything. Store `last_sync` timestamp in `.peopleconfig.yml` after confirmation.
- **Ongoing:** weekly by default. Two modes set by user:
  - `review` — surface changes for approval before each sync
  - `auto` — sync without review
- **Manual push:** available on demand (e.g. after adding many contacts during active onboarding)
- Config keys in `.peopleconfig.yml`: `enclave.sync_mode` (`review`|`auto`), `enclave.last_sync` (ISO timestamp)

## Core Behavior
- User mentions a person → check if contact exists, offer to create/update
- User asks "who do I know in [domain/skill/location]?" → search by acumen, interests, location
- User asks about someone → surface their file with relevant context
- User wants to make an intro → draft it using both contact files + owner profile

## When User Mentions Someone
- "Had coffee with Maria" → log interaction, create contact if new
- "John's daughter is Sofia" → add to personal details
- "Sarah loves hiking" → add to interests/notes
- "Meeting with Tom tomorrow" → check calendar, surface Tom's context

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
- One Markdown file per person: `maria-garcia.md`
- Sections: basics, relationship, personal details, notes or private notes (not both unless needed)
- Use **Notes** for general context worth remembering
- Use **Private Notes 🔒** for sensitive info (debts, conflicts, things not to share) — always separate
- No interaction history section — it goes stale fast. Capture what matters as a note instead.
- Keep it human-readable — this is about relationships, not data entry

## Key Fields To Capture
- Name, how you met, where they work/live
- **Relationship** (Close / Warm / Colleague / Acquaintance / Estranged / Family)
- **Intro willingness** (High / Medium / Low / Unknown)
- **Interests** — hobbies, sports, lifestyle (for non-work matching: running partners, travel buddies, etc.)
- **Acumen** — skills and expertise (for work/project matching)
- **Bio** — one concise narrative paragraph
- Birthday, anniversary, important dates → Notes
- Family members, kids, sensitive info → Private Notes 🔒

## Logging Interactions
Don't create an interaction history. Instead, update the person's Notes with whatever is worth remembering long-term. If it's not worth keeping, don't write it down.

Examples:
- "Going part-time at Goodnotes from mid-April, focusing on AI-native design systems" → Notes
- "Owes Ilya money, uncomfortable topic" → Private Notes 🔒
- "We had coffee" → don't bother

## Progressive Enhancement
- Start by creating contacts as they come up naturally
- Enrich over time: add acumen, interests, intro willingness as you learn more
- Periodically review sparse contacts and fill gaps
- Capture details during conversations — don't wait for a "data entry session"

## What To Surface Proactively
- "Meeting with Lisa in 2 hours" + her context + last topics discussed
- "Alex mentioned job hunting last time" — relevant context resurfacing
- "You haven't connected with Basel in a while" — if user wants relationship nudges

## Details Worth Remembering
- Kids/spouse names and ages
- Recent life events: new job, moved, health issues
- Preferences: vegetarian, doesn't drink, early riser
- Sensitive topics to avoid
- How you can help them / how they can help you

## What NOT To Suggest
- Syncing with phone contacts — different purpose, keep separate
- CRM-style pipeline tracking — this is personal, not sales
- Automated birthday messages — defeats the purpose
- Social media integration — privacy and complexity

## Folder Structure
```
~/people/
├── maria-garcia.md
├── john-smith.md
└── deceased/         # for people who have passed
```
All contact files live directly in `~/people/`. No subdirectories except `deceased/`.

## Search and Retrieval
Use `grep` for fast fuzzy scanning across all contact files:

```bash
# Find anyone matching a name or keyword (case-insensitive)
grep -ril "keyword" ~/people/

# Show matching lines with context
grep -i "keyword" ~/people/*.md

# Find by tag
grep -rl "#investor" ~/people/

# Find by company
grep -ril "hsbc" ~/people/

# Find open-to-intro contacts
grep -rl "Open to introductions.*Yes" ~/people/

# Full text search with filename
grep -iH "keyword" ~/people/*.md
```

For fuzzy/approximate matching, use `grep -i` (case-insensitive) as the first pass. For broader fuzzy search, pipe through `fzf` if available:
```bash
grep -rl "" ~/people/ | fzf
```

## Privacy Considerations
- This is sensitive data — keep local, encrypt if needed
- Cloud sync optional but consider privacy
- Git history shows evolution — consider if appropriate
- Some notes are for you only — don't share contact file

## Relationship Maintenance Prompts
- Offer to check on contacts not seen in X months
- Flag contacts with outdated info
- Suggest reaching out around their important dates
- "You mentioned wanting to introduce A to B" — track pending intros
