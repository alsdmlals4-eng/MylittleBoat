# AGENTS.md

Codex and other coding agents should follow this file when working in this repository.

## Project

Project name: `my little boat`
Engine: Godot 4.7 stable
Language: GDScript
Genre: rest-first cozy boat diorama / healing voyage game

Normal play shows a visible player avatar, pet, boat, decorations, and sea together through a calm 3/4 diorama camera. The existing sea-focused low-UI view is preserved as the optional `Appreciation Camera`.

Do not add combat, failure states, competitive systems, ads, payments, realtime/global/public chat, follower/ranking systems, or social pressure mechanics.

Online scope is allowed only for the approved delayed `FriendBottle` / `DriftBottle` subsystem and its required identity, moderation, report, block, consent, and safety operations. Voyage, rest, pet, decoration, album, fishing, and soundscape remain local-first and playable without the backend.

`DriftBottle` public enablement is forbidden until the approved release gate has production server-side moderation, Terms/Community Guidelines, 16+ age gating, in-app report/block, moderation operations, support contact, and verification evidence. See `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`.

## Authority bootstrap

Do not infer current project status from memory or past chats. Resolve current authority in this order:

1. Latest user instruction.
2. This `AGENTS.md` and project engine/data/safety constraints.
3. Current repository human-facing GDD, approved decisions, handoffs, planning/data/code/scenes/resources/tests, and actual runtime evidence.
4. Current adopted Base contract and routing needed for the task.
5. External references, past conversations, and inference.

### DOMAIN_SPLIT_CANON

- `REPOSITORY_HUMAN_FACING_CANON`: 사람이 읽고 비교·수정하는 Master GDD, Concept, Experience Bible, approved decision, visual lock, asset/provenance, Flow/Storyboard를 책임진다.
- `REPOSITORY_STRUCTURED_CANON`: Markdown·JSON·게임 데이터·GDScript·Scene·Resource·config·tests를 책임진다.
- `REPOSITORY_RUNTIME_TRUTH`: 실제 Godot 실행·test·log·screenshot/video evidence를 책임진다.
- `NOTION_LEGACY_DISCOVERY_ONLY`: 2026-08-28의 마지막 user-authorized migration receipt 뒤 이전 Notion page/database/attachment는 historical archive일 뿐, current truth, approval owner, read/write target, or completion gate가 아니다. 새 Notion read/write/sync를 시작하지 않는다. 예외적으로 사용자가 새 일회성 archive migration을 명시 요청한 경우에만 read-only로 대조하고 repository receipt로 닫는다.
- Google Sheets가 과거 자료로 남아 있더라도 unique 미이관 자료용 `MIGRATION_ONLY_UNTIL_REMOVAL` compatibility source일 뿐 신규 기본 작업공간이나 runtime 증거가 아니다.

Repository 문서 승인이나 정적 이미지가 runtime 구현 성공을 의미하지 않는다. 사람용 결정이 구조화 데이터나 구현 의미를 바꾸면 repository owner에 동기화한 뒤 구현·완료를 주장한다.

현재 `open/draft/ready` PR은 작업 시작 시 실제 GitHub 상태를 조회한다. 다른 workstream의 PR을 명시적 권한 없이 수정·흡수·종료·병합하지 않는다.

## Core Game Direction

Normal presentation:
- Visible player avatar + pet + boat + sea in a calm 3/4 diorama.
- `Appreciation Camera` shifts focus toward the sea/horizon and hides most nonessential UI.
- Camera mode changes must not alter voyage duration, rewards, or the persistent soundscape.

Core controls:
- Take Photo
- Appreciation Mode / Appreciation Camera
- Speed Control

Core loop:
- Launch directly into the normal 3/4 boat diorama. The device's local clock automatically chooses dawn, bright, sunset, or night; there is no startup selector and no saved atmosphere preference.
- Rest with the visible avatar and pet. Simply staying is complete play.
- Let low-density scenery pass naturally as active foreground time progresses. It is visual context, not a reward track or a task.
- Optionally use low-pressure interactions, photography, decoration, fishing, ambient discoveries, and delayed bottle letters as each slice is implemented.
- Open `꾸미기` only when desired to change cosmetic player appearance, companion species, or boat decoration.
- Drift for about 5 minutes, leave a personal voyage record if one is created, or continue resting.
- Do not present today’s mood, identity, pet, decor, light, or atmosphere as a requirement before the first boat view. Device-clock time affects visuals only and must not change rewards, progress, or saves.

Supporting direction:
- Boat decoration is self-expression/memory, not stats or optimization.
- Object/pet interaction is optional and must not create chores or repeat-farming pressure.
- `FriendBottle` and `DriftBottle` are delayed correspondence, not instant messaging.
- Stranger bottle communication has no public directory, presence, typing indicator, read receipt, public feed, or popularity system.

Rewards:
- Companion affection.
- Scenery collection.
- Album-style collection.
- Personal boat memories/decor as implemented.

## Work Style

- Inspect the actual files before editing. Use `rg` or Godot project structure instead of relying on memory.
- State assumptions when the request is ambiguous. Ask before making risky product or architecture decisions.
- Prefer the smallest change that solves the request.
- Match the existing scene, node, script, and naming style.
- Avoid speculative abstractions, large rewrites, or broad cleanup.
- Do not revert, overwrite, or reformat unrelated user changes.
- If the worktree is dirty, understand whether the dirty files are related before editing them.
- Read real error messages and logs before applying a fix.
- For every material design, visual, or implementation decision, re-read the relevant current repository owner and fresh official primary-source documentation when it can affect feasibility, platform behavior, safety, or cost.
- Run an adversarial review after a material candidate: attack authority drift, player value, scope creep, implementation feasibility, evidence overclaim, visual/rights drift, and consumer ownership. Correct only the affected owner, then re-run the whole review until one clean pass remains.

## Godot Rules

- Use Godot 4.7 stable.
- Use GDScript unless explicitly requested otherwise.
- Keep scene and node structures simple.
- Use clear node names such as `TakePhotoButton`, `AppreciationButton`, and `AlbumView`.
- Keep UI mobile-friendly first, with PC mouse input where it makes sense.
- Keep core rest/voyage/decor/pet systems local-first; isolate approved bottle-social networking behind dedicated interfaces.
- Do not add combat, stamina, HP, enemies, damage, death, failure conditions, or ranking systems.
- Do not add realtime/global/public social features outside the approved delayed bottle design.
- Do not add paid assets or dependency-heavy plugins without explicit approval.
- Update `README.md` when setup, controls, scenes, or test steps change.

## File Header Comments

For new source files, add a one-line Korean comment at the top explaining the file's role.

GDScript example:

```gdscript
# 항해 화면의 기본 상호작용을 관리한다.
extends Control
```

Skip header comments for generated files, Godot scene files, `.import` files, lockfiles, and simple README placeholders.

## Planning

For small tasks, work directly after reading the relevant files.

For larger tasks that touch multiple scenes, scripts, or gameplay systems, briefly state:
- What will change.
- Which files or scenes are likely involved.
- How the change will be verified.

Create `checklist.md` or `context-notes.md` only for long-running, risky, or multi-session work. Do not create extra process files for small, self-contained changes.

## Verification

If code, scenes, or project settings changed, run the smallest useful Godot check before marking the task complete.

Preferred checks:

```powershell
godot --headless --path . --quit
godot --headless --path . --scene "res://scenes/main_menu.tscn" --quit-after 1
```

Known Windows local fallback in this workspace:

```powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --quit
```

For UI-only or documentation-only changes, explain what was inspected instead of claiming gameplay was tested.

Final replies should include:
- What changed.
- What was verified.
- Any remaining risk or manual Godot check the user should perform.

## Commit Guidance

Commit only when one logical change is complete and the repository workflow expects it.

Good commit examples:
- `Improve AGENTS Godot guidance`
- `Add mood selection UI`
- `Fix album back button flow`

Do not mix unrelated gameplay, UI, documentation, and cleanup changes in one commit unless the user explicitly asks for a broad conversion.

## Korean Output

When replying to a Korean user, answer in Korean.

Write new human-facing project documentation in Korean. Keep Godot paths, APIs, status codes, and source identifiers in their exact original spelling where that prevents ambiguity.

Avoid ending Korean prose lines with a colon. Prefer a period, question mark, or exclamation mark. Colons are fine in code, paths, key-value examples, timestamps, and Markdown labels.

## Suggested Scene Structure

- `scenes/main_menu.tscn`
- `scenes/game.tscn`
- `scenes/album.tscn`

## Suggested Script Areas

- `scripts/core/`
- `scripts/ui/`
- `scripts/voyage/`
- `scripts/avatar/`
- `scripts/companion/`
- `scripts/album/`
- future approved social code should live behind a dedicated social/bottle boundary, not inside voyage state.
