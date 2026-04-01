# Peeps 👥

> _Your network is bigger than you think. Most of it is just invisible when you need it._

**Peeps** is an open-source agent skill that turns the people you know into a private, searchable record — kept on your machine, owned by you.

No CRM. No app. No feed. Just files and your AI agent.

---

## What it does

- **Remembers people** — one markdown file per person, everything you know about them
- **Surfaces context** — "remind me what Leo does before my meeting tomorrow"
- **Finds connections** — "who do I know in fintech in Singapore?"
- **Drafts intros** — "connect Peter and Shaurya, they should meet"

```
~/peeps/
  leo-lau.md
  peter-boeckel.md
  shaurya-srivastava.md
  ...
```

---

## Install

```bash
npx skills add Know-Your-People/peeps-skill
```

Works with Cursor, Claude Code, Codex, OpenCode, GitHub Copilot, and [40+ more agents](https://github.com/vercel-labs/skills#supported-agents).

**OpenClaw users** get an enhanced setup (workspace config, contact directory):

```bash
curl -fsSL https://raw.githubusercontent.com/Know-Your-People/peeps-skill/main/install.sh | bash
```

---

## Then just talk to your contacts

```
"I just met someone called Leo at a design event."
"Who do I know in hardware supply chain?"
"Remind me to talk to Basel next week"
"Draft an intro between Peter and Shaurya."
```

---

## The Dispatch

Peeps is local by default. But we can tap into close private network intellignce with Dispatch.

**Dispatch\* lets a small circle of trusted people share their networks insights — privately and consensually **without sharing any data\*\*. When your contacts don't have the answer, theirs might.

→ [peepsapp.ai/dispatch](https://peepsapp.ai/dispatch) for early access

---

## Contributing

This is open source. Found a bug, want a feature, think the SKILL.md could be smarter? PRs welcome.

The skill lives in `SKILL.md`. That's the brain. Edit it, improve it, make it yours.

---

## License

MIT. Take it, fork it, build on it.

---

_Built by [Posit](https://posit.place) · Powered by [OpenClaw](https://openclaw.ai)_
