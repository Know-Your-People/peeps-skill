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

**Base path** is workspace root or document root folder. On first use, create it: `mkdir -p kyp/peeps/`. Peeps uses a `kyp/peeps/` folder in your workspace.

All contact files live in a `kyp/peeps/` directory. On first use, create it with `mkdir -p kyp/peeps/` or wherever you prefer to store it. The agent should use this directory consistently across sessions.

### Owner self-entry

The owner's own contact file (slug derived from `peepsconfig.yml` `owner` field without `.md`) is intentional — it's used as a reference profile for crafting introductions, bios, and context when introducing the user to others.

### Actions File

`kyp/peeps/actions.md` — the pending actions queue. Check this during morning briefings.

Catch-ups: people `owner` wants to reconnect with. Add when he says "we should catch up with David" or similar.
Introductions: intros to facilitate. Always include a pre-generated draft intro message (using `owner` and both contact files for context). Format: `Person A → Person B — reason` followed by the intro text as a plain indented paragraph (no "Draft:" label, no quotes, no formatting).
- Move completed items to `## Completed` with a date.
- Keep it short — if it's not actionable, it shouldn't be here.

#### Housekeeping (run automatically when reading actions.md)

To keep context lean as the file grows:

Completed items: delete after 3 days
Completed section: rolling 7-day window — anything older than 7 days is removed
Stale catch-ups: if a pending catch-up has been sitting for 10+ days with no update, move it to Completed as "(not pursued)" with today's date
Pending intros: keep until explicitly marked done or cancelled — intro intent doesn't expire
- Apply this cleanup silently on every read. No need to announce.

### Dataset Config — `peepsconfig.yml`

`peepsconfig.yml` lives inside the `kyp/peeps/` directory. Read it at the start of any session involving this skill.

```yaml
owner: jane-smith # slug of the owner's contact file (without .md)
images: no (by default no, ask if you human want to feach images for pepople, warn that it is token expensive)
```

`owner`: identifies whose dataset this is. Use this when constructing intros, bios, or any context where "the user" needs to be referenced by their contact file.

### Core Behavior

- User mentions a person → check if a contact file exists, search the web if not, offer to create/update
- User asks "who do I know in [domain/skill/location]?" → search locally first; if Haah skill is installed, it may broadcast outbound per its own rules
- User asks about someone → surface insights from their file with relevant context
- User wants to make an intro → draft it using both contact files + owner profile
- Always use `Name:` not file name for talking about people 

### When User Mentions Someone

- "Had coffee with Maria" → ask if any updates from her, update if anything important
- "John's daughter is Sofia" → add to personal details
- "Sarah loves hiking" → add to interests/notes
- "Marco recommended Antifragile" → if Pages is installed, save to `kyp/pages/want/` with `Recommended by: [[marco-tabini]]` and add a note to his Peeps file
- "Priya and I both love Succession" → if Vibes is installed, add `Shared with: [[priya-nair]]` to the vibe file and note it on her Peeps file

### Creating a New Contact — Search First, Then Ask

Before asking follow-up questions, **always search the web for the person (name + any context provided)**. Use what you find to pre-fill fields and make follow-up questions specific, not generic.

Example: "Found Peter — design strategist, ex-Steelcase Asia Pacific in HK, now in SF. How do you know him?"

### Follow-Up Questions

After searching the web and pre-filling what you can, ask about the gaps:

1. **What are they really good at?** — Acumen clarification
2. **Relationship closeness** — How close are you?
3. **How you know them** — if not already provided
4. **Interests** — hobbies, sports, lifestyle?

If in `kyp/pages/peepsconfig.yml` images set to yes find a headhsot of a person and ad it to `../assets/` use person name for a slug, write it down in **Image:** feild.

Ask these as a short grouped follow-up (not one by one). Skip any that were already answered in the original message.

### Requests -> Haah

If Haah is installed: when the user has a question you cannot answer well locally, or when you find only one matching file in `kyp/peeps/`, suggest dispatching to a circle.

### Connections to other skills

Pages: if installed, when someone recommends a book, save it to `kyp/pages/want/` with `Recommended by: [[their-slug]]` and note it in their Peeps file. When drafting an intro, if both people have read the same book, surface it as a connection point.
Vibes: if installed, when someone shares a cultural interest (show, album, podcast, channel), add `Shared with: [[their-slug]]` to the vibe file and note it in their Peeps file. Surface shared taste when relevant to a conversation or intro.
Digs: if installed, when a person has expertise relevant to an open dig, surface them as a potential source. When adding someone new whose acumen matches an active research thread, mention it.

### Contact Structure

- One Markdown file per person like: `maria-garcia.md`

#### Fields

```markdown
Name: full name
Pronouns: guess, if unclear - ask
Location: from your search, otherwise ask
LinkedIn: link to LinkedIn search web for it, start with https://
Image: link to `../assets/photo-slug-usually-same-as-person-name`
Website: personal or company website if you found any, start with https://
Orgs: `[[org-slug]]`, `[[org-slug-2]]` — links to org files in `kyp/peeps/orgs/`; omit if independent/unknown
How I know them: one sentence
Acumen: skills and expertise, what person known for, based on your search + any user input
Relationship: (Close / Warm / Colleague / Acquaintance / Estranged / Family)
Interests: #hiking #coffee #jazz — comma-separated hashtags; hobbies, sports, lifestyle, anything you found
Bio: — one concise narrative paragraph based on your search and user input about them

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
- Enrich over time: add acumen, interests as you learn more
- Capture details during conversations — don't wait for a "data entry session"
- Ask about anyone mentioned in conversation and suggest adding them

### Peeps: check

On every heartbeat, check a random personal file in `kyp/peeps/`. Surface proactively in DM or appropriate channel:

- "Alex mentioned job hunting last time" — relevant context resurfacing
- "You haven't connected with Basel in a while"
- "You have **Acumen:** empty for John Wing, what he is known for?"

If nothing worth mentioning, skip.

### Adding to HEARTBEAT.md or cron

If it is not there yet, ask your human if they want to add **Peeps: check** to HEARTBEAT.md. If there is no HEARTBEAT.md, suggest to create a cron job every 30 minutes to execute **Peeps: check**.

### Details Worth Remembering

- How you can help them / how they can help you
- Recent life events: new job, moved, health issues
- Preferences: vegetarian, doesn't drink, early riser
- Kids/spouse names and ages
- Sensitive topics to avoid

## Updating

To update this skill to the latest version, fetch the new SKILL.md from GitHub and replace this file:

```
https://raw.githubusercontent.com/Know-Your-People/peeps-skill/main/SKILL.md
```

---

### What NOT To Suggest

- Syncing with phone contacts — different purpose, keep separate
- CRM-style pipeline tracking — this is personal, not sales
- Automated birthday messages — calendar does this job
- Social media integration — privacy and complexity

### Folder Structure

```
kyp/
└── peeps/
    ├── peepsconfig.yml
    ├── maria-garcia.md
    ├── john-smith.md
    ├── orgs/             # one file per organisation
    │   ├── google.md
    │   └── steelcase.md
    └── deceased/         # for people who have passed
```

All contact files live directly in `kyp/peeps/`. Org files live in `kyp/peeps/orgs/`. Move people who passed to `deceased/`.

### Organisations

Organisations worth remembering live in `kyp/peeps/orgs/`, one Markdown file per org. Create an org file whenever:

- A person's employer or affiliation is mentioned and it seems relevant to your network
- The user explicitly asks to note something about a company, community, or institution
- You're creating a person file and their org isn't already captured

**Filename:** lowercase, hyphenated slug of the org name — `openai.md`, `design-council.md`.

#### Org File Template

```markdown
# Org Name

Type: Company / Studio / NGO / Community / Institute / Fund / Startup / etc.
Industry: e.g. Design, Fintech, Healthcare, AI
Solving for: what problem this organisation is solving (like acumen for peeps, but for orgs)
Website: https://
Wikipedia: https://en.wikipedia.org/wiki/ — look this up; omit if no article exists
Founded: year if known
Size: approximate headcount range or stage (e.g. "~200", "Series B", "large enterprise")
Culture: 2–4 adjectives or a short phrase capturing the vibe — e.g. "research-heavy, slow-moving, prestigious" or "scrappy, founder-led, remote-first"
People: [[slug-one]], [[slug-two]] — everyone in `kyp/peeps/` associated with this org

## Notes

1 Apr 2026: note details
```

**Culture** is the most important field to capture. Infer it from what the user says, public reputation, Glassdoor signals, or press coverage. Ask if uncertain. Keep it honest and useful — not a PR blurb.

#### Creating a New Org — Search First

Before asking follow-up questions, search the web for the org. Pre-fill what you can. Then ask briefly about gaps, especially:

1. **Culture** — if you couldn't infer it confidently
2. **How the user is connected** — which person there do they know?

#### Wiki Links — Bidirectional, Always Maintained

`[[slug]]` links connect people and orgs. Keep them consistent:

Person → Org: `Orgs: [[org-slug]]` in the person file (comma-separate multiple)
Org → Person: `People: [[person-slug]]` in the org file

When you add or update either side, update the other. If you add Maria to `google.md`'s People list, make sure `maria-garcia.md` has `Orgs: [[google]]`. If you change Maria's org, remove her from the old org file's People list.

When creating an org file prompted by a person, immediately add that person to the People list and set their `Orgs:` field.

#### When User Mentions an Org

- "She works at Stripe now" → update person's `Orgs:` field; add them to `stripe.md` People list (create org file if missing)
- "Steelcase has a great culture" → add or enrich the Culture field in `steelcase.md`
- "I'm meeting with someone from Sequoia" → surface any people in `kyp/peeps/` who are connected to Sequoia

---

### Search and Retrieval

Use `grep` for fast fuzzy scanning. Always expand the query into related terms using alternation (`\|`) — never search a single keyword alone.

```bash
# Find matching lines with context
grep -iH "keyword\|synonym" kyp/peeps/*.md

# Find contacts with a specific interest tag
grep -rl "#hiking" kyp/peeps/

# Find everyone connected to a given org
grep -l "\[\[google\]\]" kyp/peeps/*.md kyp/peeps/orgs/*.md

# Find all people at a given org (via Orgs: field)
grep -rl "Orgs:.*\[\[stripe\]\]" kyp/peeps/

# Search org files for culture or industry keywords
grep -iH "remote\|async\|flat" kyp/peeps/orgs/*.md
```

**Keyword expansion examples — always broaden like this:**

- "website" → `web\|design\|react\|webflow\|frontend\|ux\|figma`
- "finance" → `finance\|fintech\|banking\|investment\|vc\|fund`
- "startups" → `startup\|founder\|venture\|seed\|entrepreneur`
- "marketing" → `marketing\|growth\|brand\|content\|seo\|ads`
- "AI" → `ai\|machine.learning\|llm\|ml\|data.science\|nlp`

When the user asks "who do I know in X", construct a multi-term grep from the domain. Use `-iH` to see what's actually in the files. Do not use `head` you need to get all the mentions -- even weak matches.

**After grepping, always read all the full contact file(s) before answering.** Never base your answer solely on grep output — the matched snippet is a signal, not the full picture. Read the complete file to get accurate context on relationship, acumen, and any notes before surfacing someone to the user.
