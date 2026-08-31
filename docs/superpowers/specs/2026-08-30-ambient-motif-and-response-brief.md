# 자연 장면과 동행 반응 자산 브리프

**상태:** `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human/device comfort `NOT_RUN`

## 목적

목적지·수집·알림이 없는 항해에서, 낮은 밀도의 자연 장면과 작은 동행 반응이 같은 바다를 조금 더 살아 있게 보이게 한다. 이 문서는 승인된 자연 명소 여섯 장의 provenance·runtime 경계와, 아직 후보인 동행 반응의 요구사항을 함께 정의한다. 자연 명소의 사용자 승인, 정식 등록, runtime 적용, 기계 검증, Human 평가는 서로 다른 상태다.

## 공통 시각 규칙

- `HANDPAINTED_STORYBOOK_3D_DIORAMA`와 `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`를 유지한다.
- 자연 장면은 water-only local-time backdrop 위에 별도 낮은 밀도의 mid/far scenery로만 쓴다.
- 기본 normal rear foreground의 player·dog·boat silhouette을 가리거나 duplicate boat를 만들지 않는다.
- 선명한 목표물, 도착 지점, 수집 아이콘, NPC, 텍스트, 점수, 희귀도, 길찾기, 전투·위협 표식은 넣지 않는다.
- 한 상태의 특정 시간대에만 어울리는 빛을 쓰되, 다른 시간대에 억지로 재사용하지 않는다.
- 새 후보 이미지는 사용자 확인을 받고 `USER_APPROVED`가 되기 전까지 canonical path나 runtime consumer를 만들지 않는다. 아래 여섯 자연 명소는 2026-08-30 사용자 승인 뒤 그 경계를 통과했다.

## 자연 장면 후보 여섯 가지

| ID | 로컬 시간대 | 장면 | 카메라/배치 | 조용한 반응 | 금지 |
| --- | --- | --- | --- | --- | --- |
| `MLB-AMB-MOTIF-001` | dawn | 옅은 안개 너머의 낮은 바다 아치와 이끼 낀 작은 폭포 | 수평선 왼쪽 1/3, 멀리 | 물보라가 넓고 천천히 퍼짐 | 항구, 사람이 탄 배, 목적지 표식 |
| `MLB-AMB-MOTIF-002` | bright | 투명한 얕은 물 아래의 해초 리본과 작은 모래톱 | 전경 하단 가장자리, 보트 clear zone 밖 | 완만한 굴절과 느린 빛무늬 | 물고기 떼 추적, 채집물, 버튼 |
| `MLB-AMB-MOTIF-003` | bright | 멀리 있는 낮은 흰 절벽과 바닷새 한두 마리의 작은 실루엣 | 수평선 오른쪽 1/3, 아주 멀리 | 넓은 구름 그림자 이동 | 도시, 등대 퀘스트, 과밀 새떼 |
| `MLB-AMB-MOTIF-004` | sunset | 따뜻한 사암 동굴 입구와 잔잔한 반사 | 수평선 중앙 바깥쪽, middle distance | 느린 주황 반사 띠 | 드라마틱 폭발, 위험한 협곡, 보물 |
| `MLB-AMB-MOTIF-005` | sunset | 낮은 갈대 섬과 물 위를 스치는 분홍 구름 그림자 | 수평선 왼쪽, far distance | 갈대가 아주 약하게 흔들림 | 농장, 집, NPC, 교환소 |
| `MLB-AMB-MOTIF-006` | night | 아주 먼 푸른 생물발광 띠와 작은 해파리 불빛 | 물 표면 하단과 중거리, 과밀 금지 | 저주파 밝기 호흡 | 공포, 점프스케어, 채집·보상 신호 |

## 생성 source와 기계 파일 검증

2026-08-30에 위 브리프의 여섯 항목을 각각 별도 프롬프트로 생성했다. 생성에는 외부 이미지 입력이나 특정 작품·서비스의 고유 요소를 사용하지 않았고, 모두 보트·플레이어·동반자·UI·텍스트가 없는 가로형 자연 배경이다. 아래 경로는 검토·provenance를 위해 남긴 source candidate 보관소이며, exact bytes는 다음 canonical runtime 경로로 non-destructive copy 되었다.

| ID | 후보 경로 | 규격 | SHA-256 | 파일 검증 상태 |
| --- | --- | --- | --- | --- |
| `MLB-AMB-MOTIF-001` | `docs/visual/generated/2026-08-30-ambient-motifs/dawn-sea-arch-waterfall-candidate.png` | `1672×941` | `6B00781EF8DBB9157F9F8AC290C58D8E00BA8670940847CECDDD6285C24A23CE` | source/copy hash equality, existing water-only landscape geometry parity `PASS` |
| `MLB-AMB-MOTIF-002` | `docs/visual/generated/2026-08-30-ambient-motifs/bright-seagrass-sandbar-candidate.png` | `1672×941` | `CEAA00E4D5128DBDF3E77B892911EA866F22AFADDC0727CC9BD03FEEBB892521` | source/copy hash equality, existing water-only landscape geometry parity `PASS` |
| `MLB-AMB-MOTIF-003` | `docs/visual/generated/2026-08-30-ambient-motifs/bright-chalk-cliffs-birds-candidate.png` | `1672×941` | `C820C37CD833B29BD30FDFE934A8C7472C0193D4BF3EE358BAB5B8BDE60C4FA8` | source/copy hash equality, existing water-only landscape geometry parity `PASS` |
| `MLB-AMB-MOTIF-004` | `docs/visual/generated/2026-08-30-ambient-motifs/sunset-sandstone-cove-candidate.png` | `1672×941` | `8989E86AB830EEBB1C2A66AA3A987C7416404A3036DD33F80CB39C076FA6BB06` | source/copy hash equality, existing water-only landscape geometry parity `PASS` |
| `MLB-AMB-MOTIF-005` | `docs/visual/generated/2026-08-30-ambient-motifs/sunset-reed-islet-candidate.png` | `1672×941` | `5A469FBAE8E26F5E66D5A287AED35773A8D7A351054677056AD8D6CA0A7F6E20` | source/copy hash equality, existing water-only landscape geometry parity `PASS` |
| `MLB-AMB-MOTIF-006` | `docs/visual/generated/2026-08-30-ambient-motifs/night-bioluminescent-band-candidate.png` | `1672×941` | `3C85324D785AD2D4592A901E16508520C25D28FFD628F639C9E1AC47107B6EC0` | source/copy hash equality, existing water-only landscape geometry parity `PASS` |

`1672×941`은 현재 water-only runtime art와 같은 가로형 출력 규격이다. 16:9 cross-product에는 renderer output rounding에서 온 8-pixel 차이가 있으며, 모든 후보와 기준 runtime image가 동일하게 이 허용 범위 안에 있다. 이 검증은 파일 무결성·규격만 확인한다. composition, 정서, 실제 기기 가독성, 반복 피로는 승인 또는 Human evidence를 대신하지 않는다.

**승인·등록 receipt.** 사용자는 2026-08-30에 여섯 자연 명소를 명시 승인했다. source/canonical SHA-256 equality와 Godot import를 확인한 뒤, `DriftSceneryDirector`가 active foreground 기회에 local-time motif만 고르고 `GameScene`이 water-only normal·Appreciation `SeaBackdrop`을 유지한 채 dedicated `AmbientSceneryPass`에서 약 14초간 좌우 통과시키도록 연결했다. Look Around의 approved exact angle art는 이 consumer에서 변경하지 않는다. event에는 버튼·목적지·보상·희귀도·도착·수집 state가 없으며, `save_memory=true`인 경우에만 기존 local ambient-memory writer를 호출한다.

### Canonical runtime asset과 세로 화면 표시 경계

| ID | canonical runtime path | director-side `backdrop_offset_x` | consumer | runtime evidence |
| --- | --- | ---: | --- | --- |
| `MLB-AMB-MOTIF-001` | `assets/images/runtime/voyage/ambient_motifs/dawn-sea-arch-waterfall.png` | `+8.0` | dawn foreground event → normal·Appreciation `AmbientSceneryPass` | `2026-08-31-ambient-scenery-pass/dawn_sea_arch_540x960.png` |
| `MLB-AMB-MOTIF-002` | `assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png` | `+8.0` | bright foreground event → normal·Appreciation `AmbientSceneryPass` | `2026-08-31-ambient-scenery-pass/bright_seagrass_540x960.png` |
| `MLB-AMB-MOTIF-003` | `assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png` | `-8.0` | bright foreground event → normal·Appreciation `AmbientSceneryPass` | `2026-08-31-ambient-scenery-pass/bright_chalk_cliffs_540x960.png` |
| `MLB-AMB-MOTIF-004` | `assets/images/runtime/voyage/ambient_motifs/sunset-sandstone-cove.png` | `-8.0` | sunset foreground event → normal·Appreciation `AmbientSceneryPass` | `2026-08-31-ambient-scenery-pass/sunset_sandstone_cove_540x960.png` |
| `MLB-AMB-MOTIF-005` | `assets/images/runtime/voyage/ambient_motifs/sunset-reed-islet.png` | `+8.0` | sunset foreground event → normal·Appreciation `AmbientSceneryPass` | `2026-08-31-ambient-scenery-pass/sunset_reed_islet_540x960.png` |
| `MLB-AMB-MOTIF-006` | `assets/images/runtime/voyage/ambient_motifs/night-bioluminescent-band.png` | `+8.0` | night foreground event → normal·Appreciation `AmbientSceneryPass` | `2026-08-31-ambient-scenery-pass/night_bioluminescence_540x960.png` |

현재 `Camera3D.KEEP_HEIGHT`는 승인된 후방 보트 구도를 보존한다. Director의 per-motif side hint는 card transit의 좌우 방향만 정하고, pass 자체는 세로 화면보다 큰 높이로 overscan해 수평 image edge가 보트 화면을 자르지 않게 한다. `tests/probe_ambient_portrait_projection.gd`의 historical comparison capture와 `tests/capture_ambient_motif_scenery.gd`의 current 여섯 GPU pass capture가 이 consumer를 기록한다. 이는 renderer/runtime evidence이며 Human calm, 반복 피로, 기기별 색·가독성은 `NOT_RUN`이다.

## 동행 반응 프레임 후보 세 가지

이 프레임은 대화·레벨·보상 없이 보트가 머무르는 감각만 보강한다. 모든 프레임은 투명 또는 chroma-matte 기술 배경을 사용하며, 기본 rear normal의 player·dog·boat 배치와 같은 시점 언어를 따른다.

| ID | 주체 | 장면 | 사용 조건 | 소비 경계 |
| --- | --- | --- | --- | --- |
| `MLB-REST-REACT-001` | player + dog | stern rail에 기대어 함께 수평선을 보는 3/4 rear idle | normal rear의 낮은 빈도 idle 후보 | 고정 pose replacement 후보이며 runtime 연결 전 user review 필요 |
| `MLB-REST-REACT-002` | dog | 플레이어 옆에서 고개를 살짝 들었다가 다시 기대는 side/back idle | local only, player input이나 호감도와 무관 | reaction frame set 후보, sound·reward·알림 없음 |
| `MLB-REST-REACT-003` | boat + lantern | 보트가 낮은 roll을 타며 랜턴 불빛이 부드럽게 흔들리는 frame pair | existing bob amplitude와 동기화할 수 있는 후보 | current `BoatWaterContact`와 중복 shimmer 금지 |

## 이후 승인 흐름

```text
BRIEF_READY
→ GENERATED_CANDIDATE
→ USER_APPROVED
→ CANON_REGISTERED
→ ASSET_READY
→ IMPLEMENTED
→ MACHINE_VERIFIED
→ RUNTIME_VERIFIED
```

각 후보에는 source path, SHA-256, local-time consumer, clear-zone 확인, exact runtime consumer, 540×960 GPU capture를 기록한다. 모바일에서의 자연스러움, 감정적 편안함, 5분 동안의 반복 피로와 audio harmony는 기계 검증으로 대체하지 않으며 `Human NOT_RUN`으로 남긴다.
