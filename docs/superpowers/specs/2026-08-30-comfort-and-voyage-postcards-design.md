# 편안함 설정과 항해 포스트카드 설계

**상태:** `SPECIFIED / USER_AUTHORIZED_CONTINUATION`

**제품 정본:** [프로젝트 GDD](../../design/PROJECT_GDD.md), [휴식 경험 바이블](../../RESTING_EXPERIENCE_BIBLE.md)

**결정 근거:** 2026-08-30 사용자 승인 벤치마크. Townscaper·Tiny Glade의 무실패 자기표현, Unpacking·Dordogne의 시각 기억, Microsoft XAG 117의 움직임 완화 원칙을 이 프로젝트의 무목적·local-first 항해에 맞춰 변형한다.

## 1. 해결할 문제

현재 normal diorama의 보트는 명확한 부유감이 있으나, 강도를 조절할 방법이 없다. 움직임 민감도와 실제 기기 휴식감은 아직 Human evidence가 없다.

`사진찍기`는 현재 제목 문자열만 `GameState.photos`에 남기고, Album도 count와 최근 문자열만 보여 준다. 플레이어가 실제로 본 시간대·카메라·보트 구도가 다음 항해에 남지 않는다.

## 2. 채택한 범위

### A. Comfort Mode

`파도: 기본 → 잔잔 → 고요`의 세 local-only profile을 optional rest menu에 둔다.

| Profile | Motion scale | 의미 |
| --- | --- | --- |
| `standard` | `1.0` | 현재 승인된 부유감과 카메라 리듬을 유지한다. 기본값이다. |
| `gentle` | `0.5` | 보트·카메라·수면 접점의 부유 진폭만 절반으로 줄인다. |
| `still` | `0.0` | 보트·카메라·수면 접점의 자동 상하·롤 변화를 멈춘다. |

- profile은 `user://comfort_preferences_v1.cfg`에 로컬 저장한다.
- profile은 현지 시각 분위기, 항해 시간, 속도, 함께한 시간, ambient cadence, 보상, 저장된 꾸미기, 소셜 상태를 바꾸지 않는다.
- speed는 흐르는 시간과 기존 speed index의 의미를 유지한다. Comfort Mode는 **진폭**만 곱한다.
- 첫 화면은 계속 `쉬는 메뉴`만 보이고, Comfort button은 메뉴를 연 경우에만 보인다.
- audio volume, flash reduction, UI opacity는 이 slice에 넣지 않는다. 실제 Human motion/audio 검토 뒤 별도 slice에서 판단한다.

### B. Voyage Postcard

사진 버튼은 현재 정상 게임 뷰를 UI 없이 한 프레임 캡처하여 local PNG로 저장하고, Album은 최근 포스트카드 최대 세 장을 작은 가로 행으로 보여 준다.

- `RenderingServer.frame_post_draw` 뒤 `Viewport.get_texture().get_image()`를 읽고 PNG를 `user://voyage_postcards_v1/`에 저장한다.
- 실제 capture 직전에는 TopPanel, BottomPanel, RestMenuButton, DistantSceneryLabel만 잠시 숨기고 다음 frame 즉시 원상 복구한다. Captain/companion/boat/sea/time-of-day composition은 그대로 남긴다.
- each entry is a dictionary with `id`, `label`, `atmosphere_id`, and absolute local `image_path`.
- label is generated from the actual current atmosphere only. It contains no score, rarity, date streak, social identifier, or destination.
- `PhotoMemoryPersistence` keeps metadata in `user://voyage_postcards_v1.cfg`, validates malformed data, and drops metadata for missing image files.
- `GameState.photo_memories` is the durable postcard ledger. On load it rebuilds legacy `photos` labels so existing voyage records and summaries remain compatible.
- saving a postcard does not change together time, ambient memory, affection, speed, reward, decor, fishing, or bottle state.
- a failed capture or write restores UI, creates no fake text-only photo, and returns a quiet status message.
- no cloud sync, account, public sharing, likes, score, automatic deletion, gallery pagination, filters, or photo editing are in scope.

## 3. 구현 경계

| Owner | Responsibility |
| --- | --- |
| `scripts/core/comfort_preferences.gd` | profile normalization and ConfigFile persistence only |
| `scripts/core/photo_memory_persistence.gd` | PNG and postcard metadata write/load/validation only |
| `scripts/core/game_state.gd` | current local preference and durable photo-memory ledger, no viewport/UI code |
| `scripts/voyage/game_scene.gd` | apply motion scale; hide/restore UI around frame capture; request GameState store |
| `scenes/game.tscn` | optional `ComfortButton` in existing rest menu |
| `scenes/album.tscn`, `scripts/ui/album_view.gd` | show latest three valid postcard cards, no new scene route |

## 4. 보존해야 할 불변 조건

1. 실행 즉시 normal 3/4 diorama를 열고, 현지 시각만 atmosphere를 정한다.
2. `standard` profile은 기존 0.052 unit bob, 1.15 degree roll, camera rhythm의 현재 visual baseline을 유지한다.
3. `gentle` 및 `still`은 active foreground cadence와 voyage completion timing을 바꾸지 않는다.
4. normal, Look Around, Appreciation Camera의 local presentation contract와 each camera routing을 깨지 않는다.
5. postcard capture never includes a gameplay-changing mode switch and never makes Album or photo behavior social.
6. Album remains a quiet reflection surface. Postcards have no badge, completion count target, sorting score, or missing slot copy.
7. legacy process-lifetime `add_photo` stays available for existing test/legacy callers, but runtime `TakePhotoButton` uses the durable postcard path.

## 5. 검증 계약

1. missing or malformed comfort ConfigFile restores `standard`, and each valid profile round-trips.
2. switching profile does not alter voyage remaining seconds, speed index, together time, ambience, or decor state.
3. `gentle` produces half the standard boat/camera amplitude; `still` produces no automatic bob or roll at the same phase.
4. missing postcard storage restores an empty ledger. A real generated Image saves an accessible PNG and round-trips valid metadata.
5. missing PNG and malformed metadata do not appear as postcards.
6. saving a real postcard updates the durable ledger and legacy photo summary without altering unrelated gameplay state.
7. `TakePhotoButton` capture restores all UI visibility and records a nonempty local file only after a rendered frame.
8. Album shows real loaded textures for at most three newest valid postcard entries and does not add achievement or social copy.
9. existing focused contracts, headless smoke, and 540×960 GPU capture run after change. These are machine/runtime evidence only; Human motion, touch, text, and audio comfort remain `NOT_RUN`.

## 6. 후속 후보 에셋 범위

자연 모티프 6종과 치비 반응 프레임은 이 문서의 구현 범위가 아니다. `BRIEF_READY` 상태의 다음 slice로 분리한다. 후보 이미지는 current `HANDPAINTED_STORYBOOK_3D_DIORAMA` / `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT` 기준으로 생성한 뒤, 사용자 승인 전에는 정본 또는 runtime consumer에 연결하지 않는다.

## 7. 적대적 검토

| Attack | Finding | Decision |
| --- | --- | --- |
| Comfort profile could become a saved atmosphere preference | profile affects only physical movement amplitude | allowed local accessibility setting |
| Screenshot could capture menus or contain stale frame data | hide only listed UI and await post-draw before reading texture | explicit capture contract |
| Photo gallery could create collection pressure | no target count, reward, rarity, social sharing, or auto deletion | retain quiet latest-three presentation |
| Image persistence could corrupt user data | use a dedicated v1 config and directory; ignore malformed/missing records | isolate from ambient/decor/identity stores |
| New UI could break first-view calm | controls remain behind the existing rest menu | preserve direct-entry low UI |
