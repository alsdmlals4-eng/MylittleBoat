# Social Fake Backend Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a deterministic local-only fake implementation of the approved delayed FriendBottle/DriftBottle contract so timing, polling, no-recipient, and stranger-thread gates can be verified before any real backend or account work.

**Architecture:** Add two focused `RefCounted` scripts under `scripts/social/`: `SocialSessionFake` owns only fake eligibility/identity state; `BottleClientFake` owns an in-memory accepted-bottle queue, deterministic fake clock, recipient availability, and stranger-thread message count. The fake exposes the same product-facing operations intended for the later real client, but uses no `HTTPRequest`, sockets, auth SDK, credentials, or external service. Tests advance fake time explicitly instead of waiting in real time.

**Tech Stack:** Godot 4.7 stable, GDScript, existing SceneTree contract tests, GitHub Actions `Godot 4.7 validation`.

**Spec:** `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`

## Global Constraints

- Core voyage/rest/pet/decor/album/fishing/soundscape remains local-first and independent of social availability.
- This slice uses no network, HTTP, Supabase, auth, provider secret, account permission, external moderation provider, or push notification.
- FriendBottle/DriftBottle remains delayed correspondence, not realtime chat.
- Accepted delivery delay must stay within the approved 45..210 second product range; tests use an explicit deterministic delay value inside that range.
- DriftBottle without an eligible recipient returns `NO_RECIPIENT_AVAILABLE` and does not create an accepted/sent bottle.
- `poll_inbox()` exposes only bottles with `deliver_at <= fake_now`.
- Stranger correspondence allows at most 6 letters total, then moves to `friendship_gate` and rejects another stranger message.
- Fake records contain no presence, typing, read-receipt, public-feed, follower, ranking, or public-directory semantics.
- Social fake operations must not mutate `GameState` voyage time, speed, appreciation, affection, album memories, fishing, or boat decoration.
- Human social usability/understanding remains `NOT_RUN`.

---

### Task 1: Fake session and delayed bottle contract

**Files:**
- Create: `scripts/social/social_session_fake.gd`
- Create: `scripts/social/bottle_client_fake.gd`
- Create: `tests/test_social_fake_backend_contract.gd`
- Modify: `.github/workflows/godot-validation.yml`

**Interfaces:**
- `SocialSessionFake.configure(social_status: String, age_bucket: String, terms_accepted: bool, account_age_seconds: float, completed_voyages: int) -> void`
- `SocialSessionFake.can_use_friend_bottle() -> bool`
- `SocialSessionFake.can_use_drift_bottle() -> bool`
- `BottleClientFake.configure(session, deterministic_delay_seconds: float = 90.0) -> void`
- `BottleClientFake.set_friend_available(value: bool) -> void`
- `BottleClientFake.set_drift_recipient_available(value: bool) -> void`
- `BottleClientFake.send_friend_bottle(text: String, sticker_id: String = "") -> Dictionary`
- `BottleClientFake.send_drift_bottle(text: String, sticker_id: String = "", thread_id: String = "") -> Dictionary`
- `BottleClientFake.advance_time(seconds: float) -> void`
- `BottleClientFake.poll_inbox() -> Array[Dictionary]`
- `BottleClientFake.get_local_drafts() -> Array[Dictionary]`
- `BottleClientFake.get_thread_state(thread_id: String) -> String`

- [ ] **Step 1: Write semantic RED**

Create `tests/test_social_fake_backend_contract.gd` that first asserts the two scripts exist, then requires:

```gdscript
var session = SocialSessionFake.new()
session.configure("linked_social", "16plus", true, 900.0, 1)

var client = BottleClientFake.new()
client.configure(session, 90.0)
client.set_friend_available(true)
client.set_drift_recipient_available(true)
```

The test must prove:
- FriendBottle accepted result has `status == "accepted"` and `deliver_at - accepted_at == 90.0`.
- polling before 90 seconds returns nothing; at 90 seconds returns the accepted bottle once.
- a 44-second or 211-second configured delay is clamped into approved 45..210 bounds.
- DriftBottle with no recipient returns `NO_RECIPIENT_AVAILABLE`, accepted count does not increase, and the text remains in local drafts.
- a valid DriftBottle is delayed exactly like FriendBottle.
- exactly six messages in one stranger thread are accepted, thread then reports `friendship_gate`, and the seventh is rejected with `STRANGER_THREAD_LIMIT`.
- under-16/local-only sessions cannot use online fake social.
- result dictionaries contain none of `typing`, `presence`, `read_receipt`, `followers`, `ranking`, `public_feed`.
- snapshots of all current `GameState` voyage/reward/memory/decor fields are unchanged by fake social calls.

- [ ] **Step 2: Register and verify RED**

Add the new test to `.github/workflows/godot-validation.yml`, open the current-task PR, and verify the exact-head CI fails because the two fake scripts/operations are missing. Parse/import errors do not count as semantic RED.

- [ ] **Step 3: Implement minimal fake scripts**

`SocialSessionFake` is a pure `RefCounted` value object. FriendBottle requires `linked_social + 16plus`; DriftBottle requires `anonymous_social` or `linked_social`, `16plus`, terms accepted, account age >= 600 seconds, and at least one completed voyage.

`BottleClientFake` is a pure `RefCounted` in-memory service. It stores `fake_now`, accepted-but-not-yet-polled bottles, delivered ids, local drafts, and `thread_id -> message_count`. It clamps deterministic delay to `45.0..210.0`; `poll_inbox()` returns due undelivered bottles and marks them delivered in memory. It does not reference `GameState` or any network class.

Message validation for this fake slice is intentionally minimal: non-empty text, max 400 Unicode characters, optional sticker string. Production moderation/contact filtering stays outside this slice.

- [ ] **Step 4: Verify GREEN and regressions**

Expected: `PASS: social fake backend contract` plus all pre-existing focused contracts and three Scene smokes remain green.

- [ ] **Step 5: Adversarial review and docs sync**

Re-attack clock boundary, duplicate polling, no-recipient acceptance count, seventh stranger message, core-state isolation, fake-vs-production evidence wording, no accidental network API, and maintenance complexity. After the last correction, require five clean whole-state loops. Update README/MVP/Roadmap only if needed to distinguish `SOCIAL_FAKE_BACKEND=PASS` from real social runtime `NOT_IMPLEMENTED`.

- [ ] **Step 6: Exact-head merge and Notion readback**

Verify current-task PR exact head, current main, comments/reviews/threads, CI, merge safely, read back new main, then sync Registry/Home/Core Loop/FriendBottle/DriftBottle/Production Handoff. Keep real Supabase/Auth/RLS/moderation/networking as `NOT_IMPLEMENTED` and Human social UX as `NOT_RUN`.
