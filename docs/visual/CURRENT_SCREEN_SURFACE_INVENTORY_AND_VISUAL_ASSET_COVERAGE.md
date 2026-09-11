# 현재 화면·시각 asset consumer 정본

**복구 상태:** `REBUILT_FROM_CURRENT_RUNTIME_2026-08-31`

**역할:** 이 문서는 visual direction, 실제 runtime consumer, asset provenance, 화면별 evidence의 관계를 기록합니다. 사람용 게임 설명은 [프로젝트 GDD](../design/PROJECT_GDD.md)가, 코드 수준 상태는 [현재 Godot handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가 소유합니다.

## 1. authority와 evidence를 구분하는 법

**2026-09-11 분리본 확정 후 실행.** 최신 `확정하고 진행해`는 분리본 외형과 후면 모션 연결을 승인한다. [분리본 승인·원본/런타임 해시·consumer 기록](candidates/2026-09-11-blueprint/stern-motion-parts-v1.receipt.json)이 책임 owner다. 승인 RGBA를 변경 없이 runtime 경로로 복사하고 `FinalDioramaCard → PartsViewport → Hull/Player/Pet/SternRail`로 조립한다. 새 재질은 자홍색 잔여색만 보정한다. 이는 기본 외형/후면 slice이며 구형 측면·후면 각도 카드와 다른 외형은 아직 교체되지 않았다. Aseprite frame export는 현재 분리 AtlasTexture와 위상 기반 움직임에 필수가 아니므로 미사용이며 1-frame 파일을 모션 완료로 생산하지 않는다.

**2026-09-11 최신 교정.** 사용자가 수정본의 실제 적용을 요청했다. 외형 기준은 `candidates/2026-09-10-intimate-diorama/stern-staging-no-oars-v3.png`이며 SHA-256은 `4f33cad8273699cb84eb19c875c3a0521adc79e49c283e80d802d716c0ddd3c5`다. 현재 구형 production art와 동일하다고 취급하지 않는다. v3는 한 장의 RGB 구도 이미지로, 독립 캐릭터 모션/옆면/3D 모델 준비를 뜻하지 않는다. 아래 기존 texture 재사용은 이전 작업의 사실이며 최신 교정 요청의 완료 조건이 아니다. 파생 분리 자산은 원본 외형 유지 검사와 실제 consumer 연결 전까지 후보다.

**2026-09-11 후속 이동 구현 승인.** 기존 runtime 수면·선체·접점 consumer의 이동 연출 개선은 최신 사용자가 직접 승인했다. 새 candidate art 등록 없이 기존 승인 texture를 재사용한다. 수면 shader의 원근/두 위상 교차/시선 상대 흐름은 [이동 검증](../evidence/2026-09-11-voyage-motion/REVIEW.md)이 소유한다. 새로운 3D 모델·전체 Blueprint·Human 승인은 여전히 별도다.

| 구분 | owner | 뜻 |
| --- | --- | --- |
| 제품 방향 | `PROJECT_GDD.md`, 사용자가 승인한 visual decision | 플레이어가 실제로 보게 되어야 하는 것 |
| runtime consumer | Scene, GDScript, Resource, tests, captures | 현재 game이 실제로 소비하는 것 |
| visual source/provenance | asset binary, SHA-256, 이 inventory | 어떤 파일이 어디에서 왔고 어디에 연결됐는지 |
| Human evidence | 실제 사람의 기기·플레이 관찰 | 아름다움·편안함·가독성이 확인됐는지 |

Notion은 historical archive이며 이 문서의 current owner가 아닙니다. 생성 exploration, 사용자 승인, canonical copy, Godot runtime asset, renderer capture, Human/device evidence는 서로 교환할 수 없습니다.

### 1.1 2026-09-02 standing image-production authorization

**2026-09-11 최신 override — BLUEPRINT_ASSET_PREPARATION_AUTHORIZED.** 필요한 실제 사용 규격 이미지와 아틀라스를 제작해 전체 Blueprint에 포함하라는 최신 지시가 아래 이미지 보류를 대체한다. 후보 제작·검수·Aseprite 패키징은 가능하지만 production 적용은 전체 Blueprint 최종 승인 후다. 신규 파일·출처·prompt·해시·미준비 항목은 [2026-09-11 candidate manifest](candidates/2026-09-11-blueprint/manifest.json)가 소유한다. 생성 성공을 final visual lock이나 모델/리그 준비로 쓰지 않는다.

신규 수면은 탑뷰 texture, 바위섬은 독립 원거리 RGBA, 밤하늘은 별도 배경 입력으로 준비한다. 바위섬 첫 RGBA는 색 fringe, 두 번째 편집은 실제 RGB checkerboard 실패가 발생했다. 이미지 모델의 magenta 원본을 프로젝트 기존 shader의 격리 렌더로 추출해 alpha/padding을 검사했다. Aseprite native MCP로 1-frame .aseprite 및 PNG+JSON을 왕복 검증했다. 정적인 섬의 100ms metadata는 animation 제작 증거가 아니다. 얇은 edge tint·실제 수면 반복·시간대·각도 적용은 여전히 검토 대상이다.

**2026-09-10 현재 override — IMAGE_PRODUCTION_PAUSED_FOR_PLANNING.** 사용자가 이미지를 바로 작업하지 말고 제작에 필요한 전체 기획부터 조사·정리하도록 지시했다. 아래 standing authorization과 후속 후보 준비 순서는 역사적 기록이며 현재 이미지·모델 생성/편집·runtime 연결을 시작하는 권한이 아니다. 새 계획은 GDD의 통합 제작 기획 P1–P10이 소유한다. 기존 승인/후보/분리 배치 파일은 삭제·재생성·정본 승격 없이 보존한다. 현재 작업은 기획·명세·자료 조사이며 새 최종 visual lock, 3D family, 모션 state는 아직 준비되지 않았다.

사용자는 기존 visual grammar와 실제 consumer 안에서 필요하다고 판단된 이미지를 per-file approval 없이 제작·등록·연결·검증하도록 승인했습니다. 따라서 concrete runtime consumer, current art direction, dimensions, state family와 rollback 계획을 먼저 확인한 뒤 candidate stop 없이 권장 경로를 계속할 수 있습니다. 생성 뒤에는 provenance와 source/canonical SHA-256을 기록하고 runtime consumer와 renderer evidence를 연결합니다. 이 standing authority는 새 게임 의미·새 public surface·새 asset family의 final visual lock·비용·권리 불명 source를 자동 승인하지 않으며, image generation·canonical registration·runtime implementation·Human/device acceptance는 계속 별도 상태로 기록합니다.

## 2. 확정 visual grammar

2026-09-10 최신 사용자 지시에 따라 이 절의 확정 grammar는 **기존 runtime family의 역사적 승인과 현 consumer**를 설명한다. 새 재기획의 최종 visual lock은 아니다. 새 제품 방향은 [GDD 첫 절](../design/PROJECT_GDD.md)이 소유하며, 기존 이미지를 참고자료로만 삼아 새 후보를 제작한다. 구형 자산은 소비처 교체·검증 전까지 보존한다.

### 2026-09-10 새 방향 후보

- ID `MLB-REDESIGN-VOYAGE-CANDIDATE-001`, 상태 `USER_APPROVED_DIRECTION_REFERENCE / NOT_RUNTIME_ASSET`. 2026-09-10 사용자의 “오 멋지다, 좋아 권장안대로 계속 진행해”를 해당 그림체·분위기 기준 승인으로 기록한다. 전체 Blueprint·애니메이션·runtime 승인은 아니다.
- 경로 [항해 방향 후보](candidates/2026-09-10-intimate-diorama/voyage-direction-v1.png), 실제 규격 `941×1672 PNG`. 소비 목적은 GDD의 새로운 후면 항해 장면 검토다. production consumer는 없다.
- provenance는 현재 세션 built-in image model의 신규 생성이며 기존 이미지 파일을 입력하거나 다른 게임의 실제 자산을 복사하지 않았다. 생성 원본은 호스트 generated_images에 보존하고 동일 바이트를 이 후보 경로에 복사했다.
- SHA-256 `D92FC294C27F83A8CBA9FE6DF5B99ED8B507FA654E82DC785E71B9C27B35A957`.
- 검토 결과는 후면 플레이어·옆 동반자·열린 중앙 항로·선체 접점이 읽힘. 수면의 작은 밝은 무늬는 모션에서 과밀할 위험이 있고, 배의 크기·중심은 최종 540×960 UI와 함께 다시 맞춰야 함. 정적 후보이므로 전진·편안함·키포즈 일관성은 미검증.
- Aseprite는 현재 세션의 native candidate 도구가 `CLIENT_DISCOVERED`다. 이 한 장의 opaque 구성 검토 이미지에는 frame/layer packaging consumer가 없어 호출하지 않았다. `CALL_VERIFIED`, `TASK_VERIFIED`, animation/runtime/Human PASS를 주장하지 않는다.
- 다음 생성은 이 방향 검토 결과를 반영한 일관된 캐릭터/동반자 식별 및 키포즈 준비다. 이 이미지의 물을 그대로 잘라 움직이는 production 배경으로 사용하지 않는다.

생성 prompt 요약(원문 의미 보존)은 다음과 같다. `stylized-concept; one original portrait 9:16 My Little Boat rest-first voyage; cohesive hand-painted anime picture-book, simple cel shading, friendly chibi; rear elevated 3/4; ivory wooden boat near lower fifth, reclining player in pale blue oversized hooded jacket with soft short dark hair, cream fluffy dog visible beside; transparent turquoise sea, pale sand, soft deeper horizon, narrow hull contact and subtle trailing wake; clear central sea lane, small distant side islands; calm daylight; no UI, text, watermark, destination, glossy doll, neon or named-artist imitation.` 결과는 prompt의 이상적 요구 충족을 자동 보장하지 않으며 위 findings가 우선한다.

### 2026-09-10 동반자 키포즈 후보

`MLB-REDESIGN-POSE-001`은 [companion-keyposes-v1.png](candidates/2026-09-10-intimate-diorama/companion-keyposes-v1.png)에 보존한다. 상태는 `GENERATED_CANDIDATE / REVIEWED_WITH_FINDINGS / NOT_USER_LOCKED`다. 기존 승인 방향 이미지를 참조한 built-in image model 생성이며, consumer는 GDD 모션 검토 보드다. production consumer는 없다. SHA-256은 `29C40AC86354D2BECEB602CC1F6E54A7F29B561B0055EAF9680D12EF85E8BA62`다.

왼쪽→가운데→오른쪽은 휴식·작은 고개 들기·다시 기대기의 정적 키포즈다. 후면 player, pale-blue hoodie, dark hair, cream floppy-eared companion, ivory boat를 유지한다. 얼굴 전체·성별·전신 의상 등 승인 그림에 드러나지 않은 identity는 새로 확정하지 않는다. 몸·발·좌석 접점은 유지하고 머리와 시선만 작게 바꾸는 staging을 선택했다.

연출 근거는 2026-09-10 직접 읽은 [GDC animation 세션 공개 설명](https://www.gdcvault.com/play/1021657/Powerful-and-Effective-Animation-for)과 Base `sprite-pose-sequence-controls.md`다. 공개 설명의 keyframing·anticipation·timing 원칙을 `ADAPT`하되 전체 영상을 시청한 것으로 기록하지 않는다. 세 대안 중 큰 팔 동작/몸 이동은 휴식·접점 위험 때문에 `REJECT`, 무변화 idle만은 기준 포즈로 `ADOPT`, 작은 고개 반응 뒤 복귀는 친밀함 검토용으로 `ADAPT`했다. 새 보상·행동 의무·저장값은 없다.

직접 시각 검토에서 중앙 패널의 눈·머리 반응과 양끝 휴식 복귀가 읽히고 전반적 identity가 유지된다. 그러나 패널 사이 물무늬·노와 선체 세부가 완전히 같지 않고, 노 끝은 패널 경계에서 잘린다. 물은 이전보다 부드럽지만 여전히 무늬 밀도가 있다. 따라서 **잘라 이어 붙여 최종 animation으로 쓰지 않는다**. 배경·선체 고정 layer와 head/eye pose를 분리해 제작할 때 교정한다. duration·중간 프레임·alpha·pivot·실제 재생·Human은 미검증이다. Aseprite에 패널을 단순 프레임으로 포장하는 작업은 현재 보드의 목적과 맞지 않아 수행하지 않았다.

<details>
<summary>재현용 생성 prompt</summary>

```text
Use case: stylized-concept. Input image is the USER-APPROVED VISUAL AND IDENTITY REFERENCE, not something to redesign. Create ONE landscape 3-panel key-pose storyboard for My Little Boat using exactly the same cozy hand-painted anime rendering, the same small dark-tousled-haired player in oversized pale-blue hoodie, the same cream floppy-eared fluffy puppy, and same weathered ivory rowboat, cream stern cushion and wooden oars. All three panels same size, camera rear elevated three-quarter, same scale, boat position, rim, oars, cushion and light. Tight but complete view of boat and both occupants, little pale turquoise water around it, no land or sky needed. Preserve approved staging: player reclining against stern nearest viewer facing bow away, dog next to player on viewer right, both clearly visible. Never expose a newly invented frontal player face. Panel 1 resting: puppy head low relaxed, eyes closed, player's shoulders relaxed. Panel 2 small notice: puppy lifts ONLY its head modestly and looks toward the player's shoulder with calm open eyes, body and paws remain resting at same contact positions; player only slightly inclines head toward puppy, no reaching or waving. Panel 3 settling: puppy lowers head back toward cushion beside player's sleeve, eyes softly closing, player relaxed again. Small but clearly readable differences, no dramatic pose jumps, no new anatomy, no costume changes, no standing, no extra pets. Fixed seat/support contacts, consistent boat geometry and front-back orientation across panels. Water must be calmer and MUCH lower-contrast than reference, broad transparent aqua washes and sparse ripples not dense bright caustics. Thin contact at hull, no floating above water, no giant rings. White or pale paper narrow gutters between panels, no labels, no text, no arrows, no title or watermark. This is a visual key-pose study, NOT a final sprite atlas, do not fake an animation sheet with identical repeats. Warm and cute, simple readable silhouette.
```

</details>

### 2026-09-10 빈 선체 첫 분리 후보 — 과거 alpha 실패 기준선

`MLB-REDESIGN-HULL-001`은 [empty-hull-v1-alpha-blocked.png](candidates/2026-09-10-intimate-diorama/empty-hull-v1-alpha-blocked.png)에 보존한다. 상태 `GENERATED_CANDIDATE / BLOCKED_ALPHA / NOT_ASSET_READY / NOT_IMPLEMENTED`. approved voyage direction을 built-in image model의 참조로 넣고 사람·동반자·쿠션·가방·노·바다를 제거한 빈 선체를 요청했다. 가려졌던 좌석과 내부가 드러나는 후보는 만들어졌지만, 최초 생성과 한 번의 alpha 교정 모두 회색 checkerboard가 실제 RGB 픽셀로 포함됐다. transparent PNG 요청을 성공으로 처리하지 않는다.

보존 후보는 두 번째 출력 `941×1672 RGB`, SHA-256 `59C023C29B1517739D1E5F605D0488F1BAD6CBCF51B936062BF143A3EC3347F3`다. 첫 출력과 교정 출력은 host generated_images에 남아 있으며 production 자산으로 등록하지 않았다. 원본 대비 선체 크기/투영도 완전히 동일하지 않으므로 alpha 해결 후에도 승인 구도 및 분리 캐릭터와 overlay 검증이 필요하다. 이 그림에서 노·쿠션이 없는 것은 제거/폐기 결정이 아니라 독립 자산 제작을 위한 clean plate 범위다.

Aseprite native MCP `get_sprite_info`를 task-scoped staged copy에 실제 호출했다. 반환값은 `width=941,height=1672,color_mode=rgb,frames=1,layers=[Background],tags=[]`였다. 독립 Pillow readback도 `RGB`와 모서리 픽셀 `(202,202,203)`을 확인했다. Aseprite 상태는 이 read-only 작업에 한해 `CALL_VERIFIED`; 레이어 분리/export/animation/runtime 성공은 아니다. 도구가 보고한 기본 duration 100ms는 한 장 파일의 기본 메타데이터이며 모션 타이밍으로 채택하지 않는다.

이 최초 시도 당시 native 후보 도구에는 선택영역/마스크/배경 삭제 기능이 없어 자동 alpha 교정 소비처가 없었다. Aseprite 저장/시트 export만으로 alpha 해결을 가장하지 않았다. 이 파일 자체는 실패 기준선으로 남고, 후속 기존 Godot shader 재사용의 성공은 아래 별도 후보가 소유한다.

필수 readback 기준은 `RGBA 또는 유효 transparency metadata`, 외곽 alpha=0, 선체 내부 alpha 보존, checkerboard 잔존 없음, 좌석 복원과 silhouette 여백, source hash 및 원본 보존이다. 이미지 생성 요청 자체와 화면의 체크무늬만으로 투명도를 판정하지 않는 것을 제작 교훈으로 기록한다.

### 2026-09-10 독립 layer 기술 후보 — alpha 복구

상태는 `GENERATED_CANDIDATE / REVIEWED_WITH_FINDINGS / NOT_USER_LOCKED / NOT_GAME_IMPLEMENTED`다. 승인 방향 이미지를 참조한 이미지 모델로 7개 요소를 독립 제작했다. 현재 consumer는 Blueprint 분리 납품 검토이며 production scene에는 연결하지 않았다. [기술 receipt](candidates/2026-09-10-intimate-diorama/separated-layers-v1.receipt.json)가 원본/파생본 해시·크기·prompt·도구·미해결 사항을 소유한다.

| 요소 | 독립 후보 파일 | 실제 준비 범위 |
| --- | --- | --- |
| 하늘 | `sky-day-v1.png` | 구름·바다 없는 opaque 배경 |
| 바다 | `sea-day-v1.png` | 하늘·배 없는 opaque 수면. 반복 경계/전진 미검증 |
| 돌산 | `rocks-rgba-v1.png` | 수면 없는 alpha 원경. 중앙 항로 밖 배치 예정 |
| 구름 | `clouds-rgba-v1.png` | alpha 독립 구름. 실제 배경에서 가장자리·불투명도 검토 필요 |
| 선체 | `empty-hull-rgba-v1.png`, `empty-hull-v1.aseprite` | 내부 복원, 노·쿠션·인물 없음. Aseprite 한 frame 왕복 검증 |
| 플레이어 | `player-rgba-v1.png` | 후면 pale-blue hoodie. 하반신 복원은 후보이지 새 의상 확정이 아님 |
| 동반자 | `companion-rgba-v1.png` | cream 강아지 휴식 기본 pose, 쿠션 없는 독립 후보 |

파일은 모두 `docs/visual/candidates/2026-09-10-intimate-diorama/`에 있다. 오브젝트의 `*-green-source-v1.png`는 재현용 이미지 모델 원본이며 게임에 쓰는 초록 배경이 아니다. 기존 `shaders/chibi_normal_chroma_key.gdshader`를 변경 없이 재사용하여 `tools/render_candidate_matte.gd`의 격리 display renderer로 투명 PNG를 만들었다. 녹색 의상·잎이 있는 대상에는 그대로 적용할 수 없다. 기존 shader 재사용은 `ADAPT`, 같은 alpha 요청 재반복은 두 번 실패해 `REJECT`, Aseprite 저장만으로 해결하는 경로는 배경 삭제 기능이 없어 `REJECT`다. 새로운 유료 도구·브리지 도입보다 현재 검증 가능한 경로를 택했다. [Godot SubViewport](https://docs.godotengine.org/en/stable/classes/class_subviewport.html)와 [Viewport transparent_bg](https://docs.godotengine.org/en/stable/classes/class_viewport.html)의 실제 display render로 확인했으며 headless 캡처로 대체하지 않았다.

재현은 Godot display 실행에 `--path <repo>/tools/candidate-render-project --rendering-method gl_compatibility --audio-driver Dummy --script <repo>/tools/render_candidate_matte.gd -- <source.png> <new-output.png> <repo>/shaders/chibi_normal_chroma_key.gdshader`를 전달한다. 출력 덮어쓰기를 거부한다. `python tools/verify_candidate_alpha.py <candidate.png>...`는 읽기 전용 alpha/여백 검사다. 격리 프로젝트는 autoload·게임 씬·production save가 없고 `.gdignore`로 본 프로젝트 importer와 분리했다. Pillow가 필요하며 새로운 유료 dependency는 없다.

5개 RGBA 모두 네 모서리 alpha=0, 내부 opaque pixel, 외곽 여백을 확인했다. 선체 Aseprite native `copy_sprite → export_frame → get_sprite_info` 및 Pillow decoded RGBA byte 비교가 동일했다. Aseprite `color_mode=rgb`만으로 alpha 부재를 판정하면 안 된다. 이 성공 파일도 rgb로 보고되므로 실제 PNG alpha를 독립 검사한다. 100ms는 파일 기본값이지 모션 타이밍이 아니다.

직접 이미지 검토에서 player 머리 외곽의 미세한 green fringe가 발견됐다. 투명도 PASS는 edge quality PASS가 아니다. player/companion/선체의 camera·크기·pivot·좌석 접점은 아직 맞추지 않았다. 가림용 전면 난간, 노·쿠션 등 소품, 수면 접점도 남아 있다. 바다 gradient를 그대로 수직 wrap하면 수평선/반복 경계가 깨질 수 있으므로 seamless flow 완료로 취급하지 않는다. 독립 기본 pose 한 장은 호흡·고개 반응 animation이 아니다.

공용 개선은 `alpha와 padding readback + 실패 RGB fixture + Aseprite decoded pixel roundtrip`의 Base 승격 후보로만 기록한다. 현재 Base 계약·공용 파일은 변경하지 않았다. 구현 전 최종 visual/Blueprint lock 및 후속 합성 검증을 보존한다.

#### 기술 checkpoint 증거와 clean-exit 경계

아래는 기준 head `74a89c2a6599c7414ab011ce9759fc3cb2279c21` 위 후보 working state에서 수행한 검사다. **다섯 항목을 AGENTS의 5회 full-scope clean-exit review로 바꾸어 세지 않는다.** 가장자리·접점·합성·모션 findings가 남아 있으므로 전체 준비/구현 완료 상태는 아니다.

| 검사 | 실제 명령/도구와 결과 | finding·조치 및 한계 |
| --- | --- | --- |
| alpha 회귀 | `verify_candidate_alpha.py` old checker fixture exit 1, RGBA 5개 exit 0 | RGB 체크무늬 오판 차단. 가장자리 품질은 별도 |
| 격리 render | Godot 4.7.2 OpenGL `render_candidate_matte.gd` 5개 출력 exit 0 | 기존 shader 무변경. 새 reusable isolated project로 player/pet 실제 실행 |
| 원본 보존 | native Aseprite 저장/재export 후 Pillow RGBA byte 동일 | single frame만 검증. pivot·timing 미설정 |
| 거부 경로 | headless 및 기존 output 덮어쓰기 각각 engine exit 2, 잘못된 checker matte render exit 1/no output | alpha 없는 이미지를 asset-ready로 승격하지 않음 |
| 정본/회귀 | receipt 13개 파일 SHA·byte 검증, `python -m unittest discover -s tests -p 'test_*.py' -q` 12 tests OK, production scenes/scripts/shaders/assets/evidence/adapter diff 없음 | 게임 runtime/Human 미실행. README/다른 PR #19 무변경 |

다음 full-scope review는 승인 방향과 독립 후보를 실제 크기로 합성하여 좌석·가림·미세 fringe·바다 반복 경계를 교정하는 단계부터 이어진다. 기존 판넬 시트를 animation으로 사용하거나 이 checkpoint를 runtime PASS로 승격하지 않는다.

### 2026-09-10 후면 좌석·가림 구도 교정 후보

**현재 승인·변경.** 사용자의 “확정해, 노는 없어도 될 것 같다”에 따라 `MLB-REDESIGN-STAGING-002`의 좌석·동반자·가림 구도는 `USER_LOCKED_STAGING`으로 확정했다. 노는 새 기본 시각·모션 제작 범위에서 제외하며 아래 노 관련 prompt와 후보 상태는 승인 전 역사적 기록이다. 새 노 없는 [v3 파생본](candidates/2026-09-10-intimate-diorama/stern-staging-no-oars-v3.png)은 image model의 요청 편집 결과로, 양쪽 노와 노 끝 잔물결이 제거된 것을 직접 확인했다. 캐릭터·동반자·선체 구도는 시각적으로 유지되나 원본 픽셀 동일성을 의미하지 않는다. 이 파생 이미지의 개별 최종 승인·production 등록·runtime 적용은 별도이며 `EDITED_DERIVATIVE / REVIEWED / NOT_RUNTIME_ASSET`로 둔다. 전체 이미지이므로 실제 하늘·바다·돌산·구름 분리 납품을 대체하지 않는다. 기존 이미지·분리 파일·모션 증거는 변경하지 않는다.

`MLB-REDESIGN-STAGING-002`는 [stern-staging-review-v2.png](candidates/2026-09-10-intimate-diorama/stern-staging-review-v2.png), `941×1672 RGB`, SHA-256 `21c379dffac5580a03eee84d0d6e2b2e61a706967507881ca94a486900813954`다. 상태는 `GENERATED_CANDIDATE / REVIEWED_WITH_FINDINGS / NOT_USER_LOCKED`다. approved voyage direction과 독립 선체·player·companion을 참조한 built-in image model 합성 구도 후보이며, 실제 분리 PNG의 deterministic 합성이나 Godot 캡처가 아니다. 기존 7개 독립 요소와 13개 source/derived 파일의 해시는 그대로다.

이번 범위는 후면 player의 좌석 지지, 옆 companion 가독성, stern rim의 가림, 하단 구도를 교정하는 한 후보다. 최초 합성은 배가 너무 크고 높아 동일 그림을 한 번만 축소·하단 이동하도록 수정했다. 수정 전 생성물은 host generated_images에만 보존하고 저장소에는 선택한 v2만 저장했다. [구도 receipt](candidates/2026-09-10-intimate-diorama/stern-staging-review-v2.receipt.json)에 exact prompt와 입력·출력 provenance를 기록한다.

직접 검토에서 player의 하반신이 보트 안으로 향하고, 뒤쪽 쿠션이 등을 지지하며, 강아지의 머리·앞발이 오른쪽 옆에서 보인다. 가까운 stern rim이 쿠션과 하반신 앞을 가린다. 수정 후 배의 중심은 대략 세로 75% 부근으로 내려왔지만 목표 80%와 정확히 일치하지 않으며, 게임의 540×960 안전영역에서 정량 배치한 증거는 없다. 양쪽 노 끝은 잘리지 않고 중앙 항로도 비어 있다. 물의 밝은 무늬와 wake는 여전히 촘촘하여 motion 단계에서 대비·밀도를 낮출 필요가 있다. 초록 테두리가 이 합성본에서 눈에 띄지 않는 것은 기존 독립 player PNG의 fringe가 고쳐졌다는 뜻이 아니다.

세 대안은 `ADAPT` 이미지 모델로 좌석·가림 목표 후보 교정, `TEST` Aseprite에서 exact raster 레이어를 배치하고 검증, `DEFER` final lock 전 production Sprite3D 연결이다. [Aseprite 공식 layers 문서](https://www.aseprite.org/docs/layers/)는 투명 레이어의 독립 이동을 지원하지만, 이번 세션에 노출된 native candidate 도구에는 축소·마스크 편집이 없어 서로 다른 원본 크기의 정확한 축소 합성을 수행하지 않았다. 다른 프로젝트의 opt-in 설정을 가져오거나 새로운 bridge를 만들지 않았다. [Godot Sprite3D](https://docs.godotengine.org/en/stable/classes/class_sprite3d.html)는 기존 consumer를 재사용하는 후속 경로이며, 2D 전용 [Parallax2D](https://docs.godotengine.org/en/stable/classes/class_parallax2d.html)를 현 3D camera에 바로 대입하지 않는다.

다음 순서는 이 구도의 최종 시각 판단 → 독립 player 자세와 front rail/쿠션/노/접점 정렬 → 540×960 exact-layer 합성 → 바다 반복 경계·실제 시간 흐름 → Blueprint 확정 범위의 production 연결이다. sky/sea/rocks/clouds를 하나의 배경으로 되돌리지 않고, 이 새 합성본도 production 카드로 연결하지 않는다. 후보 기록은 전체 5회 full-scope clean exit나 모션/Human 승인으로 보고하지 않는다.

### 2026-09-10 실제 분리 PNG 배치 검토

`tools/render_candidate_layout.gd`는 기존 격리 `tools/candidate-render-project`에서 7개 독립 PNG를 Sprite2D로 표시하고 **540×960 SubViewport**를 캡처한다. 이는 이미지 모델 재합성이 아닌 실제 파일의 정적 레이어 렌더다. 소스 PNG를 수정하지 않으며 game scene·save·production 자산에는 연결하지 않았다. Godot 4.7.2 Compatibility/NVIDIA RTX 3050으로 실행했다. 현재 Hera editor는 다른 프로젝트였으므로 제어하지 않았다.

| 검토 출력 | 확인된 문제와 교정 |
| --- | --- |
| [첫 배치 v1](candidates/2026-09-10-intimate-diorama/exact-layer-layout-v1.png) | player hoodie가 가까운 난간 앞을 덮음. 테스트 접점 `(250,858)`에서 R=131, B=184로 의도한 난간 가림 검사 실패 |
| [가림 교정 v2](candidates/2026-09-10-intimate-diorama/exact-layer-layout-v2.png) | 선체 원본의 `Rect2(38,1130,871,372)`를 같은 좌표·축척으로 승객 앞에 표시. 난간 검사가 통과함. 새 난간 그림을 그리거나 원본을 자르지 않음 |

레이어 배치의 단일 owner는 렌더 스크립트의 `entries`다. 하늘과 바다 경계는 y=270, 원경 돌산은 x=15의 작은 좌측 요소이며 중앙 바닷길을 비웠다. 선체의 보이는 bbox는 x=160..380, y=596..941.03으로 중심 y=768.51, **화면 높이의 80.05%**다. 이는 정적 검토 화면 수치이며 실제 모바일 safe area·UI·boat bob까지 검증한 값은 아니다. 노 layer는 없다. 투명 여백은 source `get_used_rect()`로 제외하고 오브젝트 종횡비는 보존한다. sky/sea는 고정 직사각형으로 맞췄으며 원근 흐름이나 seamless texture 검증은 아니다.

재현 명령은 `Godot --path <repo>/tools/candidate-render-project --rendering-method gl_compatibility --audio-driver Dummy --script <repo>/tools/render_candidate_layout.gd -- <repo> <new-output.png>`다. display renderer가 필요하며 기존 출력은 거부한다. `python -m unittest tests.test_candidate_layout_render -v`가 실제 PNG 크기·유효 색상·난간 가림·출력 덮어쓰기 방지를 검사한다. `GODOT_BIN`을 지정할 수 있고 실행 파일이 없으면 SKIP이지 PASS가 아니다. 테스트 임시 출력은 OS task-scoped TemporaryDirectory에서 종료 시 정리한다.

대안 비교는 **ADOPT** 기존 Godot 격리 viewport에서 원본 직접 배치, **DEFER** Aseprite native 축소·마스크 도구가 노출된 후 편집 패키징, **REJECT** 새 모델 합성본을 exact-layer 증거로 사용하는 방식이다. [Godot Sprite2D region](https://docs.godotengine.org/en/stable/classes/class_sprite2d.html)과 [SubViewport](https://docs.godotengine.org/en/stable/classes/class_subviewport.html)의 공식 기능을 현재 파일로 검증했다. 이 2D 검사로 기존 3D 카메라 전환을 대체하지 않는다. rollback은 이 검토 도구·테스트·캡처만 제거하면 되며 기존 consumer에 영향이 없다.

**남은 시각 findings.** 독립 player v1은 승인 구도보다 머리 대비 몸이 길고, 쿠션에 기대는 자세가 아니다. 강아지의 앞발이 난간에 너무 가까우며 cushion asset은 없다. 물에 닿는 얇은 접점·후류가 없어 선체가 떠 보인다. 구름/돌산의 밀도와 대기감도 승인 원화 수준으로 맞추지 않았다. 이 캡처는 문제를 숨기지 않는 조립 검사이므로 확정 그림체의 퇴행이나 final visual lock으로 해석하지 않는다. 다음 제작은 player 자세·쿠션·수면 접점에 한정하며 노는 계속 제외한다. 전체 재기획 5회 full-scope clean exit, motion·Human·release는 미완료다.

새 도구가 필요한 이유는 모델이 다시 그린 합성 이미지로는 실제 자산의 좌석·가림 문제를 검출할 수 없기 때문이다. 현재 project-only 검토 도구로 두고 Base 승격은 하지 않았다. 해시·실행 증거는 [배치 receipt](candidates/2026-09-10-intimate-diorama/exact-layer-layout.receipt.json)가 소유한다.

### 기존 runtime family의 visual grammar

새 production family는 GDD의 필수 layer 분리 계약을 따른다. 바다·돌산·하늘 등을 독립 제작하라는 2026-09-10 사용자 재확인에 따라, 아래 기존 composite 자산을 새 분리 납품의 대체품으로 사용하지 않는다.

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
| `MLB-SCR-001` Title boat waiting | 확정 로고와 실제 보트·동반자·바다를 보고 항해를 시작하는 첫 장면 | `project.godot` → `game.tscn/TitleOverlay`, `GameScene.start_voyage_from_title()` | `IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-SCR-003` Normal voyage diorama | character, companion, boat, sea와 낮은 밀도의 풍경을 함께 보는 core surface | `game.tscn`, `boat_space.tscn`, `game_scene.gd` | `IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-OVR-004` Appreciation Camera | UI를 줄이고 수평선에 집중하는 선택 화면 | `AppreciationCameraRig`, `GameScene._set_normal_boat_foreground_visible(false)` | `IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-OVR-005` 꾸미기 | arrival 뒤 원할 때 local cosmetic state를 바꾸는 surface | DecorPanel, `DecorPreview`, identity/decor local storage | `IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human readability/touch `NOT_RUN` |
| `MLB-SCR-010` Album | 실제 사진·기억·함께한 시간을 보는 archive | `scenes/album.tscn`, `AlbumView` | `PARTIAL_IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| `MLB-SCR-001-LEGACY` main menu | 시작 전 identity/time/mood selection의 이전 slice | `main_menu.tscn`, `main_menu.gd` | `SUPERSEDED_RUNTIME_SLICE`, current entry가 아님 |

### 3.1 확정 브랜드 타이틀

| asset id | canonical file | title / promise | provenance | allowed consumer | state |
| --- | --- | --- | --- | --- | --- |
| `MLB-BRAND-TITLE-001` | `assets/images/brand/my_little_boat_title_lockup_v1.png` | `MY LITTLE BOAT` / `파도 위에서, 함께 쉬는 시간` | built-in image generation, user `LOCK` 2026-08-31, `2172×724` RGB sRGB, SHA-256 `6A0511B1C2B74B742E250D556DD15D9F76A484DA5F2D8DE4D41025279C68DAFB` | store, splash, GDD cover, app/window title, `GameScene/TitleOverlay/TitleLayout/BrandLogo` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED`; `TITLE_ENTRY_RUNTIME_CONSUMER` |

`MLB-BRAND-TITLE-001`의 warm-ivory 배경과 player·dog illustration은 소개용 world-setting treatment이다. user가 승인한 title-entry runtime consumer에서만 `BrandLogo`로 표시하며, 그 아래의 실제 diorama player/pet state를 대체하지 않는다. `FinalDioramaCard`, playable player/pet selection, save ID, reward, voyage duration, soundscape에는 연결하지 않는다. 타이틀 대기에는 `GameState.begin_voyage()`를 호출하지 않으므로, title을 보는 시간이 progression으로 저장되지 않는다. 이 제한을 `TITLE_ENTRY_RUNTIME_CONSUMER`라고 표기한다.

#### 3.1.1 2026-08-31 lock 및 기계 검증 receipt

- Loop 1 — current `AGENTS.md`, `DOCUMENTATION_MAP.md`, GDD, screen inventory, `project.godot`, direct-entry Scene/test를 fresh-read했다. 첫 보트 진입과 legacy menu 격리를 유지하는 것이 retained boundary로 확인됐다.
- Loop 2 — `test_title_brand_asset_contract.gd`를 asset/doc/config보다 먼저 작성해 실행했다. canonical file, asset ID, `BRAND_DEPLOYMENT_ONLY`, GDD title/promise가 없어서 예상한 여섯 assertion이 실패했다.
- Loop 3 — 2026-08-31에 user `LOCK`한 generator source의 SHA-256과 project canonical copy를 대조했다. 양쪽 모두 `6A0511B1C2B74B742E250D556DD15D9F76A484DA5F2D8DE4D41025279C68DAFB`이며, source는 `1,273,356` bytes, `2172×724`, `RGB`였다.
- Loop 4 — Godot `--headless --path . --import` 뒤 title contract를 rerun했다. raw `Image.load_from_file`가 남긴 export-warning을 발견해 imported `Texture2D` consumer 방식으로 test를 고쳤고, warning 없이 `PASS`를 확인했다.
- Loop 5 — `test_title_brand_asset_contract.gd`, `test_direct_boat_entry_contract.gd`, `test_main_menu_identity_contract.gd`, `game.tscn` headless scene smoke, project headless smoke, `test_human_game_blueprint_profile.py` 5 cases, `git diff --check`를 다시 실행했다. title/direct-entry/identity contract와 smoke/profile checks는 `PASS`; `git diff --check`는 pre-existing CRLF conversion notices만 출력하고 whitespace error는 없었다.

이 receipt는 title asset이 imported resource와 config title로 읽힌다는 machine evidence다. store rendering, splash composition, readable contrast at distribution sizes, actual platform window title, player impression은 아직 확인하지 않아 Human/brand acceptance는 `NOT_RUN`이다.

## 4. 기본 Normal과 Look Around asset 경계

| asset id | canonical consumer | state |
| --- | --- | --- |
| `MLB-LOOK-CHIBI-NORMAL-REAR-001`과 derived matte | default C+dog `BoatSpace/FinalDioramaCard`의 explicit chroma shader | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human/device comfort `NOT_RUN` |
| `MLB-LOOK-FG-001..004` | `LookAroundPresentationRouter`의 port/starboard/aft/overhead exact foreground와 `LookAroundForeground` chroma-key shader. shared static sky와 flowing sea는 유지 | `USER_LOCKED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; 2026-09-01 OpenGL six-angle capture, 1.8초 port pair sky `0.00%` / open sea `58.44%` change; Human motion comfort `NOT_RUN` |
| `MLB-LOOK-CHIBI-TRN-001..004` | 이전 whole-composite non-front Look Around art | `SUPERSEDED_PENDING_CLEANUP`; current router consumer를 제거했으며 full source/consumer search와 regression 후에만 exact deletion |
| `MLB-BG-SPLIT-001..008` | `dawn / bright / sunset / night`별 `SkyBackdrop` + `SeaBackdrop`, normal·front Look Around·Appreciation. shared lateral flow는 항상, depth-weighted near-water forward flow는 active voyage에만 적용 | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; 2026-08-31 OpenGL 9-frame capture와 2026-09-02 normal 2-second pair lower sea `79.29%` / upper sky `0.00%`, Human motion/color comfort `NOT_RUN` |
| `MLB-AMB-MOTIF-001..006` | current local-time bucket의 normal·Appreciation `AmbientSceneryPass`, split sky·flowing sea는 유지 | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; 2026-08-31 six-pass capture, Human long-run observation `NOT_RUN` |
| `MLB-AMB-SEASONAL-REF-001` | 2026-09-01 밝은 봄 꽃섬의 visual-direction source. runtime consumer 없음 | `USER_APPROVED → CANON_REGISTERED → REFERENCE_ONLY`; full-scene source는 split layer를 대체하지 않음 |
| `MLB-AMB-SEASONAL-ISLAND-001` | Bright/spring `SeasonalIslandLayer`, Normal·Appreciation의 existing ambient-scene transit 위. 원본의 투명 캔버스는 runtime `region_rect`로 제외하고, 수평선의 원거리 landmark만 보인다 | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; alpha source/canonical SHA equality, headless contract, normal transit early/mid/late와 Appreciation 2026-09-02 OpenGL capture verified. Human `NOT_RUN` |
| `MLB-AMB-SEASONAL-CLOUD-001` | Bright/spring `SeasonalCloudLayer`, 세 camera path의 static sky 위 runtime-local chroma-key parallax | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; matte-key/material isolation, upper-cloud capture guard and 2026-09-01 OpenGL two-view capture verified. Human `NOT_RUN` |
| `MLB-BOAT-FLT-006` | `assets/images/runtime/voyage/boat-waterline-contact-v2.png` → `GameScene/VoyageWorld/BoatWaterlineContact` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human motion comfort `NOT_RUN` |

`FinalDioramaCard`는 기본 C+강아지 route에서만 사용한다. alternate pair는 동일한 `BoatSpace`의 layered `Sprite3D` route를 사용한다. 이 차이는 save 의미·voyage 시간·reward·soundscape를 바꾸지 않는다.

`MLB-BOAT-FLT-006`은 built-in image generation으로 만든 `2172×724` transparent RGBA waterline strip이며, 사용자가 2026-08-31에 승인했습니다. canonical binary SHA-256은 `8C145B545B913567A19F47927A13E83FB7328177D7DCC8A195B4BA857F10C22B`입니다. 기존 `MLB-BOAT-FLT-005`의 넓은 legacy ripple은 뒤쪽의 느린 확산 수면으로 남기고, 이 자산은 depth test를 유지한 전면 선체 하단의 좁은 접점만 담당합니다. 둘은 `BoatSpace`와 같은 lateral·forward·vertical drift를 따르며, `still` comfort에서는 모두 base position으로 돌아갑니다.

### 4.1 2026-08-31 사용자 승인 분리 하늘·바다 family

`MLB-BG-SPLIT-001..008`은 built-in image generation으로 만든 한 family다. 사용자는 밝은 시간대의 candidate 쌍을 검토한 뒤 권장 구조로 연속 진행하도록 승인했다. 각 candidate source는 `docs/visual/generated/2026-08-31-split-sky-sea/`에, 같은 SHA-256의 canonical runtime copy는 `assets/images/runtime/voyage/split/`에 보존한다. static sky는 material override가 없고, flowing sea만 `voyage_split_sea_flow.gdshader`로 수평선 아래 alpha/motion을 가진다.

| asset id | canonical runtime file | SHA-256 | consumer |
| --- | --- | --- | --- |
| `MLB-BG-SPLIT-001` | `bright-static-sky.png` | `3BCF0A54CF7939556E39F31F1029FA4016D595CC05B01F9486E266E6AF58D4A6` | Bright `SkyBackdrop` |
| `MLB-BG-SPLIT-002` | `bright-flowing-sea.png` | `AA43722C3B5EC89F784CA338F877B5FB11173F22AC1ED003E5B883501522A0A1` | Bright `SeaBackdrop` |
| `MLB-BG-SPLIT-003` | `dawn-static-sky.png` | `83F024878A9EC3619058AA7BBEF11A56C0345965C4F05CD40D13D1A146AD1950` | Dawn `SkyBackdrop` |
| `MLB-BG-SPLIT-004` | `dawn-flowing-sea.png` | `6358DF903FDB3D6293B6DE52CBAEB440C3A56F44E15664A0A894097D0AD0BE0A` | Dawn `SeaBackdrop` |
| `MLB-BG-SPLIT-005` | `sunset-static-sky.png` | `F00AA8D4A68FA96F809C402E7232A0A112BED0E4CF7474200D04D574AE2144FD` | Sunset `SkyBackdrop` |
| `MLB-BG-SPLIT-006` | `sunset-flowing-sea.png` | `1BF695BB6CBC806B60864BA0D10948D1FF7405DDCE126A92469E5E40657277E6` | Sunset `SeaBackdrop` |
| `MLB-BG-SPLIT-007` | `night-static-sky.png` | `FE7AD39F9812A947E396DE7DC1DE81AA7B72CD68CA59C008BC99B407B3E395E1` | Night `SkyBackdrop` |
| `MLB-BG-SPLIT-008` | `night-flowing-sea.png` | `87B44108258C7047FBF9C4B887E6C8334678992B9CDB5651D9AD1C00D87C37EA` | Night `SeaBackdrop` |

### 4.2 2026-09-01 user-approved bright spring seasonal parallax material

사용자는 전체 풍경 candidate의 거리감·색감·작은 명소 방향을 승인했지만, 하늘·구름·바다·섬이 한 장으로 함께 움직이는 runtime 사용은 승인하지 않았습니다. 따라서 전체 scene은 visual-direction source로만 보존하고, runtime은 기존 `Bright SkyBackdrop`과 `Bright SeaBackdrop`을 재사용한 뒤 구름과 섬을 독립 Sprite3D layer로 합성합니다. 이 경계는 보트·동반자·water contact의 foreground depth와 existing flowing-sea evidence를 보존합니다.

| asset id | source / canonical file | dimensions / format | SHA-256 | approved role | implementation boundary |
| --- | --- | --- | --- | --- | --- |
| `MLB-AMB-SEASONAL-REF-001` | `docs/visual/generated/2026-09-01-seasonal-parallax-bright/bright-spring-direction-reference.png` | `1672×941`, RGB | `5E2CCBA025C584C8B8871EB08F9B650DCF9436916122BEB5663998B14A7EB960` | bright spring islet의 source composition·palette·distance reference | runtime texture가 아니며, full scene을 `AmbientSceneryPass`로 이동시키지 않음 |
| `MLB-AMB-SEASONAL-ISLAND-001` | source `docs/visual/generated/2026-09-01-seasonal-parallax-bright/bright-spring-islet-candidate.png` → runtime `assets/images/runtime/voyage/seasonal_parallax/bright-spring-islet.png` | `1672×941`, RGBA | `22E9AE8B74B331F7147936B780823D81EA59DD407837BF4ACBC9F82FFC046987` | sky·ocean·reflection 없이 꽃·나무·풀·바위만 남긴 Bright/spring distant island | `GameScene/SeasonalIslandLayer` normal·Appreciation only. Existing source를 복제하지 않고 `region_enabled`, `Rect2(632, 350, 1028, 350)`, `pixel_size=0.005`로 투명 여백을 제외한 원거리 landmark만 사용하며 하단 보트 항로에는 진입하지 않음 |
| `MLB-AMB-SEASONAL-CLOUD-001` | source `docs/visual/generated/2026-09-01-seasonal-parallax-bright/bright-spring-clouds-chroma-candidate.png` → runtime `assets/images/runtime/voyage/seasonal_parallax/bright-spring-clouds-chroma.png` | `1672×941`, RGB technical matte | `27174AB314DDB9D93E5FE2FA45821F7F6D3C2C38080E2A34AACFA5BCFF2B2557` | three small bright clouds above horizon on magenta technical matte | three `SeasonalCloudLayer` paths reuse `look_around_foreground_chroma_key.gdshader` with per-node runtime material. Matte itself is never player-visible |
| existing `MLB-BG-SPLIT-001` / `002` | `bright-static-sky.png` + `bright-flowing-sea.png` | `1672×941`, RGB pair | see §4.1 | static sky + independently flowing sea | re-used without duplicate generation or changed asset identity |

`MLB-AMB-SEASONAL-ISLAND-001`의 empty-canvas samples are actual `A=0`; island sample is `A=253`. 불투명 alpha bounds는 `Rect2(644, 362, 1002, 322)`이고, runtime consumer는 이 영역을 충분한 여백과 함께 포함하되 source canvas의 네 변은 제외한 `Rect2(632, 350, 1028, 350)`만 표시한다. `MLB-AMB-SEASONAL-CLOUD-001` is intentionally opaque because the current built-in image output did not preserve actual transparent pixels for cloud candidates. Its non-cloud matte samples satisfy existing chroma-key thresholds with chroma `0.710–0.847` and brightness `0.827–0.882`; cloud samples do not meet the key condition. The source-level compatibility is now supplemented, not replaced, by `tests/test_seasonal_parallax_contract.gd` and `tests/capture_bright_spring_seasonal_parallax.gd`: Windows OpenGL normal early/mid/late and Appreciation captures are `540×960`, recorded at `docs/evidence/2026-09-01-bright-spring-seasonal-parallax/`. The normal capture guard requires an upper-sky cloud mark, a visible horizon-band island, no island-colour samples in the lower boat lane outside the fixed boat silhouette, and at least `80px` of early/late rendered-island center displacement. Current renderer output measured `213px`. Human/device comfort is still `NOT_RUN`.

The two generated RGB checkerboard cloud attempts and one reflective-island exploration are `REJECTED_GENERATED_CANDIDATES`; they have no project copy, canonical ID, runtime consumer, capture, or release meaning. Candidate-store deletion was attempted after their rejection but platform deletion protection blocked it. No repository capacity, Godot importer, or build path consumes them.

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

`test_resting_core_contract.gd` covers the headless non-playback boundary and explicit release. The minimal `--headless --path . --quit --verbose` smoke exits without the former two `ObjectDB` audio-instance warning. In contrast, the Windows display-server smoke and the 2026-09-01 Bright/spring OpenGL capture both still exit `0` while reporting the same two documented generated-WAV `AudioStreamWAV` / `AudioStreamPlaybackWAV` instances after explicit stream release. The existing minimal display reproduction shows this is an engine/lifecycle baseline rather than seasonal-parallax ownership; it is not a Human audio-comfort or device-shutdown PASS.

## 8. evidence ceiling and remaining review

The renderer evidence proves that the named resources loaded and appeared in controlled frames. It does not prove real-device color, touch reachability, long-session visual fatigue, motion comfort, or sound comfort. Those Human/device checks stay `NOT_RUN` until the user explicitly asks for human validation.
