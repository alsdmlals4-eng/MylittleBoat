# 현재 Godot 구현 handoff

## Active Context — P1 상세 계획·후속 배 나들이 2026-09-20

사용자 '좋아 작업진행해 / 배도 나중에 배타고 바깥으로 구경나갈수 있게 할거야'를 반영한다. PR #109의 첫 섬 설계를 상세 계획 기준으로 채택하고 `MLB-BOAT-OUTING-01`을 후속 제품 방향으로 추가했다. 섬이 생활 거점이고 배 나들이는 선택적 외출이며, 구형 항해 중심 제품으로 되돌리는 지시가 아니다.

### 이번 작업과 다음 실행

- [P1 상세 계획](../superpowers/plans/2026-09-20-island-p1-state-save.md)은 FarmState→복구 저장→Session→검사/인도 4개 task, 정확한 API/파일·RED/PASS 절차·중단/복구·보호 범위를 소유한다. 작성 완료와 실행 완료는 다르며 모든 구현 checkbox는 미실행이다.
- 실행 방식 권장은 Native다. 새 계획의 검토 뒤 같은 작업에서 직접 구현하고 필수 독립 병합 검토를 받는다. 첫 섬 설계를 다시 인터뷰하지 않으며 P1 구현/아트·Blueprint 준비의 의존성만 구분한다. 최종 아트/전체 Blueprint 승인을 이번 진행 지시로 추정하지 않는다.
- 배는 현재 P1/P2의 항해 consumer나 빈 저장 필드를 만들지 않는다. 첫 섬 P1–P4 뒤 출항/귀환·나들이 조작/경관·앱 종료를 함께 설계한다. 농장 시간/상태를 카메라·배·Scene에서 분리하는 현재 경계는 유지한다.
- current source는 main `57295a59aafdd0fd2d796d6ecf3fe11b153b6dcb`. 전용 기존 worktree에서 `codex/island-p1-plan-boat-outing-20260920` 분리. 원래 checkout `80ce184...`와 PR #19 OPEN/head `1dc7684...` 보호. Base main 재조회 `23ecad5...` 동일, 채택 version/설치 설정 변경 없음.
- 실제 읽은 consumer는 GameState의 로드/항해 수명, game_scene의 focus/pause 처리, 기존 together-time 저장 테스트, CI 전체 명령, continuation RecoverableConfigStore 전문/fault test다. Godot Time/ConfigFile/MainLoop 공식 문서를 재조회했다. 이전 12게임 조사는 `REUSED_EVIDENCE`이며 새로 모두 플레이/재조사한 것이 아니다.
- 설계 계보 전체 검토 2회는 PR #109에서 소진했다. 이번에는 계획 자기 점검·표적 교정·필수 독립 병합 검토를 수행한다. 계획에서 자동 농장 초기화, 미래 schema의 구버전 복구, clock 이중 계산, 실패한 행동 재실행이 일어나지 않도록 구체화했다.
- baseline Python 9/9 PASS. 제품 코드·Scene·data·assets·저장·플러그인은 수정하지 않았다. 새 섬 및 배 나들이 MACHINE/RUNTIME/HUMAN/ART/RELEASE는 `NOT_RUN`; 현재 섬 runtime은 `NOT_IMPLEMENTED`다. 계획 내부 테스트 코드도 실제 테스트 PASS로 보고하지 않는다.

### 완료 기준과 증거 경로

문서 경로·GDD/계획/아트 연결·보존 구간·변경 범위를 대조하고 Python 검사·독립 검토·동일 작업 PR의 exact HEAD CI/정상 병합/main 재확인을 수행한다. 이번 PR의 최종 closeout이 병합 SHA·검사·기존 월간 PDF 누적 결과를 소유한다. 과거 두 전체 검토를 재시작하지 않는다. 새 실행/아트 후보는 아직 만들지 않았다.

<!-- MONTHLY_APPEND_ISLAND_P1_PLAN_20260920_BEGIN -->
### 2026-09-20 P1 상세 계획·배 나들이 방향 추가

실제 작업·기록일은 2026-09-20 KST다. 사용자의 후속 진행과 '나중에 배타고 바깥 구경' 지시를 기존 GDD/AGENTS/시각 inventory에 연결했다. 첫 섬을 우선하는 범위는 유지하고 배 나들이는 후속 방향으로 기록했다. Codex로 실제 source·기존 저장 복구 모듈·Godot 공식 문서를 확인하여 농사 상태, 섬 전용 저장, 시간·앱 복귀, 실패·재시도에 대한 파일/API/테스트/구현 순서 계획을 작성했다. 기존 12게임 조사 근거는 재사용했다. 제품 코드·새 이미지·모델·항해 기능은 만들지 않았으며 계획 속 테스트도 미실행이다. 새 섬/나들이 실행·사람 재미·최종 아트 검증은 미실행이다. 실제 입력 화면 캡처와 계정·모델·결제·협약 사실은 확인하지 않았다. 원본은 이 handoff/GDD/P1 계획과 동일 작업 PR의 검사·병합 closeout이다. 같은 월간 PDF에 요약을 누적한다.
<!-- MONTHLY_APPEND_ISLAND_P1_PLAN_20260920_END -->

## 이전 첫 섬 설계 작업 — 2026-09-20

이번 사용자는 앞서 제안한 대표 플레이/카메라/농사/저장 설계와 재사용 조사를 승인했다. 제품 구현·이미지 대량 제작은 이번 범위가 아니다. 새 정본 후보는 GDD `MLB-ISLAND-SLICE-01 / RESEARCHED_DESIGN_CANDIDATE`와 visual inventory IV01–IV07이며, 전체 게임 또는 최종 Blueprint 승인으로 읽지 않는다.

### 승인 범위·진행 순서

1. 최신 AGENTS→GDD 현재 방향/재미 기준→이 handoff→main/PR/실제 source→adapter→필요 Base를 읽었다. 작업 시작 main `140f9858219fe4acd73597a1fd31c2b1ca642796`; 전용 기존 worktree에서 `codex/island-first-play-design-20260920` 분리. 원래 checkout/continuation은 보호한다.
2. Base 원격 main은 `23ecad5a3084f97c4e5d1e39a9a6d70d1eeb37ef`로 기존 채택 #883/#885와 동일했다. concept/fun·benchmark evidence·system-design·experience-to-presentation의 필요한 원본을 읽었다. 역사적 v9.4.4 lock/설치 스킬/플러그인 변경 없음.
3. 12게임의 공식 제품 설명, 개발자 제작 글, 개별 긍정/부정/혼합 반응, Godot/접근성/저장 실무를 대조했다. GDD B01–B12/R01–R03/P01–P07이 출처·내용·한계를 소유한다. 게임 직접 플레이·전체 영상/실험·매출 검증은 하지 않았다.
4. C2 작은 3D 섬/I2 방향 이동과 명시적 행동/T2 한 주기 무벌점 오프라인 성장/S2 섬 저장 분리 **권장 후보**를 작성했다. 6칸/2작물/바구니, 화면 상태·취소/복귀·clock·저장 실패·자산 상태군·SWOT·P1–P4 순서를 같은 GDD에 연결했다.
5. 현재 문서 후보를 2회 공유 검토와 영향 검사로 닫고 동일 작업 PR/정상 병합/main 재확인으로 보관한다. 후보 보관은 새로운 게임 규칙/최종 아트 승인이나 구현 시작 권한이 아니다. 새 핵심 UX와 성장 규칙은 사용자 검토 후 실행 계획/필요 자산/Blueprint gate에 연결한다.

### 재사용 조사와 실제 사용처

main에서 project.godot, game_state, game_scene의 lifecycle, comfort_preferences, resting_soundscape, real_time_atmosphere_resolver, photo_memory_persistence, album_view, look-around controller를 읽었다. 현재 `GameState`는 voyage 시간/기억을 소유하므로 섬 성장 owner로 쓰지 않는다. atmosphere resolver 실제 경로는 `scripts/voyage/real_time_atmosphere_resolver.gd`다.

continuation `80ce184fa6a5571e7cefcb7ad53cdabef896a1cd`에서 recoverable_config_store 전문, comfort/음량 소비 경계와 관련 tests 목록/commit history를 읽었다. 저장 복구·음량 모듈의 **선별 재사용 후보만** 기록했으며 코드를 이전하거나 그 테스트를 이번 작업에서 실행하지 않았다. PR #19는 OPEN/head `1dc768485ece548c01589d9814851b862ac50e10` read-only. 60개 커밋 전체 병합 없음.

### 적용 판단·검증 기록

- 브레인스토밍 skill의 architectural 설계 경로를 사용한다. 이미 승인한 조사·권장안 작성에 단계별 재승인을 요구하지 않고, 새 gameplay 구현과 최종 아트는 보류한다. 기존 GDD/visual/handoff를 재사용해 별도 spec·ledger·일지를 늘리지 않는다. writing-plans 형식의 실행 코드 계획은 후보 검토 후 만들며 이번 순서표를 완성된 코드 계획으로 주장하지 않는다.
- baseline 및 후보 Python 9/9 PASS, `git diff --check` PASS. 상대 문서 링크 9개가 존재하며 GDD/visual의 보존 구간은 기준 main과 동일하다. 이번 source/Scene/assets/project.godot 변경은 없다. 새 섬 MACHINE/RUNTIME/HUMAN/ART/RELEASE는 NOT_RUN.
- 검토 1/2. main·Base·관련 PR·현재/과거 GDD 경계를 읽고 B/R/P 근거를 후보에 연결했다. 세 가지 이상 대안을 camera/time/input/storage마다 비교했다. source 재사용 조사에서 main의 foreground 제한과 continuation의 복구/음량 의존성을 찾아 그대로 이식하지 않는 판단을 반영했다. 시각 inventory에 남아 있던 과거 '확정 grammar'를 섬 승인으로 오인하지 않도록 현재/보존 구간을 명시했다. 긴 온라인 성장/물주기 의무화 대신 한 주기 상한·만료 없음·1회 credit·무경쟁 결과를 후보로 제한했다.
- source 표적 재확인에서 R01 게시일을 실제 원문 2019-12-16으로 교정했고, 게임 autoload 두 개와 설치 플러그인 autoload의 보존 범위를 명확하게 했다.
- 독립 전체 검토 2/2는 `140f985 → 6c1c4e4`의 4문서 전체와 관련 실제 source, adapter 경로, 주요 공식 원문을 read-only 대조했다. Critical/Important 0, Minor 1. GDD의 위치 검증을 '형식 손상'과 '보행 불가지만 유효한 위치'로 분리하고 후자는 Scene이 위치만 복원하도록 교정했으며 P2 검사에 유효 작물 보존을 추가했다. 이는 후보 명세 보완이며 실제 저장 구현 교정이 아니다. 추가 전체 검토를 초기화하지 않고 해당 문장/기존 상태·복구 경계와 9개 회귀를 확인한다.
- 독립 검토가 판정하지 않은 전체 12게임 재플레이, Blender 재실행, 섬 runtime/모바일 성능/아트/Human은 이번 PASS 범위에 포함하지 않는다. 같은 작업 [PR #109](https://github.com/alsdmlals4-eng/MylittleBoat/pull/109)의 closeout/Actions가 최종 HEAD CI·정상 병합·main 재확인과 PDF 누적 결과를 소유한다.

### 남은 결정·다음 작업

- 사용자 검토 묶음은 GDD C2/I2/T2/S2와 6칸/2작물/바구니 범위다. 숫자는 시험 초기값이며 밸런스 확정이 아니다.
- 후보가 승인되면 P1의 상세 실행 계획과 승인 자산 제작 경로를 구체화하고 P1→P2→P3→P4 순으로 연결한다. 섬 runtime은 여전히 NOT_IMPLEMENTED.
- 기존 세이브·승인 자산·원래 작업 폴더·PR #19·설치 도구는 보호. 새 장르 기능/온라인/비용/전역 변경 없음. 정리할 새 제작 자산도 없다.

<!-- MONTHLY_APPEND_ISLAND_DESIGN_20260920_BEGIN -->
### 2026-09-20 첫 섬 플레이 조사·설계 요약

실제 조사/기록일은 2026-09-20 KST다. Codex로 현재 main과 Base 선택 계약, 구형 구현의 실제 사용처를 대조하고 12게임의 공식 제품 설명·개별 반응·개발자 제작/엔진/접근성 자료를 조사했다. 기존 GDD에 첫 섬 대표 흐름, 세 가지 이상 대안 비교, 권장 카메라·농사·성장·저장/복귀 후보, SWOT 보완 행동, 구현 패키지와 재미 검증 질문을 추가했다. 기존 시각 inventory에 분리 자산·모션 상태군을 연결했다. 제품 코드·이미지·3D 모델은 만들지 않았고 최종 기획/아트 승인 및 섬 실행/사람 재미 검증은 미실행이다. 입력 화면 캡처는 없으며 계정·모델·비용/협약 사실은 검증하지 않았다. 이 요약은 기존 월간 PDF의 같은 파일에 누적하고 최종 검사/병합 상태는 이번 PR closeout에서 확인한다.
<!-- MONTHLY_APPEND_ISLAND_DESIGN_20260920_END -->

## 이전 운영 정비 기록 — 2026-09-20

현재 제품은 GDD `MLB-DIRECTION-20260916`의 작은 섬 농장·바다 휴식이다. 섬 runtime은 `NOT_IMPLEMENTED`, 구형 보트는 보존된 실행 코드다. 현재 운영 계약은 `docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json`, 재미 기준은 GDD `MLB-FUN-20260920`을 읽는다. 아래 과거 “현재 작업”/항해 완성 표기는 해당 receipt 시점이며 섬 구현 권한이나 최신 검증이 아니다.

### 승인 범위와 작업 순서

사용자 2026-09-20 승인 A+B+C 및 같은 날 재미 기준 추가를 재사용한다.

1. **B / 완료.** 명시 승인된 PR #107만 독립 검토→정확한 HEAD 검사→정상 squash 병합. head `89ea9582579efe10f33dd45a000ebae3efdc2fac`, main `01427e864bcc791a0e16f6c9185f25299a8c4808`. exact-head CI `34910038794`, postmerge main CI `35477256521` success. 코드/씬 복구 35파일 중 33개는 clean parent와 byte-equivalent Git blob, 두 테스트만 현 consumer 정합 교정. README/GDD 의미 교정은 다음 독립 PR 범위다.
2. **A / 문서·계약 검사 PASS.** 복구된 main에서 `codex/base-lean-fun-20260920` 분리. AGENTS의 5회 무한 검토/모든 수정 3대안/중복 규칙을 최신 선택 계약으로 교정하고 GDD·README·AI spec의 충돌/역할을 정리한다. 기획 내용·code/Scene/assets/save/plugin은 운영 변경으로 수정하지 않는다.
3. **#885 / 방법 연결·문서 검사 PASS.** 기존 GDD에 경험 가설→명세→consumer→MACHINE/RUNTIME/HUMAN→교정 경로를 추가한다. 농사 수치/최종 아트/카메라는 확정하지 않는다. 실제 새 섬 consumer는 PLANNED.
4. **C / PASS.** 독립 Blender portable CLI·Python→blend 저장/재열기→GLB→Godot 4.7.2 import/readback. 프로젝트에 모델을 넣거나 MCP/plugin을 설치하지 않았다.
5. **마감 경로.** 동일 작업 [PR #108](https://github.com/alsdmlals4-eng/MylittleBoat/pull/108)이 exact-head 검사·정상 병합·postmerge main readback의 기록을 소유한다. 정적 handoff를 반복 발행해 상태를 복제하지 않고 PR의 최종 closeout/Actions를 확인한다. 두 전체 검토는 소진했으며 이후는 표적 교정·필수 회귀만 수행한다. 월간 PDF는 아래 커밋된 요약을 같은 기존 파일에 누적한다.

**보호하는 다른 작업.** 기존 작업 폴더 `C:/Users/user/Documents/GitHub/MyLittleBoat`와 `codex/title-boat-flow-20260831@80ce184fa6a5571e7cefcb7ad53cdabef896a1cd`는 그대로 둔다. 이 브랜치의 60개 후속 커밋을 통합하지 않는다. PR #19는 read-only이며 README 변경 중첩만 인지하고 branch/PR을 수정·종료·병합하지 않는다. 다음 실행자는 현재 checkout 이름·main 차이를 먼저 확인한다.

### 선택한 Base와 판단 기록

- 2026-09-20 fetch 시 Base main은 `23ecad5a3084f97c4e5d1e39a9a6d70d1eeb37ef`. #883은 이미 병합됐고 #885도 포함됐다. 이 SHA는 이번 출처 기록이지 영구 최신 기준이 아니다. Base checkout의 local main/untracked worktrees는 변경하지 않았다.
- v9.4.4 payload/evidence/finalization lock은 historical adopted identity로 보존한다. 이번 operating-policy adoption과 module lock을 구분한다. 기존 branch에서 adapter 의미만 선별 이전하며 전체 branch를 병합하지 않는다.
- 비교. 전체 Base scaffold/skill 복사 `REJECT`(중복 owner·provider 변경 위험), 구형 5회/반복 승인 유지 `REJECT`(현재 승인과 충돌), 기존 owner+조건부 route+2회 공유 `ADAPT`(프로젝트 보호와 유지비 절감).
- 기존 AGENTS·adapter·Base 규칙·실제 consumer를 benchmark/reuse 근거로 사용했다. 새 게임 시장/재미 실험은 수행하지 않았다. 설치된 skill 전체를 수정/검사했다고 주장하지 않는다. 프로젝트 tracked SKILL.md가 없어 새 wrapper 대신 adapter 조건부 경로를 사용한다.
- 판단. 실행 스킬의 별도 ledger/계획 파일 권고는 최신 사용자 “기존 작업일지에 추가”와 이번 경량화 범위에 맞춰 이 기존 handoff가 대신한다. 동일 승인 완료보고/병합을 다시 승인 메뉴로 되묻지 않는다. 잘못 적용하면 추적 손실이 생기므로 이 절의 단계·검증·판단을 함께 유지한다.
- 판단. Base의 신규 설치용 adapter schema/필수 도구 설치는 비채택이다. 현재 project-local 경로 검사를 사용하며 Base 전체 운영 validator PASS로 보고하지 않는다.
- 판단. 보트 구현 receipt와 Human Blueprint reader profile 모두 보존하고 충돌 상태 값은 실제 구현 기준으로 통합한다. 함께한 시간은 이미 구현되어 `CONFIRMED_NOT_IMPLEMENTED` 주장을 교정하되 Human 검증은 계속 `NOT_RUN`이다.
- 발견/교정. baseline Python 5개 중 1개가 AI spec의 중복 editing-master 표기로 실패했다. 본문/고유 provenance는 보존하고 현재 owner 안내를 교정했다. Base module 두 개는 파일이 없는데 enabled였다. 설치 대신 deferred로 교정했다. 새 연결 검사는 잘못된 soundscape 경로를 잡았고 실제 autoload `scripts/audio/resting_soundscape.gd`로 수정했다.

### Blender 사용과 증거 경계

- 공식 portable `Blender 5.2.2 LTS`, build `d13f752e3b9c`. ZIP SHA-256 `3849d17a682cba006075aaa3f3597ecb5c9c30ec31035b2e092c53e40679b535`가 공식 체크섬과 일치한다.
- 실행 파일은 `C:/Users/user/Documents/Tools/Blender-5.2.2/blender-5.2.2-windows-x64/blender.exe`.
- 재실행은 `C:/Users/user/Documents/MyLittleBoat_도구검증/Blender_20260920/run_connection_test.ps1`. 증거/스크립트는 같은 폴더의 `EVIDENCE.md`와 로그가 소유한다. parent는 해당 파일과 해시를 readback한다.
- 격리 CLI에서 합성 큐브 생성·blend 재열기·GLB export, Godot PackedScene instantiate 후 MeshInstance3D 1개/24정점 확인. 최종 로그 오류/경고 0. 프로세스 환경 6개 sentinel 복원 PASS. Blender 잔류 프로세스 0.
- 이 결과는 기술 연결뿐이다. live Blender MCP, 게임 모델/리그, 아트/Human/재미/출시 PASS가 아니다. 설치 plugin·전역 설정·Godot 프로젝트 변경 없음.
- 사용 끝난 ZIP/backup/초기 실패 fixture는 `C:/Users/user/Documents/MyLittleBoat_삭제대기_20260920/BLENDER_20260920_MOVE_MANIFEST.md`에 원래 경로·해시·복원법과 함께 모았다. 직접 삭제하지 않았다.

### 검토와 검증 기록

전체 검토 1/2. 승인 범위 A+B+C+#885, 원래 checkout/main/열린 PR, Base 출처/채택 lock, 보호 consumer를 대조했다. 실제 읽은 owner는 AGENTS/GDD/handoff/visual inventory/project.godot/game_state/game_scene/기존 Python 검사/adapter/reuse manifest/Base 선택 계약이다. 복구 #107 독립 검토는 MUST_FIX 0이며 README/GDD·Human·섬 적합성·기존 고아 자산 삭제는 이 복구의 범위 밖이라는 판단을 유지한다. 코드 복구 검사는 원격 exact-head와 main에 묶고 정책 후보의 검사는 따로 기록한다. 새 정책 연결 RED에서 누락 owner·허위 enabled 두 건을 확인했고 수정 후 다시 검사한다. 장기 적합성은 새 시스템 설치보다 기존 owner 연결이 낫다는 비교다.

전체 검토 2/2 + 독립 검토. `01427e8 → c0c44aa`의 12개 파일 전체, Base 선택 7원본, 실제 게임 consumer, 9개 Python 검사, source-delta, 외부 Blender 해시/로그를 독립 검토했다. Important 1건은 GDD의 전체 foreground pause 과장이다. 실제 `game_scene.gd::_process/set_application_foreground`와 `DriftSceneryDirector.advance`를 대조해 함께한 시간/명소 예약만 제한한다고 두 곳을 교정했다. `python -B -m unittest discover -s tests -p 'test_*.py' -q` 9/9 PASS와 직접 source/readback을 수행했다. 이는 문서 의미 교정이며 검사 통과만으로 agent 준수/게임 재미를 검증했다는 뜻이 아니다.

독립 검토 Minor 1건은 기존 이미지 후보 한 개와 사용자 판단 대기 경계의 누락이다. 이는 보호 계약 보존에 영향을 주므로 표적 교정 대상으로 재판정해 AGENTS 한 문장을 복원했다. 새 정책/자산은 만들지 않았다. 후보 c0c44aa의 두 원격 검사 `35477642919`(Godot)와 `35477642985`(project-policy)는 PASS였다. 최종 수정 HEAD는 별도 CI를 다시 확인하고 병합한다. 최종 SHA·검사·main readback은 PR #108 closeout을 따른다.

독립 검토가 판정하지 않은 runtime/Human/기기/아트/출시를 새 PASS로 승격하지 않는 판단을 유지한다. 월간 PDF는 실제 갱신 이후에만 발행 완료로 보고한다. 추가 전체 검토는 수행하지 않는다. 남은 deferred minor는 없다. 운영 변경의 source/scene/asset/plugin/save diff는 0, PR #19 head `1dc768485ece548c01589d9814851b862ac50e10`은 OPEN 그대로다. Base main 재조회도 동일 `23ecad5`였다.

### 후속 실행 위치와 복구

- 최신 운영 정본은 PR #108 병합 main이다. 이번 전용 checkout은 `C:/Users/user/.codex/worktrees/boat-base-lean-20260920/MyLittleBoat`이며 종료 시 원격 main과 일치시킨다.
- 원래 checkout은 60개 미통합 후속 커밋 보호를 위해 이동/덮어쓰지 않았다. 따라서 원래 폴더가 최신 main과 같다고 보고하지 않는다. 다음 작업은 최신 main에서 시작해 legacy branch의 필요한 수정만 별도 승인 범위로 비교한다.
- rollback은 운영 PR만 revert하며 #107 복구·구형 branch·승인 자산을 함께 되돌리지 않는다.
- Python 초기 실행 cache 2개 12,928 bytes는 같은 외부 삭제대기 폴더 `POLICY_CACHE_복원안내.md`에 해시/복원법과 함께 이동했다. 직접 삭제하지 않았다.
- 월간 발행기는 보존된 continuation `80ce184`의 `tools/build_ai_work_evidence_pdf.py::append_summary`를 재사용하고 실행 시 ROOT만 이 검증 checkout으로 지정한다. 이를 main에 설치된 도구라고 안내하지 않는다. source receipt는 커밋된 handoff와 과거 source SHA를 별도로 검증한다.

### 남은 제품 작업

- 섬 농사·바다 휴식의 대표 구간, 이동/카메라 대안, 입력·상태·성장/저장 계약을 조사해 bounded 구현안으로 구체화한다.
- 승인된 방향에 맞는 실제 사용 자산·모션·필요 상태군을 준비한다. Blender 연결 PASS를 모델 준비로 세지 않는다.
- 승인된 Slice에서 규칙·표현·실패/복귀·기계/실행 검증을 연결한다. Human 검증은 사용자 선언 전 NOT_RUN.
- 과거 continuation branch와 main의 전체 제품 통합 여부는 별도 범위다. 이번 운영 PR이 게임 전체 최신 구현 동기화는 아니다.

<!-- MONTHLY_APPEND_20260920_BEGIN -->
### 2026-09-20 AI 활용 작업 요약

실제 작업일/기록일은 2026-09-20 KST다. Codex 작업에서 프로젝트·최신 Base #883/#885를 대조해 운영 지침을 경량화하고 재미/표현 검증을 기존 GDD에 연결했다. 명시 승인 PR #107 복구는 main 병합과 원격 Godot 검사까지 확인했다. 운영·재미 기준의 코드/문서 변경은 PR #108에 연결했다. 로컬 문서/경로 검사 9개와 후보 원격 정책/Godot 검사가 통과했고 독립 검토의 foreground 과장 및 후보 제작 경계를 교정했다. 최종 HEAD의 검사·병합과 main 재확인 증거는 PR #108의 closeout/Actions를 참조한다. 별도 portable Blender의 CLI/Python 저장·재열기·GLB와 Godot import 왕복도 검증했다. 계정·모델·비용 인정/협약은 검증하지 않았고, 실제 입력 화면 캡처는 이 기록에 없으므로 누락으로 남긴다. 게임 아트나 새 섬 runtime은 만들지 않았으며 사람 재미 검증도 미실행이다. 원본은 이 handoff·GDD·adapter·Git PR/Actions·로컬 Blender EVIDENCE다. 기존 월간 PDF에 누적하며 새 권/버전은 만들지 않는다.
<!-- MONTHLY_APPEND_20260920_END -->

## 보존된 과거 구현 기록


**프로젝트:** `MY_LITTLE_BOAT`
**역할:** 실제 코드·Scene·test·runtime evidence와 현재 제품 정본의 차이를 기록하는 기술 router
**현재 사람용 정본:** [프로젝트 GDD](../design/PROJECT_GDD.md)
**현재 작업:** 2026-08-31 catch·조용한 무수확·취소를 구분하는 낚시와 동반자/난간의 짧은 휴식 반응, 그 GPU capture, 그리고 user-approved alternate chibi visual family의 canonical runtime 연결을 완료한 상태. 기존 사용자 승인 후면 3/4 normal foreground, local motion comfort, actual voyage postcard와 fish/completed-voyage local ledger, 여섯 승인 자연 명소와 saved floral cushion/main-postcard-omission evidence는 유지한다.

## 0. 2026-08-30 현재 runtime receipt

아래 표가 현재 runtime truth다. 이후의 `Issue #99`/`Phase 2` 절은 구현 전 기록이므로 historical context로만 읽고, 이 receipt를 덮어쓰지 않는다.

| 주제 | 현재 구현 | 검증 상태 |
| --- | --- | --- |
| 시작 경로 | `project.godot`이 `res://scenes/game.tscn`으로 곧바로 진입한다. 첫 프레임은 승인된 보트·동반자·바다 장면과 compact `쉬는 메뉴`만 보인다. | direct-entry contract `PASS`, headless game smoke `PASS`, 540×960 runtime capture `PASS` |
| 기분과 저장 시간대 | `GameState`에서 `selected_mood`와 saved time selector를 제거했다. 항해 기록은 `오늘의 항해`로 중립화했다. | state/album contracts `PASS` |
| 현지 시간대 | `RealTimeAtmosphereResolver`가 `05–08=dawn`, `09–16=bright`, `17–20=sunset`, `21–04=night`를 visual-only로 결정한다. 30초 갱신과 focus/resume 갱신이 있다. | injected-hour contract `PASS`, 네 시간대·두 카메라 capture `PASS` |
| 승인 풍경 asset | `MLB-BOAT-FLT-001/002/003/004`는 water-only normal·Appreciation `SeaBackdrop`의 current base texture이고, `MLB-BOAT-FLT-005`는 `BoatWaterContact`다. `MLB-AMB-MOTIF-001..006`은 active foreground 자연 명소의 temporary normal·Appreciation consumer다. 이전 `MLB-BP-VIS-001/002/003/004/005`는 historical Blueprint/reference asset으로 보존하되, 현재 passive Director consumer에서는 superseded다. `006`은 Human Blueprint flow-map으로 runtime 미소비다. | image/runtime asset contracts `PASS`; `2026-08-30-water-only-atmosphere-v2` GPU 8장과 `2026-08-30-ambient-motifs` GPU 6장 captured |
| 저밀도 풍경 | `DriftSceneryDirector`는 foreground delta만 누적해 첫 **기회**를 90–150초에 예약하고, 기회마다 65% 확률로 현재 local-time의 `MLB-AMB-MOTIF-001..006` 중 하나를 표시한다. 표시 여부와 무관하게 이후 기회는 120–180초 뒤에 다시 예약된다. bright·sunset은 즉시 같은 motif를 반복하지 않는다. `GameScene`은 chosen exact texture와 per-motif `backdrop_offset_x`를 normal·Appreciation `SeaBackdrop`에 10초간 적용한 뒤 현재 base atmosphere로 복귀한다. Look Around art는 건드리지 않는다. 버튼·목적지·만료·보상 track은 없고, `save_memory=true`만 `GameState.record_ambient_memory`를 거쳐 `user://ambient_memory_v1.cfg`에 즉시 저장한다. 0회 항해는 정상이며 UI에 확률·대기 시간·missed state는 없다. | director/scene + ambient persistence/state/game-scene + motif asset contracts `PASS`; six 540×960 OpenGL captures `PASS`; Human long-run observation `NOT_RUN` |
| 꾸미기 consumer | `DecorPanel`이 player/pet local selector와 boat decor controls를 제공하고, `DecorPreview`의 독립 `BoatSpace` instance가 그 state를 즉시 표시한다. 기본 C+강아지 final composite에서는 저장된 `pet_corner=pet_cushion, appearance=floral`만 bow-side overlay로 소비한다. 기존 save ID의 alternate A/B player, cat/rabbit/otter, `stripe`·`moon`은 user-approved canonical chibi paths로 layered card/decor texture에 연결된다. `rail_accent=postcard`는 main rest composite에 합성하지 않고 independent preview의 actual rail face로만 소비하며, 실제 voyage photo postcard는 Album에서 본다. 숨김 상태에서는 SubViewport 3D, render target, camera, preview BoatSpace를 모두 비활성화하고, 열 때만 함께 활성화한다. | identity/runtime-image/capture-guard/final-composite/decor-preview contracts `PASS`; alternate 540×960 GPU capture inspected; Human readability `NOT_RUN` |
| 함께한 시간 consumer | `GameScene`은 foreground active-voyage delta만 `GameState.together_time_seconds`에 더하고, `TogetherTimePersistence`가 `user://together_time_v1.cfg`에 local-only로 저장한다. `AlbumView`만 duration·관계 문구를 표시한다. | persistence/state/game-scene/Album contracts `PASS`, 540×960 Album GPU capture inspected; Human readability `NOT_RUN` |
| 모션 편안함 | `ComfortPreferences`가 `user://comfort_preferences_v1.cfg`의 normalized `standard/gentle/still`만 저장한다. `GameScene`은 기존 drift phase·속도·항해 시간·함께한 시간·수면 시간대를 바꾸지 않고, 카메라 y bob·BoatSpace y bob/roll·BoatWaterContact breath/offset 진폭만 각각 `1.0 / 0.5 / 0.0`으로 곱한다. | comfort preference/state/game-scene contracts `PASS`, standard·gentle·still bright GPU capture `PASS`; Human motion comfort `NOT_RUN` |
| 항해 포스트카드 | `PhotoMemoryPersistence`가 `user://voyage_postcards_v1.cfg`와 local PNG directory를 함께 소유한다. `GameScene._capture_voyage_postcard()`는 public `TakePhotoButton` 흐름에서 selection UI만 잠시 숨기고 post-draw `ViewportTexture.get_image()`를 저장한 뒤 가시성을 원상 복구한다. `AlbumView`는 유효 PNG만 newest-first 세 장으로 표시하며 score/reward/share를 만들지 않는다. | persistence/state/game-scene/Album contracts와 isolated bright/Album GPU capture `PASS`; Human readability `NOT_RUN` |
| 물고기와 완료 항해 기록 | `MemoryLedgerPersistence`가 `user://memory_ledger_v1.cfg`의 `fish`와 `voyage_records` string 목록만 즉시 local save·restore한다. `GameState.add_fish()`와 post-zero `complete_voyage()`가 각각 저장하고, Album은 복원된 최신 항목을 요약·recent memory로 소비한다. delayed bottle letter는 읽거나 쓰지 않는다. | persistence/state/Album contracts `PASS`; restored Album 540×960 OpenGL capture `PASS`; Human readability `NOT_RUN` |
| 조용한 낚시와 작은 상호작용 | `CalmFishingSession`은 catch·quiet no-catch·cancel을 별도 state로 처리한다. catch만 기존 `GameState.add_fish()`를 호출하며, quiet/cancel은 저장·점수·연속 보상·손해 없이 action label을 reset한다. 동반자 `나란히 쉬기`는 existing `rest` pose와 private `moment_id`를, 난간 `파도 소리 듣기`는 text-only `moment_id`를 반환한다. | focused fishing/interaction contracts `PASS`; game-scene OpenGL contract `PASS`; quiet-fishing·pet-rest 540×960 OpenGL captures `PASS`; Human readability `NOT_RUN` |
| 부유 보트와 기본 normal foreground | 보트가 없는 backdrop 위에 primary `BoatSpace` 한 개와 `BoatWaterContact` ripple을 표시한다. 보트는 0.052 unit 상하 bob과 최대 1.15° roll을 갖는다. 기본 C+강아지 route의 `FinalDioramaCard`는 `chibi-normal-rear-chroma-key.png`와 `chibi_normal_chroma_key.gdshader`의 explicit `matte_texture` uniform을 소비해, 녹색 기술 배경만 alpha 처리한 stern-side chibi player·dog·boat foreground를 표시한다. player는 stern rail에 기대어 뒷모습으로, dog는 옆에서 함께 보인다. `DioramaCameraRig`만 보트 뒤쪽 위로 옮겼고 Look Around·Appreciation rig는 보존했다. card `pixel_size`는 `0.0037`이며, time backdrop·water contact·bob과 분리된다. 숨긴 `DecorPreview`의 renderer, camera, BoatSpace도 함께 비활성화해 미리보기의 `CylinderMesh`가 normal capture 경로에 새지 않게 했다. | rear-normal/material/final-card/direct-entry/diorama/decor contracts `PASS`; bright·night 540×960 GPU capture visual inspection `PASS` |
| Look Around | `LookAroundCameraRig/LookAroundCamera3D`, `LookAroundButton`, `LookAroundCameraController`, local `_look_around_mode`와 explicit three-camera routing을 사용한다. active `InputEventScreenDrag`/PC drag만 yaw `±135°`, pitch `-16°..38°`, zero roll로 처리한다. Appreciation·decor·Album은 Look Around를 종료하며, gameplay state를 바꾸지 않는다. `LookAroundPresentationRouter`는 승인된 `MLB-LOOK-CHIBI-TRN-001..004` exact texture를 `port`·`starboard`·`aft`·`overhead`에 연결한다. non-front에서는 중복 normal card만 숨기고 primary `BoatSpace`와 `BoatWaterContact` state·motion은 유지한다. | router/input/game-scene/runtime-asset-guard contracts `PASS`; `2026-08-30-look-around-chibi-transparent` normal·네 각도·Appreciation 540×960 GPU capture `PASS`; Human motion comfort, touch reachability, long-run calm `NOT_RUN` |

이전 direct-entry 보강은 Godot `4.7.1.stable.official.a13da4feb`에서 `tests/test_*.gd` 36/36 `PASS`를 기록했다. 현재 설치된 Godot `4.7.2.stable.official.ed1daf0bf`에서 natural-motif, main-postcard-omission, fish/completed-voyage ledger, quiet-action, alternate chibi canonical rebind 뒤 focused 계약을 다시 실행했다. `tests/capture_approved_alternate_chibi_family.gd`는 NVIDIA RTX 3050 OpenGL 3.3에서 A+cat+stripe, B+rabbit+moon, A+otter+stripe의 540×960 frame을 기록했다. `RestingSoundscape`는 headless에서 출력 없는 generated audio를 시작하지 않고, real-display lifecycle에서는 stop·stream release를 수행한다. Human/device visual and audio comfort는 `NOT_RUN`이다.

### 2026-08-31 machine-verification addendum

- Godot `4.7.2.stable.official.ed1daf0bf`에서 현재 `tests/test_*.gd` 51/51을 headless 경고 없이 실행했다. 이 경로에서는 `ViewportTexture`를 읽을 수 없으므로, 포스트카드 저장 assertion만 명시적으로 `SKIP`하고 나머지 게임 계약은 실행한다.
- 동일한 포스트카드 저장 assertion은 NVIDIA RTX 3050 OpenGL 3.3에서 `test_game_scene_contract.gd`로 실제 수행했다. 독립 GPU 프로세스 종료 전에 `RestingSoundscape`의 generated audio stream을 stop·release하고 네 프레임을 기다리도록 검사 teardown을 정리했으며, 5회 중 5회 모두 ObjectDB/resource leak 경고 없이 `PASS`했다.
- `test_chibi_normal_chroma_material_proof.gd`도 같은 OpenGL 환경에서 `PASS`했다. 이 결과는 machine/runtime contract 경계이며, 실제 기기 종료 동작과 Human audio comfort는 여전히 `NOT_RUN`이다.

**Human evidence ceiling:** 실제 기기의 첫 30초·5분 휴식감, 터치 target, 모션 민감성, 텍스트 가독성, 사운드 편안함은 `NOT_RUN`이다. 기계 계약과 capture가 이를 대체하지 않는다.

## 1. 먼저 읽을 것

1. `AGENTS.md`
2. `docs/design/PROJECT_GDD.md`
3. 이 handoff
4. `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`
5. 실제 Scene, GDScript, 테스트, capture

이 repository는 Notion을 현재 정본으로 사용하지 않습니다. 이전 Notion은 historical discovery archive이며, active implementation 판단은 repository source와 runtime evidence를 우선합니다.

## 2. 현재 제품 방향과 runtime gap

| 주제 | 현재 제품 정본 | 현재 main code | disposition |
| --- | --- | --- | --- |
| 시작 | 실행 즉시 normal 3/4 boat diorama | `scenes/main_menu.tscn`의 선택형 panel 뒤 `game.tscn` 진입 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 오늘의 마음 | 제품에서 제거 | `selected_mood`, mood button, mood tone, record wording, 관련 test가 존재 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 꾸미기 entry | 바다를 본 뒤 optional `꾸미기` | identity/pet/time 선택이 menu에 있고 decor는 game panel에 존재 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 시간 기반 분위기 | 기기의 현지 현실 시간이 자동 적용, selector·saved preference 없음 | process-lifetime selection만 존재하고 menu OptionButton이 소비 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 흘러가는 풍경 | active foreground 시간에만 low-density distant scenery와 durable ambient memory | `GameScene` foreground director → `GameState.record_ambient_memory` → `ambient_memory_v1.cfg` | `IMPLEMENTED / MACHINE_VERIFIED`; Human long-run observation `NOT_RUN` |
| 함께 보낸 시간 | active foreground voyage time만 Album에 조용히 표시 | `GameScene` foreground delta → `GameState` local total → `AlbumView` duration/relation copy | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| Ambient Discovery | low-density passive presentation + 작은 알림 + local auto-save | `DriftSceneryDirector` + non-interactive label + named local persistence owner | `IMPLEMENTED / MACHINE_VERIFIED`; Human long-run observation `NOT_RUN` |

현재 code가 존재한다는 사실은 해당 제품 방향이 여전히 승인되었다는 뜻이 아닙니다. 반대로 GDD 결정은 code/test/capture가 바뀌기 전까지 runtime PASS를 뜻하지 않습니다.

## 3. Issue #99의 구현 금지선

이 문서 정본화 PR에서는 아래 runtime owner를 수정하지 않습니다.

```text
scenes/main_menu.tscn
scripts/ui/main_menu.gd
scripts/core/game_state.gd
scripts/voyage/game_scene.gd
tests/test_calm_voyage_state.gd
tests/test_game_scene_contract.gd
tests/test_game_scene_time_of_day_contract.gd
tests/test_main_menu_identity_contract.gd
tests/test_main_menu_time_of_day_contract.gd
tests/test_main_menu_atmosphere_background_contract.gd
tests/capture_main_menu_atmospheres.gd
assets/
```

PR #19 `feat/social-fake-backend-20260824`도 `READ_ONLY_NO_ABSORPTION`입니다.

## 4. 다음 Phase 2 implementation contract

다음 구현은 위 gap을 따로 쪼개서 부분적으로 고치지 않습니다. 아래를 한 contract로 묶어 설계·테스트·runtime capture·Human validation까지 검증합니다.

1. `project.godot`의 startup route가 새 local state에서 곧바로 normal boat diorama를 연다.
2. `GameState`가 mood를 retire하고, 현지 현실 시간을 순수 visual atmosphere로 resolve한다. selector·saved atmosphere를 만들지 않는다.
3. active foreground 시간만 쓰는 drifting scenery director가 distant scenery와 low-density ambient memory를 관리한다.
4. player appearance, pet species, boat decor가 in-voyage optional `꾸미기`에서만 접근 가능하다.
5. mood-facing UI, wording, color rule, test/capture dependency가 제거되거나 direct-entry contract로 대체된다.
6. 540 x 960 capture에서 boat-water contact, bob/wave/wake/reflection, avatar/pet/boat/sea/horizon hierarchy가 검증된다.
7. direct entry, local-time mapping, foreground-only scenery progress, no-mood migration, customization entry, camera parity를 test한다.
8. 사람의 첫 30초와 5분 휴식, mobile touch, sound comfort를 별도 Human evidence로 기록한다.

Godot 구현 가능성의 근거는 다음 공식 안정판 문서에 있다. Autoload는 Scene 사이 state를, `ConfigFile`과 `user://`는 local persistence를, SceneTree route는 main scene transition을 지원한다. 구현 세부와 error handling은 해당 Phase 2 contract에서 source/test를 읽고 결정한다.

- https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
- https://docs.godotengine.org/en/stable/classes/class_configfile.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html

## 5. 시각 consumer와 evidence ceiling

- `VIS-ENTRY-001`은 구형 main-entry full composition입니다. 보트가 물에 뜬다는 물리적 관계가 약하고 large selection panel이 sea-first first impression을 가리므로 `REJECTED_FOR_MAIN_ENTRY_RUNTIME_USE`입니다.
- `MLB-LOOK-CHIBI-NORMAL-REAR-001`의 opaque rear 3/4 source는 2026-08-30 사용자 승인 뒤 repository canonical path에 등록됐다. 이 source의 sky/water를 기술용 green matte로 분리한 `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`은 user-approved derived runtime asset이며, `BoatSpace/FinalDioramaCard`의 `ShaderMaterial_chibi_normal_chroma`와 explicit `matte_texture` uniform에 연결됐다. `ALPHA` chroma key는 technical green background만 투명하게 만들어 time backdrop·bob·water contact를 보존한다. stern-side rig, GPU material proof와 bright/night capture는 `ASSET_READY → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`까지의 증거이며 Human/device comfort는 아니다. 기존 `MLB-LOOK-CHIBI-NORMAL-001`과 matte는 provenance만 유지하는 superseded default-normal asset이다.
- 현재 `main_menu` atmosphere background와 legacy C+dog diorama binary는 여전히 legacy menu surface에서 소비될 수 있다. 기본 game entry는 새 치비 normal consumer를 사용한다. user-approved saved `postcard`와 `pet_cushion=floral`은 새 chibi decor assets로 정본 등록·runtime 연결됐고, surface가 player/dog focal zone을 가리지 않는 540×960 GPU capture가 있다. user-approved alternate A/B identity, cat/rabbit/otter, `stripe`·`moon` decor variant도 non-destructive canonical copies로 current runtime family에 연결됐으며 saved IDs는 보존한다.
- `HANDPAINTED_STORYBOOK_3D_DIORAMA`, `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`, `INDIGO_RAIN_REFLECTION`은 `APPROVED_DIRECTION`입니다. generated exploration, source binary, runtime capture, Human approval은 서로 다른 evidence입니다.
- real-device touch, five-minute calm, visual fatigue, audio comfort는 모두 `NOT_RUN`입니다. direct-entry와 Album runtime capture는 존재하지만 Human/device evidence가 아닙니다.

## 6. Issue #99 적대적 검토 receipt

| Loop | 공격 질문 | finding | correction owner | 상태 |
| --- | --- | --- | --- | --- |
| 1 | 사용자 승인, human GDD, current code가 mood/start flow에서 충돌하는가 | 기존 docs가 mood selector를 current product로 설명 | GDD, README, Concept, Experience Bible, handoff, visual inventory | `CORRECTED` |
| 2 | 사람이 시스템의 행동·이유·피드백·압박 회피를 이해하는가 | 이전 master GDD가 AI/evidence 구조를 앞세움 | `PROJECT_GDD.md` | `CORRECTED` |
| 3 | 직접 시작·local persistence가 Godot 4.7 구조에서 가능한가 | 구현 가능성 근거가 사람용 문서에 없음 | GDD와 이 handoff의 official stable links | `CORRECTED` |
| 4 | 구형 composition rejection이 source binary 전체 폐기로 과장되는가 | old visual inventory가 menu asset을 current product approval으로 표현 | visual inventory | `CORRECTED` |
| 5 | 문서가 runtime/Human PASS, social 확대, asset batch를 암시하는가 | source/status 문구의 overclaim 위험 | GDD/handoff evidence ceiling | `CORRECTED` |
| clean recheck | 문서 owner·stale allowlist·GDD 구조·PDF text/visual·staged diff를 correction 뒤 다시 실행 | material conflict 없음 | 이 handoff | `CLEAN` |

이 clean recheck는 8-section GDD, 7-page PDF text/visual readback, active-current stale allowlist, staged diff scope까지 확인한 상태입니다. PR exact-head readback은 push 뒤 다시 기록합니다.

발견한 정본 충돌의 Incident / Solution / Lesson과 Base 승격 판정은 [2026-08-28 direct boat entry 정본 충돌 기록](../learning/2026-08-28-direct-boat-entry-canon-reconciliation.md)에 남깁니다.
