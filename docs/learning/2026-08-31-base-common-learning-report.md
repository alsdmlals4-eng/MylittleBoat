# My Little Boat Base Common Learning Report · 2026-08-31

> **상태:** `DERIVED_BASE_REVIEW_SOURCE_NOT_PROJECT_CANON`  
> **제출물:** `output/pdf/MY_LITTLE_BOAT_BASE_COMMON_LEARNING_REPORT_2026-08-31.pdf`  
> 이 문서는 Base 검토용 PDF의 text-native 원본이다. Base 변경·Base 승인·새 공용 모듈 채택을 뜻하지 않으며, 게임 기획과 플레이 콘텐츠를 정본화하지 않는다.

## A. 공통 학습 요약

이번 사례에서 Base에 전달할 수 있는 범용 학습은 두 가지다.

1. **import 완료 자체를 검증한 뒤 후속 검증을 시작한다.** 캐시 생성 여부, 제품 source diff, import/parse, runtime 결과를 서로 다른 증거로 유지한다.
2. **렌더러 의존 assertion은 capability를 명시하고, 지원하는 실행 경로에서 검증한다.** 프로세스 exit code만으로 capture 또는 resource-teardown 성공을 대신하지 않는다.

둘 다 새 Base 모듈이 아니라, 이미 존재하는 Base의 Godot import/test 및 evidence-boundary 원칙을 더 구체적으로 적용한 관찰이다.

## B. 후보 사례

| ID | 문제와 반례 | 일반화 가능한 원칙 | 분류 | Base disposition |
| --- | --- | --- | --- | --- |
| `MLB-BASE-OBS-20260831-IMPORT-COMPLETION` | `--editor --quit`가 import 완료 전 종료할 수 있어, clean cache 뒤의 0 exit만으로 resource 검증 준비를 판단하면 false green이 된다. | import 완료를 기다리는 명령을 사용하고, generated cache를 product/runtime PASS와 분리한다. | `MIXED` | 기존 `HIGODOT_SINGLE_AUTHORITY_AND_SAFE_OPERATION`의 import gate에 command-level note 후보. Base 수정은 이 작업에서 금지. |
| `MLB-BASE-OBS-20260831-RENDERER-CAPABILITY` | headless route는 특정 rendered-image assertion을 제공하지 않는다. capability 누락 또는 종료 순서 불명확성은 테스트가 통과해도 품질 증거를 약화할 수 있다. | assertion의 renderer requirement, 지원 경로, explicit skip 사유, teardown/readback을 함께 기록한다. | `MIXED` | 기존 evidence separation 및 diagnostic-not-acceptance rule을 corroborate. 새 skill/module 후보 아님. |
| `MLB-PROJECT-ONLY-20260831-TEST-ARTIFACTS` | isolated test persistence가 exact cleanup 없이 남을 수 있다. | 각 test fixture가 자기 `user://test_*` 경로만 teardown한다. | `PROJECT_ONLY` | 현재 프로젝트에만 구현. 반복된 다중 프로젝트 근거가 없으므로 Base candidate에서 제외. |

## C. 최소 workflow 계약

기존 Base owner를 그대로 사용한다. 새 CLI wrapper, 새 Base test runner, 새 registry item, 새 skill은 만들지 않는다.

```text
clean cache 또는 import-sensitive change
→ Godot --headless --path <project> --import
→ import/parse와 영향 contract를 별도 실행
→ renderer-dependent assertion은 supporting renderer에서 실행
→ explicit skip reason, log/error scan, exact temporary-artifact readback
→ runtime/device/human evidence는 실행한 범위까지만 기록
```

제약 조건은 다음과 같다.

- `--import` 완료는 source mutation, runtime success, device pass, human pass를 뜻하지 않는다.
- headless에서 불가능한 assertion은 삭제하거나 통과로 가장하지 않고, 지원 renderer의 별도 contract로 보완한다.
- fixture cleanup은 테스트가 소유한 exact temporary path로 한정한다. production `user://` save에 wildcard cleanup을 적용하지 않는다.

## D. Base owner 통합 계획

1. Base maintainer는 현행 `HIGODOT_SINGLE_AUTHORITY_AND_SAFE_OPERATION.md`의 import/parse gate와 `WORK_EXECUTION_EVIDENCE_IDENTITY_INTEGRITY.md`의 cache/source separation을 읽는다.
2. 중복 없이 반영할 가치가 있을 때만, 기존 HIGODOT owner에 `--import`가 import 완료를 기다린다는 command-level 예시를 한 줄 추가한다.
3. renderer capability 사례는 별도 module/skill로 승격하지 않는다. existing evidence template의 proof source·renderer/capability·skip rationale field가 부족하다고 실제 다수 프로젝트에서 확인될 때만 재검토한다.
4. 모든 경우 Base 규칙 변경, registry 등록, PR 생성, activation은 이번 작업의 범위 밖이며 Base review와 별도 승인 뒤에만 가능하다.

## E. 실패·반례·적용 한계

- `--editor --quit`는 editor start/quit을 요청할 뿐, clean-cache import completion proof로 쓰면 안 된다. Godot CLI의 `--import`는 import를 기다린 뒤 종료하는 별도 동작이다.
- 0 exit 하나는 renderer-specific rendered-image assertion의 성공을 증명하지 않는다. unsupported route는 capability-limited `SKIP`와 supporting route의 actual assertion으로 분리한다.
- generated cache는 source asset·tracked product source·runtime evidence와 같은 범주의 파일이 아니다.
- test-local data cleanup은 shared or production persistence cleanup으로 일반화할 수 없다. exact ownership과 exact path가 없으면 자동 삭제하지 않는다.
- 이 사례는 하나의 프로젝트·하나의 Godot version에서 얻은 관찰이므로, Base 공통 규칙 변경을 정당화하려면 다른 project에서의 반복 가치 또는 stable, narrowly-defined interface가 추가로 필요하다.

## F. 증거 appendix

| 구분 | 읽거나 검증한 source | revision 또는 결과 | evidence ceiling |
| --- | --- | --- | --- |
| project local authority | `AGENTS.md`, `docs/PROJECT_WORK_REUSE_HANDOFF.json`, current tests/workflow | local `main` `5ca7343d1c47ee3e02d40eab11a2c84c055b0fd1`; current worktree is dirty/unmerged | current implementation, not merged/release truth |
| project remote observation | `origin/main` | `8b78f8cba74d198a668ea2edcb77900d8b781564` | observed only; not merged into local worktree |
| Base remote observation | `Base origin/main` | `1f0ef9d8bdb1869c9ba25b33efdcb34cf2ccba83` | read-only; no Base file, PR, registry, or activation change |
| Base owners compared | `docs/knowledge/godot/HIGODOT_SINGLE_AUTHORITY_AND_SAFE_OPERATION.md`; `templates/project-operations/WORK_EXECUTION_EVIDENCE_IDENTITY_INTEGRITY.md` | existing import/test/evidence boundaries found; no exact completion command in targeted search | candidate review only |
| affected test cleanup | six named `tests/test_*.gd` contracts | Godot `4.7.2.stable.official.ed1daf0bf` `PASS`; sequential `user://test_*.cfg` readback `remaining_count=0` | machine verification only |
| import command source | Godot stable command-line documentation | `--import` waits for resources and implies `--editor` plus `--quit` | documentation and local command behavior; not device/human validation |

## 상태 결론

`PROJECT_ABSORPTION_IMPLEMENTED` · `BASE_COMMON_PDF_GENERATED_CANDIDATE` · `BASE_CHANGE_NOT_REQUESTED` · `HUMAN_DEVICE_UX_NOT_RUN`
