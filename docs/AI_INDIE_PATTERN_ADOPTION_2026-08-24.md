# my little boat · AI Indie Pattern Adoption — 2026-08-24

```yaml
status: USER_DIRECTED_ADAPTATION
work_mode: PLAN
runtime_mutation: NONE
source_base_merge: dff09d83c3892a70ba5fee86a59d36086889a6c5
core_session: mood -> 5-minute drift -> discovery -> record/album/companion
combat_failure_competition: FORBIDDEN
runtime_ai: REJECT_CURRENT
human_validation: NOT_RUN
```

## 결론

이 프로젝트의 가치는 불확실성 통제나 위험 최적화가 아니라 **짧고 조용한 항해에서 작은 발견과 기억을 쌓는 감정 경험**이다. 따라서 `RNG_AGENCY_AND_RECOVERY`나 runtime 생성형 AI를 그대로 넣지 않는다.

이번 흡수는 `Human-directed AI production`, `Breadth-after-core`, `AI-visible-output quality`, `player-feedback rebuild`에 집중한다.

## 판정

| Pattern | 판정 | 적용 |
|---|---|---|
| HUMAN_DIRECTED_AI_BUILD_LOOP | ADOPT | AI가 풍경/편지/반응 후보를 늘려도 인간이 톤·감정·속도 승인 |
| SILENT_OMISSION_GATE | ADOPT | mood/voyage/record/album/companion consumer 누락 검사 |
| CONTEXT_SCOPE_AND_ARCHITECTURE_BUDGET | ADOPT | GameState, voyage, album, companion owner 분리 |
| BREADTH_AFTER_CORE_IDENTITY_LOCK | ADOPT_HIGH | 핵심 5분 감정 루프 검증 전 풍경/편지/동반자 대량 생성 금지 |
| PLAYER_FEEDBACK_REBUILD_LOOP | ADOPT_HIGH | 심심함과 편안함을 구분해서 판단 |
| AI_VISIBLE_OUTPUT_QUALITY_GATE | ADOPT_HIGH | 생성 풍경/편지/오디오도 감정 톤·일관성·권리 Gate 적용 |
| RNG_AGENCY_AND_RECOVERY | REJECT_CURRENT | 실패/위험/보상 최적화로 게임을 바꾸지 않음 |
| runtime generative AI | REJECT_CURRENT | 온라인/실시간 생성 의존 불필요 |

## 핵심 Gate · CALM_CORE_BEFORE_CONTENT_BREADTH

AI로 수십 개의 풍경·편지·동반자 반응을 만드는 것은 쉽지만, 핵심 5분이 편안하고 기억에 남지 않으면 콘텐츠 수가 문제를 해결하지 않는다.

```text
오늘의 마음 선택
→ 바다 진입
→ 5분 표류
→ 사진/감상/속도 조절
→ 작은 발견
→ 오늘의 항해 기록
→ 앨범/동반자에 기억이 남음
```

다음이 Human evidence로 확인되기 전에는 콘텐츠 breadth를 성과로 취급하지 않는다.

- 첫 30초에 조작 없이도 머물고 싶은가.
- 5분이 짧게 느껴지는가, 지루하게 느껴지는가.
- 사진/편지/풍경 발견이 체크리스트보다 기억으로 남는가.
- mood 선택이 플레이 경험의 톤에 작은 차이를 만드는가.
- 앨범과 동반자 반응이 다음 항해의 이유가 되는가.

## PLAYER_FEEDBACK_REBUILD_LOOP

Human feedback를 다음으로 나눈다.

```text
CALM
= 의도적으로 조용하고 머물고 싶음

EMPTY
= 할 이유나 감각적 변화가 없음

FRICTION
= 카메라/UI/버튼이 감상을 방해

CONTENT_REPETITION
= 발견이 반복되어 기억되지 않음

CORE_EMOTION_FAILURE
= 기능은 있지만 위로/잔잔함/작은 설렘이 생기지 않음
```

`EMPTY`를 해결한다고 전투, stamina, 실패, 경쟁, 점수, 광고 보상 같은 자극 시스템을 추가하지 않는다.

## AI_VISIBLE_OUTPUT_QUALITY_GATE

향후 AI-assisted 이미지/텍스트/오디오를 실제 player-facing asset으로 쓸 경우:

```text
프로젝트 visual/audio tone
→ 기존 자산과 일관성
→ 낮은 자극·가독성
→ 반복 생성 흔적/저품질 artifact 검사
→ 권리/provenance
→ 실제 5분 항해 맥락에서 Human review
→ accept | revise | replace
```

생성 속도나 콘텐츠 수가 quality claim이 아니다.

## Production AI · SILENT_OMISSION_GATE

새 discovery/content 추가 뒤 확인한다.

- 발견이 GameState에 기록되는가.
- album에서 다시 볼 수 있는가.
- companion reaction이 필요한 콘텐츠인가.
- mood와의 연결이 있다면 과장되지 않았는가.
- 모바일 세로 UI에서 감상을 가리지 않는가.
- 온라인 공유나 결제 등 제외 범위를 몰래 도입하지 않았는가.

## 다음 Codex/QA 소비

1. 현재 MVP 5분 루프를 release-near 감정 slice로 먼저 만든다.
2. first 30 sec / 5 min / post-voyage 세 구간 Human observation을 분리한다.
3. 콘텐츠 추가는 기존 collection/album/companion owner를 재사용한다.
4. AI-assisted asset은 별도 quality/rights review 뒤에만 product 승격.
5. runtime AI/API/online dependency는 새 user Decision 없이는 도입하지 않는다.

## IRG

현재 주장 가능: 프로젝트의 힐링 정체성을 보존한 AI 생산/콘텐츠 확장 Gate가 정의됨.

현재 주장 불가: 5분 감정 루프 Human PASS, 콘텐츠 반복성 해결, AI asset 승인, runtime AI 도입.

## 적대적 검토 5회

1. 재미 부족을 전투/실패/경쟁으로 해결하지 않음: PASS.
2. AI 콘텐츠 수를 품질로 오인하지 않음: PASS.
3. 온라인/유료 dependency를 추가하지 않음: PASS.
4. visual/audio/text quality Gate 보존: PASS.
5. Human 감정 evidence를 자동 테스트로 대체하지 않음: PASS.

`CLEAN_REVIEW_EXIT`.
