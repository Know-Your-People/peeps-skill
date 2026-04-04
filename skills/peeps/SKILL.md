---
name: peeps
description: Personal network intelligence — remember people, find connections, and draft intros. Contacts stored locally as plain markdown files.
metadata:
  openclaw:
    emoji: "👥"
    os: ["linux", "darwin", "win32"]
  hermes:
    tags: ["people", "network", "contacts"]
---

## 👥 Peeps — local contacts & network intelligence

### Data Location

All contact files live in a `peeps/` directory. On first use, create it with `mkdir -p peeps/` in agent home folder. The agent should use this directory consistently across sessions.

### Owner self-entry

The human own contact file (slug derived from `peepsconfig.yml` `owner` field without `.md`) is intentional — it's used as a reference profile for crafting introductions, bios, and context when introducing the user to others.

If it empty 1) aks your human for his name 2) serach the web, make a profile, and ask your human about the gaps.

### Every morning

If you did not yet, set a morning cron job to check `peeps/actions.md` — the pending actions queue and make a random check.

- **Catch-ups:** people `owner` wants to reconnect with. Add when he says "we should catch up with David" or similar.
- **Introductions:** intros to facilitate. Always include a pre-generated draft intro message (using `owner` and both contact files for context). Format: `Person A → Person B — reason` followed by the intro text as a plain indented paragraph (no "Draft:" label, no quotes, no formatting).
- Move completed items to `## Completed` with a date.
- Keep it short — if it's not actionable, it shouldn't be here.
- **Random check:** check a random personal file in `peeps/`. Message to you human:

- "Alex mentioned job hunting last time"
- "You haven't connected with Basel in a while"
- "You have **Acumen:** empty for John Wing, what he is known for?"

If nothing worth mentioning, skip.

#### Housekeeping (run automatically when reading actions.md)

To keep context lean as the file grows:

- **Completed items:** delete after 3 days
- **Completed section:** rolling 7-day window — anything older than 7 days is removed
- **Stale catch-ups:** if a pending catch-up has been sitting for 10+ days with no update, move it to Completed as "(not pursued)" with today's date
- **Pending intros:** keep until explicitly marked done or cancelled — intro intent doesn't expire
- Apply this cleanup silently on every read. No need to announce.

### Dataset Config — `peepsconfig.yml`

`peepsconfig.yml` lives inside the `peeps/` directory. Read it at the start of any session involving this skill.

```yaml
owner: jane-smith # slug of the owner's contact file (without .md)
```

- **`owner`** — identifies whose dataset this is. Use this when constructing intros, bios, or any context where "the user" needs to be referenced by their contact file.

### Core Behavior

- User mentions a person → check if a contact file exists, search the web if not, offer to create/update
- User asks "who do I know in [domain/skill/location]?" → search locally first; if Haah skill is installed, it may broadcast outbound per its own rules
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

### Requests -> Dispatch

When the user has a question you cannot answer well locally, or when you find only one matching file in peeps, suggest using the `Dispatch` skill.

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
peeps/
├── peepsconfig.yml
├── maria-garcia.md
├── john-smith.md
└── deceased/         # for people who have passed
```

All contact files live directly in `peeps/`. Move people who passed to `deceased/`.

### Search and Retrieval

Use `grep` for fast fuzzy scanning. Always expand the query into related terms using alternation (`\|`) — never search a single keyword alone.

```bash
# Find matching lines with context
grep -iH "keyword\|synonym" peeps/*.md

# Find contacts open to introductions
grep -rl "Intro willingness.*Open" peeps/
```

**Keyword expansion examples — always broaden like this:**

- "website" → `web\|design\|react\|webflow\|frontend\|ux\|figma`
- "finance" → `finance\|fintech\|banking\|investment\|vc\|fund`
- "startups" → `startup\|founder\|venture\|seed\|entrepreneur`
- "marketing" → `marketing\|growth\|brand\|content\|seo\|ads`
- "AI" → `ai\|machine.learning\|llm\|ml\|data.science\|nlp`

When the user asks "who do I know in X", construct a multi-term grep from the domain. Use `-iH` to see what's actually in the files. Do not use `head` you need to get all the mentions -- even weak matches.

**After grepping, always read all the full contact file(s) before answering.** Never base your answer solely on grep output — the matched snippet is a signal, not the full picture. Read the complete file to get accurate context on relationship, acumen, and any notes before surfacing someone to the user.
