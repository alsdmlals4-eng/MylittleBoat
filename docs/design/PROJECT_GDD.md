# 마이 리틀 보트 기획서

**현재 상태:** `CURRENT_HUMAN_FACING_GDD`
**갱신일:** 2026-09-13
**읽는 법:** 이 문서는 사람이 게임의 경험과 결정 상태를 이해하기 위한 정본입니다. 실제 코드·Scene·테스트·캡처는 [현재 Godot handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가, visual consumer와 provenance는 [visual inventory](../visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md)가 소유합니다.

## 현재 실행 목표 — 게임 전체 구현·완성

2026-09-13 최신 사용자는 “게임 전체 완성, 구현까지 계속 진행”을 명시했다. 기존 rest-first 코어와 현재 기획의 안전한 구현·교정은 반복 승인 없이 계속한다. 아래 과거의 ‘기획만 진행/production 보류’ 문장은 이 최신 구현 지시를 차단하지 않는다. 새 최종 아트 lock·핵심 의미 변경·공개 social 안전 gate·비용/배포/보안/파괴적 데이터 변경·Human 선언은 별도로 유지한다. 단위 검사 통과를 전체 게임 완료로 보고하지 않는다.

현재 남은 설계·실행 우선순위는 **2026-09-14 R01–R12와 연결된 구현 계획**을 따른다. P9는 전체 제작 단계의 기준으로 보존한다. 공통 공간·근거리 모델의 준비 제약과 독립적인 저장/입력/설정 작업을 분리해 한 자산 때문에 전체 구현이 멈추지 않게 한다. 명세 준비 뒤 사용자 실행 승인과 재개 지시에 따라 안전한 구현·검증을 진행 중이며, 현재 단계는 handoff와 실제 검증 증거로 판정한다.

| 묶음 | 현재 상태 | 다음 완료 기준 |
| --- | --- | --- |
| 항해·카메라·풍경 | 직선 route·공통 봄섬·정지/overlay 연결, 물/하늘/일반 motif는 부분 구현 | 같은 공간의 수면/원경 투영, 허용 회전과 경계·접점, 실제 시간/긴 soak |
| 보트·인물·동반자·모션 | 승인 후면 분리 카드 연결, 모델/리그 미준비 | 승인 방향의 모델 제작 경로와 glTF 왕복, 같은 모델의 회전·idle/notice/settle·좌석 가림 |
| 시간대·외형·장식 | 기존 ID와 consumer 존재, 새 재기획 family 일부만 연결 | 네 시간대·3 style·4 species·장식 슬롯의 실제 조합·legacy save 복원 |
| 사진·앨범·선택 행동 | 실제 촬영/페이지 탐색/낚시 취소 존재 | 손상/쓰기 실패 원본 보존·복구, 성공 후 상태 확정, 실패 피드백과 재시도 |
| 소리·설정·접근성 | 현재 ocean bed/comfort 유지 | 각 음량/음소거·안전 입력·작은 화면·기본 시점 복귀, 지속 소리/저감 회귀 |
| 빌드·최종 문서 | 엔진 자동 검사·제한 GPU 증거 | 실행 패키지·깨끗한 import/export·장시간 검증·현재 구현을 반영한 Blueprint. Human/Device/Release는 별도 |

## 2026-09-10 승인된 재기획 방향과 현재 작업

**2026-09-13 제품 개선 루프 — 사진에서 개인 기억으로 연결.** 최신 사용자는 유사 장르 조사→기획 구체화/연결→구현을 계속하는 루프를 요청했다. 이번 B5/P4/IMP-05 범위는 최근 3장만 노출되던 앨범에 3장 단위 이전/최근 탐색을 연결한다. 파일 없는 사진은 유효한 제목 기록을 남기며 다음 저장에서도 지우지 않는다. 오래된 사진은 요청할 때만 읽고 전체 원본 자동 로딩·삭제·수집 목표·보상은 없다. 작은 화면은 내용 스크롤과 고정된 바다 복귀 버튼을 사용한다. 카드가 사진의 보트/구도를 잘라내지 않도록 전체 비율을 보존한다. 기존 사진 ID와 저장 schema는 유지하며 새 이미지·3D 모델 적용과 무관하다. [조사·선택·구현·교정 기록](../evidence/2026-09-13-album-history/REVIEW.md)이 이 slice의 증거를 소유한다. 아래 과거 기획 전용 제한은 이 최신 요청의 제한된 기존 기능 연결에 대해서만 대체되며 전체 Blueprint/아트/Human 승인은 아니다.

**2026-09-12 이동 연출 후속.** 승인 봄섬은 중앙 항로를 가로지르지 않고 등장한 쪽에서 거리 변화에 따라 커지며 화면 바깥으로 지나간다. 기존 두 camera의 분리 Sprite3D를 활용한 제한된 camera-relative 깊이이며 실제 world-space 항법·Look Around의 연속 투영을 완성한 것은 아니다. 새 이미지·목적지·보상·저장 변경 없이 P3의 바닷길 비침범을 우선 교정했다. 기존 수면 흐름과 함께 30초 실행·표본 추적으로 검사했으며 Human은 별도다. [현재 이동 검증](../evidence/2026-09-12-same-side-depth/REVIEW.md).

**2026-09-12 IMP-01 연속성 구현.** 최신 사용자 `좋아 진행해`는 앞서 제시한 앨범/전체 꾸미기 연속성 우선 작업을 승인한다. 기존 `game.tscn`을 유지하며 `album.tscn`을 overlay로 재사용한다. full overlay/앱 비활성에서는 항해·물·풍경 Timer/bound Tween과 카메라 입력을 동결하고 UI/기존 autoload 소리는 별도로 둔다. 앨범 닫기는 같은 객체·위상 복귀이며 기존 P2의 무손실 낚시 취소를 적용한다. 사진 중 요청은 UI 복원 이후 열고 중복 저장을 억제한다. 같은 시간대 focus refresh는 풍경을 지우지 않으며 최초 재질·광원 적용은 반드시 실행한다. 이는 IMP-01의 해당 연결 범위 구현이지 세계 공간·3D·기기/Human·전체 Blueprint 완료가 아니다. 정확한 검증은 [현재 인계 문서](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)와 [IMP-01 기록](../evidence/2026-09-12-overlay-continuity/REVIEW.md)을 따른다.

**2026-09-11 분리본 확정·후면 slice.** 사용자가 새 분리본을 확정하고 진행하도록 승인했다. 구현 순서는 승인 외형/해시 연결 → Hull/Player/Pet/SternRail 조립과 색 번짐 제거 → 같은 시간축의 카메라·선체·탑승자 반응 → 기본 화면 캡처/정지/기존 외형 회귀다. 전체 합성 원화 교체만 하는 안은 독립 모션 불가로 `REJECT`, 분리 자산을 기존 카드 소비처의 SubViewport로 조립하는 안은 후면 slice로 `ADAPT`, 실제 근거리 3D 모델·리그는 P5의 최종 회전 해법으로 유지하되 미준비로 `PARTIAL`이다. 새 저장 키·보상·항해 목적지는 추가하지 않는다. 현재 주파수 기반 반응은 breathing/notice/settle 전체 clip 구현이 아니다.

**2026-09-11 최신 사용자 교정 — 수정 아트 적용과 탑승 이동 경험 미완료.** 사용자는 `이미지가 안바뀜(수정한 이미지 써야지)`, `나아가는 느낌이 아니잖아 카메라,캐릭터 등이 움직여야지`라고 기존 결과를 지적했다. 아래 기존 수면 개선의 기술 증거는 보존하지만 전체 항해 이동 경험의 수용 증거가 아니다. 현재 목표는 `stern-staging-no-oars-v3.png`의 후면 기대기·옆 강아지·노 없는 배 외형을 실제 화면에 연결하고, 보트의 진행과 카메라 추종·탑승자 반응·풍경 통과를 함께 구현하는 것이다. 이 특정 교정 범위의 구현 요청을 전체 Blueprint 승인 대기로 막지 않는다. 새로 파생 제작하는 자산의 품질/승인, 연속 회전용 3D 모델 준비, Human 검증은 각각 별도다.

**2026-09-11 후속 범위 승인 — 실제 항해 이동 연출.** 최신 사용자가 벤치마킹·실무조사 후 실제 구현을 명시 승인했다. 기존 게임의 수면 전진·시선 방향·반복 연속성·부유 접점과 비활성 시간 일치는 지금 구현할 수 있다. 아래 전체 Blueprint 승인 전 production 보류의 **이 범위에 한한 예외**다. 새 캐릭터/보트/동반자 모델과 후보 이미지의 최종 lock, 전체 재기획 구현·Human 승인을 의미하지 않는다.

### 항해 이동 연출 계약

2026-09-13 봄섬은 `VoyageWorld/SeasonalIslandLayer` 한 개의 고정 세계 앵커로 전환한다. 배와 카메라가 +Z 경로를 따라 그 옆을 지나가며 normal·Appreciation·LookAround가 동일한 섬을 관찰한다. 근거리 3D 지형이 아닌 승인된 원경 billboard다. 중앙 항로를 비우고 진행 거리 6.5 units(standard speed 1 약 20.31초) 동안 부드럽게 나타났다 사라진다. 속도·comfort·비활성·overlay는 실제 경로와 함께 적용되며 목적지·경주·보상은 없다. 기본 사선 시점에서 반대편 원경은 주변부에 보일 수 있으며 자동으로 카메라를 돌리거나 발견을 강제하지 않는다. 기존 14초 camera-relative 계약은 이 봄섬에 한해 대체되고 일반 motif는 유지한다. [현재 구현/검증과 남은 공간 범위](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)를 따른다.

2026-09-12 풍경 통과의 시각 시간도 speed/comfort와 일치하도록 수정했다. 일반 풍경 Tween과 계절 섬은 실제 시각 진행 완료 시 사라지며 still/느린 속도에서 벽시계 만료가 먼저 지우지 않는다. still 중 후속 발견이 동결된 풍경을 교체하지 않으며 이동 큐도 만들지 않는다. 발견 이벤트·기록·보상의 foreground 시간은 유지한다. [현재 검증과 실무 조사](../evidence/2026-09-12-scenery-clock/REVIEW.md).

- 기본 화면의 보트는 하단 구도를 유지한다. 가까운 수면은 빠르게, 수평선 가까이는 느리게 아래로 지나가며 원근 전진감을 만든다. 보트의 왕복 부유는 보조이고 목적지/거리 보상은 없다.
- 하늘에는 자동 이동 shader를 적용하지 않는다. 기존 계절 구름은 별도 느린 layer다. 화면 전체를 미는 방식은 쓰지 않는다.
- 수면은 두 개의 제한된 이동 위상을 교차한다. 위상 초기화 시 해당 layer의 기여는 0이며, 세로 반복으로 원본의 하늘이 물에 들어오지 않도록 제한한다.
- 둘러보기는 yaw에 따라 흐름의 좌우/전후 성분을 바꾼다. 현재 방식은 기존 2D 배경의 시선 상대 근사다. 실제 3D 해수면·섬의 world-space 투영이나 새 모델의 연속 가림을 완료했다고 부르지 않는다.
- 속도는 시각 흐름만 변경한다. gentle은 부유 진폭을 절반으로, 수면 유속을 줄인다. still은 자동 수면·부유 위상을 정지한다. 앱 비활성 상태에서는 항해 화면의 process 시간도 정지한다.
- 검증은 30초 실제 process 촬영, 물무늬 이동 추적, 반복 경계 GPU 검사, 접점 상대 오차, 기존 계약 회귀로 분리한다. 사용자의 전진감·편안함 확정은 Human 검증 때다.

입력 → 처리 → 화면의 관계는 `Start/속도/comfort/foreground → game_scene의 시각 phase → 각 Camera의 독립 SeaBackdrop material → 원근 수면 흐름`이다. 같은 phase가 `BoatSpace + BoatWaterContact + BoatWaterlineContact`의 부유를 제어한다. `GameState`의 기록·보상은 shader에서 수정하지 않는다. 조정/실행/검사 방법과 조사 출처는 [이동 연출 증거](../evidence/2026-09-11-voyage-motion/REVIEW.md)에 연결한다.

`output/pdf/MY_LITTLE_BOAT_HUMAN_BLUEPRINT_20260911_REVIEW.pdf`는 이번 이동 구현 전의 보존된 검토 snapshot이다. 현재 구현 상태와 차이가 있으며, 원본 결속은 당시 `.source.md`를 기준으로 검사한다. 전체 Blueprint 최종 출판 시에 갱신한다.

**2026-09-11 제작 권한 갱신.** 사용자는 십보강호의 사람용 Blueprint를 구조 참고로 제공하고, 상세 조사·권장 설계·필요한 실제 사용 규격 이미지·아틀라스를 포함한 최종 검토본 준비를 승인했다. 아래 2026-09-10의 이미지·모델 제작 보류 문장은 역사적 상태로 대체된다. 필요한 후보 제작과 패키징은 진행하되 게임 production 적용은 전체 Blueprint 최종 승인 후다. 생성 파일을 사용자 최종 승인·3D 모델·모션 완료로 간주하지 않는다. 상세 보완은 이 문서 끝의 `2026-09-11 Blueprint 제작 상세`가 소유한다.

### 2026-09-11 Blueprint 제작 상세

`MLB-BLUEPRINT-20260911 / REVIEW_DRAFT / FINAL_APPROVAL_PENDING`

이 상세는 P1–P10을 변경 없이 축약한 요약본이 아니라, 부족했던 SWOT 실행 전략·화면별 동작·데이터와 아트 납품 기준을 보완한다. PDF는 이 GDD와 실제 후보 manifest에서 만든 파생 읽기 자료다. 십보강호 PDF는 아틀라스→경험→전략→시스템→상세 표→구현 지도의 구조만 참고했다. 그 프로젝트의 전투·성장·수치·자산·승인을 가져오지 않았다. 이미지 제작은 허용됐지만 최종 승인과 게임 적용은 아직 아니다.

#### B1. 상세 SWOT — 지킬 강점과 강화 방식

| 항목·현재 상태 | 근거와 요청 이유 | 강화 조치·소비처 | 기대효과·확인 방법 |
| --- | --- | --- | --- |
| S1. 목적지 없는 명확한 휴식 | P1의 무과업 코어. 목표 없는 디오라마 사례와 맞지만 재미는 미검증 | 타이틀에서 시작 한 번. 이후 의무 설명·진행률·종료 팝업 제거. game_scene의 시작/기록 표시 | 첫 30초에 해야 할 일을 찾느라 헤매지 않음. 시작 1회·무입력 5분 기계 검사 후 Human 확인 |
| S2. 보트와 동반자의 작은 생활 공간 | 승인된 후면 기대기 구도. 큰 세계보다 한 관계에 집중 가능 | 좌석·동반자 접점 공유, 작은 귀/시선 반응. BoatSpace의 공통 anchor와 종별 motion | 말·호감도 막대 없이 친밀함. 3상태 전환·전 각도 가림 검사, 관계 지각은 Human |
| S3. local-first 개인 기억 | 사진·함께한 시간·외형 저장 consumer 존재 | 네트워크 없이 시작·사진·앨범·꾸미기. 저장 실패 복구를 핵심 기능과 함께 검증 | 서버 상태와 무관한 휴식, 개인 기록 신뢰. offline/쓰기 실패/손상 fixture |
| S4. 독립 배경 layer 기반 | 하늘·바다 분리 및 실제 기존 shader 있음 | 세계 기준 수면 phase, 먼 섬의 깊이·방향, 조명 family를 하나의 컨텍스트로 묶음 | 같은 배경에서도 조용한 변화. 기본/좌우 카메라 전진 벡터·시간대 경계 캡처 |

#### B2. 상세 SWOT — 약점과 개선 우선순위

| 항목·현재 상태 | 발생 원인·영향 | 개선 조치·우선순위 | 완료 기준·실패 대응 |
| --- | --- | --- | --- |
| W1. 정적 방향 카드의 각도 파열 | 다른 그림을 교체하므로 가림·자세가 연속적이지 않음 | P0, 근거리 실제 3D와 손그림 재질 왕복 검증. 2D 원화를 모델이라고 부르지 않음 | 같은 mesh/rig로 허용 yaw·pitch 전부 재생. 실패하면 PARTIAL 유지, 회전 축소는 별도 결정 |
| W2. 부유와 전진의 증거 부족 | 보트 왕복 흔들림·일부 수면 픽셀 변화만 확인하면 정체처럼 보임 | P0, waterline·wake·전진을 같은 좌표계에 연결. 화면 전체 스크롤 제외 | 30초 실제 시간 궤적, 수면 접점 전체 주기. 사용자 전진 지각은 별도 |
| W3. 앨범 상세 확대 시 연속성 회귀 위험 | 현재 기본 앨범은 같은 GameScene의 overlay로 연결됨. 상세 추가가 이 연속성을 깨뜨리지 않아야 함 | R08은 현재 overlay를 재사용. 별도 VoyageWorld/앨범 scene 전환 추가 금지 | 반복 20회에도 world instance·phase·선택 동일, overlay 중 시간 증가 0. 기존 구현을 신규 미구현으로 되돌려 세지 않음 |
| W4. 신규 제작 자산 준비 부족 | 이미지 후보와 실제 모델·리그·모션 상태의 혼동 | P0, manifest에 원본/후보/필수 미제작을 분리. 낮 1세트 먼저 | 실제 파일·alpha·애니메이션·consumer 기준 ASSET_READY. 모형/그림 보드로 대체 불가 |
| W5. 정보량과 기록의 성과화 | 300초·활동 수·다음 항해가 목표로 읽힐 수 있음 | P1, 기록은 앨범, 기본 화면은 바다. 기존 저장 의미 보존 | 기록 최대 1개, 자동 종료 0, 이전 기록 문자열 보존 |
| W6. 반복 제작의 일관성 비용 | 장식·외형·동반자·각도 조합이 늘어남 | P1, 3 style/4 pet/8 slot/6 item 호환표와 공통 접점 | 조합별 침범 검사. 지원되지 않는 조합을 기본 외형으로 몰래 치환하지 않음 |

#### B3. 상세 SWOT — 기회와 위험의 실행 전략

| 항목 | 가설·위험 | 실행 전략 | 성공 신호·중단 기준 |
| --- | --- | --- | --- |
| O1. 짧은 휴식과 긴 감상 동시 지원 | 플레이 길이를 강제하지 않는 작은 공간 | 30초/5분/30분 창으로 검증하되 콘텐츠 보상 cadence로 바꾸지 않음 | 짧게 종료해도 손실 경고 0. 장시간 콘텐츠 부족은 반복 과업 대신 밀도·소리로 조정 |
| O2. 동행의 몸짓으로 차별화 | 눈에 띄는 목표 대신 곁에 있는 느낌 | 동일 선체 motion + 서로 다른 미세 호흡 + 잠깐 눈 맞춤. 반응 알림 없음 | 배경 alone 대비 관계 인지 향상은 Human 가설, 미검증이면 광고 문구로 단정하지 않음 |
| O3. 개인 사진의 장소성 | 남에게 보여주기보다 나만의 기억 | 실제 viewport, 무UI 사진, 날짜·풍경 문구만. 사진을 얻으려 기다릴 필요 없음 | 생성 그림을 실제 사진으로 저장하지 않음. 저장 실패 시 원본 기억 보존 |
| T1. cozy 외형의 유사성 | 귀여운 캐릭터·파스텔만으로 독창성 보장 불가 | 이름·로고·캐릭터 실루엣은 프로젝트 자체. 타 게임 이미지 추출/복제 금지 | 출처 ledger와 동일 파일 hash. 시장 유일성·매출 인과 주장 제외 |
| T2. 멀미·눈부심·피로 | 과한 유속·반짝임·자동 회전 | gentle/still, 수평선 roll 0, 높은 대비 물무늬 억제 | still 자동 움직임 0. 편안함은 실제 사람 선언 전 NOT_RUN |
| T3. 자산 수 폭증·성능 저하 | 각도×종×의상×시간대 별 그림 생산 | C안 공통 geometry+시간대 재질; 배경 layer만 별도. atlas는 실제 수요별 | 한 family 성능/가림 통과 전 다음 family 확대 금지. 전 시간대 원본 상시 적재 금지 |
| T4. 개인 기록 손상·저장 용량 | 원본 사진 누적·실패/손상 파일 덮어쓰기 | 원본 자동 삭제 금지, on-demand 썸네일, 트랜잭션 저장·복구 | 누락 사진은 unavailable, 경로 탈출 0, 실패 시 정상본 hash 불변 |
| T5. 병편지의 안전 운영 비용 | 온라인 대화는 local 휴식과 다른 운영 책임 | 기존 delayed-only 설계 보존, public release gate 별도 | 안전 증거가 없으면 공개 기능 OFF, offline 휴식은 정상 |

#### B4. SWOT 교차 전략과 독창성

| 전략 | 구체적 결합 | 이번에 선택한 실행 | 하지 않을 것 |
| --- | --- | --- | --- |
| SO · 강점을 기회로 | S1+S2+O2, 목적지 없는 관계 | 두 몸이 같은 배에 기대는 가림·무게·반응을 첫 품질 목표로 | 친밀함을 일일 호감도·돌봄 의무로 치환 |
| WO · 기회로 약점 보완 | W1+W4+O2, 모션 생산의 근거 | 한 player+dog+boat의 glTF/rig 검증 패키지를 먼저. 낮 세트가 production 기준 | 전신 원화 다량 생성으로 리그 부족 숨기기 |
| ST · 강점으로 위험 축소 | S3+T4+T5, 개인 공간 신뢰 | local 데이터 owner 유지, 사진 안전 저장, social service 경계 분리 | 계정 의무·백엔드 실패로 시작 차단 |
| WT · 약점과 위험 동시 축소 | W2+W6+T2+T3 | 제한된 수면 제어·공통 anchor·낮 한 family·comfort부터 검증 | 물리 ocean simulation, 거대 월드, 상태별 통그림 증식 |

독창성의 중심은 ‘목적지를 향한 모험’이 아니라 ‘움직이는 나만의 작은 쉼터’다. 진행 방향은 분명하지만 도착 의무는 없다. 바다·둘의 접점·한 장의 개인 기억이 같은 경험을 설명해야 한다. 시장 유일성, 치료 효능, 사용자 만족 검증으로 과장하지 않는다.

#### B5. 화면 아틀라스의 책임과 입력

| 화면 ID | 보이는 것·우선순위 | 입력과 처리 | 취소·복귀·예외 |
| --- | --- | --- | --- |
| UI-01 타이틀 | 같은 바다·보트, 제목, 항해 시작 | 시작 1회만 수용. 새 인물/기분 선택 없음 | 대기 부유만. 항해·기억 시간은 0 |
| UI-02 휴식 | 하늘·바다·후면 보트·옆 동반자, 작은 쉬는 메뉴 | 조작 없는 시간이 기본. 메뉴 열기 | 화면 하단 버튼이 선미·동반자를 덮지 않음 |
| UI-03 쉬는 메뉴 | 감상/둘러보기/사진, 꾸미기/앨범/낚시, 속도/소리·편안함 | 하나의 그룹만 펼치고 직접 해당 기능 실행 | 뒤로 한 번은 메뉴만 닫음. 항해 유지 |
| UI-04 감상·둘러보기 | 감상은 먼 바다 중심, 둘러보기는 수동 각도 | 배경 드래그만 camera 수용. 기본 시점 버튼 | 메뉴/슬라이더 입력과 중복 0, 보상·저장 불변 |
| UI-05 꾸미기 | 실시간 보트 preview + 외형/동반자/장식 탭 | 임시 선택→적용. 저장 성공 후 확정 | 취소 시 이전 선택, 불가 slot 안내, 실패 시 기존 save 유지 |
| UI-06 앨범 | 최근 실제 사진 3장, 기억·풍경·물고기·함께한 시간 | 사진 선택→상세→앨범. 필요할 때 다음 묶음 읽기 | 빈/누락/손상 사진 구별. 뒤로는 같은 바다 phase |
| UI-07 낚시 | 작은 상태 문구, 낚기/거두기. 제한시간 없음 | WAITING→BITE_READY 또는 QUIET_READY | 언제든 거두기. 취소 결과 0, 중복 catch 0 |
| UI-08 소리·편안함 | 음량/음소거, standard/gentle/still, 기본 시점 | 설정 즉시 preview, 재실행 시 취향 복원 | still에서도 수동 카메라와 기록 사용 가능 |

화면 시안은 실제 촬영과 구분해 ‘배치 설계’로 표시한다. 런타임에는 설명용 카드 배경을 통째로 붙이지 않고 위젯·장면을 구현한다. 화면 아틀라스에 쓴 후보를 실제 완성 화면으로 라벨링하지 않는다.

#### B6. 시스템 연결과 상태 데이터

| 책임 | 입력 | 출력·소비처 | 저장·부작용 |
| --- | --- | --- | --- |
| GameState | Start, foreground delta, 선택 행동 결과 | elapsed·단일 항해 기록, UI | 현재 기록 규칙 유지, presentation은 GameState를 역으로 진행시키지 않음 |
| VoyageWorld | 활성/동결 상태, 시각 속도, comfort, 시간대 | 수면·선체·환경·반응 phase | transient. 종료 후 정확한 phase 영구 저장 없음 |
| CameraController | UI가 소비하지 않은 drag, reset | yaw/pitch·감상 전환 | 항해 시간/보상 변화 없음 |
| DriftSceneryDirector | foreground delta, atmosphere, season | 기존 motif 선택 0 또는 1 | central lane 회피·동시 큰 motif 1개. 새 콘텐츠 보상 없음 |
| Identity/Decor catalog | 기존 ID, 임시 선택 | 호환 모델·장식 상태·라벨 | Apply 성공 시 기존 persistence owner 저장 |
| PhotoMemoryPersistence | 실제 무UI Image, label, atmosphere | photo entry 또는 오류 | PNG+cfg 모두 성공 후 UI 성공. 실패 중복 금지 |
| Overlay host | open/close/back, busy flag | 하나의 전체 overlay, world 동결 | world를 파괴하지 않음. audio는 별도 책임 |
| RestingSoundscape | volume/mute, app active | 기존 ocean bed | 메뉴 이동으로 restart 금지. OS 이탈 정책 우선 |

VoyageWorld와 Overlay host는 새 구현 목표 역할 이름이며 현재 같은 이름의 노드가 있다고 주장하지 않는다. GameState·기존 catalog/persistence는 실제 consumer다. 새 대형 framework 대신 GameScene 안에서 책임을 나누고 필요가 검증된 경계만 추출한다.

#### B7. 콘텐츠·조정값 데이터 표

| 키·범위 | 기준값·출처 | 의미 | 검증 |
| --- | --- | --- | --- |
| atmosphere | dawn 05–08시 / bright 09–16시 / sunset 17–20시 / night 21–04시 | 실제 resolver의 로컬 시계. 보상과 무관 | 04/05,08/09,16/17,20/21,잘못된 hour |
| voyage record | 300초, 항해당 최대 1개 | 기존 기록 호환. 자동 종료 없음 | 299.9→300→600,중복 callback |
| scenery first | 90–150초, existing baseline | foreground에서 기회, 출현 보장 아님 | seed 고정+inactive 동안 변화 0 |
| scenery next/chance | 120–180초 / 0.65 | 기존 cadence. 5분 무출현도 정상 | 확률을 희귀 보상으로 표시하지 않음 |
| scenery visible | 기존 14초를 비교 baseline | 새 원거리 투영에서는 가림·크기에 따라 재조정 | 출현/중간/퇴장 순간이동 없음 |
| camera | yaw ±135°, pitch -16°..38°, roll 0 | 기존 범위에서 새 연속 3D 시험 | 극점·복귀·조합별 mesh 가림 |
| comfort | standard 1 / gentle 0.5 / still 0 | 새 자동 motion intensity 권장값 | still 수동 조작/기록 유지 |
| family blend | 3초 권장 시험값 | 하늘·물·광원 동기 전환 | 중간 프레임 혼합·복귀 경계 |
| pet notice interval | 45–90초 권장 시험값 | 반복 탭으로 단축하지 않음 | overlay/inactive 중 큐 0 |

| 기존 motif ID | 새 표현의 역할 | 움직임/가림 계약 |
| --- | --- | --- |
| MLB-AMB-MOTIF-001 | 새벽의 바다 아치·먼 낙수 | 먼 측면. 보트가 아치 아래 통과하지 않음 |
| MLB-AMB-MOTIF-002 | 낮 얕은 해초·모래 여울 | 수면 아래 낮은 대비. 불투명 육지처럼 표현하지 않음 |
| MLB-AMB-MOTIF-003 | 낮 흰 절벽·작은 새 | 절벽은 먼 측면, 새는 별도 layer·낮은 밀도 |
| MLB-AMB-MOTIF-004 | 해질녘 사암 코브 | 항로 밖. 긴 반사는 선체에 고정해 그리지 않음 |
| MLB-AMB-MOTIF-005 | 해질녘 갈대섬 | 낮은 실루엣·느린 상대 이동 |
| MLB-AMB-MOTIF-006 | 밤 먼 생물발광·해파리 | 약한 호흡 광도. 섬광/고밀도 입자 금지 |
| MLB-AMB-SEASONAL-ISLAND-001 | 봄 밝은 꽃섬 | 기존 spring 조건 보존. 신규 계절 보상 없음 |

#### B8. 저장 계약과 오류 시나리오

| 소유 파일 | 보존 데이터 | 변경 원칙·오류 처리 |
| --- | --- | --- |
| identity_profile_v1.cfg | 기존 player style·pet ID | 3 style/4 pet ID 그대로. 신규 모델 미지원은 명시적으로 표시 |
| boat_decor_v1.cfg | slot→item, item appearance | 8 slot/6 item 호환 유지. preview는 cfg에 쓰지 않음 |
| together_time_v1.cfg | 함께한 초 | foreground만. 음수/비유한 수 거부 |
| comfort_preferences_v1.cfg | 편안함 선택 | 모션 의미 확대는 기존 값 호환. 사용자의 still을 임의로 완화하지 않음 |
| ambient_memory_v1.cfg | 풍경 기억 | 동일 의미의 기존 문자열/ID 보존, 새 완성률 추가 없음 |
| voyage_postcards_v1.cfg + PNG | 실제 사진·메타데이터 | 이미지 저장→메타 저장→성공, 각 단계 실패 fixture |
| memory_ledger_v1.cfg | 물고기·항해 문자열 | 기존 기록 보존, 새 표현은 표시 단계에서 처리 |

새 항목은 version key를 무조건 올리기보다 기존 owner에서 optional key/default 호환으로 먼저 판단한다. 손상 파일 보존→마지막 정상본 복구→없으면 빈 상태 진입 순서로 설계한다. 외부 경로·권한 없는 파일에 대한 재시도는 하지 않는다. 자동 삭제와 공개 업로드는 이 계획에 없다.

| 상황 | 보여 줄 문구·행동 | 잃으면 안 되는 것 |
| --- | --- | --- |
| 사진 없음 | 아직 사진이 없어요. 그냥 쉬어도 좋아요. | 강제 촬영 튜토리얼 없음 |
| 파일 누락 | 이 사진 파일을 찾지 못했어요. | 메타를 임의 삭제하지 않음 |
| 저장 실패 | 사진을 저장하지 못했어요. 잠시 후 다시 시도해 주세요. | 기존 사진, UI 복귀, 현재 항해 |
| 꾸미기 저장 실패 | 변경을 저장하지 못했어요. 이전 모습으로 돌아갑니다. | 기존 외형·장식 선택 |
| 오래 비활성 | 복귀 보상·손실 문구 없음 | 이탈 시간 누적·장면 급속 catch-up 없음 |

#### B9. 자산 아틀라스와 실제 납품 계약

| family | 실제 게임에서의 용도 | 규격·분리·모션 | 준비 판정 |
| --- | --- | --- | --- |
| Sky | 먼 배경·시간대 | 구름/섬/태양을 bake하지 않은 panorama 또는 sky 재질 입력. 회전 시 가장자리 노출 금지 | 기존 낮 후보 있음, 네 시간대 coverage 별도 |
| Clouds | 먼 하늘의 독립 object | true RGBA, 충분한 여백, sky와 분리. 수동 camera와 공간 일치 | 기존 분리 후보 검토, 큰 자동 이동 제외 |
| Sea surface | world-space plane의 albedo | 탑뷰·무수평선·낮은 대비·반복 경계 검사. 투명 깊이는 엔진 재질 책임 | 신규 이미지 모델 texture 후보, 반복 품질 검증 전 |
| Distant rock | 측면 원거리 motif | true RGBA, 바닥 waterline pivot, 반사/바다/구름 금지 | 신규 개별 후보. 항로 밖 depth 배치 |
| Waterline / wake | 선체 접점·약한 전진 흔적 | 별도 alpha texture, boat anchor와 world velocity. 선체에 그려넣지 않음 | 새 family 미준비면 ASSET_READY 금지 |
| Boat / player / dog | 연속 회전하는 근거리 가족 | .glb+재질+rig+3상태. 노·노걸이 동작 제외, seat/pet/prop anchor | 모델·리그 BLOCKED_UNVERIFIED. PNG를 glTF로 둔갑시키지 않음 |
| Other styles/pets/decor | 기존 선택 보존 | 기존 ID별 mapping, 종별 접점과 의상 침범 검사 | 미지원 ID를 삭제하지 않고 기존 consumer 유지 |
| UI | 버튼·슬라이더·탭·focus·오류 | text-native Control/Theme. 장식용 통이미지에 클릭 영역을 bake하지 않음 | 위젯 상태 명세, 실제 구현 최종 승인 후 |

아틀라스는 서로 다른 목적을 구분한다. ‘화면 아틀라스’는 플레이어의 여정을 찾는 지도, ‘자산 아틀라스’는 독립 PNG/texture/model의 연결 지도, ‘spritesheet’는 프레임 metadata를 가진 실제 패키지다. 셋을 같은 완성 증거로 쓰지 않는다. 모델이 만든 투명 이미지는 alpha를 검사하고 가짜 checkerboard·바깥 잘림·색 fringe가 있으면 실패로 기록한다.

원본은 candidate 경로에, 승인 후 canonical copy는 실제 runtime asset family에 둔다. manifest 필수값은 asset_id, path, sha256, dimensions, alpha, origin/prompt, intended_consumer, state, finding이다. atlas frame은 rect·pivot·duration·loop/tag까지 추가한다. 실제 파일 없는 항목은 path를 발명하지 않고 NEEDED로 둔다.

#### B10. 모션·3D 제작 패키지

| 대상 | 기준 pose·접점 | animation 납품 | 검사·거부 조건 |
| --- | --- | --- | --- |
| Boat | origin은 waterline 중심, 선수 방향 통일. seat_player/seat_pet/decor anchors | title_float/voyage_float는 제한된 transform controller. mesh vertex에 파도 애니메이션 bake 금지 | 모든 bob 위상에서 물과 틈 0 목표, 선미 바닥 노출·큰 roll 거부 |
| Player | 승인 후면 hoodie, 선미에 기대어 등/엉덩이/발 지지 | rest_loop 6초, notice 1.2초, settle 1.8초를 제작 시험값. root motion 0 | 손·발·의상 관통, 위치 drift, 얼굴 미승인 확정 금지 |
| Dog | 옆자리에서 몸·발 지지, cream floppy ears | rest_loop 6초, notice 1.2초, settle 1.8초. 머리/귀만 작은 반응 | 몸 scale 변화·발 미끄러짐·반응 과밀·회복 점프 거부 |
| Water | 좌표계는 세계, 경계·접점은 boat로 연결 | 자동 흐름 phase는 실제 active delta, material TIME만으로 이탈 진행 금지 | still·overlay·focus에서 독립적으로 계속 흐르면 실패 |
| 2D frame 요소 | equal canvas와 공통 pivot | 실제 제작된 다른 pose만 Aseprite tag/PNG+JSON export | 동일 그림 복제 후 animation 완료 주장 금지 |

glTF 제작 단계는 일관된 3면/후면 기준→geometry/UV→손그림 재질→rig→3상태 clip→Godot import→각도·접점·변형 순이다. 투명 원경은 geometry와 별도로 둔다. importer 옵션으로 해결 못 하는 골격/UV 오류는 원본 제작 파일에서 교정한다. 모델 제작 도구와 실제 품질 경로가 아직 확인되지 않았으므로 이 문서는 **전체 자산 납품 완료본이 아닌 구현 준비 검토본**이다. 사용자 승인이 있어도 없는 3D 자산의 준비 상태를 올리지 않는다.

#### B11. 구현 패키지별 즉시 착수 조건

| 패키지 | 수정할 실제 owner | 승인 후 첫 작업 | 완료 증거·rollback |
| --- | --- | --- | --- |
| IMP-01 연속성 | game_scene.gd / album_view.gd / game_state.gd | 기존 full overlay 진입/뒤로 fixture부터 추가, world 생존 분리 | 시작/사진 busy/20회 복귀/비활성. 저장 schema 무변경으로 연결 단위 revert |
| IMP-02 수면 공간 | boat_space.tscn / game.tscn / water shaders / camera controller | 낮 texture import와 world phase, contact anchors | 기본·좌우·극점 30초 실시간, still 이동 0. 기존 family 재선택 rollback |
| IMP-03 근거리 3D | boat_space.tscn / identity_visual_catalog.gd | 승인 외형 glTF 1세트 import, 3clip 검증 | 모델 파일 없으면 착수 gate BLOCKED. 기존 카드를 완성 자산으로 대체하지 않음 |
| IMP-04 외형·콘텐츠 | identity/decor catalog / scenery director / time catalog | legacy ID mapping·slot 침범 fixture, 네 시간대 동기 | 3 style/4 pet/8 slot/6 item와 motif 전수. 미완성 family 활성화 안 함 |
| IMP-05 기억·선택 행동 | photo/memory persistence / fishing_session / resting_soundscape | 저장 실패·낚시 취소·audio 연속성 테스트 | 중복 0·원본 보존·무음 사용. 기능별 원복 가능 |
| IMP-06 빌드·검수 | export presets / tests / 이 Blueprint | 플랫폼별 import/export·실시간 soak·변경된 설명 재출판 | Machine/Runtime/Device/Human/Release 별도. 공개 배포 자동 실행 없음 |

IMP-01은 추가 이미지 없이 구현을 시작할 수 있다. IMP-02는 해당 texture의 반복/alpha·접점 검증이 필요하다. IMP-03 이후는 모델/리그 준비 gate가 실제 blocker다. 작업 순서를 이렇게 분리하면 한 자산의 제작 실패로 데이터·입력·저장 검증까지 정지할 필요가 없다. 단, 이번 요청은 기획·준비만이므로 production code는 수정하지 않는다.

#### B12. 검수표·추가/수정/폐기·연구 범위

| 현재 상태 | 권장 조치 | 이유 | 기대효과 |
| --- | --- | --- | --- |
| 화면 이미지 중심의 구형 요약 PDF | source-bound 장별 Blueprint, 화면/자산 아틀라스와 상태 라벨 | 보기 좋은 이미지가 실제 구현과 혼동됨 | 사람 검토와 구현 인계가 같은 근거 사용 |
| 기존 10개 benchmark | 공식 소개를 재확인하고 SWOT 실행 항목에 연결 | 링크 목록만으로 선택 이유 부족 | 목적 없는 휴식에 맞는 선택·배제 근거 |
| P1–P10 통합 계획 | 유지, B1–B12에서 세부 오류/데이터/제작 기준 보완 | 정본 중복보다 기존 owner 확장 | 변경 위치 명확화 |
| Aseprite 선택 | native MCP의 후보 패키징에 조건부 사용 | 창작/리그 생성과 프레임 정리를 혼동하지 않음 | 현재 도구 재사용, 새 bridge·유료 의존성 없음 |
| 이전 통그림·실패 alpha·기존 runtime assets | 새 production으로 승격하지 않음. 이력·consumer 때문에 삭제하지 않음 | 나이만으로 삭제하면 복구/출처/실행 손실 | 폐기 판단과 물리 삭제의 안전 분리 |
| 범용 새 skill·Base 프레임워크 | 이번에는 만들지 않음 | 반복 검증된 공용 consumer 없음 | 과설계와 유지보수 비용 억제 |

필수 수용 항목은 화면 8종의 진입/취소/복귀, 시작 한 번, 300초 기록 한 번, 풍경 항로 비침범, 시간대 family 일치, 수면 접점·전진·각도 연속성, 사진 성공/실패, 기존 ID/save, comfort, 오디오 복귀다. PDF에서는 쪽수·글자 겹침·표 잘림·이미지 누락·라벨·원본 hash를 검사한다. 문서 PASS는 엔진·Human·출시 PASS가 아니다.

2026-09-11 공식 소개를 다시 열어 확인한 10개 사례는 아래 기존 benchmark 표와 같다. [A Short Hike 제작자 회고](https://blog.playstation.com/2021/08/05/crafting-a-tiny-open-world-a-look-behind-the-scenes-at-the-creation-of-a-short-hike/)는 작은 범위의 일관된 표현을 참고했다. [Godot glTF](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html), [pause](https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html), [Aseprite spritesheet](https://www.aseprite.org/docs/sprite-sheet/), [XAG 101](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/101), [XAG 103](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/103)을 제작/입력/가독성 근거로 확인했다. 공식 설명과 공개 회고 범위이며 실무자 인터뷰·전 게임 직접 플레이·내부 source 역공학은 수행하지 않았다. 수치 권장안은 우리 프로젝트의 시험 가설이다.

### 통합 제작 기획 — 전체 경험·시스템·제작 계약

`MLB-PLAN-20260910 / RECOMMENDED_PRODUCTION_BASELINE / IMPLEMENTATION_NOT_AUTHORIZED_BY_THIS_RECORD`

사용자는 카메라만 검토하고 재질문하는 흐름이 아니라 **게임 제작에 필요한 기획 전체를 조사하여 권장안으로 진행·마무리**하도록 지시했다. 이 절은 아래 개별 재기획 메모를 통합하는 최신 권장 제작 기준이다. 기존 승인 코어·노 제외·후면 좌석 구도는 유지한다. 새 추천값은 `RECOMMENDED_DEFAULT`, 실제 품질은 검증 전이다. 이미지·모델 제작 보류는 유지하며, 이 문서가 전체 Blueprint 최종 승인·새 구현·Human 승인으로 해석되어서는 안 된다. 기술적으로 정할 수 있는 세부사항은 재질문하지 않고 범위 안에서 보완한다.

#### P1. 제품 약속·세계관·플레이 범위

- 제목은 `MY LITTLE BOAT`, 약속은 `파도 위에서, 함께 쉬는 시간`을 유지한다. 목적지·엔진·돛·마법 추진·세계 구원 서사를 추가하지 않는다. 작은 보트와 동반자가 나의 머무는 장소다.
- 대상 플레이 상황은 짧은 틈에 화면을 보거나, 조용한 배경 소리와 함께 더 머무는 개인 휴식이다. 의학적 치료나 모든 사용자에게 편안함을 보장하는 제품으로 표현하지 않는다.
- 필수 행동은 타이틀의 `항해 시작` 한 번뿐이다. 일일 보상·호감도 농사·배고픔·실패·전투·결제·광고·온라인 접속 요구는 없다. 손을 쓰고 싶을 때만 사진·감상·꾸미기·낚시·작은 반응을 이용한다.
- Micro는 바다와 동반자에 머무르기, Session은 원할 때 들어와 쉬다가 떠나기, Meta는 스스로 남긴 사진·기억과 취향이다. 새 성장 곡선·재화·잠금 해제·완성률을 만들지 않는다.
- 첫 30초의 질문은 ‘무엇을 해야 하지?’가 아니라 ‘그냥 있어도 되는구나’다. 첫 5분은 QA 관찰 창이고 의무 시간이 아니다. 15·30분은 자발적 연장으로만 검토한다.

#### P2. 화면·입력·연속성

```text
실행 → 같은 보트의 타이틀 대기 → 항해 시작 → 휴식
                                           ↔ 쉬는 메뉴 → 사진 / 꾸미기 / 앨범 / 낚시 / 소리·편안함
                                           ↔ 둘러보기 / 바다 감상
                                           → 언제든 종료
```

| 상태 | 화면·주요 입력 | 시간·복귀 권장 규칙 | 오류·취소 |
| --- | --- | --- | --- |
| 타이틀 대기 | 로고·실제 보트·시작. 사전 외형/시간대 선택 없음 | 부유·파도 소리는 유지, 항해/함께한 시간/기억 생성 없음 | 시작 연타는 한 번만 처리 |
| 휴식 | 기본 후면 3/4, 하단 약 20%의 보트, 옆 동반자. compact 쉬는 메뉴 | foreground에서만 항해·함께한 시간·풍경 진행. 속도는 시각 전용 | 조작하지 않아도 완전한 플레이 |
| 쉬는 메뉴 | 감상·사진·둘러보기·꾸미기·앨범·낚시·속도·소리/편안함. 역할별 묶음 | 작은 메뉴에서는 같은 항해 계속, 새 세션 시작 금지 | 뒤로는 메뉴만 닫음 |
| 둘러보기 / 감상 | 드래그로 보기, 기본 시점 복귀. 감상은 바다 중심 | 데이터·소리·풍경 위상 유지. 강제 회전·각도 보상 없음 | UI 드래그와 카메라 입력 중복 금지, 한 번의 복귀 입력 |
| 앨범 / 전체 꾸미기 | 기록 읽기 또는 호환 외형 선택. 뒤로로 바다 복귀 | 가려진 항해의 타이머·풍경·반응은 동결, 소리는 이어짐. 복귀는 같은 시각 위상 | 별도 Scene 재생성에 의존하지 않는 overlay를 우선 채택. 낚시는 입장 전에 무손실 취소 |
| 사진 | 현재 실제 viewport에서 UI 없는 프레임 저장 | 저장 성공 때만 앨범 항목 추가, 대기 중 중복 저장 억제 | 저장 실패 시 UI 복구와 짧은 안내, 나머지 휴식은 계속 |
| 앱 이탈 / 복귀 | 다른 앱·잠금·최소화 | 모든 휴식 진행 동결, 이탈 시간 몰아주기 없음. 음향은 중단/감쇠 후 복귀, 시스템 오디오 정책 준수 | focus와 OS suspend를 각각 검사. foreground 플래그만으로 동작을 증명하지 않음 |
| 완전 종료 / 재실행 | 정상 종료 때 변경된 기억·취향 저장. 재실행은 타이틀 | 영구 기억·취향 복원, 정확한 파도 위상·미완료 낚시·오프라인 경과는 복원하지 않음 | 손실 경고·복귀 보상 없음. 저장 실패는 기술 오류이지 게임 실패가 아님 |

상태 우선순위는 `앱 비활성 > 저장 오류 처리 > 전체 overlay > 감상/둘러보기 > 기본 휴식`이다. 사진 중 화면 전환은 캡처·UI 복원까지 지연하고, 다시 누른 입력은 무시한다. 전체 overlay는 하나만 활성화한다. PC는 mouse+기본 focus/뒤로, 모바일은 단일 탭·드래그를 목표로 하고 연타·정밀 조준·필수 장기 홀드는 요구하지 않는다. 화면 재생성+전체 상태 직렬화는 과도한 저장 책임 때문에 `REJECT`, 작은 transient snapshot 방식은 rollback 대안으로 `TEST`, 하나의 항해 scene+overlay는 `ADOPT` 권장이다. 새 영구 save key는 이 연속성만을 위해 만들지 않는다.

동결은 `_process`의 delta만 막는 것이 아니다. 풍경 Tween·return Timer·애니메이션·낚시 대기까지 같은 pause domain을 사용해야 한다. 전체 SceneTree를 무조건 멈춰 overlay 입력과 soundscape까지 정지시키는 안은 제외하고, voyage world와 UI/audio의 process 책임을 분리한다. `still`에서는 새 풍경 이동을 큐에 쌓지 않으며, 기존 개인 기록 생성 cadence는 보존하되 저감 상태에서 갑자기 출현/순간이동하는 표시를 금지한다. [Godot pause/process mode](https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html)

#### P3. 시간·기억·콘텐츠 밀도

- 현실 시계는 기존 네 시간대 매핑만 사용하고 진행·보상에 쓰지 않는다. 시간대 경계 또는 복귀 시 하늘·바다·광원 family를 함께 전환한다. 부분 교체·밝기 튐을 금지하며 전환 3초를 초기 시험값으로 둔다.
- 300초의 기존 단일 항해 기록은 호환성을 위해 보존하되 종료 조건으로 쓰지 않는다. 추천 UI는 카운트다운을 기본 휴식에서 숨기고 기록 생성 팝업·다음 항해 강조를 줄이는 방식이다. 장면은 자동 재시작하지 않는다. 기존 완료 기록 생성 규칙을 바꾸거나 짧은 항해 자동 기록을 추가하지 않는다.
- 앨범의 새 표시 문구는 ‘오늘 잠시 함께 쉰 기록’처럼 기억 중심으로 쓰고 활동 수 합계를 대표 제목으로 삼지 않는다. 과거 저장된 문자열은 파괴적으로 다시 쓰지 않는다. 문구 예시는 추천 copy이며 실제 출시 문구의 가독성은 별도 검사한다.
- 풍경은 기존 6개 motif(새벽 아치, 낮 해초·흰 절벽, 저녁 사암 코브·갈대섬, 밤 생물발광)와 밝은 봄 꽃섬의 의미를 재사용한다. 새 목적지·항로 선택·날씨 위험·미니맵을 추가하지 않는다. 첫 slice는 낮 한 family, 확대는 네 시간대와 기존 motif 순서다.
- 기존 기회 범위 90–150초/후속 120–180초/표시 확률 0.65를 초기 비교 기준으로 유지한다. 5분에 0회도 정상이다. 명소 한 개를 보려 기다리게 만들지 않고 미발견 목록·희귀도·알림 배지를 만들지 않는다.
- 명소가 존재하는 공간을 지나가야 한다. 한쪽에서 나타나 반대쪽으로 횡단하는 단순 슬라이드보다 거리·관찰각·진행 방향에 따른 투영을 권장한다. 통과 시간 14초는 기존 baseline이지 새 화면 확정값이 아니다. 중앙 바닷길은 항상 비우고 섬은 플레이어/보트와 교차하지 않는다.

#### P4. 캐릭터·동반자·꾸미기·선택 행동

| 기능 | 권장 범위와 피드백 | 데이터·예외·제작 조건 |
| --- | --- | --- |
| 플레이어 | 승인 분위기의 친근한 애니메이션/치비 비례, 선미에 기대는 기본 휴식 | 기존 3개 style ID 보존. 스타일 변경은 숫자/성격/진행을 바꾸지 않음. 새 외형을 과거 save ID에 연결할 때 호환표 필요 |
| 동반자 | 기본 강아지와 나란히 쉬기. 작은 시선·귀·자세 반응 | 기존 dog/cat/rabbit/otter ID와 선택 보존. 종별 리그·접점은 달라야 하며 강아지 모션을 단순 확대복제하지 않음. 새 상태군 준비 전 원본 consumer 유지 |
| 관계 | 함께한 시간은 앨범 안에서만. 반응은 놓쳐도 손해 없음 | 상호작용 횟수 multiplier·호감도 막대·이별·방치 벌 없음 |
| 꾸미기 | 기존 8개 slot/6개 item catalog 재사용, preview에서 호환성 확인 | 완전한 자유 배치·물리 시뮬레이션은 제외. 좌석·손·동반자 점유 영역 침범 조합은 막거나 검증된 위치로 표현. 불가 조합은 저장하지 않고 이전 선택 유지 |
| 사진·앨범 | 실제 사진, 최근 기억, 풍경·물고기·함께한 시간. 최근 3장부터 표시, 나머지는 요청 시 읽는 목록 권장 | 모든 원본 자동 로딩/자동 삭제 금지. 빈 상태는 ‘아직 사진이 없어요. 그냥 쉬어도 좋아요.’ 누락 파일은 unavailable로 구분, 가짜 이미지로 대체하지 않음 |
| 낚시 | 캐스팅→느긋한 기다림→낚기 또는 조용히 거두기→휴식 | 기존 WAITING/BITE_READY/QUIET_READY 재사용. 제한시간·놓침 패널티·재화 없음. 취소 시 결과 생성 없음. 반복 입력 한 catch만 저장 |
| 작은 행동 | 이미 있는 나란히 쉬기·파도 듣기·컵/랜턴 등의 선택적 반응 | 즉시 입력 수용을 알리되 모든 행동에 새 전신 애니메이션을 요구하지 않음. 실제 pose/prop이 없는 행동을 모션 완료로 쓰지 않음 |
| 병편지 | 기존 승인 delayed subsystem은 독립 범위로 보존 | 이번 local-first slice의 필수 동선·성공 조건이 아님. 새 public enablement·실시간 소셜·외부 PR 변경 없음 |

수집 RPG로 확장하는 안은 `REJECT`, 모든 선택 행동을 삭제하는 안도 기존 취향·기억 손실 때문에 `REJECT`, **선택 행동은 보존하고 상시 노출·성과 표현을 줄이는 안을 ADAPT**한다. 새 어종·외형·소품 물량은 core slice와 기존 조합 회귀 검증 뒤 별도 필요가 있을 때만 늘린다.

#### P5. 카메라·공간·아트 생산 방식

2026-09-13 승인 실행의 첫 단위는 실제 `VoyageRoute` Path3D + `BoatProgress`다. 기존 +Z 직선 해역을 128-unit 단위로 이어 배·카메라·접점의 공간 이동을 공유하며, 512-unit에서 위치를 되감던 표현은 대체한다. 단일 world 풍경·독립 추적/관찰축·물/모델 연결은 다음 단위이며 이 경로만으로 전진감·자유 회전 완료를 판정하지 않는다. 공간 이동은 visual-only이고 기존 저장/보상/foreground 계약은 유지한다.

최종 목표의 권장 구조는 **C. 근거리 보트·플레이어·동반자·접점은 실제 3D, 원경은 분리된 배경 요소**다. 전체 3D 오픈월드는 필요 없다. A(제한된 2D)는 제작 실패 시 비교할 축소안, B(방향별 카드)는 기존 build 보존용이며 신규 연속 회전의 완료 해법으로 쓰지 않는다. A로 회전 의미를 축소하는 것은 기술 편의로 몰래 결정하지 않는다.

기본 후면 3/4와 하단 약 20% 구도를 유지한다. 사용자 드래그 둘러보기의 첫 시험 범위는 기준 시점에 대한 상대 yaw ±135°, 상대 pitch -16°..38°이며 완전한 360°·수중·배 밑 관찰은 약속하지 않는다. 2026-09-13 관찰축 연결은 중립 시점을 기본 후면과 일치시키며 기준 pitch -29.793805°에 상대 입력을 더한다(실제 pitch -45.793805°..8.206195°). 수평선 roll=0, 관성·자동 orbit·자동 줌은 기본 제외한다. 범위 안에서 단일 선체/캐릭터의 실루엣·의상·가림이 연속적이어야 한다. 기본 시점 복귀 후 같은 항해를 유지한다.

**원경 2D도 카메라에 붙인 한 장으로 끝낼 수 없다.** 세계 기준 방향·깊이를 갖는 원거리 layer 또는 넓은 sky 표현으로 회전에 대응하고, 가려진 구간·측면에서 카드 가장자리가 노출되지 않게 설계한다. 하늘이 ‘고정’이라는 뜻은 자동 흐름/흔들림이 없다는 뜻이며, 사용자 회전 때 공간적 방향까지 화면에 붙여 놓는다는 뜻이 아니다. ‘수평선→하단’ 수면 흐름은 기본 카메라의 관찰 결과다. 다른 시점은 같은 world-space 흐름을 투영해야 한다.

2026-09-13 수면 방향 후속은 기존 원화/두 위상 shader를 보존하면서 기본 3/4 heading을 누락하던 상대 yaw 계산을 교정한다. 실제 Camera3D의 수평 right/forward와 직선 항로의 세계 +Z 축을 비교하므로 기본 시점에도 옆으로 지나가는 성분이 있고, 항로 반대편을 보면 흐름이 반전된다. 이는 **수평 방향 연결만 구현한 단계**다. pitch에 따른 수면 원근·수평선 이동, 단일 world 수면, sky 회전 대응과 실제 모델은 여전히 미완료이며 이 수정으로 대체하지 않는다. [검증 기록](../evidence/2026-09-13-water-heading/REVIEW.md)을 따른다.

실현성은 `PARTIAL`이다. Godot는 glTF·AnimationPlayer/AnimationTree 경로를 지원하지만 현재 `assets`에서 .glb/.gltf/.blend/.fbx/.obj 파일은 찾지 못했다. 기존 primitive MeshInstance3D는 승인된 리깅 캐릭터가 아니다. 연결 도구 목록에 Blender/rigging 전용 도구는 없고 PATH·기본 Blender 설치 폴더에서도 실행 파일을 확인하지 못했다. 전체 PC에 없다고 단정하지 않으며 설치·외부 서비스 구매는 하지 않았다. **현재 승인 외형을 재현하는 모델/리그 제작·왕복·변형 품질은 BLOCKED_UNVERIFIED**다.

무료·로컬 3D 제작 경로를 먼저 검증하고, 한 player+dog+boat의 왕복과 idle→notice→settle를 통과한 뒤 C를 production으로 승격한다. Aseprite는 2D texture/레이어/프레임·PNG+JSON 정리가 필요한 경우만 사용하며 3D 모델·리그 생성기로 취급하지 않는다. 이미지 모델은 필요 이미지 제작·편집에만 쓰고, 렌더용 원화와 모델 입력/재질 입력을 혼동하지 않는다.

#### P6. 모션·물·빛의 역할과 상태군

| 대상 | 최소 상태·역할 | 공통 규칙·검증 |
| --- | --- | --- |
| 보트 | title_float / voyage_float | 물 위 부유는 작은 heave/roll, 전진은 환경 흐름. 노·노 splash 없음. 물리 기반 부력 엔진 대신 제한된 시각 제어를 ADOPT; 물리 시뮬레이션은 TEST 필요가 생기기 전 DEFER |
| 물·접점 | 고정 원경 대비 / 근경 흐름 / waterline / 약한 wake | 같은 world phase와 선체 anchor 사용. 수면 없는 선체 원본, 선체에 고정해 그린 반사 금지. 전체 주기에 틈·바닥 노출·중복 그림자 없음 |
| 플레이어 | rest_loop / notice / settle | 등·엉덩이·발 접점 유지. 기본 뒷모습에서도 작은 몸의 이완이 읽힘. 큰 몸 돌리기·기립·노 젓기 제외 |
| 동반자 | rest_loop / notice / settle | 낮은 빈도, 한 번 반응한 뒤 휴식 복귀. 반응 큐를 쌓지 않음. 초기 시험 간격 45–90초, 사용자 반복 탭으로 단축하지 않음 |
| 환경 | sky / clouds / distant motif / sea | 하늘·구름·돌산·바다 별도. 중심 항로 비움, 풍경 하나가 끝나기 전에 다음 큰 motif 중첩 금지 |
| 시간대 | dawn / bright / sunset / night | 하늘·수면·인물·선체의 광원 방향과 색을 동기화. 밤을 고휘도 발광 노이즈로 채우지 않음 |

기대는 두 몸을 독립된 랜덤 흔들림으로 처리하지 않는다. 선체 움직임은 공유하고 호흡/작은 반응만 분리한다. 새 후보 수치는 저감 시험값 `standard/gentle/still = 1/0.5/0`를 사용한다. `still`은 자동 카메라·보트·풍경 이동을 멈추는 방향으로 정의하되 수동 보기·사진·소리·저장 가치를 유지한다. 이 전체 동작은 새 설계이며 현재 comfort 구현 전체가 이미 일치한다는 뜻은 아니다.

#### P7. 소리·문구·접근성

현재 `RestingSoundscape` autoload와 ocean bed를 보존한다. 소리 우선순위는 바다→가까운 물→바람→작은 선체 소리→먼 자연/동반자→UI다. 모든 layer가 현재 존재한다는 뜻은 아니다. 해상 소리가 중심인 안을 `ADOPT`, 음악 중심은 `DEFER`, 완전 무음은 사용자가 고를 수 있는 대안으로 둔다. 새 음악·음성·유료 라이브러리는 필요 없다. 반복 경계·클리핑·갑작스러운 gain·화면 전환 시 재시작을 기계 검사하고 실제 청취는 Human으로 남긴다.

설정은 환경음·효과음 음량/음소거, 기존 모션 편안함, 기본 시점 복귀를 최소 범위로 한다. 새 저장값은 구현 시 기존 preference owner의 호환 가능한 확장으로 명세하고 임의로 쓰지 않는다. 진동은 기본 없음. 중요한 저장 오류·낚시 준비·입력 수용은 소리 또는 색 하나만으로 알리지 않는다.

2026-09-13 바다 소리 조절은 기존 실제 `OceanBed` consumer에 연결했다. 쉬는 메뉴의 `OceanVolumeOption`에서 끄기/25/50/75/100%를 고르며 100%는 기존 -18 dB 믹스의 1.0배다. `comfort_preferences_v1.cfg`의 `[comfort] ocean_volume` 숫자 0..1을 추가하되 기존 `profile`과 다른 키를 보존한다. 이전 파일이나 잘못된 음량값은 1.0으로 읽고, 읽지 못한 원본은 새 저장으로 덮지 않는다. 저장 실패여도 현재 음량은 적용하고 실패 문구를 표시한다. `RestingSoundscape`가 재생 위치를 유지하며 누적 process delta 기준 full-range 최대 150ms로 gain만 전환한다. 재시작·증폭·새 음원·의무 설정 단계는 없다. 실제 효과음 consumer가 없는 현재 별도 효과음 조절기를 만들지 않았으며, 효과음 layer 추가 때 독립 조절을 연결한다. [실행·입력·저장 검증](../evidence/2026-09-13-ocean-volume/REVIEW.md). 청취 품질/실기기 접근성은 별도다.

540×960을 설계 기준으로 유지하되 360×640·540×960·720×1280과 긴 화면의 safe area를 검사한다. 터치 영역은 초기 기준 48 logical px, 본문 18 logical px 이상으로 시험하고 큰 글자에서도 버튼이 겹치지 않게 한다. 이는 장치별 dp/pt 인증이나 접근성 PASS가 아니다. 색 대비는 실제 배경 위 측정, focus/뒤로/드래그 충돌·스크린리더 지원은 각각 검증한다. 지원하지 않은 입력·보조공학을 지원 완료로 표시하지 않는다.

글자 크기·오류 안내에도 동일한 가독성 설정을 적용하고, 소리·색 하나에만 정보를 의존하지 않는 원칙은 [XAG 101](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/101)과 [XAG 103](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/103)을 참고한다. 위 48/18 값은 이 프로젝트 시험값이지 XAG의 수치를 그대로 옮긴 것이 아니다.

문구는 짧고 재촉하지 않는다. ‘성공/실패/완료율/오늘도 접속’ 대신 ‘바다로 돌아가기/잠시 함께 쉬기/사진을 저장하지 못했어요’를 쓴다. 저장 실패를 무조건 숨기는 것도 휴식이 아니다. 문제와 재시도 선택을 알리되 기존 기억은 보존한다.

#### P8. 데이터·오류·안전·배포 경계

2026-09-13 구현은 사진 목록이 이미 손상되거나 알 수 없는 형식일 때 새 저장으로 덮어쓰지 않는 보호를 우선 적용한다. 파일이 없으면 새 앨범을 만들고, 존재하면 파싱/entries Array/필수 필드가 보존되는지 확인한다. 실패 시 기존 bytes와 PNG를 그대로 두고 성공 기록을 만들지 않는다. 정상 메타데이터의 PNG 누락은 저장 차단 원인이 아니다. 자동 정상본 복구·전원 차단 내성·atomic replace는 아직 별도 미구현 기준이다.

`GameState`는 진행, `identity_profile_v1.cfg`는 외형, 기존 decor persistence는 장식, `together_time_v1.cfg`는 함께한 시간, `comfort_preferences_v1.cfg`는 편안함, `ambient_memory_v1.cfg`는 풍경, `voyage_postcards_v1.cfg`+PNG는 사진, `memory_ledger_v1.cfg`는 물고기/기존 항해 기록을 계속 소유한다. 기존 ID/파일을 일괄 새 schema로 바꾸지 않는다. transient 모션·풍경 phase는 현재 실행 중 메모리만 필요하다.

저장 오류 시 성공 UI/기록 중복을 금지한다. 쓰기 전에 유효성 확인, 성공 후 state 확정, 가능한 atomic replace와 이전 정상본 복구를 구현 패키지에서 검증한다. 손상 파일은 보존하고 조용한 기본값으로 진입하되 자동 저장이 복구 가능 원본을 덮지 않게 한다. 사진 경로는 지정 user directory 내부인지 확인하고, 누락 파일·디스크 부족·중복 클릭·동일 시각 파일명·앱 종료 도중 저장을 테스트한다. 자동 원본 사진 삭제/용량 cap은 채택하지 않는다. 나중에 사용자가 선택하는 사진 삭제 UI를 만들 때 exact 대상·확인·복구 가능성을 별도 명세한다.

모든 휴식 기능은 offline 실행이 기본이다. analytics SDK·클라우드 저장·계정 의무·공개 업로드를 추가하지 않는다. 병편지의 기존 moderation/consent/report/block/age/production gate는 별도 설계 owner를 그대로 따른다. 온라인 safety release가 안 됐어도 local rest는 막지 않는다. 새 출시 플랫폼·스토어 가격·배포일·서명·개인정보 정책 확정을 이 기획으로 대신하지 않는다.

### 2026-09-14 남은 작업 설계 명세 — R01–R12

**명세 준비 뒤 2026-09-14 사용자 `좋아 권장안대로 작업진행해`로 안전한 구현·검증 실행이 승인됐다. 최종 아트 lock·Human·출시 승인은 별도다.** 기존 P1–P10/B1–B12의 의미는 이 GDD가 계속 소유한다. 아래는 그 목표와 현재 코드 사이의 차이를 구현 단위로 구체화한 설계다. 실행 절차는 [남은 작업 구현 계획](../superpowers/plans/2026-09-14-remaining-implementation.md)이 소유하며 별도 AI/GDD master를 만들지 않는다. 현재 R07의 공통 저장 절차와 첫 owner부터 구현 중이며 전체 R07 완료가 아니다.

기준은 작업 branch `6b7949a563150bd93e08d5d5eb1e028eab7336ef`, 관찰한 origin/main `7181d5e6845e75107eade8c4d2e62e10334ab54b`다. 두 revision은 같지 않다. 아래 구현 상태는 **작업 branch 기준**이며 main에 모두 반영됐다는 뜻이 아니다. PR #19는 다른 social workstream으로 read-only다. Base v9.4.4 adapter를 유지하며 최신 Base 관찰값 `d830c0f6967678eed3c208ac6b24f9cd1b262ec3`로 조용히 교체하지 않는다.

#### 현재 구현과 남은 범위

| ID / 기존 패키지 | 현재 확인한 상태 | 남은 납품물 | 우선순위·착수 조건 |
| --- | --- | --- | --- |
| R01 / IMP-02 | 실제 직선 Path3D, 수평 방향 연결 있음. 수면은 camera-local | 공통 world 수면·깊이·접점·장거리 연속성 | P0 / 기술 probe 가능, 신규 texture production은 lock 필요. PARTIAL |
| R02 / IMP-02·04 | 봄섬 하나 world 공유. sky/cloud/일반 motif는 camera-local | 세계 방향 sky·cloud와 일반 motif의 공통 배치 | P0 / R01 좌표 계약. PARTIAL |
| R03 / IMP-03 | 후면 분리 PNG 모션 있음. assets에서 모델 파일 없음 | 기본 player+dog+boat의 실제 mesh/UV/rig/3clip 왕복 | P0 / 제작 경로·원본·최종 외형 lock 필요. BLOCKED_UNVERIFIED |
| R04 / IMP-02·03 | 카메라는 고정 위치에서 회전, 탑승자는 사인파 반응 | 실제 orbit·reset·부유·rest/notice/settle 연결 | P0 / R01–03. 계약 probe는 먼저 가능. PARTIAL |
| R05 / IMP-04 | 네 시간대 resolver/기존 이미지 있음 | 새 world family의 네 시간대 동기 전환. 계절 풍경은 R02 소유 | P1 / 낮 R01–04 통합 통과. PARTIAL |
| R06 / IMP-04 | 3 style/4 pet/8 slot/6 item 존재. style/pet 즉시 저장 | 미리보기/탭별 적용/취소, 새 모델 호환 전수 | P1 / 데이터 UI는 R07 뒤, 새 family는 R03 뒤. FEASIBLE(자산 제외) |
| R07 / IMP-05 | helper/comfort·다섯 단순 owner·사진 owner/Album 안전 읽기 연결 | GameState 성공 확정·복구 UI·모바일 사진 경로 지원 | P0 / R07a·R07b1·R07b2 scoped 구현/검증, 전체 PARTIAL. 전원차단 보장 제외 |
| R08 / IMP-05 | 앨범 최근/이전 3장 탐색과 누락 안내 있음 | 실제 사진 상세·안전한 지연 읽기·닫기 복귀 | P1 / R07 경로 경계. FEASIBLE |
| R09 / IMP-01·05 | 같은 world overlay, 조용한 낚시 상태·취소 있음 | 전 화면 입력/가독성·저장 실패·무손실 선택 행동 완결 | P1 / R06–08 연결. FEASIBLE |
| R10 / IMP-05 | 지속 OceanBed와 5단계 음량·음소거 있음 | 필요 근접 효과음 최소 layer·독립 제어·청취 검증 | P2 / 실제 음원·소비처 확인. PARTIAL |
| R11 / IMP-06 | headless/GPU 검사, Windows 내부 export 경로 있음 | 실제 시간 장기 soak·리소스/성능·실기기·패키지 검사 | P0 측정 / P1 통합. Device는 장치 없으면 BLOCKED_UNVERIFIED |
| R12 / IMP-06 | 작업 branch와 main 차이, 과거 source-bound PDF 존재 | 검토된 main 통합·현재 구현 Blueprint·배포 gate | 마지막 / R01–11 완료 증거 및 권한. PARTIAL |

FEASIBLE은 설계상 구현 경로가 있다는 뜻이다. `SPECIFIED`와 `ASSET_READY`, `IMPLEMENTED`, `RUNTIME_VERIFIED`를 구분한다. 이전 62 headless·20 Python·30초 GPU 결과는 해당 revision의 역사적 증거이며 이번 문서 작성으로 재실행한 결과가 아니다. Start/overlay/route/음량/앨범 pagination 자체를 다시 신규 제작하지 않는다.

#### 공통 좌표·시간·상태 계약

**2026-09-14 실행 전 벤치마킹 재대조.** 다음은 제작진·공식 자료에서 확인한 원리와 이 프로젝트의 적용 판단이다. 다른 게임의 엔진 내부를 추측하거나 이 비교를 우리 게임의 성능 증거로 쓰지 않는다. 최적화의 채택 기준은 동일 장치·renderer·viewport에서의 R11 측정과 실제 화면의 R01/R04 통과다.

| 근거 | 채택/변형/제외와 실제 연결 | 기대효과·검증 한계 |
|---|---|---|
| [DREDGE 제작진의 수면 시행착오](https://www.gamedeveloper.com/design/trawling-in-the-deep-how-black-salt-games-made-spooky-fishing-rpg-i-dredge-i-) — 파도에 의해 배가 비정상적으로 날아가는 문제, 단순 사인 파형과 이동 제어 | `ADAPT`. R01은 경로의 XZ 진행과 수면 높이/기울기의 시각 접점을 분리한다. 수면 물리로 항해 시간을 진행시키거나 배를 밀지 않는다. DREDGE의 시간 자원·위험·경제는 `REJECT` | 기존 `VoyageRoute`를 보존하면서 전진과 부유를 각각 검사할 수 있다. 같은 CPU/GPU 파형·선체 접점·정지/재개·128/512 경계를 실제 검증해야 한다 |
| [Lake 공식 접근성](https://whitethorngames.com/lake/accessibility) — 자동 이동, 안정적 카메라와 추적 선택 | `ADAPT`. 목적지/배송 목표는 도입하지 않고 자동 항해·선택적 둘러보기·저감/정지 설정을 유지한다. R04 자동 sway와 사용자 orbit을 분리한다 | 흔들림을 줄여도 경관의 공간적 이동이 남는지 R01/R04에서 검사. 접근성 목록은 우리 게임의 멀미/Human 통과 근거가 아니다 |
| [DREDGE 모바일 제작진 발표](https://developer.apple.com/videos/play/meet-with-apple/247/) — 화면비·손가락 가림·hover 의존을 수정 | `ADAPT`. R06 미리보기/적용, R08 카드 탭→상세→같은 페이지, R09 UI 소비 입력의 카메라 전달 차단. 화면 위 두 개 joystick이나 경제형 inventory는 `REJECT` | 탭으로 의도가 명확한 조작을 제공한다. PC 클릭 테스트 외 실제 화면 크기·touch·확대 글꼴 검증이 필요하며 모바일 기기 없이 완료 판정하지 않는다 |
| [Tiny Glade 제작진 인터뷰](https://80.lv/articles/exclusive-tiny-glade-developers-discuss-bevy-proceduralism-publishers-cozy-games) — 원하는 경험에 맞는 요소별 제작 파이프라인 | `ADAPT`. R01 수면, R02 sky/cloud/명소, R03 선체·인물·동반자, R04 motion의 책임과 납품을 분리한다. 자체 엔진/대규모 procedural GPU 생성기는 `REJECT` | 한 장 합성 그림을 다시 분해하는 재작업과 이중 수면을 피한다. 인터뷰에 없는 수면 알고리즘을 Tiny Glade의 구현이라고 주장하지 않는다 |

세 구현 대안은 R01의 화면 UV 보정 지속, 공통 세계 수면+기존 경로, 전체 해양 물리/오픈월드다. 현재 선택은 두 번째다. 큰 지도나 물리 엔진을 늘리는 것보다 세계에 고정된 가까운 물결·멀리 있는 명소를 보트/카메라가 지나가게 만드는 편이 현재 목적지 없는 휴식과 검증 비용에 맞는다. 성능 측정 전에는 **현재 제약에 맞는 권장 구조**이며 전 플랫폼의 최적해로 단정하지 않는다.

```text
GameState(항해·기억)     RestingSoundscape(지속 오디오)
          │                          │
기존 foreground/overlay gate ── UI와 오디오를 world에서 분리
          │ active visual delta
VoyageRoute(+Z 직선, 목적지 없음)
          ├─ BoatSpace/선체 anchors ── player/pet/장식/접점
          ├─ Camera focus ── orbit 입력/감상/reset
          ├─ OceanSurface(세계 좌표 UV, 배 이동과 이중 scroll 금지)
          └─ WorldScenery(항로 밖, 고정 위치를 실제로 지나감)
WorldEnvironment/Sky(자동 yaw 없음, 수동 시점에 공간 대응)
```

- 길이 기준 1 Godot unit = 제작상 1 m. 기존 2D card의 임의 pixel scale을 실제 모델 치수로 승계하지 않는다. 새 기본 선체 시험 길이 3 m, 폭 1.4 m. 최종 화면 크기는 B10 접점/구도와 함께 검수한다.
- 선수 +Z, 위 +Y. 선체 원점은 수면 중심. world 수면 평균 y=0. 기존 `-2.25` 접점 보정은 **구형 후면 카드 전용**으로 남기며 새 모델에 적용하지 않는다.
- visual advance는 현재 속도 tier와 `standard/gentle/still=1/0.5/0`를 한 번만 곱한다. title은 부유만, Start 뒤 route 진행. 물 shader의 `TIME`으로 비활성/overlay를 우회하지 않는다.
- full overlay/앱 비활성에서 world·반응·풍경 시간 동결. 재개 프레임에 이탈 시간을 더하지 않는다. UI·음량·뒤로 버튼은 동결하지 않는다. 영구 저장에 파도 phase나 카메라 각도를 추가하지 않는다.
- 새 production family는 한 번에 전환한다. 기존 card를 새 mesh 위에 겹치거나 새 바다 뒤에 기존 SeaBackdrop을 남겨 이중 수면을 만들지 않는다. 기존 family는 검증된 rollback용으로 보존한다.

#### R01. 세계 수면·전진·접점

**현 consumer**는 `scenes/game.tscn`의 세 `SeaBackdrop`, 숨겨진 `OceanPlane`, `BoatWaterContact`, `BoatWaterlineContact`와 `scripts/voyage/game_scene.gd::_apply_drift_motion`다. `scripts/voyage/voyage_route.gd`는 현재 128-unit 직선 구간을 잇는다.

**선택.** A 화면 UV를 계속 보정 `REJECT`(pitch/가림 불일치), B 한 world 수면+기존 직선 경로 `ADAPT`, C 전체 해양 물리/무한 오픈월드 `DEFER`(현재 소비 가치 대비 복잡함). 물리 부력으로 이동시키지 않고 시각 파동과 경로 이동을 분리한다.

**새 책임.** 제안 `scripts/voyage/world_ocean.gd`가 수면 위치·phase·접점 높이를 제공하고, 제안 `assets/shaders/world_ocean.gdshader`가 세계 XZ를 texture 좌표로 사용한다. `OceanPlane`을 실제 consumer로 전환한다. 기본 180×180 plane과 far 200의 현재 값을 무조건 유지하지 않는다. 허용 카메라의 최저 시선각까지 plane 경계가 노출되지 않도록 거리 fade와 sky 수평선을 먼저 검증한다. plane은 boat 주변으로 재중심화할 수 있으나 UV는 world 좌표 또는 연속 tile origin을 사용해 수면 무늬가 배와 같이 붙어가지 않게 한다. route 이동을 UV scroll에도 다시 더하지 않는다.

낮 탑뷰 후보 `MLB-NEW-SEA-001`은 `docs/visual/candidates/2026-09-11-blueprint/manifest.json`에서 FINAL_PENDING이다. 파일은 존재하지만 production-ready가 아니다. 격리 probe에만 사용하고, 실제 반복·모든 허용각·투명도/반사 검사와 lock 뒤 runtime copy를 등록한다. 새 투명감은 texture ALPHA를 낮추는 것만으로 해결하지 않는다. 첫 비교는 A 불투명 얕은 바다색(기준), B 깊이색+약한 굴절(시험), C 다중 screen/depth 패스(보류). B가 지원 renderer·접점·성능을 통과하지 못하면 A는 비교 기준으로만 유지하고 투명한 물 완료로 표시하지 않는다.

깊이 복원 구현 주의. [Godot 공식 depth 문서](https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html)를 2026-09-14 재확인했다. Mobile/Forward+와 Compatibility의 NDC z 범위를 같은 공식으로 처리하지 않고 renderer 분기를 둔다. depth는 해당 viewport의 값만 읽고 inverse projection으로 선형화한다. 다른 SubViewport의 카드 합성 깊이를 배 접점의 실제 깊이로 추정하지 않는다. [Spatial shader 문서](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html)의 depth/alpha 경계도 함께 검사한다. 이는 R01a 시험 구현 기준이며 현재 `voyage_split_sea_flow.gdshader`가 이미 이 새 world 수면이라는 뜻이 아니다.

제안 인터페이스는 `advance_visual(delta: float, intensity: float, active: bool) -> void`, `sample_height(world_xz: Vector2) -> float`, `set_boat_anchor(anchor: Transform3D) -> void`다. shader uniform은 `visual_phase: float`, `tile_origin_xz: Vector2`, `water_tint: Color`, `ripple_strength: float`이며 전부 transient다. 작은 두 사인파를 쓸 경우 CPU 접점 높이와 GPU 높이가 같은 파라미터를 공유한다. 별도 난수 부력·높이 계산 금지.

**완료 판정.** 기본/좌우/후방/상하극점에서 동일한 diagnostic world 표식의 위치를 비교한다. 표식은 QA 전용이며 게임 아트가 아니다. 128/512-unit, UV 한 주기, plane 재중심화 경계에서 표식 화면위치 jump ≤1 logical px를 초기 기계 기준으로 시험한다. 30초/5분/30분 실제 시간 capture와 접점 높이 오차 ≤0.02 m 시험값을 기록한다. still/overlay/background에서는 phase와 route 변화 0. 오직 물의 패치만 측정하고 섬이 포함된 영역은 속도 증거에서 제외한다. 수면 근경/원경 속도 관계를 실제 world 표식으로 판정한다.

#### R02. 하늘·구름·일반 명소 공간화

**선택.** A 카메라별 sky 카드 `REJECT`, B `WorldEnvironment.environment.sky`와 독립 world cloud/원경 `ADAPT`, C 거대한 sky mesh+전체 3D 지형 `DEFER`. `Sky`는 먼 배경 방향, 구름과 섬은 독립 consumer로 둔다. 낮/밤 flat 이미지가 panorama라는 뜻은 아니다. sky 후보는 yaw 범위와 seam coverage를 검사해 lock 후 연결한다.

현재 `SeasonalIslandLayer`의 공통 앵커 패턴을 일반 `AmbientSceneryPass`에도 적용한다. 제안 `scripts/voyage/world_scenery_layer.gd`는 `present_motif(motif_id: String, route_transform: Transform3D) -> bool`, `advance_visual(delta: float, active: bool) -> void`, `clear_motif() -> void`를 제공한다. `drift_scenery_director.gd`의 선택 ID/간격/확률은 그대로 입력받고 새 보상은 없다. 최대 큰 motif 1개. 중심선으로부터 거리 `abs(x) >= boat_half_width + rotated_motif_radius + 1.25`를 확보한다. radius는 billboard 회전까지 포함한 실제 크기로 구한다. 중앙에 섬을 내고 collision으로 피해 가는 새 항법은 만들지 않는다.

앵커 생성 후 world 위치는 고정, 접근·통과는 route 이동 결과다. 날씨/시간대 전환으로 화면 중간에 섬을 새 위치로 순간 재생성하지 않는다. 정상 퇴장 또는 안전 fade 후 교체한다. 구름의 자동 이동도 world active clock을 사용하며 still에서 멈춘다. sky 자동 yaw=0, 수동 카메라 회전에는 방향이 바뀌어야 한다.

**완료 판정.** 7개 기존 motif ID별 양쪽 항로·3 camera·시작/중간/퇴장, 중앙 통과 불가, single-instance, 누출 없음. sky는 title/자동 drift에 고정되되 user yaw에는 방향이 바뀜을 별도 검사한다. 기존 이미지로 옆면/가장자리를 충족하지 못하면 해당 family는 후보로 남기고 억지 확대하지 않는다.

#### R03. 실제 근거리 3D 납품·왕복

**선택.** A 방향 카드 추가 `REJECT`(연속 가림 불가), B 기본 한 가족의 glTF mesh/rig/손그림 texture `ADAPT`, C 모든 외형 동시 제작 `DEFER`. 먼저 player 1+dog 1+boat 1로 import·접점·변형 품질을 증명한다. 현재 `assets` 안에는 glb/gltf/blend/fbx/obj가 없으므로 이 단위는 자산 납품 차단 상태다. 무료 로컬 제작 도구 조사·기술 feasibility와 모델 완성은 분리한다. 설치·유료 서비스·파일 외부 전송은 필요한 권한을 별도 확인한다.

실제 파일이 생길 때 제안 runtime 경로는 `assets/models/boat/boat.glb`, `assets/models/player/player.glb`, `assets/models/companion/dog.glb`다. **지금 존재하는 경로가 아니다.** 모델 제작 원본·texture 원본·export 설정·Godot import 설정·권리/출처·hash를 기존 visual manifest에 추가한다. PNG를 plane으로 감싼 glb나 Godot primitive 조합으로 최종 모델을 대신하지 않는다.

필수 node/anchor 이름은 `Waterline`, `SeatPlayer`, `BackSupportPlayer`, `FootSupportPlayer`, `SeatPet`, `FootSupportPet`, `CameraFocus`, `WakeAnchor`, `DecorAnchors/<기존 slot ID>`다. 모델은 +Z 선수/1 m 단위, root scale (1,1,1). player/pet에는 Skeleton3D와 `rest_loop` 6 s, `notice` 1.2 s, `settle` 1.8 s 시험 clip을 납품한다. root translation=0, rest만 loop, notice/settle은 one-shot. 현재 공개되지 않은 얼굴/의상 세부는 최종 아트 lock에서 판단한다.

첫 모델 texture는 1024/2048 비교, 재질·삼각형·bone 수는 측정값으로 기록한다. 미지정 모바일의 최종 상한을 발명하지 않는다. 실루엣/접점/잔털·투명 material 오버드로우에 따라 최저 품질을 결정한다. `scenes/boat_space.tscn`에 imported scene의 wrapper를 두고 자동 재import 대상 자체를 수동 편집하지 않는다.

**완료 판정.** reimport 2회에도 wrapper anchor·clip 이름 보존, 승인 후면 구도 비교, 전 허용 yaw/pitch에서 갑작스러운 외형 교체 없음, 좌석/발 접점 drift ≤0.02 m 시험, 의상/선체 관통·잘림 검수, rollback family 복귀 가능. 도구 실행 성공만으로 ASSET_READY 판정 금지.

#### R04. 추적·orbit·부유·탑승 모션

**선택.** A 제자리 카메라 회전 `REJECT`, B route focus를 중심으로 수동 orbit `ADAPT`, C 자동 orbit/물리 spring chase `DEFER`. 제안 `scripts/voyage/voyage_orbit_controller.gd`가 카메라 위치와 방향을 함께 계산한다. normal reset은 기준 후면 3/4, `CameraFocus`를 화면 (0.5,0.80)±(0.03,0.03)에 두는 framing 시험이다. 캐릭터/선미가 UI 뒤로 잘리지 않게 실제 mesh bounds도 검사한다. 고정 반경 초기값 8.5 m를 비교하고 최종값은 기본 3 m 선체와 화면 capture로 정한다.

`set_view_angles(yaw: float, pitch: float) -> void`, `reset_view() -> void`, `set_focus_transform(value: Transform3D) -> void`, `cancel_drag() -> void`를 제공한다. yaw는 기준 대비 ±135°. pitch 입력 -16..38은 **orbit 위치의 위에서 내려다보는 정도**로 정의하여 기준 elevation 29.793805°에 더한다. 위치는 focus+rotated radius, 시선 목표는 별도로 `focus + Vector3.UP * framing_height`다. 실제 camera orientation은 이 시선 목표를 바라보도록 계산하며 pitch를 다시 -elevation으로 덮지 않는다. normal/reset/viewport 변경 때 framing_height를 0..radius×0.8 범위에서 탐색하여 focus의 정규화 투영 좌표 (0.5,0.80)를 맞춘다. 해가 없거나 mesh가 잘리면 검증 실패로 남기고 몰래 crop하지 않는다. 수동 orbit 중에는 마지막 framing_height를 유지하고 극점에서 mesh bounds를 재검사한다. 현재 rotation-only 코드의 +pitch 부호를 그대로 복사하지 않는다. `get_angle_id()`의 overhead 의미는 보존하되 카드 선택을 runtime model에 적용하지 않는다. horizon roll=0, 관성/자동 줌 없음.

보트의 작은 heave/roll은 route에서 분리된 시각 offset, 탑승자는 같은 BoatSpace를 상속한다. 제안 `scripts/companion/rest_pose_controller.gd`의 `advance_rest(delta: float, intensity: float, active: bool)`가 REST→NOTICE→SETTLE→REST를 제어한다. 반응 대기 45–90 active seconds, notice 1.2 s, settle 1.8 s. 탭은 진행 중 반응을 다시 시작하거나 예약하지 않는다. still에서는 자동 pose·clip 시간 동결, 수동 보기와 소리는 유지한다. 저감 모드는 움직임 강도를 줄이지 반응 빈도를 보상으로 바꾸지 않는다.

**완료 판정.** 대각 드래그·두 손가락·release/focus loss·UI drag·20회 reset, 같은 voyage instance/시간/소리 보존. 전 각도에서 focus 프레임 안, 좌석 접점 유지. 반응 종료 뒤 rest 복귀 점프 없음, inactive 1시간 뒤 catch-up 0, 연타해도 notice queue 0. 현재 2D slice에는 새 모델 clip 완료를 표시하지 않는다.

#### R05. 시간대 family 동기화

**선택.** A 즉시 texture 교체 `REJECT`(큰 색 점프), B sky/sea/light/모델 재질의 공통 3초 blend `ADAPT`, C 모든 시간대 이중 world 상주 `REJECT`(메모리/중복). `time_of_day_catalog.gd`와 resolver ID는 유지한다. 제안 `scripts/voyage/atmosphere_transition.gd`의 `request_atmosphere(id: String)`, `advance_visual(delta: float, active: bool)`, `get_blend_weight() -> float`가 하나의 0..1 weight를 제공한다. 현재/다음 family 최대 두 개만 유지하고 완료 뒤 이전 texture 참조를 해제한다.

첫 진입은 로컬 시계의 해당 family를 즉시 적용한다. 실행 중 경계만 3 active seconds 전환, overlay/background는 전환도 동결한다. 전환 중 다른 요청은 `latest_requested_id` 문자열 하나만 갱신하며 세 번째 texture를 읽지 않는다. 현재 전환을 끝낸 뒤 최신 ID가 도달한 target과 다를 때만 새 3초 전환을 시작한다. 동일 ID 재요청은 weight를 초기화하지 않는다. 복귀 때도 최신 시계 ID만 요청하고 놓친 시간대 backlog는 재생하지 않는다. 따라서 최신 시각 반영은 남은 전환 최대 3초와 새 전환 3초까지 지연될 수 있으나 화면은 연속적이다. still은 자동 blend를 돌리지 않고 최신 family를 한 번 즉시 동기화하며 이전 참조와 pending ID를 비운다. 시간대 저장 preference/보상 없음. 계절별 풍경의 기존 motif ID·제작·연결은 R02에서 담당하며 새 계절 전용 하늘/바다 family 확대는 이번 R05에 포함하지 않는다.

**완료 판정.** 04/05,08/09,16/17,20/21시, 월 경계, 전환 중 다시 시간 변경, invalid hour. 세 카메라/물/선체/구름의 atmosphere ID와 blend 값 동일. 단색 tint로 네 시간대 아트 납품을 대신하지 않는다.

#### R06. 꾸미기 draft·기존 ID·새 외형 family

**확인된 차이.** `game_scene.gd::_on_player_style_selected/_on_pet_type_selected`가 현재 즉시 GameState를 변경한다. `UI-05`의 미리보기 후 적용/취소를 충족하지 않는다.

**선택.** A 즉시 저장 유지 `REJECT`, B 탭별 메모리 draft+명시 적용 `ADAPT`, C 여러 cfg를 한 글로벌 거래로 묶기 `DEFER`. 외형 탭은 style+pet을 identity 파일에 함께 적용, 장식 탭은 decor+appearances를 decor 파일에 함께 적용한다. 적용 버튼은 현재 탭을 명시하고 닫기/뒤로는 **아직 적용하지 않은 draft만** 버린다. 이미 적용한 다른 탭을 취소한 것처럼 표현하지 않는다.

제안 `scripts/decor/decor_edit_session.gd`는 `begin(identity: Dictionary, decor: Dictionary)`, `set_identity(style: String, pet: String)`, `set_item(slot: String, item: String, appearance: String)`, `snapshot(tab_id: String) -> Dictionary`, `discard(tab_id: String)`, `mark_applied(tab_id: String)`를 제공한다. snapshot은 deep copy이며 identity 키는 player_style/pet_type, decor 키는 decor/appearances다. GameState에 제안 `apply_identity_selection(style: String, pet: String) -> bool`, `apply_decor_selection(decor: Dictionary, appearances: Dictionary) -> bool`을 추가한다. persist가 성공해야 state/signal을 확정하고 mark_applied로 해당 탭 baseline을 갱신한다. preview는 snapshot을 읽고 autoload/save를 쓰지 않는다. 실패 문구를 보여 주고 committed 모습으로 복구한다.

기존 style `a_soft_hooded/b_short_cape/c_loose_knit`, pet `cat/rabbit/otter/dog`, 8 slot/6 item는 삭제·이름 변경하지 않는다. 3×4=12 identity 조합, 모든 허용 slot/item/appearance를 catalog에서 열거한다. 새 family 미지원 ID를 default로 치환하지 않고 기존 family를 명시 유지한다. 새 모델 하나 완료와 전 외형 호환 완료를 별도로 표시한다.

**완료 판정.** 선택만 하고 닫기→cfg/state bytes 동일, Apply 성공 1회, 실패→기존 모습 유지. NOT_COMMITTED는 파일 보존, RECOVERY_REQUIRED는 R07의 쓰기 잠금·복구 안내를 따른다. 연타 중복 0, slot 불가 item 거부, preview와 바다 동일 선택. 12 identity 조합+호환 장식·네 시간대·카메라 극점에서 clipping/접점 검사.

#### R07. 저장 보호·정상본 복구·사진 경로

**2026-09-14 R07a·R07b1 구현 현황.** 공통 store/comfort(`4773c68`)에 이어 identity/decor/together-time/ambient/ledger owner도 연결했다(`b07f8b8`, 우선순위 교정 `6f6f716`). 사진 resolver와 GameState/UI 성공 확정은 여전히 남았다. 세부 검증·미검증 및 독립 검토 상태는 [현재 증거](../evidence/2026-09-14-recoverable-save/REVIEW.md)를 따른다. 단순 읽기는 파일을 변경하지 않으며 증거 보존/잠금 파일 쓰기는 실제 저장·명시 복구 요청 때만 수행한다.

**선택.** A 기존 파일 바로 overwrite `REJECT`, B 기존 schema를 유지한 owner별 staging+검증 정상본+복구 receipt `ADAPT`, C 새 DB/클라우드/전체 migration `REJECT`. 대상은 `scripts/core/*_persistence.gd`, `cosmetic_identity_profile.gd`, `comfort_preferences.gd`의 실제 소비 owner다. 단순 rename을 Windows/모바일 모두 atomic 또는 전원차단 안전하다고 부르지 않는다.

제안 공통 `scripts/core/recoverable_config_store.gd`는 파일 처리만 맡고 각 owner의 schema 검증 Callable을 받는다. `read_validated(path: String, validate: Callable) -> Dictionary`, `write_validated(path: String, candidate: ConfigFile, validate: Callable) -> Dictionary`, `recover_primary(path: String, validate: Callable) -> Dictionary`. read 결과 키는 `status: String`(OK/ABSENT/RECOVERED/CORRUPT/IO_ERROR), `config: ConfigFile|null`, `source_path: String`. write/recover 결과는 `status: String`(COMMITTED/NOT_COMMITTED/RECOVERY_REQUIRED), `error: Error`, `source_path: String`이며 COMMITTED만 state/UI 성공으로 전달한다. filename 확장은 `.pending`, `.last_good`, `.recovery.json`이고 owner 파일 옆에 둔다. 단일 앱 내 동일 owner의 쓰기는 직렬화한다.

쓰기 순서. 기존 정상 primary와 candidate를 검증→원본 hash/부재를 담은 쓰기 의도를 검증 저장→candidate를 pending에 쓰고 재읽기 검증→기존 primary의 정상본을 last_good에 복사·hash 대조→교체 시도→primary 재읽기 검증→성공 반환. 의도 기록은 최초 저장의 pending 실패에서도 검증된 원본 부재를 복구할 수 있도록 pending 생성 전에 남긴다. 기존 pending/미해결 의도 기록이 있으면 먼저 검증·복구 판정하여 보존하고 새 쓰기로 덮지 않는다. 알 수 없는 orphan pending만으로 원본 부재를 추정하지 않는다. 교체 전 실패는 NOT_COMMITTED다. 교체 후 검증 실패는 verified last_good으로 원본을 복원하고 재읽기/hash가 일치할 때만 NOT_COMMITTED다. 원래 파일이 없었다면 이번 쓰기의 산출물만 격리 보존한 뒤 primary 부재를 검증한다. 복원/부재 검증도 실패하거나 commit 여부를 판정할 수 없으면 RECOVERY_REQUIRED로 해당 owner 쓰기를 잠그고 모든 primary/last_good/pending/recovery 증거와 마지막 committed 메모리를 보존한다. UI는 단순 취소가 아니라 복구 필요를 표시하며 디스크 불변을 주장하지 않는다.

깨진 primary는 별도 recovery 사본과 hash를 보존하고 검증된 last_good만 읽기 복구 후보로 사용한다. read의 RECOVERED는 backup 읽기 상태이지 primary 복원 성공이 아니다. `recover_primary`가 사본 보존→검증 정상본 복원→readback/hash 일치를 확인한 COMMITTED 이후에만 쓰기 잠금을 해제한다. 실패하면 RECOVERY_REQUIRED를 유지한다. 이전 원본/알 수 없는 key는 자동 정규화 삭제하지 않는다. staging/backup 정리에 실패해도 회복 가능 증거를 남긴다. OS crash/power-loss 내성은 별도 실제 장애 시험 전 PARTIAL이다.

사진은 PNG 저장·목록 저장을 분리한다. 목록 commit 성공 전 UI 성공/메모리 추가 없음. 손상 목록은 현재처럼 저장 거부. 새 PNG만 남는 중단 상태는 원본을 지우지 않고 recovery receipt에 기록한다. 저장 직후 실패의 이번 생성 PNG teardown과 사용자 원본 삭제를 구분한다. 기존 id/label/atmosphere/image_path는 보존한다.

읽기 경계. album은 metadata의 임의 경로를 직접 열지 않고 owner의 `resolve_photo_path(entry: Dictionary) -> String`을 호출한다. 지정 photo directory 안에 있고 예상 id basename과 일치하는 정상 PNG만 반환한다. `..`, 절대 외부 경로, 접두사만 같은 sibling, 경로 구분자 삽입, 확인 불가 link/reparse 우회는 거부한다. fixture에서 안전한 link 판별이 엔진/API로 검증되지 않으면 해당 경로를 열지 않는다. metadata는 보존하고 읽기 불가 안내만 한다.

R07b 사진 구현의 자원 경계는 압축 PNG 32 MiB 이하, 각 축 4096 이하, 총 16,777,216 pixels 이하다. 전체 디코드 전에 파일 크기/PNG header를 확인하고 초과·손상 파일은 원본을 그대로 둔 채 unavailable로 표시한다. A 무제한 디코드 `REJECT`, B 현재 촬영 크기를 포함하는 유한 상한+오류 반환 `ADAPT`, C 새 썸네일 DB/마이그레이션 `DEFER`다. 이 수치는 엔진 최대치가 아니라 앨범의 최대 카드 3장+상세 1장에 맞춘 초기 방어 상한이며 R11 메모리 측정으로 더 낮출 수 있다. [Godot Image API](https://docs.godotengine.org/en/stable/classes/class_image.html)의 오류 반환과 [DirAccess.is_link](https://docs.godotengine.org/en/stable/classes/class_diraccess.html#class-diraccess-method-is-link)의 실제 플랫폼 지원을 검증한다. 앱 자신의 save root 아래 link/reparse 검사를 수행하되, 동시에 파일을 바꾸는 악의적 OS 사용자의 경쟁 상태까지 완전 차단했다고 주장하지 않는다.

R07의 실제 상태 확정 소비처는 GameState의 외형/장식/풍경/물고기/항해 기록과 together-time flush다. 저장 실패 때 기록 배열·성공 문구·입질 소비를 확정하지 않고 미저장 함께한 시간은 유지한다. comfort/mute는 기존 접근성 예외로 이번 실행에 즉시 적용하되 영구 저장 실패를 별도로 알린다. `game_scene.gd::_apply_stored_boat_decor`처럼 읽은 선택을 화면에 적용하는 함수는 다시 저장하지 않아야 한다. 최초 Scene 진입/앨범 복귀를 사용자 선택 변경으로 취급하지 않는다.

**완료 판정.** 파일 없음/파싱 실패/unknown key/NaN/잘못된 row/type/디스크 쓰기 실패/각 쓰기 단계 종료/복구본도 손상/경로 탈출/중복 사진을 격리 `user://test_*`에서 시험한다. NOT_COMMITTED는 원본 bytes(또는 기존 부재)와 기억 개수·선택 불변을 확인한다. 복원 실패는 RECOVERY_REQUIRED·후속 쓰기 차단·메모리/모든 복구 증거 보존을 확인하며 정상 rollback으로 세지 않는다. 복구는 silent reset과 구별되는 RECOVERED 읽기 및 recover_primary 결과를 기록한다. production save로 fault injection 금지.

사진 손상 진단 경계. PNG 크기·chunk 구조·CRC 선검사 뒤에도 엔진 decoder가 압축 payload 손상을 발견하면 오류 반환을 확인하고 unavailable로 표시한다. 해당 격리 음성 검사의 예상 libpng/Godot 진단은 원본 로그와 따로 기록하며 일반 실행 오류 0으로 합산하지 않는다. 전역 오류 출력을 숨기거나 별도 PNG/DEFLATE decoder를 재구현하지 않는다. 플레이어에게 오류창·중단 없이 안내하는 계약과 악성 파일 입력의 엔진 진단 절대 부재는 다르다. 정상 사진/일반 회귀의 예상치 않은 오류는 검증 실패다.

#### R08. 앨범 사진 상세·자원 해제

**선택.** A 최근/이전 카드만 유지 `REJECT`(UI-06 상세 누락), B 같은 album 안의 단일 상세 overlay `ADAPT`, C 갤러리 별도 scene/무한 preload `REJECT`. 현재 `album_view.gd`는 카드가 입력을 무시하고 원본 3장을 직접 읽는다.

`scenes/album.tscn`에 제안 `PhotoDetail` Control/TextureRect/Caption/Back, script는 기존 `scripts/ui/album_view.gd`에 작은 책임으로 추가한다. `open_photo_detail(photo_id: String) -> bool`, `close_photo_detail() -> void`. card는 사진 ID를 전달하고 R07 경로 검증 뒤 해당 한 장만 읽는다. 뒤로 순서는 상세→같은 페이지/스크롤의 앨범→같은 항해. 잘못된 ID·누락·손상은 서로 구분해 표시하고 기존 기록은 삭제하지 않는다. 공유/다운로드/삭제 기능은 추가하지 않는다.

최대 원본 residency는 현재 3개 card+상세 1개를 상한으로 시작하고 화면용 썸네일 필요성은 R11 측정으로 결정한다. detail 닫기/페이지 변경/앨범 닫기에서 참조를 해제한다. viewport를 바꿔도 전체 이미지 비율을 유지하고 caption/Back은 읽을 수 있어야 한다.

**완료 판정.** 0/1/3/4/100개 기록, 첫/마지막 페이지 clamp, 상세 20회 열기/닫기, 파일 누락·외부 path·메모리 해제, 360×640/540×960/720×1280, overlay 중 world 시간 증가 0. 기존 pagination을 재구현하지 않는다.

#### R09. 선택 행동·입력·가독성 통합

**선택.** A 새 시작 튜토리얼/상시 HUD `REJECT`, B 기존 작은 메뉴와 state를 유지하며 실패/취소/입력을 보강 `ADAPT`, C 모든 선택 행동 제거 `REJECT`. 범위는 기존 game/album/decor/fishing/low_pressure_interactable이며 새 미니게임·보상은 없다.

낚시 WAITING/BITE_READY/QUIET_READY와 실패 패널티 없음은 유지한다. overlay 열기/취소는 결과 0, 준비 상태 연타는 결과 최대 1. 저장 실패 때 catch state를 성공으로 소모하지 않는지는 실제 state/persistence 경로로 검증하고 필요하면 저장 성공 뒤 resolve 순서로 바꾼다. no-catch는 실패 팝업 없이 휴식 복귀한다. 300초 후 자동 종료·재시작 유도 패널을 만들지 않고 기록은 앨범에서 보이게 한다.

text-native Theme/Container를 우선한다. 초기 시험값 본문 18 logical px, hit 영역 48 logical px. 큰 글자 배율 1/1.25/1.5 비교, safe-area padding은 실제 viewport/display rect에서 계산한다. 메뉴 button/option/slider가 받은 입력을 camera가 다시 소비하면 실패. reset와 뒤로의 우선순위를 `사진 busy 복원→상세→full overlay→쉬는 메뉴→기본 항해`로 명시한다. 화면낭독기 지원은 실제 연결을 확인하기 전 미지원/미검증으로 남긴다.

**완료 판정.** 시작 연타/사진 busy 중 뒤로/drag 중 popup/focus loss/20회 overlay/낚시 취소/저장 실패/큰 글자·긴 caption 표본. 기본 화면에 엽서·성과 카운터 자동 노출 0. 소리와 색 없이 중요한 상태·오류를 파악할 수 있어야 한다.

#### R10. 근접 소리 최소 보강

**선택.** A 현재 ocean만 유지 `ADOPT_BASELINE`, B 실제 waterline/선체·작은 동반자 반응에 필요한 짧은 효과만 독립 bus로 추가 `TEST`, C 음악·다수 자연음 상시 중첩 `REJECT`. 현재 OceanBed와 volume 기능은 완성된 기준선으로 보존한다. 효과음이 정말 필요한 clip/consumer를 청취 가능한 원본으로 확인한 뒤 B를 채택한다.

제안 `RestingSoundscape.play_near_effect(effect_id: String) -> bool`, GameState의 `set_effect_volume(value: float) -> bool`. effect ID는 실제 납품된 파일만 catalog에 등록한다. 현재 존재하지 않는 음원 경로를 납품 완료로 쓰지 않는다. effect bus 0..1, 최대 동시 one-shot 2개 시험, 과밀 요청은 queue 없이 버린다. UI/배경 이탈 처리와 ocean 재생 위치는 분리한다. `comfort_preferences_v1.cfg` optional `effects_volume`은 실제 bus 연결 시에만 추가한다.

**완료 판정.** muted startup/0..1 범위/저장 실패 session-only/화면 전환 ocean 재시작 0/voice limit/반응 연타/loop seam·peak 검사. OS 출력·귀로 듣는 품질은 Human 선언 후 별도. 새 음악이나 유료 음원 구매는 포함하지 않는다.

#### R11. 성능·장시간·내부 패키지 검증

**선택.** A 테스트 수만 증가 `REJECT`, B 기존 capture/contract에 실제 시간·자원·패키지 측정 추가 `ADAPT`, C 대형 외부 telemetry 서비스 `REJECT`. `tests/capture_voyage_realtime_motion.gd`, `tools/analyze_voyage_motion_capture.py`, 기존 tests/export를 재사용한다. frame time median/p95/p99, draw calls, texture/메모리, viewport, renderer, engine, 하드웨어와 실행 revision을 기록한다. 실제 30초/5분/30분은 수동 delta 장기 점프와 구분한다.

PC 60 fps/모바일 30 fps는 시험 목표이며 기기 미지정 상태에서 최저사양·PASS를 만들지 않는다. 먼저 기준 PC p95 16.7 ms, 모바일 p95 33.3 ms를 목표로 측정하고 미달 구간의 texture/투명 overdraw/photo load부터 줄인다. idle·사진 상세 20회·꾸미기 조합 교체·시간대 4회·30분 후 메모리 plateau를 비교한다. 10회 워밍업 뒤 후속 10회에서 지속 증가 여부를 기록하고 OS 잡음과 실제 retained resource를 구분한다.

Windows 현재 preset은 unsigned 내부 배포용이다. clean import→export→새 빈 user data로 실행→기존 테스트 save fixture 로드→실제 Start/사진/앨범/음량까지 패키지에서 확인한다. 원본 사진/사용자 save를 빌드에 포함하지 않는다. 모바일은 target OS/장치/SDK·서명 권한이 확인되기 전 spec만 준비하고 새 store upload는 하지 않는다.

#### R12. 통합·Blueprint·공개 범위 분리

**선택.** A 누적 branch를 즉시 main에 합치기 `REJECT`, B 범위·충돌·검증을 확인한 PR 통합 `ADAPT`, C 정본을 별도 문서/Notion으로 복제 `REJECT`. 시작 시 exact branch/main/open PR·ruleset를 다시 확인한다. unrelated PR #19는 흡수·수정·병합하지 않는다. 검토된 범위만 정상 PR 절차로 합치고 main에서 import/전체 tests/실제 패키지 재검증한다. 새로운 branch를 이미 병합된 것처럼 보고하지 않는다.

구현 후 사람용 Blueprint는 기존 GDD와 source-bound PDF generator를 재사용해 갱신한다. 새 runtime screenshot/모션 표본, 화면 아틀라스, 상세 SWOT 실행 상태, 시스템 연결, 데이터/자산표와 실제 consumer를 빠짐없이 포함한다. 이전 PDF/receipt는 덮지 않는다. 새 revision/hash/page count/텍스트 넘침/이미지 중복/캡션·후보/실행 구별을 검증한다. 단순 링크 개수나 과거 캡처로 현재 적용을 증명하지 않는다.

local game 완성과 온라인 병편지 공개는 다른 gate다. social 구현/보안 상세는 기존 `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`를 책임 owner로 유지한다. production moderation·동의·16+·report/block·운영·지원·정책 증거 없이는 공개 금지. 이 명세로 법적 적합성·온라인 배포를 새 승인하지 않는다. 해당 workstream이 사용자 지정으로 열릴 때 최신 공식 규정과 실제 backend를 별도 조사한다.

최종 승인 조건은 ① local core 기능 전체 ② 새 art/model consumer ③ 기계/실행/기기 증거 ④ 사용자가 선언한 Human 검증 ⑤ 권리·서명·공개 gate를 각각 표기하는 것이다. 일부 통과를 전체 출시 PASS로 합치지 않는다.

#### 조사 근거와 해석 범위

2026-09-14 조회. 아래는 설계 근거이며 우리 프로젝트 실행 증거가 아니다.

- [Godot spatial shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html) — world 좌표/재질 입력 분리. R01에서 엔진 전역 TIME 대신 승인된 active clock을 공급한다.
- [Godot Sky](https://docs.godotengine.org/en/stable/classes/class_sky.html) — R02 먼 배경 owner. 평면 후보의 자동 panorama 승격은 제외한다.
- [Godot 3D format/import](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html) — R03 glTF 제작/왕복 경로. 엔진 지원이 모델 제작 성공을 뜻하지 않는다.
- [Godot ConfigFile](https://docs.godotengine.org/en/stable/classes/class_configfile.html) — R07 load/save Error와 기존 저장 형식. 파일 API를 전원차단 transaction 보장으로 해석하지 않는다.
- [DREDGE 제작진의 Apple 플랫폼 사례·공식 transcript](https://developer.apple.com/videos/play/meet-with-apple/247/) — 터치 버튼·손가락 가림·UI 흐름은 PC 입력을 그대로 옮기는 것으로 끝나지 않았다는 제작 경험을 R09/R11에 ADAPT. 이 게임에는 수동 항해 joystick·낚시 경제·유료화 사례를 가져오지 않는다. 공개 transcript를 읽었으며 영상 전체 시청/내부 코드 열람은 아니다.
- DREDGE Sprint 22 페이지는 이번 직접 open에서 오류가 나 근거로 채택하지 않았다. 검색 요약만으로 우리 수면 구현 완료를 주장하지 않는다.

#### 유지·추가·교체·폐기 판단

| 현재 상태 | 권장 조치 | 이유·기대효과 |
| --- | --- | --- |
| 단일 route/overlay/사진 pagination/ocean volume 있음 | 유지·회귀 검사 | 검증된 기능을 다시 만들지 않아 장면/저장 회귀 감소 |
| camera-local sea/sky와 방향 카드 | 새 family 통과 후 production consumer 교체 | 공간 모순·연속 회전 파열 제거. 파일은 즉시 삭제하지 않음 |
| 즉시 저장 꾸미기 | R06 draft/적용/취소 추가 | 실수 선택과 저장 실패의 의미 명확화 |
| 부분 저장 보호 | R07 공통 파일 절차만 재사용, schema는 기존 owner | 손상 복구를 각 기능에서 제각각 만들지 않음 |
| 여러 과거 기획/증거 | current router는 이 절/실행 계획, historical receipt 보존 | 오래된 완료/보류 상태를 현재 실행 권한으로 오독하는 일 감소 |
| 사용 종료 원본·임시 probe | 소비처/해시 확인 후 날짜별 삭제 대기 이동 | 실제 사용 파일만 작업 경로에 유지하고 사용자 직접 삭제 보장 |

새 공용 skill/module은 현재 필요 없다. world 좌표·fault injection·증거 분리 교훈은 프로젝트 handoff로 연결하고, 여러 프로젝트에서 동일 실패가 확인될 때만 Base promotion 후보를 만든다.

#### P9. 제작 순서·실제 consumer·검증 계획

| 순서 | 제작 단위와 소비처 | 필요한 입력 / 완료 기준 | 실패 시 처리 |
| --- | --- | --- | --- |
| 0 | 이 통합 기획 + handoff + visual inventory | 전체 범위·정본·기존 save·이미지 보류 경계 일치 | 문서 모순부터 교정; 새 원화로 넘어가지 않음 |
| 1 | C안 생산 가능성 검증, 이후 `scenes/boat_space.tscn` 대체 family | 승인 방향 기준 모델/리그/재질 제작 경로·glTF 왕복·3상태·회전 접점·모바일 측정 | PARTIAL 유지. 원본 primitive나 카드로 최종 성공 위장 금지. A로 축소 전 의미 결정 분리 |
| 1a | 필요한 준비물과 이 GDD의 source-bound Blueprint 검토 | 이미지 보류 해제 후 필요한 후보만 준비, exact 검토 범위의 final approval 이후 아래 production 구현 진행 | 불확실한 자산이나 문서만으로 게임 구현 gate 통과 금지 |
| 2 | `scripts/voyage/game_scene.gd`, `scripts/ui/album_view.gd`, `scripts/core/game_state.gd` | 단일 항해+overlay, foreground 공통 진행, 기존 기록 호환. state 전환 table과 오류 테스트 | 영구 데이터 migration 없이 연결 단위 rollback |
| 3 | game/boat_space + 기존 water/background shaders + camera controller | 낮 한 가족으로 물·배·player·dog·수동 회전·감상·접점 연속성 | 수면/카메라/가림을 먼저 수정, 콘텐츠 확대 금지 |
| 4 | time_of_day_catalog / drift_scenery_director / identity·decor catalogs | 네 시간대·기존 motif·3 style/4 species/장식 호환 확대 | 새 미지원 조합으로 기존 save를 silently 기본값 치환하지 않음 |
| 5 | 사진·앨범·낚시·soundscape·설정 | 비어 있음/저장 실패/취소/복귀/음소거/저감까지 전체 흐름 | 실패 상태를 숨기지 않고 원본 보존·기능별 안전한 취소 |
| 6 | export presets·실제 빌드·구현 반영 Blueprint 파생 publication | target별 clean import/export, 실제 시간 검증, source/hash·권리·Human·release 분리 | 공개 출시·Human 승인은 조건 충족 전 보류 |

각 단위는 `IDEA → RESEARCHED → FEASIBLE → SPECIFIED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_VERIFIED → USER_APPROVED`를 따르며 불확실한 C를 FEASIBLE로 건너뛰지 않는다. 기획 전반 정리는 이미지 보류와 양립한다. 다음 제작 단계는 사용자의 이미지 보류 해제와 현행 Blueprint final gate를 지켜 진행한다.

기계 수용 기준은 시작 연타 1회, 300초 기록 최대 1개, 메뉴·focus 복귀 시간 jump 없음, scene 재진입 시 위상·선택·소리 유지, 낮/밤 경계의 family 일치, 전체 bob/회전에서 좌석·수면 접점 유지, 섬 항로 비침범, 사진 실제 frame+성공 저장 1개, 취소 낚시 0개, 모든 legacy ID 복원, 누락/손상/쓰기 실패 보존이다. 모션 캡처는 직접 delta 호출 비교만이 아니라 실제 시간 30초·5분·30분 soak와 반복 경계로 확인한다. 기계 장시간 테스트는 사용자 휴식감의 증거가 아니다.

성능 목표는 `RECOMMENDED_DEFAULT`: 기준 PC 60fps, 후속 목표 모바일 30fps 하한을 우선 시험한다. target device 미지정이므로 성능 PASS/최저 지원 사양/메모리 상한을 발명하지 않는다. baseline을 측정하고 반복 메뉴 전환·사진 읽기·투명 오버드로우·texture residency를 비교한다. 한꺼번에 모든 사진·시간대·종별 원본을 메모리에 올리지 않는다. 텍스처 크기와 compression은 실제 화면/alpha/장치 검사 후 고정한다.

최종 Human은 사용자가 선언할 때만 진행한다. 첫 화면에서 의미를 이해하는지, 5분이 의무처럼 느껴지는지, 배가 전진/부유하는지, 30분 반복이 피곤한지, touch/소리가 편안한지 확인한다. 품질 수치·기계 검사가 이 질문을 대체하지 않는다.

#### P10. 조사·권장안·유지보수 판정

아래 기존 10개 benchmark 표의 공식 URL을 2026-09-10 다시 조회했다. Tiny Glade/Townscaper/SUMMERHOUSE의 비과업 창작, A Short Hike/ABZÛ/Flower의 환경 반응, Journey/Spiritfarer의 동행·장소성, Lil Gator의 친근한 가독성, Kind Words의 낮은 압력 표현을 위 규칙에 변형 적용했다. 플레이테스트·내부 역공학·매출 원인 검증은 아니다. 본디 제공 자료는 구성 참고이고 자산·브랜드·고유 외형을 복제하지 않는다.

공식 기술 근거는 [Godot Sprite3D](https://docs.godotengine.org/en/stable/classes/class_sprite3d.html), [glTF 가져오기](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html), [AnimationTree](https://docs.godotengine.org/en/stable/classes/class_animationtree.html)다. Sprite3D는 2D texture 표시이지 자동 3D 복원 기능이 아니다. AnimationTree를 채택하면 playback owner는 하나로 두고 AnimationPlayer와 경쟁 제어하지 않는다. [접근성 모션 지침](https://gameaccessibilityguidelines.com/avoid-or-provide-option-to-disable-any-difference-between-controller-movement-and-camera-movement/)은 자동 카메라 흔들림을 줄이고 끌 수 있게 하는 판단의 근거다.

Base v9.4.4는 유지하고 공용의 entry/exit/cancel/re-entry·실현성·evidence 구분만 프로젝트에 적용한다. 별도 전투·실패·보상 사다리·Notion 동기화·두 번째 GDD를 가져오지 않는다. 범용 framework/새 skill/서비스를 만들기보다 기존 owner에 규칙을 보완한다. 공용 환류 후보는 ‘메뉴 복귀의 데이터 연속성과 시각/소리 연속성을 별도로 검증하기’이며 이번에는 Base 파일을 수정하지 않는다.

유지할 것은 코어·브랜드·후면 구도·노 없음·기존 local 기억/선택이다. 수정할 것은 시간/focus/복귀 계약·성과 중심 표시·카메라/물 공간 관계다. 추가할 것은 필수 motion state·오류/접근성/성능 수용 기준이며, 새 콘텐츠 물량·온라인 확장·경제·자동 사진 삭제는 제외한다. **기획 기준의 마련, 아트 생산 가능성, 코드 구현, 실제 플레이, 최종 출시를 하나의 완료 상태로 합치지 않는다.**

`CORE_DIRECTION_USER_APPROVED / VISUAL_MOTION_DESIGN_IN_REVIEW / NEW_RUNTIME_NOT_IMPLEMENTED`

사용자는 목적지 없이 동반자와 보트에서 쉬는 코어 판타지를 유지하고, **떠다니는 친밀 디오라마** 방향으로 화면 흐름·아트·모션을 다시 설계하도록 승인했다. 아래 과거 구현표는 현재 실행 상태를 설명하는 기준선이며, 새 디자인의 확정 이미지나 구현 완료 증거가 아니다. 기존 이미지는 새 디자인의 참고자료로만 사용한다. 아직 실제 consumer가 있으므로 원본·승인 기록·runtime 파일을 삭제하지 않는다.

### 플레이 경험과 화면 흐름

새 방향의 중심은 콘텐츠를 더 많이 수행하는 것이 아니라, **내가 아무것도 하지 않아도 곁에 누군가 있고 작은 배가 물 위를 지나간다고 느끼는 것**이다. 친밀함은 호감도 알림 대신 자세·시선·간격으로 전달한다. 다음 흐름은 승인 방향을 구체화한 설계안이며, 수치·새 캐릭터·새 시각 표현은 검토 중이다.

```text
타이틀 대기 — 같은 바다·보트 + 제목 + 항해 시작
  → 시작 — 화면 컷 없이 제목/UI만 사라지고 항해 시간 시작
  → 나란히 쉬기 — 플레이어는 뒤에 기대고 동반자는 옆에 보임
  → 풍경이 지나감 — 중앙 바닷길은 비우고 먼 곳만 변화
  → 선택적 감상 / 사진 / 쉬는 메뉴
  → 돌아오면 같은 항해의 시간·소리·편안함 설정을 유지
  → 종료하거나 계속 쉬기 — 강제 결산·미완료 경고 없음
```

메인 화면에는 엽서·보상 추적·할 일 목록을 넣지 않는다. Album을 열었을 때만 사진과 개인 기록을 읽는다. 동반자가 고개를 들거나 다시 기대는 짧은 동작은 시각 후보이며 보상·퀘스트·새 저장 상태를 만들지 않는다. 놓쳐도 손해가 없는 주변 반응으로 설계한다.

### 10개 벤치마크의 채택·변형·제외

2026-09-10 공식 소개와 제작자 글을 직접 조회했다. 아래 관찰은 해당 1차 자료에 한정한다. 실제 게임을 모두 플레이했거나 내부 제작 공정을 역공학한 결과, 상업적 성공 원인, 의학적 힐링 효과를 검증한 것이 아니다. 오른쪽의 적용 판단은 본 프로젝트에 대한 설계 추론이다.

| 사례·1차 자료 | 확인한 특성 | 프로젝트 판단 |
| --- | --- | --- |
| [A Short Hike](https://ashorthike.com/) | 평화로운 자연 탐색, 정상이라는 목적지 | `ADAPT` 작은 자연 발견과 자유로운 속도. 정상·경로 목표는 제외 |
| [Tiny Glade](https://store.steampowered.com/app/2198150/Tiny_Glade/) | 관리·전투·목표 없는 디오라마, 실패 없는 수정 | `ADOPT` 부담 없는 꾸미기 원칙. 건축 편집기 전체는 제외 |
| [Townscaper](https://store.steampowered.com/app/1291340/Townscaper/) | 목표 없는 건축 장난감과 즉각적인 형태 반응 | `ADAPT` 선택 즉시 preview. 거대한 배치 알고리즘 도입은 제외 |
| [SUMMERHOUSE](https://store.steampowered.com/app/2533960/SUMMERHOUSE/) | 생활감 있는 작은 집, 승패 없는 창작 | `ADAPT` 사용 흔적이 느껴지는 작은 소품. 장식 물량 경쟁은 제외 |
| [Spiritfarer](https://thunderlotusgames.com/games/spiritfarer/) | 배를 만들고 동료를 돌보는 관리 게임, 이별 주제 | `ADAPT` 배가 함께 사는 장소라는 관계. 돌봄 의무·죽음 서사는 제외 |
| [ABZÛ](https://abzugame.com/) | 수중 환경과 생물과의 만남, 유영 탐색 | `ADAPT` 맑은 물의 깊이와 먼 생물. 잠수·서사 목적지는 제외 |
| [Journey](https://thatgamecompany.com/journey/) | 여행 중 동행, 먼 산이라는 목표 | `ADAPT` 말보다 함께 있는 구도. 종착점·익명 실시간 만남은 제외 |
| [Flower](https://thatgamecompany.com/flower/) | 단순한 방향 입력으로 자연을 통과 | `ADAPT` 움직임과 환경의 일관된 관계. 기울이기 필수 조작은 제외 |
| [Lil Gator Game](https://store.steampowered.com/app/1586800/Lil_Gator_Game/) | 친근한 캐릭터와 이동 중심 탐색, 퀘스트·제작 | `ADAPT` 읽기 쉬운 귀여움과 놀이 분위기. 퀘스트·전투 흉내·재료 수집은 제외 |
| [Kind Words](https://store.steampowered.com/app/1070710/Kind_Words_lo_fi_chill_beats_to_write_to/) | 아늑한 방에서 실제 사람에게 편지 | `ADAPT` 낮은 자극의 개인 공간. 온라인 확장·공개 상담 기능은 이번 범위에서 제외 |

[A Short Hike 제작자 회고](https://blog.playstation.com/2021/08/05/crafting-a-tiny-open-world-a-look-behind-the-scenes-at-the-creation-of-a-short-hike/)는 제한된 개인 제작 범위에서 일관된 셰이딩과 가독성을 연결하고, 장소·행동에 따른 음악 변화를 설명한다. 여기서는 **그림체를 하나로 맞추고 작은 장면부터 검증하는 제작 원칙**을 변형 채택한다. 해당 게임의 픽셀 스타일을 복사하거나 동적 음악을 이미 구현했다고 해석하지 않는다. Bondee는 사용자가 제공한 구성 참고이며, 이번 10개 조사와 별도로 내부 구현·권리·모델 구조를 확인한 자료는 아니다.

### SWOT와 독창성 검토

| 구분 | 현재 판단 | 대응 |
| --- | --- | --- |
| 강점 S | 목적지 없는 휴식, 보트·동반자라는 명확한 중심, local-first 구현 | 게임 약속을 유지하고 첫 장면에서 둘의 관계를 읽히게 한다 |
| 약점 W | 실제 consumer가 정적 카드 중심. 각도 전환에서 다른 그림이 보이며, 수면 변화량 검사는 전진 지각을 증명하지 못함 | 자세의 접점과 시간 연속성, 각도별 silhouette를 별도로 검증 |
| 기회 O | 과업 없는 창작·감상 사례에서 작은 공간 자체의 가치를 확인 | 배 위 작은 생활감과 나란히 쉬는 모션을 차별화 후보로 시험 |
| 위협 T | 유사한 cozy 외형, 물량 증가에 따른 상태×각도×외형 자산 폭증, 과한 흐름의 멀미 가능성 | 시각·모션 한 가족부터 시험하고 편안함 설정 유지. 독창성·편안함은 사용자 검증 전 단정하지 않음 |

독창성 가설은 **목적지나 보상을 따라 움직이는 배가 아니라, 서로 기대어 쉬는 둘을 중심으로 세상이 조용히 지나가는 배**이다. 친밀함을 수치 상승 대신 보트 흔들림에 함께 반응하는 자세와 잠깐의 시선으로 표현한다. 세계 최초나 시장 검증으로 주장하지 않는다.

### 기존 요소의 유지·수정·추가·보류

| 현재 상태 | 권장 조치 | 이유 | 기대효과 |
| --- | --- | --- | --- |
| 타이틀 대기와 시작 분리 | 유지, 같은 장면 위 제목의 시각 통합 개선 | 시작 전 시간 누적을 피하면서 진입 맥락 유지 | 끊기지 않는 첫 경험 |
| 후면 3/4와 하단 20% 부근 보트 | 유지, 캐릭터·동반자 겹침과 하단 안전영역 재검증 | 작은 화면에서 관계와 전진 방향을 동시에 읽혀야 함 | 넓은 바다와 친근한 동행 |
| 기존 승인 그림체와 합성 카드 | 새 후보 제작. 이전 자산은 교체 검증 전 보존 | 사용자 최신 지시와 새 모션의 분리 제작 필요 | 인물·배·배경 이질감 완화 |
| 하늘·바다 및 계절 layer 분리 구현 | 유지, 원경·중경·근경의 속도와 접점 재설계 | 단순 픽셀 변화만으로 진행 방향이 보장되지 않음 | 앞으로 나아가는 공간적 일관성 |
| 정적 player/pet 그림 | 휴식→작은 반응→휴식 복귀의 모션 후보 추가 | 전체 카드를 흔들어서는 생명감이 제한됨 | 과업 없는 존재감 |
| LookAround의 방향별 카드 | 제한된 시점과 실제 3D 대안 비교 후 결정 | 자유 회전을 약속하려면 새 제작 구조가 필요 | 전환 파열·자산 폭증 방지 |
| 사진·Album·꾸미기·감상·편안함 설정 | 유지, 기존 저장 ID와 입력 경로 보존 | 이미 있는 선택적 가치와 회귀 위험 | 기능 손실 없는 재기획 |
| 신규 수집 체계·상시 알림·일일 과업 | 이번 재기획에서 제외 | 쉬는 의미를 과업으로 바꿈 | 부담과 구현 범위 억제 |
| 기존 낚시·병편지 | 현 구현 보존, 신규 확대 보류 | 핵심 시각·모션 검증과 독립된 범위 | 안전 경계와 작업 집중 유지 |

### 제작 구조의 세 대안

| 대안 | 장점 | 한계 | 현재 판단 |
| --- | --- | --- | --- |
| A. 방향별 손그림 프레임 + AnimatedSprite3D | 그림체 통제, 현재 카드 소비처와 가까움 | 각도×의상×동작으로 물량 증가, 연속 자유 회전 불가 | `TEST` 작은 표정·귀·시선 시퀀스 |
| B. 분리형 2D 레이어 + 제한된 리깅/키포즈 | 기존 Sprite3D·접점 구조 재사용, 호흡·기대기 분리 | 큰 회전과 몸의 가림 해결이 어려움 | `ADAPT` 첫 rear 3/4 검증 슬라이스 권장. 전체 회전 해법으로 확정하지 않음 |
| C. 실제 3D 모델·리그 + 일관된 스타일 재질 | 연속 회전, 동일 모델의 조명·관절·접점 | 신규 모델링·리깅·변형 QA와 모바일 성능 검증 필요 | `TEST` 자유 회전 유지 여부 판단용 비교. 즉시 전면 전환은 미확정 |

[Godot AnimatedSprite3D](https://docs.godotengine.org/en/stable/classes/class_animatedsprite3d.html)는 SpriteFrames 기반 시퀀스의 엔진 경로를 제공한다. 이는 API 가능성이지 현재 자산의 일관성·성능 증거가 아니다. **첫 장면 B는 `FEASIBLE`(구조 수준), 각도 연속성·새 motion family는 `PARTIAL`**로 둔다. Aseprite를 쓴다는 이유로 픽셀 아트나 4×4 고정 프레임 수를 선택하지 않는다.

### 모션·합성 계약 초안

사용자는 2026-09-10 `voyage-direction-v1.png`의 그림체·분위기를 승인하고 권장 제작을 계속하도록 지시했다. 이 승인은 새 방향의 기준 이미지에 적용하며 완성 애니메이션·전체 Blueprint·runtime 승인으로 확대하지 않는다. 이어서 바다·돌산·하늘 등을 나중에 움직이기 쉽도록 따로 제작하라고 재확인했다. 따라서 아래 분리는 production 납품의 필수 조건이다. 합성 컨셉·키포즈 보드는 검토 자료일 뿐, 그대로 배경이나 캐릭터 시트로 사용하지 않는다.

**분리 납품 단위**는 `sky`, `clouds`, `distant_rocks_islands`, `midground_scenery`, `sea`, `boat`, `player`, `companion`, `water_contact_wake`다. 하늘·바다는 독립 배경으로, 나머지 오브젝트는 필요한 실제 alpha와 겹침 여유를 갖춰 제작한다. 돌산·섬에 바다/하늘을 포함하지 않고, 보트에 반사·잔물결·수면 그림자를 고정 합성하지 않는다. 섬은 중앙 항로 밖에 배치한다. 카메라 기준·명암·광원은 가족 전체에서 일치시키며, 최종 pivot·offset·잘림 방지 여백은 개별 export 전에 검증한다. 캐릭터가 가리는 선체 안쪽과 동반자 아래 쿠션도 분리 제작에서 복원되어야 한다.

| 대상 | 독립적으로 제작할 것 | 시간·접점 규칙 | 완료 증거 |
| --- | --- | --- | --- |
| 하늘 / 구름 | 기본 하늘과 투명 구름 분리 | 수평선·카메라 자동 회전 금지, 구름만 약하게 변화 | 고정 하늘과 구름 영역별 연속 캡처 |
| 섬 / 해상 명소 | 투명 원경·중경, 바다를 포함하지 않는 silhouette | 중앙 항로 밖, 가까워지며 배를 관통하지 않음 | 전체 통과 구간 lane 검사 |
| 바다 | 근경 흐름과 원경의 낮은 대비 표현 분리 | 수평선에서 하단으로 흐름, 반복 경계 숨김, 편안함 설정 준수 | 실제 시간 진행의 방향·연속성·주기 경계 검사 |
| 선체 / 접점 / 잔물결 | 수면을 굽지 않은 선체, 별도 접점과 약한 후류 | 선체 pivot 공유, 수면 아래 접점 유지 | 흔들림 전 주기에서 틈·중복 그림자 검사 |
| 플레이어 / 동반자 | idle, notice, settle 키포즈와 필요한 가림 layer | 엉덩이·기댄 등·발 접점 고정. 둘을 같은 위상으로 기계적으로 흔들지 않음 | 같은 크기 overlay, silhouette·접점·복귀 검사 |

모션 서사는 `idle → notice 준비 → 작은 시선/귀 반응 → settle → idle`로 정의한다. 휴식은 반복 루프, 반응은 비반복, 종료 후 같은 휴식 상태로 돌아간다. 움직임 크기·프레임 수·duration은 실제 크기 키포즈 검토 후 정한다. 소리·배경 이동·동반자 반응을 모두 동일한 주기로 반복하지 않는다. 저감 설정에서 필수 조작이나 정보를 잃지 않도록 한다.

### Aseprite 자동 선택과 구현 패키지 경계

Base v9.4.4 lock은 유지한다. 사용자 요청에 따라 최신 Base의 `ART_DIRECTION_AND_ASSET_PLANNING_GUIDE.md` §11 조건부 선택만 이번 제작 판단에 적용한다. 새 그림은 이미지 모델로 만들고, **실제 레이어·프레임 정리 또는 PNG+JSON 시트가 필요한 시점**에 연결된 Aseprite MCP를 우선 평가한다. 한 장짜리 컨셉을 억지로 Aseprite에 넣거나 같은 그림 복제로 모션 완료를 만들지 않는다. [Aseprite 공식 export 문서](https://www.aseprite.org/docs/cli/)의 프레임·메타데이터 구조를 참고하되 current tool의 실제 지원 범위로 검증한다.

아래 패키지·준비 순서는 통합 제작 기획 이전의 **2D 후보 준비 단계 기록**이며 현재 실행 queue가 아니다. 최신 전체 제작 순서는 이 문서 P9를 따른다. 당시 첫 구현 패키지는 `scenes/game.tscn`의 기존 배경·접점, `scenes/boat_space.tscn`의 `FinalDioramaCard` 대체 후보와 player/pet 분리, `scripts/voyage/game_scene.gd`의 visual update 경로에 한정했다. 사진·Album·꾸미기·soundscape·save ID와 social 경계 보존은 계속 유효하다.

준비 순서는 **단일 항해 장면 후보 → 동일 캐릭터/동반자 식별 카드와 키포즈 → 실제 규격·분리 레이어 → 필요 시 Aseprite 포장 → 검토용 Blueprint 파생본 → 확정 범위 구현**이다. 새 시각 후보는 사용자 확정 전 production 자산으로 연결하지 않는다. rollback은 기존 consumer·원본을 그대로 보존한 채 새 visual family 연결만 되돌릴 수 있어야 한다. 그림체 확정 전 네 시간대·모든 각도·모든 꾸미기 조합을 대량 제작하지 않는다.

### 현재 증거와 남은 검증

**현재 분리 배치 검증.** 기존 7개 독립 PNG를 실제 540×960 격리 Godot viewport에 렌더하고 가까운 선체 난간을 승객 앞에 표시하는 가림을 교정했다. 정적 선체 중심은 화면 높이 80.05%다. 새 모델 합성본이 아니라 actual-file renderer evidence지만 game scene 통합·motion 증거는 아니다. player 자세와 쿠션·수면 접점은 아직 승인 구도에 못 미치므로 visual inventory의 findings에 따라 교정한다.

**최신 사용자 확정.** `stern-staging-review-v2.png`의 후면 좌석·옆 동반자·난간 가림 구도를 승인했다. 동시에 새 디자인에서 노를 제외하도록 변경했다. 따라서 새 기본 항해 장면에는 노 이미지·노 젓기 모션·노 끝 splash를 제작하지 않는다. 노 없는 자연스러운 표류를 수면 흐름·선체 접점·미세 부유로 표현하며, 엔진·돛·마법 추진 같은 새 요소를 추가하지 않는다. 기존 runtime 노 포함 자산은 교체 검증 전 역사적 원본으로 보존한다. 이 확정은 구도와 노 제외 결정이며 전체 Blueprint·모션·게임/Human 승인이 아니다. 아래 후보 당시의 `NOT_USER_LOCKED` 기록보다 이 결정이 우선한다.

후속 `MLB-REDESIGN-STAGING-002`는 뒤쪽 쿠션에 기대는 player, 옆 companion, 가까운 stern rim의 가림과 하단 배치를 검토하는 새 합성 후보다. 이미지 모델 재구성이므로 기존 독립 레이어의 exact 합성·모션·게임 구현 증거가 아니다. 원본 분리 요소는 유지하고, final visual lock 전 이 합성본을 production 카드로 연결하지 않는다. 현재 후보·findings·재현 prompt는 visual inventory와 구도 receipt가 소유한다.

2026-09-10 후속 준비에서 **빈 선체·돌산·구름·player·companion은 실제 RGBA 후보**, **하늘·바다는 별도 opaque 배경 후보**로 제작됐다. 선체는 Aseprite 왕복 픽셀 보존도 검증했다. 이는 분리 제작 경로의 기술 검증이며, 새 visual lock·캐릭터/동반자 조합·전진 흐름·게임 구현·Human 승인은 아니다. 재현 경로와 해시는 visual inventory 및 `separated-layers-v1.receipt.json`이 소유한다. 다음 준비는 가림용 전면 난간·소품·접점과 좌석/pivot 맞춤, 바다 반복 경계·가장자리·실제 크기 합성 검토다. 새 player의 하반신은 기존 그림에서 가려진 영역을 복원한 후보이며 의상 identity 확정이 아니다.

2026-09-10 최초 조사 기준 코드 head는 `08637e3f59a9e50b19582eff62080715f8d9ea47`이며, 당시 branch가 `origin/main`보다 15 commits 앞선 기록은 역사적 스냅샷이다. 후속 준비의 exact source revision은 각 candidate receipt가 소유하며 현재 branch 상태는 작업마다 원격에서 다시 확인한다. 별도 PR #19는 read-only로 유지한다. 이번 준비는 production code·scene·save·기존 이미지·과거 캡처를 변경하지 않는다.

기존 `tests/capture_voyage_forward_flow.gd`는 process를 멈추고 `_apply_drift_motion(2.0)`을 직접 호출한 렌더 비교다. 기록된 픽셀 변화율은 **단계별 렌더 변화**를 증명하며, 자연 시간 재생·정방향 지각·접점 연속성·휴먼 편안함을 증명하지 않는다. 다음 runtime 검증은 사용자 입력 경로의 title→start→rest→감상→복귀를 실제 시간으로 재생하고, 기존 evidence를 덮어쓰지 않는 새 출력 경로·격리 저장으로 실행한다. 현재 새 디자인의 runtime·device·Human은 `NOT_RUN`이다.

이하 2026-09-02 PDF는 당시 정본에 source-bound된 **역사적 스냅샷**으로 보존한다. 새 재기획 내용을 포함한 current publication은 아직 만들지 않았다. 과거 `CURRENT_SOURCE_BOUND_DERIVED_PUBLICATION` 표기는 해당 receipt 당시 상태이며 현재 재기획 전달본으로 사용하지 않는다.

## 0. Human Game Blueprint 읽기 profile

> `HUMAN_GAME_BLUEPRINT_GDD_LAYERED_PROFILE`

`NO_SEPARATE_BLUEPRINT_ARTIFACT`

이 GDD는 별도 Blueprint 문서·보드·부록을 **정본으로 만들지 않고**, 현재 플레이 경험·시스템 카드·화면 흐름·증거 한계를 한 곳에서 계층적으로 읽게 합니다. 사람이 빠르게 보는 PDF는 이 정본에서 파생될 수 있지만 별도 결정 owner가 아니며, 이전 AI specification은 `SUPERSEDED_AS_CURRENT_GDD` 역사 포인터입니다.

### 산출물과 publication 경계

`output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.pdf` = `HISTORICAL_SOURCE_BOUND_PUBLICATION`.
`output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.receipt.json` = `HISTORICAL_PUBLICATION_SOURCE_AND_ASSET_RECEIPT`.
`output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.source.md`는 당시 GDD의 byte-exact 보존본이다. 새 편집 owner가 아니며 기존 receipt의 source hash 검증에만 사용한다.
`exports/my-little-boat_MASTER_PRODUCTION_GDD_20260829.pdf` = `HISTORICAL_STALE_PUBLICATION_NOT_CURRENT_SOURCE`.
`exports/my-little-boat_MASTER_PRODUCTION_GDD_20260828.pdf` = `HISTORICAL_DERIVED_NOT_CURRENT_SOURCE`.

`CURRENT_BLUEPRINT_PLAYER_FACING_SELECTION`: 현재 PDF는 이 GDD의 §1–§6, §7의 concise status와 실제 runtime capture를 읽습니다. §8의 다섯-loop 기술 영수증은 정본 evidence layer로 보존하되, 플레이어용 첫 읽기 PDF에 반복하지 않습니다. receipt는 exact GDD·generator·이미지 SHA-256과 source revision을 기록합니다. PDF binary는 source owner가 아니며 GDD와 receipt가 일치할 때만 current publication으로 읽습니다.

### Layered reader route

| layer | 먼저 답할 질문 | 현재 section |
| --- | --- | --- |
| `PROJECT_PLAYER_LAYER` | 어떤 휴식 경험이며 무엇을 선택하지 않아도 되는가 | §1–§3 |
| `SYSTEM_LAYER` | 머무르기·분위기·기억이 어떤 흐름으로 이어지는가 | §4–§5 |
| `CONTENT_UX_PRESENTATION_LAYER` | 어떤 화면·시각·입력이 경험을 전달하는가 | §5–§6 |
| `PRODUCTION_EVIDENCE_LAYER` | 무엇이 구현됐고 어떤 기계·runtime·Human evidence가 남았는가 | §7–§8과 current handoff/visual inventory |

```text
3-MINUTE PROJECT / PLAYER READ
-> 10-MINUTE SYSTEM + CONTENT / UX / PRESENTATION READ
-> DETAIL READ
-> IMPLEMENTATION READ
-> VERIFICATION READ
```

### 상태와 evidence legend

> `STATE_AND_EVIDENCE_LEGEND`

| 상태 | 허용하는 주장 | 허용하지 않는 상위 주장 |
| --- | --- | --- |
| `CONFIRMED` | 현재 방향과 결정이 정본에 기록됨 | 구현·runtime 동작 |
| `IMPLEMENTED` / `IMPLEMENTED_AND_TESTED` | 실제 consumer와 지정 기계 계약이 있음 | 실제 기기 편안함·Human UX |
| `GPU_CAPTURED` | 지정 renderer에서 실제 화면이 렌더됨 | touch/audio/장시간 calmness |
| `PARTIAL_IMPLEMENTED` | 일부 consumer는 있으나 남은 product alignment가 있음 | 시스템 전체 완료 |
| `NOT_RUN` | 해당 device/Human/audio evidence가 없음 | 추정에 의한 PASS |

### Prospective future-package gate

`PLAN -> REQUIRED_IMAGE_AND_MATERIAL_PREPARATION -> BLUEPRINT_REVIEW_PUBLICATION -> USER_FINAL_REVIEW_APPROVAL -> IMPLEMENTATION`

- `NO_IMPLEMENTATION_BEFORE_USER_FINAL_APPROVAL`: 이 profile 이후의 새 package는 exact reviewed revision에 대한 명시적 `USER_FINAL_REVIEW_APPROVAL` 전 구현하지 않습니다.
- `PROSPECTIVE_ONLY_EXISTING_IMPLEMENTATION_EVIDENCE_PRESERVED`: 이미 구현·검증된 현재 code, Scene, test, runtime evidence는 소급 취소하지 않습니다.
- `PROSPECTIVE_ONLY_PREEXISTING_EXACT_USER_APPROVED_IMPLEMENTATION_AUTHORITY_PRESERVED`와 `EXACT_APPROVED_SCOPE_AND_REVISION_ONLY`는 동일 package·scope·revision에만 적용됩니다.
- `SCOPE_EXPANSION | SUCCESSOR_PACKAGE | INFERRED_BLANKET_APPROVAL`은 새 review gate가 필요합니다.
- 새 image deliverable은 `IMAGE_MODEL_REQUIRED_FOR_IMAGE_CREATION_OR_EDITING`을 따르며, exact 관계 정보는 `TEXT_NATIVE_EXACT_DIAGRAMS` 및 `STRUCTURED_INFORMATION_ARTIFACTS_REMAIN_TEXT_NATIVE`로 유지합니다.
### 2026-08-30 현재 runtime receipt

아래 상태가 현재 실행 build를 설명합니다. 이후의 pre-implementation 표와 `NOT_IMPLEMENTED` 표기는 historical context로만 읽고 이 receipt를 덮어쓰지 않습니다.

| 주제 | 현재 상태 | evidence ceiling |
| --- | --- | --- |
| Direct boat entry | 실행 즉시 사용자 승인 후면 3/4 치비 player·강아지·ivory/deep-teal 보트·바다 구도와 compact `쉬는 메뉴`가 보입니다. 보트는 540×960 세로 화면의 하단 20% 부근에 있고, 플레이어는 stern 쪽에 기대어 뒷모습으로, 강아지는 옆에서 함께 쉬는 모습으로 읽힙니다. `MLB-LOOK-CHIBI-NORMAL-REAR-001`의 보관 원본에서 만든 foreground matte를 `FinalDioramaCard`의 explicit shader material에 연결해, 보트 bob·legacy ripple·`MLB-BOAT-FLT-006` narrow waterline·시간대 backdrop을 분리한 채 stern-side normal 3/4를 보입니다. 감상모드는 이 normal foreground와 두 수면 접점을 숨겨 바다·수평선과 `감상 끝내기`만 남깁니다. 저장된 `꽃` 펫 쿠션만 bow-side overlay로 보입니다. `엽서`는 main rest composite에 합성하지 않고 꾸미기 preview 난간 장식과 Album의 항해 포스트카드에서 읽습니다. | rear-normal/material/final-card/direct-entry/decor/waterline/appreciation contracts와 bright title·voyage·Appreciation 540×960 GPU capture `PASS`; Human comfort `NOT_RUN` |
| 현지 시간과 풍경 | 현지 시간은 visual-only 네 분위기를 정하고, foreground에 머문 시간만 low-density 자연 명소 기회를 보냅니다. 각 시간대의 고정 하늘과 독립 흐름 바다는 그대로 유지되고, 새벽 아치·해초 모래톱·흰 절벽·사암 코브·갈대섬·밤 생물발광은 전용 pass에서 약 14초 동안 수평선을 가로질러 조용히 지나갑니다. 첫 기회는 90–150초, 기회별 표시는 65%, 다음 기회는 표시 여부와 무관하게 120–180초입니다. | split background/time contracts와 여섯 540×960 GPU pass capture `PASS`; Human long-run observation `NOT_RUN` |
| 꾸미기 | `꾸미기`에서 플레이어 외형, 동반자 종류, 보트 장식을 local-only로 고르고, 별도 보트 preview에서 즉시 확인합니다. 기본 first-view backdrop은 바꾸지 않습니다. A/B player, cat/rabbit/otter, `stripe`·`moon` cushion은 승인된 soft-matte 치비 family로 실제 선택 경로에 연결됐습니다. | identity/decor/asset-guard contracts와 alternate family 540×960 GPU capture `PASS`; Human readability `NOT_RUN` |
| 함께한 시간 | foreground 항해의 실제 시간을 local-only로 누적하고 Album에서만 분 단위·관계 문구로 보여 줍니다. | together-time contracts와 540×960 Album capture `PASS`; Human readability `NOT_RUN` |
| 모션 편안함 | `파도: 기본/잔잔/고요`는 보트·카메라·수면 접점의 자동 진폭만 `1.0 / 0.5 / 0.0`으로 바꾸는 local-only 선택입니다. | preference/state/scene contracts와 bright GPU capture `PASS`; Human motion comfort `NOT_RUN` |
| 항해 포스트카드 | `사진`은 UI 없는 실제 렌더 프레임 PNG와 메타데이터를 기기에 저장하고, Album은 최신 세 장을 점수·보상 없이 보여 줍니다. | persistence/state/scene/Album contracts와 bright·Album GPU capture `PASS`; Human readability `NOT_RUN` |
| 둘러보기 | `LookAroundCamera3D`와 드래그 입력, 기본·감상 전환, 꾸미기/Album 격리가 구현되었습니다. user-locked cute chibi `MLB-LOOK-FG-001..004`가 `LookAroundForeground`에서 좌·우·뒤·위 각도로 바뀌고, static sky와 independently flowing sea는 non-front에서도 유지됩니다. opaque magenta technical matte는 전용 chroma-key shader만 alpha 처리하며, non-front에서는 중복 normal card만 숨기고 부유 보트 상태와 수면 접점은 유지합니다. | mode/input/foreground/router/capture-guard contracts와 540×960 OpenGL GPU capture `PASS`; 1.8초 port pair sky `0.00%`, open sea `58.44%` change; `MLB-LOOK-FG-001..004` `USER_LOCKED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human motion comfort `NOT_RUN` |

## 1. 이 게임은 무엇인가

`마이 리틀 보트`는 내 캐릭터와 동반자가 바다 위 작은 보트에서 목적지 없이 천천히 지나가며 함께 쉬는 휴식 우선 게임입니다. 플레이어는 목표를 해내기 위해 보트에 오르는 것이 아니라, 게임을 여는 순간 이미 그곳에 있습니다.

### 게임명과 세계관 문장

- 표기 게임명: `MY LITTLE BOAT`
- 약속 문장: `파도 위에서, 함께 쉬는 시간`
- 확정 브랜드 자산: `MLB-BRAND-TITLE-001` — 잔잔한 파도 위의 작은 보트, 뒤를 향한 사람과 동반자, 작은 별빛을 제목 주변의 상징으로만 쓴 가로형 title lockup

이 제목은 목적지·정복·탐험 과업이 아니라 동반자와 함께 머무는 시간을 약속한다. latest user direction에 따라 title lockup은 store, splash, GDD 표지와 `game.tscn`의 identity-neutral `TitleOverlay/BrandLogo`에 쓴다. 실제 실행은 **타이틀 대기** 상태의 보트 diorama로 곧바로 들어간다. 이때 실제 보트·현재 player/pet·바다는 보이지만 `GameState.begin_voyage()`와 함께한 시간·기억·보상은 아직 호출하지 않는다. `항해 시작`을 누른 뒤에만 normal voyage와 `쉬는 메뉴`가 열린다. 이미지 속 특정 사람·강아지는 기본 player/pet identity, save, reward, 혹은 runtime character asset을 정하지 않는다.

### 플레이어 약속

> “게임을 열자마자 내 작은 보트가 동반자와 함께 잔잔한 바다를 목적지 없이 지나가고, 나는 아무것도 하지 않아도 잠시 쉬어 갈 수 있다.”

정상 화면은 보트 뒤쪽 위의 calm 3/4 diorama입니다. 플레이어는 stern 쪽에 기대어 뒷모습으로, 동반자는 바로 옆에서 함께 보이며, 보트·장식·바다와 수평선이 한 장면에 함께 읽힙니다. `Appreciation Camera`는 같은 세계에서 UI를 줄이고 바다·수평선을 더 오래 바라보는 선택적 감상 모드입니다.

### 이 게임이 남기려는 감정

- 편안함과 안정감
- 내 캐릭터·동반자·보트가 만드는 작은 애착
- 혼자 있지만 외롭지 않은 느낌
- 성과보다 개인적인 기억이 남는 느낌

전투, 실패, 경쟁, 등급, 효율, 숙제, 실시간 소셜 압박은 위 감정과 충돌하므로 넣지 않습니다.

## 2. 첫 30초와 시작 흐름

### 확정된 첫 경험

```text
실행
→ 이미 물 위에 떠 있는 보트와 바다를 봄
→ 캐릭터와 동반자가 함께 있는 모습을 봄
→ 그냥 머무르거나, 원할 때만 작은 행동을 선택함
→ 계속 쉬거나 나만의 기억을 남김
```

시작할 때 `오늘의 마음`, 시간대, 외형, 동반자, 장식 중 무엇도 고르게 하지 않습니다. 기기의 **현지 현실 시간**이 새벽·밝음·해질녘·밤 분위기를 자동으로 정합니다. 수동 분위기 control과 마지막 분위기 저장은 없습니다. 기기 시계는 시각 표현에만 쓰며 보상, 항해 진행, 기억 저장, 호감도에는 영향을 주지 않습니다.

외형·동반자·보트 장식은 바다를 본 뒤에만, 원할 때 `꾸미기`에서 바꿉니다. 모든 꾸미기 선택은 cosmetic이며 능력치, 희귀도, 보상, 최적 조합을 만들지 않습니다.

### 첫인상 수용 기준

- 보트 hull과 물의 접점이 읽힌다.
- 느린 bob, 잔물결 또는 wake, 반사·가림이 보트와 바다를 하나의 공간으로 묶는다.
- 캐릭터·동반자·보트는 보이되 수평선과 넓은 바다를 가리지 않는다.
- 큰 선택 panel이 first view를 덮지 않는다.
- 540 x 960 실제 gameplay 크기에서 위 관계가 읽힌다.

현재 제공된 구형 main-entry 구성은 이 기준을 충족하지 않습니다. 보트가 바다 위에 합성된 것처럼 보이고 시작 panel이 휴식보다 먼저 보이므로 `REJECTED_FOR_MAIN_ENTRY_RUNTIME_USE`입니다. 현재 선택형 main menu code도 이 제품 흐름에서는 `PRODUCT_SUPERSEDED_IMPLEMENTATION`입니다. 이 결정은 보트·바다 source binary를 일괄 폐기한다는 뜻이 아닙니다.

## 3. 플레이는 어떻게 이어지는가

### 핵심 반복

```text
바다 위 보트에 머문다
→ 바다와 동반자를 바라본다
→ 원하면 사진·낚시·감상·작은 상호작용·꾸미기를 한다
→ 작은 반응이나 개인적인 기억을 남긴다
→ 계속 머물거나 자연스럽게 떠난다
```

핵심 행동은 “머무르기”입니다. 선택 행동은 정적 화면의 빈틈을 메우는 과제가 아니라, 지금 하고 싶은 만큼만 사용하는 생활감입니다.

### 한 번의 휴식

명목상 한 항해는 약 5분입니다. 기록이 남은 뒤에도 플레이어는 더 머물 수 있습니다. 시간을 끝까지 채우거나 모든 행동을 해야만 완성되는 세션은 아닙니다.

### 첫 5·15·30분 truth table

`FIRST_5_MINUTES_NOMINAL_SESSION_HYPOTHESIS`: 첫 5분은 반드시 채워야 하는 목표가 아니라 한 번의 명목상 휴식 세션을 설명하는 hypothesis입니다. 실제 기기에서 이 시간이 calm한지는 actual-device calmness `NOT_RUN`입니다.

`FIRST_15_30_MINUTES_CONDITIONAL_OPTIONAL_EXTENDED_STAY_NOT_FORCED_MILESTONES`: 첫 15분과 30분은 플레이어가 스스로 더 머물 때만 생기는 conditional optional extended stay이며 forced onboarding·retention·reward milestone이 아닙니다.

| 시간 | 경험 contract | evidence |
| --- | --- | --- |
| 첫 5분 | 명목상 한 항해에서 머무르거나 원할 때 낮은 압력 행동을 쓰고 자연스럽게 떠날 수 있음 | 기계 계약과 runtime capture가 존재하며 actual-device calmness `NOT_RUN` |
| 첫 15분 | 선택적으로 더 머물며 분위기·풍경·개인 기록을 느슨하게 경험할 수 있음 | optional extended-stay hypothesis; Human `NOT_RUN` |
| 첫 30분 | 선택적으로 계속 머물거나 Album·꾸미기를 오갈 수 있음 | optional extended-stay hypothesis; Human `NOT_RUN` |
### 남는 기억

사진, 풍경, 낚시 기억, 보트 장식, 함께한 시간, ambient memory는 개인적인 앨범과 보트의 흔적으로 돌아옵니다. 이들은 power, currency, social qualification, collection completion을 위한 재료가 아닙니다.

### 선택과 결과

| 선택 | 플레이어가 고민하는 것 | 관찰 가능한 결과 | 손해가 아닌 것 |
| --- | --- | --- | --- |
| 그냥 머무르기 | 지금은 아무것도 하지 않고 쉬고 싶은가 | 바다·동반자·보트의 조용한 움직임 | 아무 행동도 하지 않는 것 |
| 사진 | 이 순간을 기록하고 싶은가 | 개인 album의 사진 기억 | 사진을 찍지 않는 것 |
| 낚시 | 잠시 기다리는 행동이 어울리는가 | 기다림 뒤 catch, 입질 없는 조용한 거두기, 또는 언제든 취소 | catch가 없거나 중단하는 것 |
| Appreciation Camera | 화면을 덜 보고 바다를 더 볼 것인가 | 낮은 UI의 수평선 감상 | normal view를 유지하는 것 |
| 꾸미기 | 내 공간을 어떤 모습으로 두고 싶은가 | cosmetic appearance 변화 | 장식을 바꾸지 않는 것 |

## 4. 시스템 카드

> `REUSABLE_FLOW_AND_SYSTEM_CARDS`

`LAYERED_TRACEABILITY_REQUIRED`: 아래 카드와 §5–§7은 플레이어 약속, 화면·시각 표현, 구현/기계 증거, Human `NOT_RUN` 한계를 같은 reader route에서 연결합니다. 정확한 code·Scene·test 경로는 사람용 설명을 중복하지 않고 current handoff와 visual inventory가 소유합니다.

### 떠 있는 휴식

**플레이어가 보고 하는 일.** 캐릭터와 동반자가 탄 보트가 잔잔한 바다를 목적지 없이 천천히 지나가는 모습을 보고, 원하면 아무 입력 없이 머뭅니다.

**필요한 이유.** 이 게임의 핵심 재미는 보상 전 대기 시간이 아니라 함께 존재하는 장소를 보는 데 있습니다.

**피드백.** 보트의 느린 전진과 bob, 바다·하늘의 변화, 동반자의 낮은 빈도 idle, 파도 중심 soundscape가 “함께 흘러가고 있다”는 감각을 줍니다.

현지 시간이 바뀌면 하늘·빛·바다의 색과 반사가 천천히 이어집니다. active foreground로 머문 시간이 쌓이면 새벽의 바다 아치, 밝은 낮의 해초 또는 절벽, 해질녘의 사암 코브 또는 갈대섬, 밤의 먼 생물발광처럼 한 장면이 낮은 밀도로 흘러갑니다. 이 장면은 10초 뒤 현재 시간대의 물만 있는 기본 바다로 돌아오며, 버튼·목적지·보상·과제가 아닙니다. 둘 다 해야 할 일이나 보상이 아니라, 같은 장소가 살아 있다는 배경 감각입니다.

**피해야 할 압박.** 방치 벌, timer 실패, idle 보상, 매분 확인 요구, 목적지·항로·도착 보상.

**상태.** 자연 명소 여섯 장은 `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`입니다. 보트의 전후·측면 움직임은 목적지·항로·보상·저장과 무관한 순환형 시각 표현이며, `파도: 고요`에서는 기존 bob·roll과 함께 멈춥니다. 실제 기기에서의 휴식감은 `NOT_RUN`입니다.

### 감상 카메라

**플레이어가 보고 하는 일.** 필요할 때 UI를 줄이고 바다와 수평선에 집중합니다.

**필요한 이유.** 캐릭터와 보트를 보는 휴식과 바다만 보는 휴식은 서로 다른 순간에 필요합니다.

**피드백.** 같은 항해 시간과 soundscape 안에서 시야만 조용해집니다.

**피해야 할 압박.** 보상, timer, 동반자 관계, ambient discovery 확률을 바꾸는 별도 게임 모드.

**상태.** earlier runtime slice에 존재합니다. 실제 기기에서의 편안함은 `NOT_RUN`입니다.

### 둘러보기

**플레이어가 보고 하는 일.** 원할 때 보트 주변을 천천히 드래그해 좌우·뒤·위 시점을 바라봅니다. 마음에 드는 곳에서 멈춰도 되고, 기본 3/4 시점이나 감상 카메라로 언제든 돌아갈 수 있습니다.

**필요한 이유.** 같은 보트 안의 사람·동반자·랜턴·물결을 다른 거리와 각도에서 보는 작은 변화가, 목적지 없이도 살아 있는 항해 감각을 더 분명하게 합니다.

**피드백.** 카메라만 바뀌며 항해 시간, 속도, 함께한 시간, 장식, 사진·풍경·낚시 기억, 저장, soundscape는 바뀌지 않습니다. 화면은 PC의 왼쪽 버튼 드래그와 모바일 화면 드래그를 쓰고, 수평선은 기울지 않으며 큰 자동 회전·줌·번쩍임은 없습니다.

**피해야 할 압박.** 특정 시점을 모두 찾아야 하는 수집, 각도별 보상, 생물 추적, 목표표식, 이동 강요, 멀미를 유발하는 관성·강제 카메라.

**상태.** 입력·mode 격리, 승인된 `port`·`starboard`·`aft`·`overhead` canonical asset routing, 기본 Normal의 후면 치비 foreground material, 저장된 `꽃` 펫 쿠션·`엽서`의 치비 decor consumer, 그리고 normal·네 각도·Appreciation의 540×960 GPU capture가 `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`입니다. 이 상태는 항해 시간·속도·저장·보상·soundscape를 바꾸지 않습니다. 기본 C+강아지 Normal은 `MLB-LOOK-CHIBI-NORMAL-REAR-001` 보관 원본에서 만든 `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`를 `FinalDioramaCard`에 연결하고 stern-side rig에서 보여 주며, time-paired static sky·flowing sea backdrop과 BoatSpace 부유를 유지합니다. 정면 Look Around은 같은 분리 배경을 사용하고, `port`·`starboard`·`aft`·`overhead`의 보트+바다 composite 원화는 선체가 가려지지 않도록 whole-image still로 보존합니다. 사용자가 승인한 alternate A/B player, cat/rabbit/otter, `stripe`·`moon` cushion 7종은 exact canonical copy와 기존 save ID를 사용해 layered `Sprite3D`와 decor texture consumer에 연결됐습니다. 실제 기기의 motion comfort, touch reachability, 장시간 휴식감은 `NOT_RUN`입니다.

### 꾸미기

**플레이어가 보고 하는 일.** 도착 뒤 원할 때 외형, 동반자 species, 보트 장식을 바꿉니다.

**필요한 이유.** 공간이 “게임의 배경”이 아니라 “내 작은 장소”로 느껴지게 합니다.

**피드백.** 기본 바다 화면을 바꾸지 않는 별도 보트 preview에서 바뀐 외형·동반자·장식이 즉시 보입니다.

**피해야 할 압박.** stats, rarity, gacha, price, daily shop, 모든 slot 채우기, 최적 배치.

**상태.** in-voyage `꾸미기`, local-only preview, 기존 ID를 보존한 alternate 치비 asset family가 `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED`입니다. 실제 기기에서의 readability와 touch comfort는 `NOT_RUN`입니다.

### 사진·조용한 낚시·작은 상호작용

**플레이어가 보고 하는 일.** 지금의 풍경을 찍고, 조용히 기다리거나, 보트의 작은 물건·동반자와 가볍게 반응합니다.

**필요한 이유.** 가만히 쉬기와 별개로 손을 조금 쓰고 싶은 플레이어에게 낮은 밀도의 생활감을 줍니다.

**피드백.** 사진은 UI 없는 실제 항해 프레임을 local PNG와 메타데이터로 남기고, Album의 최신 세 장 포스트카드로 돌아옵니다. catch만 물고기 기억으로 남고, 입질 없는 거두기·취소·작은 상호작용은 짧은 문구와 작은 pose만 남기며 저장·보상·함께한 시간을 만들지 않습니다.

**피해야 할 압박.** 반복 탭, 확률 보상 farming, 실패 패널티, 행동 횟수에 따른 동반자 보상.

**상태.** 사진의 local PNG 저장·메타데이터 복원·UI 복구·Album 최근 세 장 표시는 `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`입니다. 낚시는 `catch → 저장`, `무수확 → 조용한 거두기`, `기다림 → 취소`를 모두 손해 없이 처리하고, 상호작용은 동반자의 `나란히 쉬기`와 난간의 `파도 소리 듣기`를 포함합니다. focused 계약과 540×960 OpenGL capture가 `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED`입니다. 실제 기기에서 사진·앨범·새 문구의 가독성이 편안한지는 `NOT_RUN`입니다.

### 함께 보낸 시간

**플레이어가 보고 하는 일.** 동반자와 active foreground 항해에서 함께 보낸 시간이 앨범에 조용히 쌓이는 것을 봅니다.

**필요한 이유.** 동반자를 행동 보상으로 바꾸지 않고도 함께 머문 시간이 의미 있게 느껴지게 합니다.

**피드백.** 앨범의 시간과 짧은 관계 문구.

**피해야 할 압박.** live level, progress bar, growth popup, species bonus, action multiplier.

**상태.** active foreground delta만 누적하고 `user://together_time_v1.cfg`에 local-only로 저장하는 구현이 `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`입니다. 실제 기기에서의 readability와 pressure 판단은 `NOT_RUN`입니다.

### 흘러가는 풍경과 배경 발견 연출

**플레이어가 보고 하는 일.** active foreground로 머무는 동안 새벽의 바다 아치, 밝은 낮의 해초 또는 흰 절벽, 해질녘의 사암 코브 또는 갈대섬, 밤의 먼 생물발광처럼 바다의 자연경관이 천천히 지나가는 것을 봅니다. 일부 낮은 빈도의 장면은 짧은 알림과 함께 개인 memory로 자동 저장됩니다.

**필요한 이유.** 바다가 정지한 배경이 아니라 천천히 흘러가는 장소처럼 느껴지되, 휴식을 끊지 않게 합니다.

**피드백.** 현재 시간대의 자연 명소, 짧고 사라지는 notification, local ambient memory.

**피해야 할 압박.** 발견을 보기 위한 기다림, button 요구, reward claim, task, social message, missed-event penalty, 구조물을 탭해야 하는 상호작용.

**상태.** active foreground 시간만 사용하고, 명목 5분에 약 1-2회가 지나가되 zero도 정상이라는 cadence와 여섯 승인 motif의 runtime consumer는 `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED`입니다. actual device에서의 5분 휴식감·noticeability·반복 피로는 `NOT_RUN`입니다.

### Album

**플레이어가 보고 하는 일.** 실제 사진, 기록, catch와 함께한 시간을 돌아봅니다.

**필요한 이유.** 효율표가 아닌 개인적 기억이 시간이 남는 방식입니다.

**피드백.** 내가 실제로 남긴 기록과 조용한 관계 문구.

**피해야 할 압박.** completion checklist, 가짜 illustrative photo, collection score.

**상태.** Album surface는 `PARTIAL_IMPLEMENTED`입니다. 함께한 시간의 Album-only 표현, 실제 사진 포스트카드, 자동 풍경, 물고기와 완료 항해 기록의 local save·restore는 각각 `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`입니다. delayed bottle 편지 내용과 그 밖의 전체 memory save는 별도 범위입니다.

## 5. 화면과 정보의 흐름

| 화면 또는 상태 | 플레이어 목표 | 주요 행동 | 다음 연결 | 제품 상태 |
| --- | --- | --- | --- | --- |
| 타이틀 대기 | “여기는 어떤 장소인가”를 로고와 실제 보트로 즉시 느낌 | 보기, `항해 시작` | normal voyage | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human calm `NOT_RUN` |
| Normal voyage diorama | 캐릭터·동반자·보트·바다와 시간에 따라 바뀌는 풍경을 함께 보기 | 쉬기, 사진, 낚시, 감상, 꾸미기 | album 또는 계속 머무르기 | direct-entry atmosphere/scenery `RUNTIME_CAPTURE_VERIFIED`; Human calm `NOT_RUN` |
| Appreciation Camera | 수평선과 바다에 집중 | 감상 시작·종료 | 같은 normal voyage | `IMPLEMENTED`; Human comfort `NOT_RUN` |
| 꾸미기 | 공간을 내 취향으로 두기 | 외형·동반자·장식 변경 및 별도 preview 확인 | 같은 normal voyage | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| Album | 남은 개인 기록과 함께한 시간 보기 | 최근 포스트카드 세 장, 복원된 물고기·항해 기록 읽기, 바다로 돌아가기 | normal voyage | together-time·postcard·ambient·fish/voyage ledger `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; delayed-letter persistence를 포함한 전체 memory save `PARTIAL_IMPLEMENTED` |

첫 화면은 설정 메뉴가 아니라 **타이틀 대기**입니다. `TitleOverlay`는 로고와 `항해 시작`만 표시하고, 배경에는 same `BoatSpace`·동반자·바다를 사용합니다. 따라서 현재 `main_menu.tscn`의 identity/time/mood UI와 그 capture는 code evidence일 뿐, 이 화면 흐름의 디자인 정본이나 visual approval이 아닙니다.

## 6. 확정된 시각 방향

### 시각 방향 고정

- 전체: `HANDPAINTED_STORYBOOK_3D_DIORAMA`
- 브랜드 표지: `MLB-BRAND-TITLE-001`은 deep teal ink, warm ivory paper, 작은 파도·별빛으로 `MY LITTLE BOAT`와 `파도 위에서, 함께 쉬는 시간`을 읽히게 한다. `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED`; user가 요청한 `TitleOverlay/BrandLogo` runtime consumer에서만 쓰며 player/pet identity consumer는 없다.
- 둘러보기 foreground: `MLB-LOOK-STYLE-006`의 soft-matte chibi player + round dog + matte ivory/deep-teal rounded dinghy
- 기본 Normal Diorama foreground: 기본 C+강아지 route는 stern 쪽에 기대어 뒷모습으로 보이는 `MLB-LOOK-CHIBI-NORMAL-REAR-001`의 user-approved source와 그 기술용 foreground matte `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`를 `FinalDioramaCard` shader material로 소비한다. normal rig는 보트 뒤쪽 위에서 바라보며, card `pixel_size=0.0037`은 새 원화의 넓은 하늘 여백 속에서도 보트·player·dog가 모바일에서 읽히도록 한다. material은 녹색 기술 배경만 alpha 처리하고, 시간대별 static `SkyBackdrop`·flowing `SeaBackdrop`·수면 접점·BoatSpace bob을 유지한다. user-approved `꽃` 펫 쿠션만 bow-side overlay로 보인다. `엽서`는 main normal art에 합성하지 않으며, independent 꾸미기 preview 난간 장식과 Album 항해 포스트카드로만 소비한다. alternate identity와 `stripe`·`moon` decor variant도 승인 치비 family로 current consumer에 연결됐지만, 기본 C+강아지 first-view route는 바꾸지 않는다.
- 밤: `INDIGO_RAIN_REFLECTION`

### 유지할 것

- 넓은 바다·하늘, 안정된 수평선, 낮거나 중간인 환경 대비.
- 부드러운 matte/painterly 재질과 큰 painted mass.
- 3/4 diorama 안에서 함께 읽히는 캐릭터·동반자·보트.
- 둥글고 애니메이션적인 치비 캐릭터 silhouette, 큰 머리카락 mass, 절제된 셀 명암.
- 느리고 예측 가능한 bob, 물결, idle.

### 피할 것 / 흔들리지 말 것

- glossy photoreal CG, 과한 PBR micro-detail, random AI noise.
- 큰 유리눈, glamour fashion, 실제 유아화, character만 과도하게 강조하는 rim light.
- 빠른 깜빡임, 과한 bob, attention call, 넓은 고휘도 반사.
- 보트와 물이 분리되어 보이는 합성, 바다를 가리는 거대한 UI panel.
- 다른 게임의 character proportion, UI, branding, trade dress를 닮게 복제하는 것.

### 증거를 구분하는 법

`APPROVED_DIRECTION`은 그림체의 선택입니다. 생성 exploration은 runtime asset이 아니며, source binary가 있다고 runtime alignment가 증명되는 것도 아닙니다. 실제 540 x 960 capture는 화면이 실행됐다는 증거이고, Human comfort는 사람이 확인하기 전까지 `NOT_RUN`입니다.

## 7. 현재 제품 상태와 구현 가능성

### 현재 상태

| 항목 | 상태 | 의미 |
| --- | --- | --- |
| Rest-first direction | `CONFIRMED` | 머무르기가 complete play라는 제품 방향 |
| 타이틀 대기 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | `game.tscn`이 startup route이며, `항해 시작` 전에는 voyage state를 만들지 않는다. Human comfort는 별도 검증 전 |
| 오늘의 마음 제거 | `IMPLEMENTED / MACHINE_VERIFIED` | mood data와 pre-entry prompt를 current product route에서 retire함 |
| 현실 시간 분위기 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | 현지 시간은 시각만 바꾸고, startup selector·saved preference는 없음 |
| 기본 하늘·바다 흐름 | `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED` | 각 시간대의 `SkyBackdrop`은 material override 없이 고정되고, `SeaBackdrop`만 `voyage_split_sea_flow.gdshader`의 alpha mask와 shared lateral flow offset으로 타이틀 대기·항해 중 계속 느리게 흐른다. 항해가 시작된 뒤에만 가까운 수면은 별도 `forward_flow_offset`을 받아 수평선에서 하단으로 흐르며, title 대기는 이 전진 phase 없이 부유한다. speed와 `standard/gentle/still`은 기존 multiplier를 공유하고 항해 시간·저장·보상에는 영향을 주지 않는다. Bright 2초 renderer pair에서 upper sky `0.00%`, lower sea `79.29%` changed-pixel 증거가 남아 있다. |
| 밝은 봄 분리 parallax | `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED` | 현지 월 `3..5`의 `bright` visual context에서만 구름이 세 camera path에, 꽃섬은 normal·Appreciation의 기존 저밀도 기회 위에 별도 Sprite3D로 합성된다. 꽃섬은 원본의 투명 캔버스를 제외한 수평선용 영역만 쓰므로 보트가 지나가는 하단 바다 항로에 들어오지 않는다. static sky, flowing sea, 보트, 저장·보상은 바꾸지 않는다. Human/device motion comfort는 별도 검증 전. |
| 선체-수면 접점 | `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED` | existing ripple은 보트의 x/z와 거의 같은 y bob을 따른다. user-approved `MLB-BOAT-FLT-006` narrow waterline raster는 `BoatWaterlineContact`가 depth test를 유지한 채 선체 하단에만 표시하며, 같은 x/z·vertical drift와 `still` comfort base return을 사용한다. 540×960 title·voyage capture에서 캐릭터·동반자·`쉬는 메뉴`를 가리지 않는다. Human comfort는 별도 검증 전 |
| 흘러가는 풍경 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | 첫 기회 90–150초와 기회별 65% 표시를 사용하며, local ambient memory 저장은 구현됨. 0회 항해도 정상이고 Human five-minute observation은 별도 검증 전 |
| cosmetic 꾸미기 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | in-voyage selector와 독립 preview가 local cosmetic state만 바꿈 |
| 함께 보낸 시간 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | active foreground delta만 누적하고 Album에만 표시. Human readability는 별도 검증 전 |
| Ambient Discovery | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | active foreground의 자동 풍경만 `user://ambient_memory_v1.cfg`에 저장·복원. no-first-guarantee cadence는 구현됐고 Human five-minute observation은 별도 |
| Visual direction | `APPROVED_DIRECTION` | production asset batch와 runtime alignment는 별도 |
| Human usability / Player Experience | `NOT_RUN` | 실제 30초·5분 기기 경험 검증 전 |

### 구현 가능성 확인

현재 Godot 구조에서 direct boat entry는 구현 가능한 범위입니다. `GameState`처럼 Autoload된 Node는 Scene 전환을 넘어 state를 유지할 수 있고, 이는 mood를 retire한 뒤 local cosmetic state와 active foreground session state를 owner로 유지하는 데 맞습니다. [Godot Autoload 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

Godot `Time`은 현지 시스템 시간을 읽을 수 있으므로 현실 시간 기반의 순수 시각 분위기에 맞습니다. 다만 시스템 시계는 사용자가 바꿀 수 있으므로 precise progress에는 쓰지 말아야 합니다. active foreground scenery는 monotonic tick 또는 scene delta로 계산합니다. [Godot Time 공식 문서](https://docs.godotengine.org/en/stable/classes/class_time.html)

작은 local cosmetic과 ambient memory는 `user://`와 `ConfigFile`로 저장·복원할 수 있습니다. 이 저장은 시간대 자체를 저장하지 않으며, 기존 mood data migration과 save 실패 처리는 구현 계약에서 정합니다. [Godot ConfigFile 공식 문서](https://docs.godotengine.org/en/stable/classes/class_configfile.html), [Godot user data filesystem 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html)

main scene을 direct boat route로 바꾸고 optional customization을 같은 게임 내 surface로 연결하는 것은 Godot 표준 SceneTree 전환의 범위입니다. 이 가능성은 아직 전환 구현이나 mobile performance 검증을 뜻하지 않습니다. [Godot Scene 전환 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html)

### 완료된 Direct Boat Entry package의 역사적 구현 계약

아래 항목은 2026-08-30부터 2026-09-01까지 구현·기계/runtime 검증으로 이어진 Direct Boat Entry package의 당시 contract입니다.

1. main scene이 현지 현실 시간에 맞는 normal boat diorama로 바로 시작한다.
2. 새벽 `05:00–08:59`, 밝음 `09:00–16:59`, 해질녘 `17:00–20:59`, 밤 `21:00–04:59`를 첫 구현의 local-time mapping으로 사용한다. 수동 selector와 saved atmosphere는 retire한다.
3. mood data, mood wording, mood color rule, mood-dependent test를 migration과 함께 retire한다.
4. active foreground 시간만 사용하는 low-density drifting scenery director를 추가한다. 명목 5분에 약 1-2개의 먼 풍경 장면이 지나가며, zero도 정상이다. 실제 scene asset은 named consumer가 없는 한 만들지 않는다.
5. 외형·동반자·장식 선택을 optional `꾸미기`로 이동한다.
6. direct-entry diorama가 540 x 960에서 float-contact 기준을 충족하는 runtime capture를 만든다.
7. 자동 route/time-mapping/foreground-progress tests, targeted scene smoke, runtime capture, Human 30초·5분 검증을 서로 구분해 기록한다.

위 contract의 scene, state, scenery, customization entry, water-contact, test, GPU capture 경로는 현재 receipt에 따라 구현되었습니다. 이 문단은 현재 작업 순서를 정하는 새 구현 queue가 아닙니다. 이후 작업은 `docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json`의 fresh-read → reuse/benchmark → bounded owner change → evidence → review 순서를 따르며, Human/device evidence는 계속 별도 gate입니다.

### Blueprint evidence ceiling

| evidence subject | current ceiling | next proof |
| --- | --- | --- |
| Direct boat entry | `IMPLEMENTED_AND_GPU_CAPTURED` | actual-device first 30 seconds |
| Real-time atmosphere | `IMPLEMENTED_AND_TESTED`; GPU capture exists | device transition/readability observation |
| Foreground scenery | `IMPLEMENTED_AND_GPU_CAPTURED` | normal five-minute density observation |
| Ambient memory | `IMPLEMENTED_AND_TESTED` | noticeability and calmness observation |
| Relationship/shared-time expression | `IMPLEMENTED_AND_TESTED`; Album GPU capture exists | Human readability and pressure observation |
| Device first 30 seconds / 5 minutes | `NOT_RUN` | named Human/device session |
| Touch / audio / notification intensity | `NOT_RUN` | real touch, soundscape, notification observation |

Static docs, automated tests, generated assets, and GPU captures do not promote any `NOT_RUN` row to Human or device PASS.
## 8. 금지 범위와 열린 결정

### 금지 범위

- 전투, 체력, 피해, 적, 죽음, 실패 조건, retry pressure.
- 경쟁, rank, follower, popularity, public feed, realtime chat.
- ads, payments, gacha, rare power, stats, economy farming, daily FOMO.
- 펫의 배고픔·청소·피로·방치 벌.
- direct-entry 변경을 핑계로 하는 asset batch, social expansion, unrelated refactor.

### 열린 결정

| 항목 | 현재 결정 | 나중에 정할 것 |
| --- | --- | --- |
| 현실 시간 분위기 | 현지 현실 시간이 자동 적용 | 계절·지역 일몰까지 반영할지 여부. 첫 구현에는 포함하지 않음 |
| direct-entry visual production | 구형 composite-flow composition reject, static sky + flowing sea pair·기본 normal chibi material foreground·저장된 `꽃` 쿠션/`엽서` chibi decor consumer와 alternate identity/`stripe`·`moon` family가 runtime consumer로 확정 | actual-device color, readability, motion/visual comfort review |
| 함께 보낸 시간 | active foreground 시간만 1:1 누적, Album-only 분 단위 copy, local ConfigFile | Human/device readability와 5분 pressure review |
| 물고기와 완료 항해 기록 | `memory_ledger_v1.cfg`에 string 목록만 local save·restore, Album-only 소비 | Human/device readability와 delayed bottle letter의 별도 safety gate |
| 흘러가는 풍경 / Ambient Discovery | active foreground, passive, auto-save, 첫 기회 90–150초, 기회별 65% 표시, `ambient_memory_v1.cfg` | Human five-minute calm/noticeability와 장기 표현 검증 |
| Human validation | 아직 `NOT_RUN` | 실제 기기에서 first 30 seconds와 5 minutes가 calm인지 |

새 결정은 current owner와 공식 근거를 대조한 뒤에만 정본으로 올립니다. 충돌은 해당 owner만 교정한 뒤 적대적 검토를 다시 통과합니다.

### 8.1 2026-09-01 계절형 자연 명소 분리 합성 Pass v1 Blueprint review

**상태.** `RESEARCHED → FEASIBLE → USER_APPROVED_MATERIAL → ASSET_READY → BLUEPRINT_REVIEW_READY → USER_FINAL_REVIEW_APPROVED → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`입니다. 이 상태는 exact Bright/spring v1 Scene·GDScript·contract·Windows OpenGL capture에만 적용합니다. Human/device five-minute calmness, touch, color, motion comfort와 release acceptance는 `NOT_RUN`입니다.

**목표.** 밝은 봄의 작은 꽃섬과 느린 구름이 existing clear sea 위에서 서로 다른 깊이와 속도로 움직여, 보트가 목적지 없이 계속 떠가고 있다는 감각을 강화합니다. 배경은 풍부해지되, 명소를 보거나 사진을 찍거나 기다려야 하는 목적은 만들지 않습니다.

**플레이어가 보게 되는 흐름.** 기기의 현지 시간이 `bright`이고 현지 월이 3–5월이면, 일반 항해와 Appreciation Camera의 현재 low-density scenery opportunity가 기존 bright motif 또는 작은 꽃섬 중 하나를 지나가게 할 수 있습니다. 같은 기간에는 sky 위의 작은 구름이 섬보다 느리게, existing sea shader는 두 layer와 독립적으로 흐릅니다. 명소를 전혀 만나지 않아도 정상이며, 구름은 save·notice·reward를 만들지 않습니다.

**범위와 고정 경계.**

- `bright`의 시간 범위와 current `dawn / bright / sunset / night` decision은 바꾸지 않습니다.
- 월 3–5월은 내부 `spring` visual bucket일 뿐, 날짜·계절 이름·지역·날씨·달력 UI·saved preference를 표시하지 않습니다.
- first v1은 `bright + spring`의 one-island vertical slice입니다. 6–2월과 bright의 다른 기존 motif는 current pool로 fallback하며, 다른 계절 image batch는 이 package에 자동 포함하지 않습니다.
- `SkyBackdrop`은 그대로 고정하고, existing `SeaBackdrop`과 `voyage_split_sea_flow.gdshader`를 재사용합니다. 새 sea image, full-scene moving texture, whole-sky pan은 만들지 않습니다.
- `SeasonalCloudLayer`는 three camera path의 sky와 sea 사이에서 only-cloud parallax를 보이고, `SeasonalIslandLayer`는 current normal·Appreciation ambient transit에서 sea 앞/boat 뒤의 수평선 landmark로만 보입니다. 꽃섬의 source alpha bounds를 포함하는 runtime crop과 작은 scale을 사용해 하단 보트 항로와 교차하지 않습니다. Look Around의 angle-specific foreground와 existing ambient policy는 변경하지 않습니다.
- 꽃섬은 current `DriftSceneryDirector`의 foreground-only cadence, one-at-a-time state, 65% display chance, 0-event-valid rule, existing short label, and optional local ambient memory save를 그대로 공유합니다. chance, cadence, save rate, camera mode, speed tier, cosmetic identity, together time, fishing, decor, affection, reward는 바꾸지 않습니다.
- 구름은 visual-only loop이며 ambient memory, notification, timer, reward, photo requirement, score, completion, collection slot, seasonal event, daily goal, missed-state, social action을 만들지 않습니다.
- user `still` motion comfort setting에서는 새 cloud parallax와 new island transit movement도 advance하지 않습니다. `standard / gentle`은 current normalized motion multiplier를 재사용해 amplitude와 transit speed를 낮춥니다. 이 behavior는 existing approved sea and boat semantics를 변경하지 않습니다.

**approved material and composition.** `MLB-AMB-SEASONAL-REF-001` is a non-runtime visual direction source. `MLB-AMB-SEASONAL-ISLAND-001` is the actual RGBA island texture. `MLB-AMB-SEASONAL-CLOUD-001` is an intentionally opaque magenta technical matte that uses the existing verified `look_around_foreground_chroma_key.gdshader`, not a new image conversion or a new shader family. `MLB-BG-SPLIT-001 / 002` remain the current bright static-sky / flowing-sea pair. Exact paths, dimensions, hashes, candidate provenance, and state distinctions are owned by the current visual inventory.

**implementation mapping after final approval.**

| owner | bounded responsibility | save / rollback boundary |
| --- | --- | --- |
| `scripts/voyage/real_time_atmosphere_resolver.gd` | injectably resolve `spring` for months `3..5`; invalid month safely resolves to empty seasonal bucket | device date is visual-only; no persistence, reward, or progress use. Godot system time is not a monotonic gameplay clock |
| `scripts/voyage/drift_scenery_director.gd` | select the existing bright motif pool plus exactly one `bright + spring` island when compatible; preserve no-immediate-repeat and fallback behavior | no new cadence/state persistence; reverting the seasonal entry restores the current six motif selection |
| `scenes/game.tscn` | add named `SeasonalCloudLayer` to three camera paths and named `SeasonalIslandLayer` only beside existing normal/Appreciation `AmbientSceneryPass`; island keeps the canonical source but uses `region_enabled`, `Rect2(632, 350, 1028, 350)`, and `pixel_size=0.005` for a horizon-only silhouette | no changed BoatSpace, Look Around foreground, sky/sea source, or UI hierarchy |
| `scripts/voyage/game_scene.gd` | bind exact approved textures, existing chroma-key shader, visual month bucket, cloud loop, island transit, and comfort multiplier without touching voyage/save semantics | a package reversion removes the named nodes/routes and returns exact current scene behavior |
| `tests/test_seasonal_parallax_contract.gd` and focused existing contracts | injected month / atmosphere matrix, source-to-canonical hash, alpha/matte guard, layer order, runtime crop excluding source-canvas edges, distant projected scale, fallback, no save/reward mutation, still/gentle motion boundaries | display capture assertions stay renderer-only and never report headless texture readback as PASS |

**alternatives compared.**

| alternative | verdict | reason |
| --- | --- | --- |
| Existing sky + existing flowing sea + separately composited cloud/island parallax | **ADOPT** | direct response to the user's movement-depth request, reuses approved surfaces and a tested chroma-key route, and keeps foreground boat legible |
| Four fully illustrated seasonal full-screen backgrounds that move as one card | **REJECT** | repeats the original whole-image movement problem, duplicates the sea/sky asset family, and expands asset count without preserving independent motion |
| Real-time daily quests, seasonal event calendar, photo objectives, collection completion or notice-driven rewards | **REJECT** | converts visual context into a chore/FOMO loop and violates the rest-first no-pressure boundary |
| Local month only changing a static tint with no new landmark layers | **ADAPT later only** | cheap but does not solve the user-requested depth and continuous movement issue |

**feasibility and test path.** Godot `Time.get_date_dict_from_system(false)` exposes local month data, but system-clock values can be changed by the user or OS; therefore the package uses it only for visual routing and injected deterministic tests, never elapsed-time, reward, or save computation. [Godot Time 공식 문서](https://docs.godotengine.org/en/stable/classes/class_time.html) `Sprite3D.region_enabled` displays only the configured `region_rect`, so it can consume the existing island source without a derivative PNG while excluding its transparent canvas margin. [Godot Sprite3D 공식 문서](https://docs.godotengine.org/en/stable/classes/class_sprite3d.html) `test_seasonal_parallax_contract.gd` first failed on absent month routing, three-argument seasonal selection, named camera consumers and motion behavior, then passed after the bounded implementation. The distance correction adds a source-edge crop and projected-scale contract. The renderer capture now requires a horizon island and clear lower boat lane in three normal frames of one transit, then measures an early/late island-center displacement of at least `80px`; current Windows OpenGL run measured `213px`. This remains machine/runtime evidence, not Human/device comfort proof.

**final approval boundary.** The user approved this exact Blueprint revision before implementation. That authority was consumed only for this Bright/spring vertical slice. It did not authorize other seasonal images, daily systems, location settings, social features, or Human validation.

#### 8.1.1 Preimplementation material and Blueprint review receipt

| loop | exact review | validated result | correction / retained boundary | evidence ceiling |
| --- | --- | --- | --- | --- |
| 1 | current `AGENTS.md`, current GDD/handoff/visual inventory, `game.tscn`, `GameScene`, `DriftSceneryDirector`, existing split bright images and prior runtime evidence | whole-scene `AmbientSceneryPass` would move sky, sea and landmark together, while existing bright sea is already a separate flowing asset | adopt separate cloud/island composition and reuse existing static-sky/flowing-sea pair | current runtime remains unchanged |
| 2 | Tiny Glade, Cozy Grove, TOEM, Palia and Godot Time primary/official material comparison with project no-pressure constraints | landmark variation is feasible; full seasonal screens and daily/quest/photo completion systems conflict with the product | select one bright/spring visual-only vertical slice with month `3..5` and no UI/reward/save meaning | research/feasibility, not runtime proof |
| 3 | built-in image generation output plus alpha/matte pixel inspection | direction-reference scene, isolated island and cloud art met the intended composition; first island contained reflection and two cloud outputs were opaque checkerboard RGB | retain user-approved reference, regenerate reflection-free RGBA island, reject opaque checkerboard attempts, use existing chroma-key route for cloud matte | source asset quality only |
| 4 | exact source/canonical byte hashes, free-space preflight, non-overwriting project copies, Godot `--headless --path . --import`, project headless smoke | source/canonical pairs match; two runtime textures import without project startup regression | register only source/reference plus exact two implementation-ready textures; no full-scene runtime duplicate or new sea file | asset import and project smoke only |
| 5 | runtime-isolation search, documented ID/path readback, island alpha samples, cloud-key threshold samples, `git diff --check` | new asset paths have no Scene/script/test consumer before final approval; island alpha and chroma matte meet their respective source-level contracts; no whitespace error | preserve `NOT_IMPLEMENTED` / `NOT_RUN` status and require failure-first implementation contracts and display renderer capture next | no seasonal runtime, Human, device, audio, accessibility or release PASS |

No valid MUST_FIX remains in the material-preparation scope. The rejected candidate-store outputs are not project assets. The only remaining gate is user review of this exact Blueprint revision before code implementation.

#### 8.1.2 Implementation and adversarial review receipt

| loop | exact review | validated result | correction / retained boundary | regression / evidence |
| --- | --- | --- | --- | --- |
| 1 | user-approved §8.1 revision, current `AGENTS.md`, `game.tscn`, `game_scene.gd`, resolver, director, comfort owner and approved hashes | month can remain visual-only and the existing bright pool can safely accept one additional entry only under `spring` | `resolve_season_for_month(3..5)` and optional director season argument were selected; 6–2 and old two-argument callers retain fallback | initial seasonal contract failed as expected on missing resolver/selection behavior |
| 2 | resolver/director green run and existing director/ambient/split contracts | direct append into a constant-backed motif array produced Godot `Array is in read-only state` | copied the array before appending; no cadence, chance, save rate or old motif source changed | seasonal, director, ambient and split contracts passed |
| 3 | Scene consumer contract, three camera nodes and Look Around foreground material | shared chroma-key `ShaderMaterial` would overwrite the existing angle foreground texture binding | each `SeasonalCloudLayer` now gets a runtime-local shader material while reusing the same approved shader source | named normal/Look Around/Appreciation cloud layers, normal/Appreciation island layers and untouched Look Around policy passed |
| 4 | motion contract with no-save deterministic island event and existing comfort/forward-drift/ambient contracts | dedicated island needed manual comfort-aware transit rather than the old tween, which would move even in `still` | cloud phase and island progress use existing `standard/gentle/still` scale; the shared return timer clears the visual route without a new saved timer | standard motion, gentle reduction, still freeze and photo/fish/record/together-time non-mutation passed |
| 5 | Windows OpenGL capture, image readback, 57 headless contracts in two bounded batches, import and current CI guard | first normal capture had cloud source above the tighter 3/4 frame despite correct chroma alpha | moved only camera-local cloud Sprite y to `-3.2`; the later island-distance correction is recorded separately below | historical pre-distance normal SHA `05620478B85A1C86D5E3D4EC7735C69B21C2DF43F7EB21918FD9EC655D6B3AE7`, Appreciation SHA `6DDC2C5C882EB95F435140C2E72C0D100585AEA378DAF72A9B1FA528C58F1235`; Human/device remains `NOT_RUN` |

#### 8.1.3 2026-09-01 원거리 꽃섬 항로 보정 receipt

사용자 방향은 “섬은 멀리 두고 배는 바다만 지난다”입니다. 이 보정은 `MLB-AMB-SEASONAL-ISLAND-001` 원본·승인·hash·chance·cadence·save·reward·camera mode를 바꾸지 않고, 두 existing `SeasonalIslandLayer`의 표시 영역과 scale만 좁힙니다.

| loop | exact review | validated finding | applied correction / retained boundary | regression / evidence |
| --- | --- | --- | --- | --- |
| 1 | latest user direction, current `AGENTS.md`, `game.tscn`, current normal OpenGL capture, island asset consumer | island source full canvas was displayed at the same scale as the ambient pass, so its large transparent canvas made the landmark read near the boat lane | choose source-preserving runtime crop plus smaller projected scale; do not add a new island image or move the boat, sea, reward, or transit schedule | initial static geometry and renderer lane guards fail before correction |
| 2 | failure-first `test_seasonal_parallax_contract.gd` geometry assertion and normal renderer lower-lane assertion | full-canvas source does not exclude empty margins, cannot prove horizon scale, and can leave island-colour samples in the lower boat lane | require a non-edge `region_rect`, `region_enabled`, and normal-camera projected height ratio `≤ 0.30`; renderer also requires a horizon mark and clear lower lane | failure output retained before Scene correction |
| 3 | exact source alpha inspection and official `Sprite3D` region semantics | `1672×941` source has opaque alpha only in `Rect2(644, 362, 1002, 322)` | retain source bytes and select padded `Rect2(632, 350, 1028, 350)` with `pixel_size=0.005` in normal and Appreciation layers | crop contains every opaque source pixel while excluding all four source-canvas edges |
| 4 | iterative scene diff, actual 540×960 display capture, untouched `SkyBackdrop` and `SeaBackdrop` readback | an overly broad scene edit briefly changed the normal sky/sea card scale, visibly producing blue frame bars | restore both normal sky/sea `pixel_size` values exactly to their prior `0.02`; retain only the two island `region` and `pixel_size` changes | current scene diff is restricted to the two seasonal island layers; sky, flowing sea, BoatSpace and Look Around remain untouched |
| 5 | Godot `--import`, normal scene smoke, 57 headless contracts in `27 + 30` batches, display-only material proof, Windows OpenGL normal/Appreciation capture, hash/readback | all machine checks passed. The initial aggregate harness falsely treated the exit-0 Windows export contract as failure because it prints `Windows export contract passed` rather than `PASS:`; its source assert and exit code were read, then batch two was rechecked by exit code | retain the project test sources unchanged and make the aggregation receipt use engine exit code. Final scene diff is still limited to the two island layers | normal SHA `C6B652B85D83E30C54406EFA0646248A52761F81DA059D807920B2638E330E7C`, Appreciation SHA `291E141B8021E46A20A613AA91E3238D59227A9E0891C58A08F8B8F3C9B010F0`; Human/device remains `NOT_RUN` |

#### 8.1.4 2026-09-02 꽃섬 transit renderer proof receipt

| loop | exact review | validated finding | correction / retained boundary | regression / evidence |
| --- | --- | --- | --- | --- |
| 1 | latest user standing image authorization, current `AGENTS.md`, GDD, visual inventory, `game.tscn`, `GameScene`, capture source and prior single normal/Appreciation evidence | previous evidence proves a safe single frame but does not prove that the distant island traverses the screen while maintaining the lower boat lane | retain existing asset and scene; add only a renderer-evidence pair inside the actual 14-second transit | no new image consumer, gameplay meaning, save, reward, camera mode, or asset source change |
| 2 | three alternatives against the existing rest-first loop and Godot display-capture path | a physical island collision/route changes passive play, a newly generated island duplicates an approved consumer, and a timed renderer pair directly verifies the reported risk | **ADOPT** timed renderer pair, **REJECT** collision/waypoint route and duplicate island art, **ADAPT** existing capture guard with pixel-center measurement | [Godot RenderingServer 공식 문서](https://docs.godotengine.org/en/stable/classes/class_renderingserver.html)의 `frame_post_draw` semantics에 맞춘 runtime proof design이며 Human proof가 아니다 |
| 3 | failure-first `test_seasonal_parallax_contract.gd` capture-source contract | capture had no early/late files, displacement threshold, or rendered-silhouette locator | add early/late normal files, `MIN_MOTION_HORIZONTAL_DELTA_PIXELS`, and island center extraction to the existing capture route | initial focused contract failed on all four missing proof requirements |
| 4 | Windows OpenGL capture failures, scene route state, event timer and island progress/position instrumentation | first timing attempt spent the old 7-second wait plus the new wait, while the next attempt sampled outside the narrow normal-camera visibility window | remove duplicated timing budget and sample the same active transit at `6.5`, `7.0`, `7.5` seconds. Remove temporary diagnostics after the cause is known | `AmbientSceneryReturnTimer` stays `14` seconds; game Scene and asset source remain unchanged |
| 5 | clean Windows OpenGL capture, four PNG readback and pixel guard | three normal frames contain cloud, horizon island and clear lower boat lane; early/late island center differs by `213px` | retain minimal capture-only change and record exact files/hashes in evidence owner | renderer capture `PASS`; Human/device motion comfort, touch and five-minute calmness remain `NOT_RUN` |

#### 8.1.5 2026-09-02 항해 전진 수면 renderer proof receipt

| loop | exact review | validated finding | correction / retained boundary | regression / evidence |
| --- | --- | --- | --- | --- |
| 1 | latest user direction, current `AGENTS.md`, GDD, handoff, normal GPU captures, `game.tscn`, `GameScene`, split-sea shader and forward-drift contract | existing `BoatSpace` forward surge is symmetric and the sea only uses lateral UV flow, so the scene can read as floating rather than progressing | retain the approved boat, camera, sky, sea image, waterline texture and local-first loop; add a voyage-only near-water phase rather than a route, destination or new image | no save, reward, scene hierarchy, input, camera mode or asset-source change |
| 2 | three alternatives and Godot 4.7 spatial-shader reference | enlarging boat surge makes a stronger bob but still returns to the base point; moving the full background breaks fixed sky/horizon; depth-weighted near-water UV travel gives a clear forward cue while preserving the diorama | **ADOPT** voyage-only depth-weighted water travel, **REJECT** stronger boat-only oscillation and whole-background pan, **ADAPT** existing `ShaderMaterial` uniform route | [Godot 4.7 Spatial shader 공식 문서](https://docs.godotengine.org/en/4.7/tutorials/shaders/shader_reference/spatial_shader.html)는 fragment `UV`와 spatial shader uniform route를 지원한다 |
| 3 | failure-first `test_voyage_forward_drift_contract.gd` | no voyage-only forward water state, no shared `forward_flow_offset` uniform, and no title/still boundary existed | add the contract before production code | expected red result was 15 forward-water assertions; the first null-uniform test error was corrected in the test before implementation |
| 4 | minimal `GameScene` and split-sea shader change, focused headless contract, Windows OpenGL capture | a local vertical UV offset must be weighted only in near water and must not run while title waiting or comfort is `still` | increment `_forward_water_flow_offset` only during active voyage, apply it below the horizon, and add a small existing ripple wake emphasis without a new asset | focused forward-drift contract passed; two 540×960 renderer images were created |
| 5 | normal 2-second renderer pair, hash/readback, sky/lower-water pixel comparison, 57 headless contracts, display-only material proof, Python suite and untouched consumer review | lower sea changed `0.7929` while upper fixed sky changed `0.0000`; BoatSpace, camera route, title flow, seasonal island and visual assets remain isolated | retain the bounded shader/state change and evidence owner | renderer capture, `27 + 15 + 15` headless contracts, display material proof and Python suite passed; remote CI and Human/device comfort remain separately recorded |
