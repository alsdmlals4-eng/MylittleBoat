# 제품 개선 루프 — 바다의 사진을 다시 꺼내 보는 기억으로

## 문제와 실행 전 계획

기준 HEAD dc6570983ed3a834cc91e2a6df91606ada6c0bbf. 사용자는 반복 검사가 아니라 유사 장르 조사→기획 구체화→연결→실제 구현을 요청했다. 현재 GDD B5/P4는 최근 세 장 이후 요청 시 탐색을 기획했지만 실제 album_view는 최신 세 장만 읽었다. 계획을 먼저 대화로 제시했고 사용자 승인 범위의 기존 기능 연결로 진행했다. 3장씩 이전/최근 탐색, 원본 불변, 누락 안내, 같은 바다 복귀가 범위다. 자유 회전용 모델·아트 lock은 별도다.

## 벤치마크와 ADOPT / ADAPT / REJECT

2026-09-13 개발사/배급사 공식 소개를 직접 읽었다. 게임 바이너리를 분석하거나 해당 게임을 플레이한 결과가 아니며 내부 엔진/자산을 역추출하지 않았다.

| 사례와 확인한 내용 | 우리 게임에 연결할 것 | 제외할 것 |
|---|---|---|
| [Tiny Glade 공식 소개](https://store.steampowered.com/app/2198150/Tiny_Glade/) — 목표·관리·실패 없이 만드는 작은 공간 | ADAPT. 할 일을 추가하지 않고 이미 머문 공간을 돌아보는 선택권 | 건축 시스템·재료·양적 콘텐츠 확장 |
| [Lushfoil 배급사 소개](https://annapurnainteractive.com/games/lushfoil-photography-sim) — 풍경 탐색과 실제 게임 내 카메라 | ADAPT. 직접 본 풍경 사진을 개인 앨범에서 다시 보기 | 촬영 목표·해금·전문 촬영 설정을 그대로 이식 |
| [Virtual Cottage 개발사 소개](https://store.steampowered.com/app/1369320/Virtual_Cottage/) — 현지 시간 조명·분위기, 활동 목표와 타이머 | ADOPT 기존 현지 시각의 분위기만 유지. REJECT 목표/타이머의 의무화 | 집중 과제·중단할 수 없는 타이머를 휴식에 적용 |

사진을 기억으로 연결하면 휴식의 지속 가치를 높일 수 있다는 것은 우리 설계 가설이며 Human 검증은 아니다. 이미지·매출·인기·치료 효과를 근거 없이 인과로 주장하지 않는다.

| 구현 대안 | 판정 | 판단 이유 |
|---|---|---|
| 모든 사진을 한 번에 펼침 | REJECT | 원본 수에 따라 로딩과 메모리가 늘고 기존 저밀도 화면을 압박 |
| 3장 단위 이전/최근 페이지 | ADAPT / FEASIBLE | 기존 카드 consumer 재사용, 한 페이지의 파일만 읽음, 새 저장 키 없음 |
| 무한 스크롤+가상화/썸네일 캐시 | TEST 후속 | 많은 기록에서 가치가 있지만 현재 paging 해결보다 캐시 무효화·파일 owner 비용 큼 |

[Godot Containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html), [Image 로딩](https://docs.godotengine.org/en/stable/classes/class_image.html)을 fresh-read했다. 스크롤 구조와 Image→ImageTexture 소비처를 사용하며 별도 라이브러리는 없다.

## 구체화한 데이터·입력·복귀 계약

- Album open → 최신 3장. 이전 사진 → 다음 오래된 묶음. 최근 사진 → 최근 방향 묶음. 범위 밖 이동은 clamp, 항해/보상 변화 0.
- page는 transient, 새로 열면 최신부터. 저장 ID·이미지 경로·label·atmosphere schema는 유지한다.
- 없는 이미지의 유효한 메타데이터는 load/save에서 보존한다. 빈 필수 필드 등 기존 invalid 정리는 유지한다. 누락 이미지를 복구한 것이 아니며 이전 버전이 이미 지운 메타데이터를 재생성하지 않는다.
- 새 ID는 실제 파일뿐 아니라 기록의 ID와도 충돌하지 않아야 한다. 누락된 사진의 경로를 새 사진으로 바꾸지 않는다.
- 전체 사진 비율을 보존한다. 저장 PNG 가공/재저장은 없다. 확대 상세 보기·고해상도 썸네일 캐시는 이번에 만들지 않았다.
- 앨범 내용만 스크롤, Back은 고정. 기존 overlay가 같은 game 인스턴스·물 위상을 유지한다.
- rollback은 이 연결 commit revert. migration 없이 저장 schema v1 유지. revert된 이전 loader는 누락 기록을 다시 필터링할 수 있으므로 그 정책 회귀는 주의한다.

## 실제 발견→교정→재검증

1. 최근 3장 외 접근 실패를 신규 테스트로 재현(RED 1). paging 구현 후 GREEN.
2. reviewer가 누락 PNG를 persistence가 걸러 다음 save에서 기록까지 빠지는 실제 경로를 발견했다. 파일 없는 config→reload→새 사진 저장 및 ID 재사용 금지를 RED 3으로 재현하고 보존 정책으로 교정했다.
3. 첫 화면 검사에서 작은 물리 창과 논리 viewport를 혼동한 assertion을 발견했다. 논리 해상도를 실제 540×960/360×640으로 설정하고 visible rect와 대조하는 검사로 교정했다. 따라서 초기 실패만으로 기존 작은 화면 잘림을 확정하지 않는다. 최종 스크롤/고정 Back은 두 논리 해상도에서 확인했다.
4. 마지막 한 장이 가로로 늘어나 보트가 crop되는 것을 실제 캡처로 확인했다. 전체 비율 보존 RED→GREEN으로 바꿨다.
5. Scroll 이동으로 깨진 capture consumer 4개의 경로를 찾았다. 고유 이름 조회로 교정했다. 과거 고정 evidence를 덮는 legacy capture 전체 실행은 하지 않고 최신 GPU 통합에서 같은 실제 노드를 검증한다.

## 검증과 증거 범위

전체 Godot headless 60개 실패 0, Python 20개 통과, Base v9.4.4 compatibility check 통과. `test_voyage_overlay_continuity.gd` GPU 실행 실패 0. 실제 게임 사진 네 장을 격리 저장하고 이전 버튼의 실제 마우스 입력, 페이지, 위상 동결·복귀, 540×960/360×640 Back 포함을 확인했다. `verified-runtime`의 PNG는 실제 실행 캡처이며 사용자 개인 사진이 아니다. 테스트 당시 야간 화면을 짧게 연속 촬영했으므로 사진이 비슷한 것은 fixture 특성이며 새 콘텐츠 다양성 증거가 아니다.

Human/실제 모바일 터치·메모리 성능 프로파일/출시/원본 복구는 NOT_RUN. 손상 PNG는 로더 오류를 낼 수 있으며 이번 신규 증거는 파일 누락 분리까지다. 카메라 이동 코드는 이번 변경하지 않았다.

최종 node 참조 교정 후 album memory/composition/photo persistence를 다시 실행해 통과했다. legacy capture 4개는 `--check-only`로 모두 파싱 통과했으며 과거 증거를 덮는 실행은 하지 않았다. 중간 캡처 12파일 5,158,245 bytes는 `C:/Users/user/Desktop/MyLittleBoat_삭제대기_20260913/album-history`로 이동하고 원래 경로 부재·이동 전후 SHA를 검증했다. `이동목록.json`이 이동 사유/원래 경로/용량/hash를 소유한다. 직접 삭제하지 않았으며 현재 verified-runtime은 저장소에 유지한다.

## 다음 제품 개선과 SWOT 환류

## 독립 적대적 검토 5회 영수증

기준 dc6570983ed3a834cc91e2a6df91606ada6c0bbf의 최종 교정 소스 상태로 새 5회를 계산했다. 이전 결함 상태는 횟수에서 제외한다. 각 회차 AGENTS/README/GDD/handoff/adapter, 생산 3파일, GameState/game_scene 소비처, 변경 테스트 4개와 legacy capture 4개를 전체 재독하고 hash/diff/status/미변경 소비처를 대조했다. reviewer는 읽기 전용이며 root의 Godot 실행을 중복하지 않았다.

| KST 회차 | 추가 확인·실행 | finding·교정·회귀·대안 판정 |
|---|---|---|
| 1 00:42:05 | 고유 이름 경로·전체 변경·승인 범위 | 신규 MUST_FIX 0. 실제 기획 연결과 테스트 반복 구분, scope 일치 |
| 2 00:42:21 | missing→load→save→reload, ID 예약·clamp·카드 해제, 공식 자료 | 신규 0. 누락 보존 교정 타당, 전체 원본 로딩보다 페이지 적합 |
| 3 00:42:36 | GPU 테스트 입력·저장 격리·복귀, 0–100장 페이지 별도 산술 확인 | 신규 0. 최대 3장·중복 없음. 산술은 Godot 실행과 별도 증거 |
| 4 00:44:47 | 최종 REVIEW/manifest, 실제 older·작은 화면 캡처 | 신규 0. 전체 사진 비율·고정 Back·논리 viewport 경계 일치 |
| 5 00:45:04 | source 6개/capture 8개 실제 SHA 대조, 낡은 경로 검색·diff check | 일치·낡은 경로 0·diff check PASS. 남은 필수 교정 0 |

반복 사용 명령은 `Get-Content -Raw -LiteralPath`, `Get-FileHash -Algorithm SHA256`, `git rev-parse HEAD`, `git diff --check`, 관련 전체 diff와 scoped untouched diff다. 각 회차 검증은 위 root의 RED/GREEN·60/20·GPU 결과와 source hash로 결속했다. 전체 사진 동시 로드/무한 캐시보다 기존 카드 paging이 장기 유지에 적합하며 새로운 강한 in-scope 대안은 발견하지 못했다. 저장 전체가 무변경인 것은 아니다. schema·원본은 그대로이고 누락 메타데이터 보존 정책은 의도적으로 교정했다.

## 다음 안전 작업

| 현재 상태 | 권장 다음 작업 | 이유·기대효과 |
|---|---|---|
| W. 다른 시점마다 섬 좌표가 다름 | 공통 공간/카메라 정렬의 낮 한 slice → 연속 이동 캡처 | 실제 앞으로 나가는 공간 일관성. 이 앨범 개선으로 완료 처리하지 않음 |
| W. 사진은 전체 비율의 작은 카드 | 선택한 사진 확대·한 번 뒤로 복귀를 다음 기억 slice로 구체화 | 새 콘텐츠를 늘리지 않고 직접 남긴 사진의 가치 강화 |
| S/O. 목적지 없는 local 기억 | 유지. 저장 누락을 조용히 표시하고 기록 보존 | 과업·희귀도 없이 애착을 보완 |
| T. 파일 수/자산 상태 폭증 | page 로딩 유지, 모델/리그 준비 상태 분리 | 그림 수·문서 수로 구현 공백을 감추지 않음 |

Base 환류 후보는 '제품 개선 루프와 검증 반복을 구분하고, UI 연결 변경 때 capture 소비처까지 검색'이다. 프로젝트 AGENTS에 최신 사용자 정의를 반영했으며 Base 공용 파일은 변경하지 않았다. v9.4.4 lock, 다른 PR #19와 다른 worktree는 보존했다.
