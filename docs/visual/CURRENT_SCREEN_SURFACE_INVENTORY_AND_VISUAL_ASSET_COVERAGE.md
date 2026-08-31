# 현재 화면·시각 asset consumer 정본

<<<<<<< HEAD
**복구 상태:** `REBUILT_FROM_CURRENT_RUNTIME_2026-08-31`

**역할:** 이 문서는 visual direction, 실제 runtime consumer, asset provenance, 화면별 evidence의 관계를 기록합니다. 사람용 게임 설명은 [프로젝트 GDD](../design/PROJECT_GDD.md)가, 코드 수준 상태는 [현재 Godot handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가 소유합니다.

## 1. authority와 evidence를 구분하는 법

| 구분 | owner | 뜻 |
| --- | --- | --- |
| 제품 방향 | `PROJECT_GDD.md`, 사용자가 승인한 visual decision | 플레이어가 실제로 보게 되어야 하는 것 |
| runtime consumer | Scene, GDScript, Resource, tests, captures | 현재 game이 실제로 소비하는 것 |
| visual source/provenance | asset binary, SHA-256, 이 inventory | 어떤 파일이 어디에서 왔고 어디에 연결됐는지 |
| Human evidence | 실제 사람의 기기·플레이 관찰 | 아름다움·편안함·가독성이 확인됐는지 |

Notion은 historical archive이며 이 문서의 current owner가 아닙니다. 생성 exploration, 사용자 승인, canonical copy, Godot runtime asset, renderer capture, Human/device evidence는 서로 교환할 수 없습니다.

## 2. 확정 visual grammar

| layer | Keep | Avoid |
| --- | --- | --- |
| 전체 | `HANDPAINTED_STORYBOOK_3D_DIORAMA`, 넓은 바다·하늘, 안정된 수평선, soft-matte painterly material | glossy photoreal CG, noisy micro-detail, 다른 게임의 trade dress |
| 캐릭터·동반자 | 둥근 silhouette, 큰 hair/fur mass, 절제된 셀 명암, 친근한 chibi 비율 | 과도한 유리눈, glamour fashion, generic AI doll feel |
| 보트·소품 | 생활감 있는 넓은 painted value, 바다를 가리지 않는 제한된 decor | 과밀 장식, stats/rarity visual language |
| 바다·빛 | 느린 water motion, 낮거나 중간 대비, `INDIGO_RAIN_REFLECTION` night | 강한 점멸, 과한 bloom, 위협적인 날씨 spectacle |
| camera/UI | rear 3/4 diorama와 low-UI Appreciation parity, compact `쉬는 메뉴` | 큰 panel이 first view를 가리는 구성 |

기본 Normal anchor는 chestnut-bob chibi player + round dog입니다. 이는 다른 cosmetic pair를 제거하거나 능력 차이를 주는 결정이 아닙니다. alternate A/B player, cat/rabbit/otter, `stripe`·`moon` cushion은 2026-08-31 사용자 일괄 승인 뒤 같은 soft-matte chibi family로 canonical runtime path에 등록됐습니다. 기본 C+강아지, `floral` cushion, Album의 실제 항해 postcard는 유지합니다.

## 3. 현재 제품 화면과 actual runtime surface

| screen_id | 제품에서의 의미 | actual runtime consumer | 상태 |
| --- | --- | --- | --- |
| `MLB-SCR-001` Direct boat entry | 실행 즉시 떠 있는 보트·동반자·바다를 보는 첫 장면 | `project.godot` → `scenes/game.tscn` | `IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-SCR-003` Normal voyage diorama | character, companion, boat, sea와 낮은 밀도의 풍경을 함께 보는 core surface | `game.tscn`, `boat_space.tscn`, `game_scene.gd` | `IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-OVR-004` Appreciation Camera | UI를 줄이고 수평선에 집중하는 선택 화면 | `AppreciationCameraRig`, `GameScene` | `IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-OVR-005` 꾸미기 | arrival 뒤 원할 때 local cosmetic state를 바꾸는 surface | DecorPanel, `DecorPreview`, identity/decor local storage | `IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human readability/touch `NOT_RUN` |
| `MLB-SCR-010` Album | 실제 사진·기억·함께한 시간을 보는 archive | `scenes/album.tscn`, `AlbumView` | `PARTIAL_IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| `MLB-SCR-001-LEGACY` main menu | 시작 전 identity/time/mood selection의 이전 slice | `main_menu.tscn`, `main_menu.gd` | `SUPERSEDED_RUNTIME_SLICE`, current entry가 아님 |

## 4. 기본 Normal과 Look Around asset 경계

| asset id | canonical consumer | state |
| --- | --- | --- |
| `MLB-LOOK-CHIBI-NORMAL-REAR-001`과 derived matte | default C+dog `BoatSpace/FinalDioramaCard`의 explicit chroma shader | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human/device comfort `NOT_RUN` |
| `MLB-LOOK-CHIBI-TRN-001..004` | `LookAroundPresentationRouter`의 port/starboard/aft/overhead exact routing | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human motion comfort `NOT_RUN` |
| `MLB-AMB-MOTIF-001..006` | current local-time bucket의 temporary `SeaBackdrop` | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human long-run observation `NOT_RUN` |

`FinalDioramaCard`는 기본 C+강아지 route에서만 사용한다. alternate pair는 동일한 `BoatSpace`의 layered `Sprite3D` route를 사용한다. 이 차이는 save 의미·voyage 시간·reward·soundscape를 바꾸지 않는다.

## 5. 승인 decor와 alternate 치비 family

`rail_accent=postcard`는 main rest composite에 합성하지 않는다. 이 선택은 independent `DecorPreview`의 rail face와 Album의 실제 항해 postcard에만 보인다. 기본 C+강아지 final composite은 `pet_cushion=floral`만 bow-side clear space에 표시한다.

| asset id | canonical file | consumer | state |
| --- | --- | --- | --- |
| `MLB-DECOR-CHIBI-CUSHION-FLORAL-001` | `assets/images/decor/pet_cushion/cushion_floral_chibi.png` | default C+dog bow-side `StorybookPetCushionSurface` | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-DECOR-CHIBI-POSTCARD-001` | `assets/images/decor/postcard/postcard_chibi_moonboat.png` | independent DecorPreview `TechnicalPostcardFace`, no main overlay | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |

### 5.1 2026-08-31 user-approved alternate chibi family

이 seven-asset batch는 기존 alternate player·pet과 unselected `stripe`·`moon` cushion의 고밀도/사실적 질감을, 현재 soft-matte chibi visual grammar에 맞추기 위해 제작했다. user가 제공한 치비 이미지는 큰 머리, 둥근 silhouette, 단순한 색 블로킹, 친근한 낮은 detail이라는 일반 reference로만 사용했으며 특정 캐릭터, 의상, 플랫폼 UI, 작가 또는 서비스의 고유 식별 요소를 재현하지 않았다. candidate bytes는 `docs/visual/generated/2026-08-31-alternate-chibi-family/`에 보존되고 아래 canonical file은 동일 SHA-256의 non-destructive sibling copy다.

| canonical asset id | preserved candidate source | canonical file and exact consumer | dimensions | SHA-256 | state |
| --- | --- | --- | --- | --- | --- |
| `MLB-ALT-CHIBI-001` | `candidate-player-a-soft-hooded-chibi.png` | `assets/images/runtime/chibi_alternates/avatar_a_soft_hooded_chibi.png` → `a_soft_hooded` Sprite3D | `1199×1312` | `FDEAA5D7C69445CCBD126101A44B2615D781D2E55C4E295F1FAAB3EE53E3634F` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-002` | `candidate-player-b-sailor-cape-chibi.png` | `assets/images/runtime/chibi_alternates/avatar_b_short_cape_chibi.png` → `b_short_cape` Sprite3D | `1214×1295` | `054C6EDBD0581D751331846761EFF26861B14B0489D230F7CBE1CD47103A7C88` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-003` | `candidate-pet-cat-chibi.png` | `assets/images/runtime/chibi_alternates/pet_cat_chibi.png` → `cat` Sprite3D | `1214×1295` | `ADA2EC057D77FEE2951915672C1B272D8D40102F526D78F3F3527FDAD54108A3` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-004` | `candidate-pet-rabbit-chibi.png` | `assets/images/runtime/chibi_alternates/pet_rabbit_chibi.png` → `rabbit` Sprite3D | `1214×1295` | `4E7110A3F84516E7676B807107E149244102F3360FB1B9B1B6F934FCE056DAF9` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-005` | `candidate-pet-otter-chibi.png` | `assets/images/runtime/chibi_alternates/pet_otter_chibi.png` → `otter` Sprite3D | `1312×1199` | `47793AE64210FDD3F586ABBE3C5567BD2441FB395A3C23A764205D671E2C2439` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-006` | `candidate-cushion-stripe-chibi.png` | `assets/images/decor/pet_cushion/cushion_stripe_chibi.png` → `pet_cushion=stripe` | `1254×1254` | `88F6C0081DBBE29139EC45D2F28C080E8B6A3579CB0C3AFB30D1561D2ECB5438` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-007` | `candidate-cushion-moon-chibi.png` | `assets/images/decor/pet_cushion/cushion_moon_chibi.png` → `pet_cushion=moon` | `1254×1254` | `AF0E460B7FBC21A8C4C3C775DF21D53E2432651D7FFD7B6E8D87E33B7469A6C2` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |

## 6. implementation and evidence receipt

- `IdentityVisualCatalog` resolves the existing `a_soft_hooded`, `b_short_cape`, `cat`, `rabbit`, and `otter` IDs to their seven-family canonical paths. Unknown IDs still normalize to the existing C+dog defaults.
- `boat_space.tscn` binds the five alternate `Sprite3D` cards to the canonical copies. It does not alter default `FinalDioramaCard` or Look Around routing.
- `DecorVisualAssets` resolves the existing `stripe` and `moon` appearance IDs to the canonical cushion copies. No save migration, reward, stats, or new slot was added.
- Candidate-to-canonical SHA-256 equality is checked for all seven files. Player/pet sources are transparent cutouts; cushion sources are opaque full-bleed textures.
- `test_identity_visual_contract.gd`, `test_runtime_image_asset_contract.gd`, and `test_runtime_capture_guard_contract.gd` pass after the rebind. The identity contract verifies the selected scene card's actual texture path, not catalog text alone.
- OpenGL 3.3 GPU capture `tests/capture_approved_alternate_chibi_family.gd` recorded `a+cat+stripe`, `b+rabbit+moon`, and `a+otter+stripe` at 540×960 in `docs/evidence/2026-08-31-approved-alternate-chibi-family/`.

## 7. machine-only shutdown-audio receipt

`RestingSoundscape` generates and plays its authored ocean bed only when a real display server is present. Headless machine checks keep the persistent `OceanBed` owner but do not allocate a silent generated `AudioStreamWAV`; normal runtime exit also explicitly stops playback and releases the generated stream. This is a test/runtime resource-lifecycle boundary, not a change to player-facing sound design.

`test_resting_core_contract.gd` covers the headless non-playback boundary and explicit release. The minimal `--headless --path . --quit --verbose` smoke now exits without the former two `ObjectDB` audio-instance warning. OpenGL runtime capture also exits without that warning. Human audio comfort remains `NOT_RUN`.

## 8. evidence ceiling and remaining review

The renderer evidence proves that the named resources loaded and appeared in controlled frames. It does not prove real-device color, touch reachability, long-session visual fatigue, motion comfort, or sound comfort. Those Human/device checks stay `NOT_RUN` until the user explicitly asks for human validation.
=======
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
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
