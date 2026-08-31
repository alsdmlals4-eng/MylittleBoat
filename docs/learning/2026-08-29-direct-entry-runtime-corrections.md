# Direct entry runtime correction · 2026-08-29

## Incident

승인된 direct boat entry를 구현하는 동안 첫 runtime capture에서 세 가지 product-risk가 확인됐다.

1. 첫 night art는 낮 배경과 수평선 위치가 달라 보트가 바다 대신 sky 위에 떠 있는 듯 보였다.
2. hull과 sea 사이의 빈 틈 때문에 보트가 합성 sticker처럼 읽혔다.
3. 첫 distant scenery Sprite3D는 camera-attached backdrop에 가려 실제 runtime에서 보이지 않았다.
4. foreground flag가 있어도 항해 timer·낚시 대기·알림이 background에서 계속 tick되어 앱을 보지 않는 동안 기록이 생길 수 있었다.
5. 같은 automatic scenery의 저장은 허용했지만 복원은 중복을 제거해 앨범 기억 수가 세션 뒤 달라졌다.
6. 네 개의 historical capture runner가 retire된 mood/time API를 호출해 현재 evidence를 재생성할 수 없었다.
7. 보트 motion은 y bob과 roll만 바꿔, 수면 접점은 맞아도 목적지 없이 함께 흘러가는 전진감이 화면에서 읽히지 않았다.

## Solution

- bright sea와 같은 horizon/sea proportion을 유지한 dedicated indigo-rain night source로 교체했다.
- `BoatWaterlineOverlay`라는 named wake/occlusion consumer를 `BoatSpace`에 추가했다.
- scenic prop은 input-free horizon `Control` overlay로 바꾸고, visible capture 및 consumer contract를 추가했다.
- `game_scene.gd`의 time-based runtime update를 application foreground gate 뒤로 옮겨 background elapsed time이 항해 기록을 만들지 않게 했다.
- automatic scenery의 local round-trip이 순서와 duplicate sighting을 그대로 복원하도록 고치고 계약을 추가했다.
- 당시 outdated capture runner를 `HISTORICAL_RETIRED` marker로 교체하고 current evidence를 `capture_direct_boat_entry_atmospheres.gd` 하나로 고정했다. 이후 2026-08-31 parent-integration audit에서 그 runner 역시 제거된 `DistantSceneryLayer` API를 계속 호출함이 확인되어, current evidence는 `DriftSceneryDirector` contract와 현재 handoff의 named capture receipt로 다시 라우팅했다.
- `BoatSpace`에 comfort-scaled 순환 전후 surge와 미세한 측면 current를 더하고, 기존 `BoatWaterContact`가 동일한 x/z offset과 미세한 scale 변화로 계속 결합되게 했다. 이 움직임은 항해 시간·저장·보상·카메라 mode를 바꾸지 않으며 `still` comfort에서는 0이 된다.

## Lesson

보트·바다처럼 여러 depth layer가 겹치는 휴식 화면에서는 source art 단독 검토가 충분하지 않다. target resolution, actual camera, background depth, hull-water contact를 한 runtime capture에서 함께 확인해야 한다. 밤 원화도 시간대만 바꾸는 것이 아니라 동일 composition grammar를 지켜야 한다. 또한 "active foreground"은 scenery director 하나의 옵션이 아니라 모든 session-time consumer와 저장 round-trip까지 함께 검증해야 하는 제품 계약이다. 부유가 기계적으로 매끄럽다는 것과 전진감이 화면에서 읽힌다는 것도 별도 조건이다. 목적지 없는 게임에서는 누적 world translation 대신 comfort-scaled 순환 surge를 사용하면 경계·저장·보상 문제 없이 후자를 보강할 수 있다.

## 2026-08-31 forward-drift verification receipts

검증 대상은 `7181d5e6845e75107eade8c4d2e62e10334ab54b`의 현재 main 작업 트리다. open PR #19와 Base worktree는 read-only로 유지했다. 아래 loop는 전진감 보강의 전체 범위, 즉 normal·Appreciation·Look Around camera routing, comfort, boat-water contact, 사진·Album·낚시·함께한 시간, CI contract discovery와 source-owner 동기화를 함께 다시 읽은 기록이다.

1. **현상과 대안.** `GameScene._apply_drift_motion()`은 y bob·roll·water-contact breath만 바꾸고 x/z translation은 만들지 않는다는 런타임 측정값을 확인했다. 누적 world translation은 목적지 없는 휴식과 경계·리셋 문제 때문에 `REJECT`, camera-attached backdrop slide는 ambient motif의 portrait-safe offset을 덮을 위험 때문에 `REJECT`, 기존 `BoatSpace`와 water-contact를 함께 움직이는 closed surge는 새 asset·save·reward consumer가 없어 `ADOPT`했다.
2. **Red contract.** 새 `test_voyage_forward_drift_contract.gd`는 기존 구현에서 세 speed 모두 전후·측면 offset이 0이라 7개 assertion이 실패했다. 이 test는 forward/lateral motion, water-contact x/z alignment, speed tier ordering, voyage duration·camera mode 불변, `still`의 완전 정지를 고정한다.
3. **첫 Green과 회귀.** minimal `BoatSpace` surge/current와 `BoatWaterContact` 동기화 뒤 focused gameplay contracts 15개가 통과했다. direct entry, comfort, diorama, Look Around, photo memory, together time, fishing, low-pressure interaction은 그대로 통과했다.
4. **표시 renderer의 반례와 보정.** Windows OpenGL Compatibility 540×960 probe는 첫 구현에서 frame jump 없이 동작했지만 2.4초 screen displacement가 2.628px뿐이었다. 이는 “전진감이 읽힌다”는 수용 기준에는 너무 은은하다고 판단했다. fast tier surge가 최소 0.09 unit이라는 추가 Red assertion은 1개 실패했고, 다른 기능 결함은 없었다.
5. **보정 Green과 renderer readback.** surge max를 0.16 unit으로만 조정한 뒤 새 contract가 통과했다. 동일 표시 probe는 `forward_range=0.127853`, `max_frame_step=0.010951`, `screen_delta_px=6.719`, water-contact alignment `PASS`를 기록했고 soundscape teardown까지 수행해 warning 없이 종료했다. 모든 움직임은 `standard/gentle/still` scale을 재사용하므로 고요 profile에서 0이다.
6. **최종 scope 재검사.** `tests/test_*.gd` 52개 중 headless-safe 51개는 43개와 마지막 8개로 나누어 실제 실행해 모두 exit 0으로 통과했다. 출력 형식이 다른 `test_windows_export_contract.gd`는 direct readback에서 `Windows export contract passed`, exit 0임을 확인했다. display-only chroma material proof, main/game/album smoke, CI coverage Python contract도 통과했다. 현재 exact-count guard는 `all=52`, `headless=51`, `display-only=1`이다. Human/device comfort는 이 machine receipt로 닫지 않으며 `NOT_RUN`이다.

## Base promotion decision

`NO_BASE_PROMOTION`. 이 lesson은 Godot의 일반 도구 사용법이 아니라 My Little Boat의 boat/sea/horizon composition, approved style lock, direct-entry surface에 결합되어 있다. 일반화 가능한 작업 흐름으로 검증할 만큼 여러 프로젝트 evidence가 쌓이지 않았다.

## 2026-08-31 ambient scenery pass verification receipts

검증 대상은 같은 `7181d5e6845e75107eade8c4d2e62e10334ab54b` base의 dirty current worktree다. 이 loop는 승인된 여섯 motif, water-only atmosphere backdrop, normal·Appreciation·Look Around routing, local ambient-memory writer, photo·fish·voyage record, renderer capture와 human-evidence ceiling을 함께 다시 읽은 기록이다. 다른 worktree·PR은 건드리지 않았다.

1. **현상·대안과 current consumer.** 실제 `GameScene`과 `DriftSceneryDirector`를 다시 읽어 event가 `SeaBackdrop` texture를 즉시 교체하고 10초 뒤 복귀한다는 것을 확인했다. whole-backdrop swap은 이미지가 흘러가는 감각이 없어 `REJECT`, 새 자연 asset batch는 기존 여섯 user-approved canonical asset을 재사용할 수 있어 `REJECT`, water-only backdrop 앞을 좌우로 지나가는 dedicated `Sprite3D` pass는 새 save·reward·network consumer가 없어 `ADOPT`했다. Tchia의 sailing-through-scenery와 Spiritfarer의 boat+companion+scenery 동시 구도를 reference로 비교했지만, 목적지·목표·NPC loop는 rest-first canon 때문에 `REJECT`했다.
2. **Red contract와 minimal boundary.** `test_ambient_motif_game_scene_contract.gd`를 먼저 water-only base texture/position 유지, normal·Appreciation exact texture pass, live-frame lateral movement, fade, restore hide, no photo·fish·voyage·together-time mutation으로 바꿨다. 구현 전에는 기존 backdrop swap과 missing pass 때문에 8 assertion이 실제로 실패했다. `AmbientSceneryPass`는 normal·Appreciation camera의 child로만 두고 Look Around에는 만들지 않아 approved angle art consumer가 변하지 않는다.
3. **첫 Green과 adjacent regression.** `game.tscn`에 두 pass node와 14-second return timer를 넣고, `game_scene.gd`는 base backdrop을 바꾸지 않은 채 exact approved texture, authored-side direction, `Tween` transit, temporal fade, cleanup을 소유하도록 최소 변경했다. 새 contract가 통과했고 director, Look Around game scene, real-time atmosphere, ambient memory, calm game scene contract가 모두 재실행 `PASS`했다. 이 단계의 validated boundary는 pass가 photo·fish·voyage record를 만들지 않고 Look Around backdrop을 바꾸지 않는다는 것이다.
4. **표시 renderer 반례와 visual correction.** NVIDIA RTX 3050 OpenGL Compatibility 540×960 실제 capture에서 최초 0.009 pixel-size pass는 이동 자체와 node metrics는 정상이었지만, 이미지 하단의 수평 edge가 boat view를 가르는 것을 확인했다. 이는 자연스러운 풍경 통과 기준에서 `MUST_FIX`였다. overscan pixel-size `0.02`, opposite-side transit minimum `±21`, 14-second duration을 요구하는 Red contract가 4 assertion 실패한 뒤, 해당 두 Scene property와 one travel constant만 보정해 Green으로 재검증했다. 새 capture는 위아래 edge가 화면 밖으로 나가고 좌우 흐름만 남는다.
5. **actual runtime readback과 full-scope recheck.** isolated Windows display probe가 normal에서 `x=18.9171 → 0.8637`, Appreciation에서 `x=18.8863 → 0.7860`, sampled frame difference `0.143997 / 0.142857`을 기록하며 `PASS`했고, 같은 probe는 warning 없이 종료했다. 이어 `tests/capture_ambient_motif_scenery.gd`를 current pass contract로 교정해 다섯 time/motif frame을 한 runner에서, night frame을 같은 display contract의 bounded final runner에서 생성하여 `docs/evidence/2026-08-31-ambient-scenery-pass/`에 여섯 540×960 image를 완성했다. stale `SeaBackdrop` wording은 README, GDD, visual inventory, current handoff, ambient decisions/spec에 current consumer와 evidence path로 동기화했다. Human long-run calm, noticeability, device color/touch, motion and audio comfort는 여전히 `NOT_RUN`이며 renderer evidence로 닫지 않는다.
