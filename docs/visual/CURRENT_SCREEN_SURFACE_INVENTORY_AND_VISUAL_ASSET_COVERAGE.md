# 현재 화면·시각 asset consumer 정본

**갱신일:** 2026-08-29

**역할:** 이 문서는 approved visual direction, 실제 runtime consumer, asset provenance, capture/Human evidence를 분리한다. 사람용 경험은 [프로젝트 GDD](../design/PROJECT_GDD.md), 구현 상태는 [current Godot handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가 소유한다.

## 1. 증거를 읽는 법

| 구분 | 뜻 |
| --- | --- |
| `APPROVED_DIRECTION` | user-approved visual grammar. source binary나 runtime 성공을 뜻하지 않는다. |
| `GENERATED_RUNTIME_ASSET` | current named consumer를 위해 생성해 repository에 둔 image binary. 독립 승인 board나 Human PASS가 아니다. |
| `GPU_CAPTURED` | 지정 renderer/해상도에서 해당 screen이 실제로 렌더됐다는 뜻이다. |
| `HUMAN_NOT_RUN` | 실제 기기·손·5분 휴식 경험을 아직 사람이 평가하지 않았다. |

Notion은 historical archive이며 current owner가 아니다. generated exploration board는 runtime asset이 아니고, runtime asset은 Human comfort evidence가 아니다.

## 2. current screen surface

| screen_id | player 의미 | actual consumer | 상태 |
| --- | --- | --- | --- |
| `MLB-SCR-001` Direct boat entry | 실행 즉시 보트·동반자·바다를 보며 머무르기 시작한다. | `project.godot` → `scenes/game.tscn`, menu-closed `GameScene` | `IMPLEMENTED_AND_GPU_CAPTURED`; `HUMAN_NOT_RUN` |
| `MLB-SCR-003` Normal voyage diorama | 3/4 boat, companion, sea, horizon과 낮은 밀도의 풍경을 함께 본다. | `scenes/game.tscn`, `scenes/boat_space.tscn`, `scripts/voyage/game_scene.gd` | `IMPLEMENTED_AND_GPU_CAPTURED`; `HUMAN_NOT_RUN` |
| `MLB-OVR-004` Appreciation Camera | UI를 줄이고 같은 바다·수평선에 집중한다. | `AppreciationCameraRig`, `GameScene._apply_camera_mode` | `IMPLEMENTED`; Human comfort `NOT_RUN` |
| `MLB-OVR-005` 꾸미기 | 바다를 본 뒤 원할 때 외형·동반자·장식을 고른다. | `DecorPanel`, `IdentityVisualRouter` | `IMPLEMENTED`; mobile touch `NOT_RUN` |
| `MLB-OVR-006/007` 사진·상호작용·낚시 | 원할 때만 쓰는 낮은 압력의 행동이다. | GameScene action panel/session | `PARTIAL_IMPLEMENTED` |
| `MLB-OVR-008` Ambient Discovery | 풍경이 조용히 지나가고 일부가 local memory가 된다. | `DriftSceneryDirector`, `DistantSceneryLayer`, `AmbientMemoryPersistence` | `IMPLEMENTED_AND_TESTED`; Human frequency `NOT_RUN` |
| `MLB-SCR-010` Album | 실제로 남은 개인 기억을 돌아본다. | `scenes/album.tscn`, `album_view.gd` | `PARTIAL_IMPLEMENTED`; auto background `IMPLEMENTED` |
| `MLB-SCR-001-LEGACY` 선택형 main menu | 과거 route이다. 제품 화면이 아니다. | `main_menu.tscn` compatibility redirect only | `SUPERSEDED_COMPATIBILITY_ROUTE` |

## 3. fixed visual grammar

| layer | Keep | Avoid |
| --- | --- | --- |
| 전체 | `HANDPAINTED_STORYBOOK_3D_DIORAMA`, 넓은 바다와 안정된 수평선, soft matte painterly value | glossy photoreal CG, noisy micro-detail, 다른 게임의 trade dress |
| 캐릭터·동반자 | `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`, 둥근 silhouette, 큰 hair mass, 절제된 셀 명암 | 큰 유리눈, glamour fashion, generic AI doll feel |
| 보트·물 | hull-water contact, 낮은 wake/occlusion, 느린 predictable bob | 보트가 sky 위에 붙은 듯한 빈 틈, 과한 foam, 빠른 흔들림 |
| 바다·빛 | 실제 현지 시간 tone, 넓은 sky/sea 비율, `INDIGO_RAIN_REFLECTION` night | 강한 점멸, neon reflection, 위협적인 날씨 spectacle |
| UI | 처음에는 compact `메뉴`만, action은 의도적으로 열었을 때 | 큰 selection panel이 first view를 가리는 구성 |

기본 character/companion anchor는 C loose-knit/long hair + dog다. 다른 cosmetic pair를 제거하거나 power difference를 만드는 결정은 아니다.

## 4. runtime asset consumer와 provenance

| asset | consumer | runtime role | provenance / rights | validation |
| --- | --- | --- | --- | --- |
| `assets/images/runtime/storybook/sea_bright_storybook.png` | 두 camera `SeaBackdrop`, album default background | dawn/bright/sunset base sea art | existing project asset | direct-entry GPU capture |
| `assets/images/runtime/storybook/sea_night_indigo_rain_storybook.png` | 두 camera `SeaBackdrop`, album night background | dedicated night sea art | `GENERATED_RUNTIME_ASSET`, built-in image generation 2026-08-29; no external reference copied | path contract + night GPU capture |
| `assets/images/runtime/storybook/boat_waterline_storybook.png` | `BoatSpace/BoatWaterlineOverlay` | hull-water wake/occlusion | `GENERATED_RUNTIME_ASSET`, built-in image generation 2026-08-29; no external reference copied | direct-entry GPU capture |
| `assets/images/runtime/scenery/distant_buoy_storybook.png` | `DistantSceneryLayer` dynamic `TextureRect` | far buoy silhouette | `GENERATED_RUNTIME_ASSET`, built-in image generation 2026-08-29; no external reference copied | runtime consumer contract |
| `assets/images/runtime/scenery/distant_islet_storybook.png` | same | far small-islet silhouette | `GENERATED_RUNTIME_ASSET`, built-in image generation 2026-08-29; no external reference copied | visible GPU capture |
| `assets/images/runtime/scenery/distant_lighthouse_storybook.png` | same | far lighthouse silhouette | `GENERATED_RUNTIME_ASSET`, built-in image generation 2026-08-29; no external reference copied | runtime consumer contract |

These five generated source files are project runtime assets, not comparison boards, not a batch of separate gameplay systems, and not evidence of Human approval. They contain no external game logo, character, UI, or copied reference expression.

## 5. runtime capture

| evidence file | what it proves | what it does not prove |
| --- | --- | --- |
| `docs/evidence/2026-08-29-direct-boat-entry/dawn_normal_540x960.png` | dawn direct-entry render | device comfort/performance |
| `bright_normal_540x960.png` | bright direct-entry render and boat-water contact | 5-minute calm |
| `sunset_normal_540x960.png` | sunset tone in the same composition | real system-time boundary transition |
| `night_normal_540x960.png` | dedicated indigo-rain night sea + warm boat light | night readability to a player |
| `bright_distant_islet_540x960.png` | actual horizon islet consumer can render | normal 90–150 second timing; capture moves it into frame solely for observation |

See [evidence README](../evidence/2026-08-29-direct-boat-entry/README.md) for renderer, target resolution, and limitations.

## 6. adversarial visual receipt

| failure assumption | finding | correction | status |
| --- | --- | --- | --- |
| generated night art shares no stable camera/horizon grammar | first candidate put the sea too low | regenerated night art with a horizon matching the bright composition, then re-captured | `CORRECTED` |
| boat and sea are separate stickers | first capture exposed a hull-water gap | added a named wake/occlusion consumer in `BoatSpace` | `CORRECTED` |
| 3D scenery is assumed visible without proof | background Sprite3D was hidden by camera backdrop | used input-free 2.5D horizon overlay and wrote a runtime test | `CORRECTED` |
| generated asset equals finished UX | capture can overclaim visual calm | keep Human first 30 seconds/5 minutes/touch/audio as `NOT_RUN` | `CLEAN` |

## 7. current visual next action

No production asset batch starts from this work. The next visual gate is a human device pass: boat-water contact, companion readability, menu discovery, time-tone transition, distant-scenery density, and notification presence must be judged at gameplay size before additional asset work.
