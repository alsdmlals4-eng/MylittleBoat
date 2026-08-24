# Rest-first Bondee Boat Diorama + Delayed Bottle Social Design

Status: **USER-APPROVED DESIGN / IMPLEMENTATION GATED BY WRITTEN SPEC REVIEW**  
Date: 2026-08-24  
Issue: #12  
Base repository main at design start: `b6949a0b92f591bc099a5cf143b9fe32a863e45f`

## 0. Authority and migration note

This design records the user's latest approved product direction and supersedes the older assumptions that the game must be first-person-only, the player body must never be visible, and online bottle-letter sharing is forbidden.

The current `AGENTS.md` still contains those older constraints. The first implementation slice must update that operating canon explicitly before runtime work adopts this design. Do not silently ignore the old rules.

Notion remains the human-facing design canon. Repository Markdown is the structured implementation mirror. Runtime claims still require Godot/code/test evidence.

---

## 1. Product North Star

**A small storybook boat diorama where the player's visible avatar and pet quietly live, decorate, rest, and exchange slowly drifting bottle letters without turning the experience into a realtime social network.**

Emotional priority:

1. Rest and comfort.
2. Attachment to avatar, pet, and boat.
3. A sense that the boat is "my small place".
4. Gentle object and pet interaction.
5. Unexpected human warmth through bottle letters.
6. Collection/customization as memory, not optimization.

Efficiency, urgency, social status, streaks, FOMO, ranking, or response pressure never outrank those goals.

---

## 2. Core experience shift

### Before

- first-person sea appreciation is the primary presentation;
- player body not visible;
- boat mainly functions as viewpoint/container;
- bottle letters are authored ambient content only;
- online social exchange prohibited.

### After

- primary presentation becomes a **3/4 diorama camera** showing avatar + pet + boat + decorations + sea;
- optional **Appreciation Camera** preserves the current sea-focused/first-person-like relaxation mode;
- boat becomes a personal living space with low-pressure decoration and interaction;
- bottle letters split into `FriendBottle` and `DriftBottle`;
- online scope stays isolated to social identity, bottle delivery, friendship, and safety operations;
- voyage, pet, decoration, album, fishing, soundscape, and rest loop remain local-first.

---

## 3. Camera and avatar

### Primary camera — 3/4 Boat Diorama

- Show avatar, pet, useful boat area, and horizon together.
- Camera movement is slow, bounded, and predictable.
- Mobile portrait remains the primary composition constraint.
- Do not aggressively chase tiny avatar movement.
- Decorations stay readable without hiding the sea.

### Appreciation Camera

Entering Appreciation Camera:

- hides most nonessential UI;
- shifts framing toward sea/horizon;
- may place avatar/pet at edge or temporarily out of frame;
- keeps voyage timer and soundscape running;
- changes no rewards.

This preserves the current Resting Core investment instead of throwing it away.

### Avatar MVP

Customization starts with:

- body/base preset;
- hair;
- top;
- bottom;
- head accessory;
- one small accessory slot;
- color variants.

Cosmetics have no stats.

Low-pressure actions:

- sit;
- rest/lie down where supported;
- lean on rail;
- look at sea;
- hold cup;
- view album;
- read/write bottle letter;
- fish;
- pet companion.

---

## 4. Boat decoration

### Selected approach — slot-zone decoration

Use explicit zones instead of a freeform 3D editor in the first implementation.

Initial zones:

1. bow-left;
2. bow-right;
3. center-left;
4. center-right;
5. rear-left;
6. rear-right;
7. wall/rail accent;
8. pet corner.

Each zone accepts only compatible categories.

Why selected:

- predictable portrait-mobile touch controls;
- lower clipping/overlap complexity;
- simpler save data;
- easier calm camera composition;
- lower solo-development cost;
- can later evolve into constrained free placement if Human tests justify it.

Good decor: lantern, mug, cushion, blanket, plant, framed voyage photo, shell, postcard, bottle shelf, pet cushion.

Rejected as core: rarity score, stat bonuses, gacha pressure, daily limited shops, optimization bonuses for filling every slot.

---

## 5. Interaction architecture

Use one reusable interaction contract instead of one-off prop scripts.

```text
Interactable
- get_actions(actor_context) -> Array[InteractionAction]
- can_interact(actor_context, action_id) -> bool
- perform(actor_context, action_id) -> InteractionResult
```

Examples:

- pet → pet / sit together / look at sea;
- rail → lean / look at sea;
- cushion → sit;
- lantern → turn on/off;
- cup → hold / put down;
- album → open;
- fishing rod → start quiet fishing;
- bottle station → write bottle / check arrivals.

Constraints:

- no rapid-tap progression;
- ignoring interactions never causes loss;
- interactions never force exit from Appreciation Camera;
- animation/dialogue variation may exist but cannot become optimal farming.

---

## 6. Delayed Bottle Social common contract

This is deliberately **not realtime chat**.

MVP message shape:

- text only;
- maximum 400 Unicode characters;
- one optional developer-curated sticker;
- no user image/file/audio attachment.

Explicitly absent:

- typing indicator;
- online/presence indicator;
- read receipt;
- public profile browsing;
- follower counts;
- public feed;
- global chat;
- popularity/ranking score.

Every message passes through a server-side delivery/safety pipeline.

### Healthy-backend delivery target

`TARGET_DELIVERY <= 5 minutes` means an **accepted** bottle becomes server-receivable by its assigned recipient within 5 minutes under healthy backend/network conditions.

It does not guarantee a visible phone notification if the recipient is offline, app-closed, or the backend/network is degraded.

Timing contract:

```text
normal moderation/validation budget: <= 5 sec
deliver_at offset after acceptance: random 45..210 sec
active-client poll interval: 20..30 sec
normal healthy-path upper target: <= 245 sec
product-target margin: >= 55 sec
```

Random delay is product behavior, not accidental latency.

**No cron/scheduler is required for MVP availability.** `poll-inbox` treats any allowed bottle with `deliver_at <= server_now` as available and may atomically stamp `delivered_at` on first retrieval. The database timestamp is the source of truth; the client cannot shorten the delay.

---

## 7. Social eligibility and durable identity

### MVP age policy

To avoid an ambiguous child-safety implementation, **all online social sending/receiving is 16+ in the MVP**.

- declared under-16 users can use the full local rest/decor/pet/voyage game;
- declared under-16 users cannot send/receive `FriendBottle` or `DriftBottle` in MVP;
- lowering this threshold is a separate future policy/design change, not an implementation shortcut.

### Account stages

1. `local_only` — no social account required for core game.
2. `anonymous_social` — Supabase anonymous Auth creates a unique authenticated server identity for limited `DriftBottle` eligibility.
3. `linked_social` — durable account link required for friendships and `FriendBottle`.

MVP durable link method: **email OTP**. Platform OAuth can be added later without changing the user id.

Anonymous identity must be linked, not replaced, when upgraded.

---

## 8. Friend discovery and FriendBottle

### Adding a friend

No public user search.

Use a server-generated **8-character one-time Friend Invite Code**:

- expires after 24 hours;
- generated only for `linked_social` users;
- code itself reveals no email or auth id;
- the code owner is the inviter;
- a second linked user redeems the code as the invitee;
- redemption consumes the code and records the invitee's consent;
- the inviter must then explicitly confirm the pending request before `friendships.status` becomes `accepted`;
- raw code is shown only at creation time and the database stores only its hash.

This extra inviter-confirm step prevents a leaked code from silently creating a durable friendship.

### FriendBottle flow

```text
select accepted friend
→ write <= 400 chars + optional sticker
→ server safety validation
→ deliver_at = accepted_at + random(45..210 sec)
→ friend inbox
→ active client discovers at next poll
→ optional delayed reply
```

Still delayed; no instant-message bypass.

Baseline server rate limits:

- 10 FriendBottle sends/hour;
- 50/day.

---

## 9. DriftBottle for unknown users

### Purpose

Feel like a letter drifted from another quiet boat, not like entering a random chat room.

### Additional eligibility

In addition to 16+ social eligibility:

- Terms + Community Guidelines accepted;
- account at least 10 minutes old;
- at least one completed 5-minute voyage;
- not restricted/rate-limited.

### Acceptance and no-recipient rule

The 5-minute delivery target begins only after the server has found an eligible recipient and **accepted** the send.

If no eligible recipient exists at send time:

- server returns `NO_RECIPIENT_AVAILABLE`;
- no bottle row is accepted as sent;
- client keeps/restores the letter as a local draft;
- UI presents a calm retry-later state;
- no false 5-minute promise is shown.

This avoids silently queueing a stranger bottle for an unbounded time.

### Stranger identity

Each correspondence gets a server-generated ephemeral alias such as adjective+nature-noun+number.

- alias is scoped to one stranger thread;
- durable account id/global profile is hidden;
- no alias search exists;
- external contact exchange is filtered.

### Matching

Recipient must:

- not be sender;
- not be blocked either direction;
- be 16+ and stranger-eligible;
- be within inbox capacity;
- not have been recently over-matched with the same sender.

### Limited stranger correspondence

A stranger thread allows **at most 6 letters total**.

- server stores `message_count`;
- when `message_count == 6`, thread moves to `friendship_gate`;
- either user may end silently;
- either may request `Continue as friends`;
- only mutual independent consent creates a durable friendship;
- no external contact data is revealed automatically.

Baseline server rate limits:

- 3 new/reply DriftBottle sends/hour;
- 10/day.

---

## 10. Safety, moderation, and store compliance

Bottle letters are UGC. Safety is a release requirement.

Required before any public `DriftBottle` enablement:

- Terms/Community Guidelines acceptance;
- defined prohibited content;
- pre-publication filtering;
- report content;
- report user;
- block user;
- immediate local hide after report/block;
- moderation review queue;
- developer support/contact path;
- retention/deletion policy;
- age gate;
- abuse/rate limiting;
- moderation audit receipt.

Block or quarantine in MVP:

- URLs;
- email addresses;
- phone numbers;
- obvious social handles/external contact patterns;
- sexual solicitation;
- threats;
- targeted harassment;
- hate/abusive content;
- self-harm encouragement;
- exploitation/grooming patterns;
- spam/repetition patterns.

Pipeline:

```text
send request
→ authentication + eligibility
→ normalization
→ length/sticker validation
→ contact/URL deterministic filter
→ rate limit
→ server-side semantic moderation adapter
→ ALLOW / REJECT / QUARANTINE
→ only ALLOW enters delivery
```

Provider secrets are server-only.

**Release gate:** `DriftBottle` remains feature-flag OFF unless production semantic moderation, report/block UX, moderation operations, Terms, and support contact are deployed and tested.

Apple/Google policy implication: the product must remain primarily a rest/boat/decor game with an incidental bottle-letter feature, not a random/anonymous chat product.

Authoritative references checked during design:

- Apple App Review Guidelines 1.2 User-Generated Content and February 2026 clarification for random/anonymous chat.
- Google Play Developer Program User Generated Content policy requiring terms, ongoing moderation, in-app report and block.

---

## 11. Backend trade study

### A. Supabase — SELECTED FOR MVP

Integrated strengths:

- anonymous Auth;
- account-link path;
- Postgres relational model;
- Row Level Security;
- Edge Functions.

Published Free references at design time:

- 500 MB database/project;
- 50,000 MAU;
- 500,000 Edge Function invocations;
- 2 million Realtime messages;
- Free projects may pause after one week of inactivity.

We do **not** use Realtime for delivery. Polling matches the fiction and lowers complexity.

Risk: a dormant paused Free project means the 5-minute target is not a hard public-production uptime SLA. Hosting tier is re-Gated before public release.

### B. Cloudflare Workers + D1 — STRONG ZERO-COST FALLBACK

Published Free references at design time:

- Workers 100,000 requests/day;
- D1 5 million rows read/day;
- D1 100,000 rows written/day;
- D1 5 GB total free storage.

Strengths: excellent small-service cost profile, no equivalent inactivity pause.

Weaknesses: authentication/friend/security model becomes much more custom than Supabase Auth+RLS.

Keep as migration/fallback if Supabase operational cost/pause becomes a release problem.

### C. Firebase Auth + Firestore — NOT SELECTED

Published Free Firestore references:

- 1 GiB storage;
- 50,000 document reads/day;
- 20,000 document writes/day;
- 10 GiB outbound/month;
- anonymous Auth supported.

Strengths: mature mobile auth and anonymous account linking.

Weaknesses: this relational friend/thread/report model fits Postgres better; server moderation/routing adds another deployment concern; polling mistakes can create noisy document-read costs.

---

## 12. Selected backend architecture

```text
Godot 4.7
├─ local voyage / pet / decor / album / fishing / soundscape
├─ SocialSession
│  ├─ local_only
│  ├─ anonymous_social
│  ├─ linked_social
│  └─ eligibility
└─ BottleClient
   ├─ send_friend_bottle()
   ├─ send_drift_bottle()
   ├─ poll_inbox()
   ├─ reply()
   ├─ report()
   ├─ block()
   ├─ create_friend_invite()
   └─ friendship_action()
        │
        ▼
Supabase
├─ Auth
├─ Postgres + RLS
├─ Edge Functions
│  ├─ send-bottle
│  ├─ poll-inbox
│  ├─ bottle-action
│  ├─ friend-invite
│  ├─ friendship-action
│  └─ moderation/report intake
└─ tables
   ├─ profiles
   ├─ social_consents
   ├─ friend_invites
   ├─ friendships
   ├─ bottle_threads
   ├─ bottles
   ├─ blocks
   ├─ reports
   └─ moderation_actions
```

Sensitive social state is mutated through Edge Functions when full invariants must be enforced atomically.

---

## 13. Data model

### `profiles`

- `user_id uuid primary key` → auth user;
- `display_name text`;
- `age_bucket enum('under16','16plus')`;
- `social_status enum('local_only','anonymous_social','linked_social','restricted')`;
- `created_at timestamptz`;
- `linked_identity boolean`.

### `social_consents`

- `user_id uuid`;
- `terms_version text`;
- `community_version text`;
- `accepted_at timestamptz`;
- primary key `(user_id, terms_version, community_version)`.

### `friend_invites`

- `id uuid`;
- `owner_id uuid`;
- `code_hash text unique`;
- `expires_at timestamptz`;
- `redeemed_by uuid nullable`;
- `redeemed_at timestamptz nullable`;
- `confirmed_at timestamptz nullable`;
- `created_at timestamptz`.

Raw invite codes are returned once to the owner and are not stored in plaintext.

### `friendships`

- canonical ordered pair `user_a`, `user_b`;
- `status enum('pending','accepted','ended')`;
- `requested_by uuid`;
- timestamps;
- unique pair constraint.

### `bottle_threads`

- `id uuid`;
- `kind enum('friend','stranger')`;
- `participant_a uuid`;
- `participant_b uuid`;
- `stranger_alias_a text nullable`;
- `stranger_alias_b text nullable`;
- `message_count int default 0`;
- `state enum('open','friendship_gate','closed','blocked')`;
- timestamps.

### `bottles`

- `id uuid`;
- `thread_id uuid`;
- `sender_id uuid`;
- `recipient_id uuid`;
- `body text`;
- `sticker_id text nullable`;
- `created_at timestamptz`;
- `accepted_at timestamptz`;
- `deliver_at timestamptz`;
- `delivered_at timestamptz nullable`;
- `read_at timestamptz nullable`;
- `moderation_state enum('allow','reject','quarantine')`;
- `status enum('queued','available','read','deleted','expired')`.

Storage layer also enforces body length <= 400.

### `blocks`

- blocker user;
- blocked user;
- timestamp;
- unique pair.

Block immediately prevents matching, thread continuation, and friend delivery.

### `reports`

- reporter;
- reported user;
- bottle id;
- reason enum;
- optional length-limited detail;
- status;
- created timestamp.

### `moderation_actions`

- report/bottle reference;
- action enum;
- actor/system identifier;
- reason code;
- timestamp.

---

## 14. RLS and access boundaries

- Users read their own profile and only approved friend-facing fields of accepted friends.
- Users read bottle content only when sender or recipient.
- Client cannot choose arbitrary `recipient_id` for stranger matching.
- Client cannot set `moderation_state=allow`.
- Client cannot shorten `deliver_at`.
- Client cannot bypass rate limits by direct bottle insert.
- Blocks are checked server-side before every route/send.
- Report/moderation tables are not broadly readable.
- Service-role credentials never ship in Godot.
- Anonymous Auth is still an authenticated identity and is distinguished by account/social state.

---

## 15. Offline and failure behavior

### Send while offline

- save local draft;
- UI says bottle has not left the boat;
- retry after connectivity;
- do not fabricate `deliver_at` before server acceptance.

### Recipient offline

- bottle becomes available server-side when `deliver_at <= server_now`;
- remains unread until a future poll/session;
- no push notification required in MVP.

### Moderation unavailable

- fail closed for `DriftBottle`;
- no unmoderated stranger routing.

### Backend paused/degraded

- calm non-urgent error copy;
- no streak/reward loss;
- local voyage/rest/decor remains fully playable.

---

## 16. Privacy and data minimization

MVP social backend does not require:

- phone contacts;
- precise location;
- address-book upload;
- public social graph;
- real-world name;
- user photos;
- voice data.

Store only what is needed for auth, age/social eligibility, routing, moderation, block/report, and requested friendship.

External contact exchange is filtered in stranger correspondence.

---

## 17. Rest-loop integration

Bottle arrival must stay ambient.

Preferred presentation:

- bottle quietly appears near boat/bottle basket;
- small optional indicator;
- no countdown;
- no "reply now" pressure;
- unread bottle persists until chosen.

Permissible soft rewards: memory entry, decorative postcard frame, album log, optional curated sticker unlock after broad milestones.

Rejected: reply streak, social currency farming, rarity ranking, response-time bonus, public popularity score.

---

## 18. Implementation decomposition after written-spec review

This architecture is intentionally split into testable slices rather than one giant PR.

1. **Canon migration + Diorama camera/visible avatar shell**  
   Update AGENTS/Notion/repository direction, preserve Appreciation Camera, add avatar placeholder and camera contract. No backend.

2. **Local decoration + Interactable contract**  
   Slot zones, local save model, representative props, pet/rail/cup interactions. No cloud dependency.

3. **Social fake-backend contract**  
   Godot `BottleClient` interface + deterministic local fake implementing delayed FriendBottle/DriftBottle transitions, 5-minute acceptance semantics, report/block, invite-code, age gate, and 6-letter stranger limit.

4. **Supabase schema/Auth/RLS/Edge Functions**  
   Local Supabase development first, SQL migrations, anonymous→email-OTP link, RLS/security tests, rate limits, delivery timestamp semantics, block routing, invite flow, stranger gate.

5. **Production moderation + release gate**  
   Separate focused design/benchmark for the concrete semantic moderation provider, then implement Terms, report queue, block/report UX and feature gating. `DriftBottle` remains OFF until this passes.

6. **End-to-end delayed bottle integration**  
   Replace fake adapter with real adapter under the same client interface; polling; offline drafts; friendship; delivery evidence.

7. **Human/device social-rest validation**  
   Verify arrivals feel ambient, safety actions are discoverable, delivery target holds on real networks, and backend failure never blocks rest gameplay.

Every implementation slice receives its own TDD RED/GREEN, PR, exact-head CI, adversarial review, and Notion sync.

---

## 19. Architecture acceptance criteria

Implementation is faithful only if:

- normal play shows avatar + pet in 3/4 boat diorama;
- Appreciation Camera still provides low-UI sea rest;
- decor has no stats/mandatory optimization;
- interactions remain optional/low-pressure;
- FriendBottle and DriftBottle are delayed, not realtime;
- accepted healthy-backend bottles target server availability under 5 minutes;
- no-recipient DriftBottle is not falsely accepted;
- all online social is 16+ in MVP;
- FriendInvite codes are one-time, 8-character, 24-hour and server-generated;
- FriendInvite redemption does not create an accepted friendship until the inviter confirms;
- stranger mode has no directory, presence, typing, read receipt, or public feed;
- stranger thread stops at 6 letters unless mutual friendship consent succeeds;
- report and block are in-app;
- blocked users cannot re-match or deliver new bottles;
- stranger UGC is moderated server-side before delivery;
- local rest/decor/voyage remains playable without backend;
- no server/moderation secret ships in Godot;
- `DriftBottle` public feature flag cannot turn on before the safety release gate passes.

---

## 20. Explicit non-goals

- realtime chat;
- voice/video chat;
- public timeline/feed;
- follower system;
- location matching;
- dating/matchmaking;
- popularity competition;
- online co-op movement in the same world;
- marketplace/trading;
- user-uploaded media in letters;
- unrestricted external contact exchange;
- backend dependency for basic single-player rest gameplay.

---

## 21. Decision summary

- Product: **Rest-first Bondee Boat Diorama + Delayed Bottle Social**.
- Camera: 3/4 visible-avatar normal view + Appreciation Camera.
- Decoration: fixed slot zones first.
- Interaction: reusable `Interactable` contract.
- Social age: all online social 16+ for MVP.
- Friend discovery: durable linked account + one-time 8-char/24h Friend Invite Code + inviter confirm after redemption.
- Stranger social: delayed/rate-limited `DriftBottle`, server-assigned ephemeral alias, max 6 letters, mutual consent to become friends.
- Delivery: accepted bottles use 45..210 sec intentional delay + 20..30 sec polling; `poll-inbox` resolves `deliver_at <= server_now`; target <=5 min under healthy conditions.
- MVP backend: Supabase Auth + Postgres/RLS + Edge Functions, polling instead of Realtime.
- Safety: stranger mode remains OFF until semantic moderation + Terms + report/block + operations are deployed/tested.
- Cost: local/free-first development; hosting tier is re-Gated before public release if Supabase Free pause/limits conflict with real reliability.
