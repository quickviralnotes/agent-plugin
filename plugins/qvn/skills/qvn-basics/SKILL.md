---
name: qvn-basics
description: MANDATORY before the first Quick Viral Notes (QVN) tool call in a session. Use whenever the user wants to write, generate, post, schedule, edit or delete Substack Notes, check how their notes, posts or subscribers are doing, read Substack articles, notes, comments or their inbox, review their own Substack activity (replies, likes, DMs), or research newsletters, even if they never say "Quick Viral Notes" or "QVN". Also use when QVN tools seem missing, ask for authentication, or return auth or cookie errors: that is normally an unauthenticated server or an unsynced Substack session, not a broken install.
---

# Quick Viral Notes basics

Quick Viral Notes (QVN) connects this agent to the user's Substack through a hosted MCP server at `https://mcp.quickviralnotes.xyz`. The server's own instructions (sent when it connects) cover note HTML formatting, scheduling rules and the built-in workflows. This skill covers what comes before and around those: getting connected, routing requests, and proving the work landed.

## 1. Make sure the tools are connected

If QVN tools are visible (names containing `notes_manager`, `notes_gen_studio`, `substack_reader`, `get_published_note_stats`), skip to section 2. Do not reinstall anything, and do not start a new session.

If they are not visible, find out which stage failed. Check each stage in order and stop at the first one that fails:

1. **Registered.** Claude Code: `claude mcp get plugin:qvn:qvn`. Codex / ChatGPT desktop: `codex mcp get qvn`. If neither exists, the plugin isn't installed: point the user to `https://quickviralnotes.xyz/claude` (Claude Code) or `https://quickviralnotes.xyz/chatgpt` (Codex / ChatGPT desktop) and follow that guide. Do not register a second copy of the server by hand.
2. **Authenticated.** If the server shows "Needs authentication" or "Not logged in", log in:
   - Claude Code: run `sh "${CLAUDE_PLUGIN_ROOT}/skills/qvn-basics/login-qvn.sh" > /tmp/qvn-login.log 2>&1 &`, then read `/tmp/qvn-login.log` every few seconds. A browser opens on the Quick Viral Notes sign-in page; wait while the user signs in. Success is the line `Authenticated with "plugin:qvn:qvn"`. The user can also run `/mcp`, pick `plugin:qvn:qvn` and choose Authenticate.
   - Codex / ChatGPT desktop: run `codex mcp login qvn` and wait for the browser sign-in to finish.
3. **Connected in this session.** Tools load only when a session starts. If the server is authenticated but its tools still aren't visible here, tell the user to start a new session (Claude Code: `/clear` or a new conversation; Codex: a new task) and ask again there.

When you report a problem, name the stage that failed ("the plugin isn't installed", "you're not signed in", "you're signed in but this session started before the tools loaded"). Never say only "QVN is unavailable".

The user needs a Quick Viral Notes account. New accounts get a free trial at `https://quickviralnotes.xyz/signup`. If the server says the account has no active plan or credits, say so plainly and link `https://quickviralnotes.xyz/pricing`.

## 2. The one prerequisite people miss: the Substack session

Posting, scheduling, deleting, stats and private reads (inbox, DMs, paid posts) act as the user on Substack. QVN gets that access from the **Quick Viral Notes Chrome extension**, which syncs the user's Substack login. If a tool returns `no_cookie` or `cookie_invalid`, the tools work but QVN can't reach Substack yet: ask the user to open Substack in Chrome while logged in, with the extension installed (`https://quickviralnotes.xyz/connect`), then retry once. Public reads (other people's notes, public posts, newsletter search) work without it.

## 3. Route the request to a product tool first

Start with a QVN tool call, not with reading files or debugging:

| The user wants to | Start with |
|---|---|
| Write or generate notes | `notes_gen_studio` (knowledge bank → formulas → generate) |
| Post, schedule, edit or delete a note on Substack | `notes_manager` (`post` with optional `trigger_at`, `update_published`, `delete_published`, `list_scheduled_drafts`) |
| Know how to post images, videos, links | `notes_gen_studio` action `posting_formats` |
| See how notes or posts performed | `get_published_note_stats`, `get_published_post_stats` |
| Read articles, notes, comments, inbox, feed | `substack_reader` |
| Review their own replies, likes, restacks, DMs | `substack_activity` |
| Look at subscribers | `substack_subscribers` |
| Research newsletters in a niche | `newsletter_explorer` |
| Follow a guided growth workflow | `search_workflows`, then `use_workflow` |

Do only what was asked. Drafting is not posting: never post, schedule or delete on Substack unless the user asked for that action or confirmed it. Read current state before changing it, because the user may have edited notes in Substack or the QVN web app since you last looked.

## 4. Prove it landed before saying done

A successful tool response is not proof on its own.

- After scheduling: call `notes_manager` `list_scheduled_drafts` and confirm the draft is there with the right time and any attachment.
- After posting: give the user the note link from the response.
- After deleting or editing: read the note back or list again.

If you can't verify, say what you did, what you couldn't confirm, and why. Never report success you haven't seen.

For error messages and what to do about each, use the `qvn-known-errors` skill.
