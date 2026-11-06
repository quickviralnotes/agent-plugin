---
name: qvn-known-errors
description: Use when a Quick Viral Notes (QVN) tool returns an error, fails, or returns something unexpected (no_cookie, cookie_invalid, subscription_required, trial_expired, 401, Substack API errors, missing notes or stats), to decide whether to retry, fix, or tell the user what to do.
user-invocable: false
---

# Quick Viral Notes known errors

Treat the error the tool returned as the truth. Don't retry the same call with the same inputs hoping for a different result, and don't guess a different call shape from memory: if a call was rejected for its shape, look it up again (`notes_studio` action `posting_formats` for posting; call the tool with `action: "help"` for the live parameter list of the rest).

## Access and account

| Error | What it means | What to do |
|---|---|---|
| `401` / "Unauthorized" / "Needs authentication" | Not signed in, or the sign-in expired | Sign in again (see `qvn-basics` section 1, stage 2). Then retry once. |
| `subscription_required` | The account has no active plan (or never finished signing up) | Tell the user. Link `https://quickviralnotes.xyz/pricing`. Don't retry. |
| `trial_expired` / `subscription_expired` | The 7-day trial or the paid plan ended | Tell the user, link `https://quickviralnotes.xyz/pricing`. Don't retry. |

## Substack connection

| Error | What it means | What to do |
|---|---|---|
| `no_cookie` | QVN has never received the user's Substack login | Ask the user to install the QVN Chrome extension and open Substack in Chrome while logged in (`https://quickviralnotes.xyz/connect`). Retry once after they confirm. |
| `cookie_invalid` | The synced Substack login expired or was revoked | Ask the user to open substack.com in Chrome (logging in again if needed) so the extension syncs a fresh session. Retry once after they confirm. |
| `decrypt_failed` | QVN couldn't read the stored Substack session | Same as `cookie_invalid`: a fresh sync fixes it. If it repeats, tell the user to contact support. |
| `substack_api_error` | Substack itself rejected or failed the request | Report Substack's message verbatim. Retry once only if it looks temporary (timeout, 5xx). A 4xx means the request needs to change. |

## Content and scheduling

- **Note rejected or posted with odd formatting.** Note content must be HTML (`<p>`, `<strong>`, `<ul><li>`...), never markdown. Fix the HTML and retry.
- **Scheduling.** `trigger_at` must be ISO 8601 with a timezone. Keep at least 2 hours between notes on the same day and use non-round minutes (:08, :17, :23, :38, :42, :47, :53). If a time conflicts, propose the next free slot rather than overwriting.
- **Scheduled note missing its image or video.** Re-list with `substack_write` action `list_scheduled_drafts`. If the attachment isn't there, re-upload with a fresh upload token (`substack_write` action `image_upload_token` or `video_upload_token`); tokens are single-use and short-lived.
- **Stats empty.** Brand-new notes take a while to collect stats. Empty stats on an account that has posted usually means the Substack session isn't synced (see `no_cookie`).

## When nothing here matches

Tell the user exactly which tool you called, with what (leave out note text if it's long), and the full error message. Don't claim the action happened. Support: `https://quickviralnotes.xyz/contact`.
