# Rest-first Bondee Boat Diorama + Delayed Bottle Social Design

Status: **USER-APPROVED DESIGN / IMPLEMENTATION GATED BY WRITTEN SPEC REVIEW**  
Date: 2026-08-24  
Issue: #12  
Base repository main at design start: `b6949a0b92f591bc099a5cf143b9fe32a863e45f`

## 0. Authority and migration note

This design captures the user's latest approved product direction and therefore supersedes the older product assumptions that the game must be first-person-only, that the player body must never be visible, and that online bottle-letter sharing is forbidden.

The current `AGENTS.md` still contains those older constraints. **Do not implement against the new design by silently ignoring `AGENTS.md`.** The first implementation slice must update the project operating canon explicitly, then move runtime work forward under the new authority.

Notion remains the human-facing design canon. Repository Markdown is the structured implementation mirror. Runtime claims still require Godot/code/test evidence.

---

## 1. Product North Star

### One sentence

**A small storybook boat diorama where the player's visible avatar and pet quietly live, decorate, rest, and exchange slowly drifting bottle letters without turning the experience into a realtime social network.**

### Emotional priority

1. Rest and comfort.
2. Personal attachment to avatar, pet, and boat.
3. A sense that the boat is "my small place".
4. Gentle object and pet interaction.
5. Unexpected human warmth through bottle letters.
6. Collection and customization as memory, not optimization.

No new system may make efficiency, urgency, social status, streaks, FOMO, ranking, or response pressure more important than the above order.

---

## 2. Core experience shift

### Before

- Primary presentation: first-person sea appreciation.
- Player body not visible.
- Boat mainly functions as viewpoint/container.
- Bottle letters are authored ambient content only.
- Online social exchange prohibited.

### After

- Primary presentation: **3/4 diorama camera** showing the player's avatar, pet, boat, decorations, and sea together.
- Optional **Appreciation Camera** preserves the existing close sea-view/first-person-like relaxation mode.
- Boat becomes a personal living space with low-pressure decoration and interaction.
- Bottle letters become two systems:
  - `FriendBottle`: delayed direct correspondence with an accepted friend.
  - `DriftBottle`: delayed, limited correspondence with an unknown user.
- Online scope stays isolated to social identity + bottle delivery + safety operations. Voyage, pet, decoration, album, fishing, soundscape, and rest loop remain local-first.

---

## 3. Camera and avatar design

### Primary camera: 3/4 Boat Diorama

Requirements:

- Show avatar + pet + useful portion of boat + horizon in one calm composition.
- Keep camera movement slow, bounded, and predictable.
- Mobile portrait remains the primary screen constraint.
- Camera should not constantly follow tiny avatar movement with aggressive easing.
- The player's decorations must remain readable without covering the sea.

### Appreciation Camera

The existing appreciation idea is preserved, not deleted.

Entering Appreciation Camera:

- hides most nonessential UI;
- shifts framing toward sea/horizon;
- may place the avatar/pet at the edge or temporarily out of frame;
- does not stop the voyage timer or soundscape;
- does not increase rewards.

This keeps the previous Resting Core investment useful while allowing a visible player character during normal play.

### Avatar MVP

Visible avatar customization starts with only:

- body/base preset;
- hair;
- top;
- bottom;
- head accessory;
- one small accessory slot;
- color variants.

No stat bonuses are attached to cosmetics.

Avatar low-pressure actions:

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

## 4. Boat decoration design

### Selected approach: slot-zone decoration

Use explicit decoration zones instead of a freeform 3D editor for the first implementation.

Recommended initial zones:

1. bow-left;
2. bow-right;
3. center-left;
4. center-right;
5. rear-left;
6. rear-right;
7. wall/rail accent;
8. pet corner.

Each zone accepts a small compatible category set.

### Why this approach

- predictable touch controls on portrait mobile;
- lower overlap/clipping complexity;
- lower save-data complexity;
- easier camera composition;
- easier to keep the boat visually calm;
- compatible with later upgrade to constrained free placement if Human tests justify it.

### Decoration reward rule

Decor should represent memory and self-expression, not power.

Good examples:

- lantern;
- mug;
- cushion;
- blanket;
- plant;
- framed voyage photo;
- shell;
- postcard;
- bottle shelf;
- pet cushion.

Rejected as core:

- rarity score;
- decoration DPS/stat bonuses;
- gacha pressure;
- daily limited shops;
- optimization bonuses for filling every slot.

---

## 5. Interaction architecture

Create one reusable interaction contract instead of implementing each prop as a special case.

Conceptual interface:

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

Interaction constraints:

- no rapid repeated tapping for progression;
- no failure penalty for ignoring interactions;
- no interaction that forces the player to interrupt Appreciation Camera;
- repeated interactions may vary animation/dialogue but must not become optimal farming.

---

## 6. Delayed Bottle Social overview

The social feature is deliberately **not realtime chat**.

### Common properties

- text only in MVP;
- maximum 400 Unicode characters per letter;
- one optional sticker from a developer-curated sticker set;
- no user photo/file/audio attachment in MVP;
- no typing indicator;
- no online/presence indicator;
- no read receipt;
- no public profile browsing;
- no follower/following counts;
- no public feed;
- no global chat;
- no ranking or popularity score;
- every sent message travels through a server-side delivery pipeline.

### Healthy-backend delivery target

`TARGET_DELIVERY <= 5 minutes` means the message is **server-receivable** by the recipient under healthy backend/network conditions.

It does not guarantee a visible phone notification within 5 minutes if the recipient is offline, the app is closed, or backend/network service is degraded.

Selected timing:

```text
server moderation/validation budget: <= 5 sec normal path
deliver_at offset: random 45..210 sec
active-client poll interval: 20..30 sec
healthy-path worst target: normally <= 245 sec
safety margin to product target: 55 sec
```

The random delay is intentional product behavior, not technical latency.

---

## 7. FriendBottle

### Purpose

Slow correspondence with a known in-game friend without turning the game into a messenger.

### Identity

Friend relationships require a **durable linked account**. An anonymous temporary account may play the local game and use offline systems, but must be linked before creating a durable friend relation.

Allowed durable login methods can be implemented incrementally, but the architecture must support linking the existing anonymous account instead of replacing its user id.

### Flow

```text
select friend
→ write <= 400 chars + optional curated sticker
→ server validation/moderation
→ deliver_at assigned 45..210 sec later
→ stored in friend's inbox
→ active client discovers it at next poll
→ friend may reply with another delayed bottle
```

FriendBottle still has delay. It must not become an instant-message bypass.

Rate limit baseline:

- max 10 FriendBottle sends per hour;
- max 50 FriendBottle sends per day;
- server-enforced, not client-only.

---

## 8. DriftBottle for unknown users

### Purpose

Create the feeling that a letter drifted from another quiet boat, not that the player entered random chat.

### Eligibility

MVP safety profile:

- Terms/Community Guidelines accepted;
- self-declared age **16+** for stranger matching;
- account at least 10 minutes old;
- at least one completed 5-minute voyage;
- not currently rate-limited or restricted;
- client may be anonymous-authenticated, but server identity is still a unique authenticated user id.

Declared users under 16 do not receive/send `DriftBottle`; they may use local systems and, where account policy allows, `FriendBottle` only.

### Stranger identity

The recipient does not receive the sender's durable account identifier or global profile.

Each stranger correspondence gets an ephemeral server-generated pen-name, for example adjective+nature-noun+number. The alias is scoped to that correspondence only.

No search can resolve that alias back to a global account.

### Matching

Server selects an eligible recipient who:

- is not the sender;
- is not blocked in either direction;
- has not been recently over-matched with the sender;
- is eligible for stranger bottles;
- is within inbox capacity limits.

### Limited stranger correspondence

A stranger pairing may exchange at most **3 round trips** (maximum six letters total) before continuation requires a mutual friend opt-in.

At the limit:

- either side may end silently;
- either side may request `Continue as friends`;
- only if both independently accept does the relationship become a durable `Friendship`;
- no external contact information is revealed automatically.

This intentionally prevents infinite anonymous-chat threads.

Rate limit baseline:

- max 3 new DriftBottle sends per hour;
- max 10 new DriftBottle sends per day;
- replies count toward the same stranger-social budget;
- server-enforced.

---

## 9. Safety, moderation, and store compliance

Bottle letters are UGC. Safety is a release requirement, not post-launch cleanup.

### Required before public stranger matching

- Terms of Use / Community Guidelines acceptance before sending UGC;
- clearly defined prohibited content;
- server-side pre-publication filtering;
- report content;
- report user;
- block user;
- immediate local hide after report/block;
- moderation review queue;
- developer contact/support path;
- data retention/deletion policy;
- age gating described above;
- abuse/rate limiting;
- audit receipt for moderation action.

### Content restrictions in MVP

Block or quarantine:

- URLs;
- email addresses;
- phone numbers;
- obvious social handles / external contact exchange patterns;
- sexual solicitation;
- threats;
- targeted harassment;
- hate/abusive content;
- self-harm encouragement;
- exploitation/grooming patterns;
- spam/repetition patterns.

### Moderation pipeline

```text
send request
→ authentication + eligibility
→ normalization
→ length/sticker schema validation
→ contact/URL deterministic filter
→ rate limit
→ server-side semantic moderation adapter
→ ALLOW / REJECT / QUARANTINE
→ only ALLOW enters delivery queue
```

The semantic moderation adapter is server-only. Godot never contains a provider secret.

**Release gate:** `DriftBottle` remains server-feature-flag OFF unless a production moderation adapter, report/block flow, and moderation operation path are all working in the deployed environment.

### App-review positioning

The product must remain a rest/boat/decor game with an incidental bottle-letter feature. Do not redesign the home screen or marketing so random stranger communication becomes the app's primary purpose.

References checked during design:

- Apple App Review Guidelines 1.2 User-Generated Content, including 2026 clarification for random/anonymous chat.
- Google Play Developer Program UGC policy requiring terms, moderation, in-app report and block.

---

## 10. Backend trade study

### A. Supabase — SELECTED FOR MVP

Provides in one stack:

- anonymous Auth;
- account linking path;
- Postgres relational model;
- Row Level Security;
- Edge Functions;
- enough free-tier capacity for development and small closed testing.

Current published Free-plan reference at design time:

- 500 MB database per project;
- 50,000 MAU;
- 500,000 Edge Function invocations;
- 2 million Realtime messages;
- Free projects may pause after one week of inactivity.

We **do not need Supabase Realtime for bottle delivery**. Polling is selected because it supports the product fiction and reduces complexity.

Risk: Free-plan pause means the 5-minute target cannot be treated as a hard uptime SLA on a dormant free project. Public-launch hosting is a separate deployment Gate.

### B. Cloudflare Workers + D1 — STRONG ZERO-COST ALTERNATIVE

Current free reference at design time:

- Workers: 100,000 requests/day;
- D1: 5 million rows read/day;
- D1: 100,000 rows written/day;
- 5 GB total free D1 storage;
- no equivalent inactivity pause, but daily limits fail closed when exhausted.

Advantages:

- excellent small-service cost profile;
- explicit server function layer;
- good fit for a narrow bottle service.

Disadvantages:

- no integrated user/friend authentication model comparable to Supabase Auth+RLS;
- more custom security/account work;
- increases implementation surface for a solo project.

Decision: keep as migration/fallback option if Supabase operational cost or pause behavior becomes a real release problem.

### C. Firebase Auth + Firestore — REJECT FOR CURRENT MVP

Current free Firestore reference:

- 1 GiB storage;
- 50,000 document reads/day;
- 20,000 document writes/day;
- 10 GiB outbound/month;
- anonymous authentication supported.

Advantages:

- mature mobile auth;
- straightforward anonymous-to-linked account path.

Disadvantages:

- message/friend/report relations are less natural than Postgres for this design;
- server-side moderation/routing adds another function/deployment concern;
- cost behavior is read/write-operation centered and easier to make noisy with polling if queries are poorly structured.

Decision: not selected.

---

## 11. Selected backend architecture

```text
Godot 4.7
├─ local voyage / pet / decor / album / fishing / soundscape
├─ SocialSession
│  ├─ anonymous auth bootstrap
│  ├─ linked-account state
│  └─ feature eligibility
└─ BottleClient
   ├─ send_friend_bottle()
   ├─ send_drift_bottle()
   ├─ poll_inbox()
   ├─ reply()
   ├─ report()
   ├─ block()
   └─ request_friendship()
        │
        ▼
Supabase
├─ Auth
├─ Postgres + RLS
├─ Edge Functions
│  ├─ send-bottle
│  ├─ poll-inbox
│  ├─ bottle-action
│  ├─ friendship-action
│  └─ moderation/report intake
└─ tables
   ├─ profiles
   ├─ social_consents
   ├─ friendships
   ├─ bottle_threads
   ├─ bottles
   ├─ blocks
   ├─ reports
   └─ moderation_actions
```

Do not expose direct table write access for sensitive social state when an Edge Function can enforce the full invariant atomically.

---

## 12. Data model

### `profiles`

- `user_id uuid primary key` → auth user;
- `display_name text` → visible only where policy allows;
- `age_bucket enum('under16','16plus')`;
- `social_status enum('local_only','stranger_eligible','restricted')`;
- `created_at timestamptz`;
- `linked_identity boolean`.

### `social_consents`

- `user_id uuid`;
- `terms_version text`;
- `community_version text`;
- `accepted_at timestamptz`;
- primary key `(user_id, terms_version, community_version)`.

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
- `round_trip_count int default 0`;
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
- `deliver_at timestamptz`;
- `delivered_at timestamptz nullable`;
- `read_at timestamptz nullable`;
- `moderation_state enum('allow','reject','quarantine')`;
- `status enum('queued','available','read','deleted','expired')`.

Database constraints must enforce `length <= 400` at the storage boundary as well as the Edge Function.

### `blocks`

- blocker user;
- blocked user;
- timestamp;
- unique pair.

A block immediately prevents future matching, thread continuation, and friend sends in both delivery checks and routing.

### `reports`

- reporter;
- reported user;
- bottle id;
- reason enum;
- freeform detail optional and length-limited;
- status;
- created timestamp.

### `moderation_actions`

- report/bottle reference;
- action enum;
- actor/system identifier;
- reason code;
- timestamp.

---

## 13. RLS and access boundaries

Minimum principles:

- users can read their own profile and only approved public friend-facing fields of accepted friends;
- users can read bottle content only when they are sender or recipient;
- client cannot arbitrarily assign `recipient_id` for stranger matching;
- client cannot set `moderation_state=allow`;
- client cannot shorten `deliver_at`;
- client cannot bypass rate limits by writing directly to `bottles`;
- blocked relationships are checked server-side before every route/send;
- moderation/report tables are not broadly readable;
- service-role credentials never ship in Godot.

Use authenticated user JWTs. Anonymous Auth users are still authenticated identities and must be distinguished by claim/account state where social policy requires it.

---

## 14. Offline and failure behavior

### Sending while offline

- local draft may be saved;
- UI says the bottle has **not left the boat yet**;
- retry only after connectivity returns;
- do not fabricate a `deliver_at` before server acceptance.

### Recipient offline

- bottle becomes available in server inbox at/after `deliver_at`;
- it remains unread until next successful poll/session;
- no push notification is required in MVP.

### Moderation unavailable

- fail closed for `DriftBottle`;
- FriendBottle may also fail closed until the required production safety policy says otherwise;
- never silently route an unmoderated stranger message.

### Backend paused/degraded

- client shows a calm non-urgent state such as "오늘은 바다가 조금 멀리 흐르고 있어요";
- no streak or reward loss;
- local voyage/rest loop remains fully playable.

---

## 15. Privacy and data minimization

MVP social backend should not require:

- phone contacts;
- precise location;
- address book upload;
- public social graph;
- real-world name;
- user photos;
- voice data.

The bottle subsystem stores only what is necessary for authentication, social eligibility, routing, content moderation, blocking/reporting, and user-requested friendship.

External contact exchange is filtered in stranger correspondence so an ephemeral stranger alias does not become an accidental doxxing channel.

---

## 16. Integration with the rest loop

Bottle social must remain ambient.

### Arrival presentation

Do not use a loud push-style popup while the player is resting.

Preferred in-game treatment:

- a bottle quietly appears near the boat / bottle basket;
- small optional visual indicator;
- no countdown;
- no "reply now" pressure;
- unread bottles persist until the player chooses to read them.

### Rewards

Receiving or replying to human bottles must not grant an economy advantage large enough to force social play.

Permissible soft rewards:

- memory entry;
- decorative postcard frame;
- album log;
- optional cosmetic sticker unlock after broad milestones.

Rejected:

- daily reply streak;
- social currency farming;
- rarity ranking;
- response-time bonus;
- public popularity score.

---

## 17. Implementation decomposition after spec review

This architecture is too broad for one implementation PR. It must be split into independently testable slices.

Recommended order:

1. **Canon migration + Diorama camera/visible avatar shell**  
   Update AGENTS/Notion/repository direction, preserve Appreciation Camera, add avatar placeholder and camera contract. No backend.

2. **Local decoration + Interactable contract**  
   Slot zones, local save model, 3–5 representative props, pet/rail/cup interactions. No online dependency.

3. **Social fake-backend contract**  
   Godot `BottleClient` interface + deterministic local fake implementing delayed FriendBottle/DriftBottle state transitions, tests for 5-minute target semantics, report/block, thread limits. No real cloud dependency yet.

4. **Supabase schema/Auth/RLS/Edge Functions**  
   Local Supabase development environment first, migration SQL, tests for unauthorized reads/writes, rate limits, delivery scheduling, block routing, stranger round-trip gate.

5. **Production moderation + release feature gate**  
   Server-side moderation adapter, terms acceptance, report queue, block/report UX. Stranger matching remains OFF until this slice passes.

6. **End-to-end delayed bottle integration**  
   Replace fake backend with real adapter under the same client interface; polling; offline drafts; friend linking; healthy-path delivery timing evidence.

7. **Human/device social-rest validation**  
   Verify bottle arrival feels ambient, not urgent; verify moderation/report/block discoverability; verify 5-minute target in real network conditions; verify local rest remains functional during backend failure.

Each slice gets its own TDD red/green cycle, PR, exact-head CI, adversarial review, and Notion sync.

---

## 18. Acceptance criteria for the architecture

The future implementation is only faithful to this design if all are true:

- normal gameplay visibly shows the player avatar and pet in a 3/4 boat diorama;
- Appreciation Camera still offers a low-UI sea-focused rest view;
- decoration has no stats or mandatory optimization;
- object/pet interactions are optional and low-pressure;
- FriendBottle and DriftBottle are delayed rather than realtime;
- healthy backend design keeps active-client server receipt under the 5-minute target;
- stranger communication has no directory, presence, typing, read receipt, or public feed;
- stranger thread cannot continue indefinitely without mutual friend consent;
- declared under-16 users cannot use stranger matching in the MVP safety profile;
- reports and blocks are accessible in-app;
- blocked users cannot be re-matched or deliver new bottles;
- UGC moderation happens server-side before stranger delivery;
- local voyage/rest/decor remains playable if social backend is unavailable;
- no service-role or moderation-provider secret ships in the Godot client;
- `DriftBottle` cannot be enabled for public release without the safety release gate.

---

## 19. Explicit non-goals

Not part of this design:

- realtime chat;
- voice/video chat;
- public timeline/feed;
- social follower system;
- location-based matching;
- dating/matchmaking mechanics;
- competitive popularity;
- online co-op movement in the same boat world;
- marketplace/trading;
- user-uploaded images/audio/files in bottle letters;
- unrestricted external contact exchange;
- backend dependency for basic single-player rest gameplay.

---

## 20. Design decision summary

**Selected product architecture:** `Rest-first Bondee Boat Diorama + Delayed Bottle Social`.

**Selected camera architecture:** 3/4 visible-avatar diorama for normal play + preserved Appreciation Camera for sea-focused rest.

**Selected decoration architecture:** fixed slot zones first.

**Selected interaction architecture:** reusable Interactable contract.

**Selected social model:** delayed FriendBottle + rate-limited/limited-thread DriftBottle; mutual consent required to convert strangers into friends.

**Selected backend for MVP:** Supabase Auth + Postgres/RLS + Edge Functions, with polling instead of Realtime.

**Selected safety posture:** stranger matching is an incidental, gated UGC subsystem and remains disabled until production moderation/report/block/terms operations are deployable.

**Selected cost posture:** develop on free/local-first infrastructure; re-evaluate hosting before public launch if Supabase Free pause/limits conflict with real delivery reliability.
