# Audio

`my little boat`의 오디오는 **파도소리만 들어도 쉬는 느낌이 드는가**를 최우선으로 판단합니다.

현재 이 폴더에는 **production audio asset이 없습니다.** 아래는 자산 구조와 승인 기준이며, 후보 URL이 존재한다고 해서 게임에 통합됐다는 뜻은 아닙니다.

## 0. 현재 Technical Prototype

- `RestingSoundscape`는 `project.godot` AutoLoad로 존재해 메뉴/항해/앨범 Scene 전환에도 유지됩니다.
- `scripts/audio/resting_soundscape.gd`가 4초짜리 합성 `AudioStreamWAV`를 런타임에서 한 번 생성하고 loop합니다.
- 기본 볼륨은 `-16 dB`입니다.
- 이 소리는 **외부 자연 녹음이 아니라 playback/loop/지속성 구조를 검증하기 위한 TECHNICAL_PROTOTYPE**입니다.
- 자동 테스트는 `TECHNICAL_PROTOTYPE=true`, loop mode, 낮은 기본 볼륨, persistent AutoLoad를 검증합니다.
- 이 합성음을 듣고 `AUDIO_REST_PASS`를 판정하지 않습니다. 실제 자연 파도 자산 + Human listening이 필요합니다.

현재 evidence:

`TECH_AUDIO_WIRING = PASS / PRODUCTION_OCEAN_AUDIO = NOT_INTEGRATED / HUMAN_LISTENING = NOT_RUN`

## 1. Audio North Star

- BGM보다 자연음이 먼저입니다.
- 음악 OFF 상태에서도 5분 항해가 성립해야 합니다.
- 파도는 배경 소음이 아니라 핵심 콘텐츠입니다.
- 작은 소리의 층이 공간감을 만들되 플레이어의 주의를 계속 빼앗지 않습니다.

## 2. 권장 런타임 레이어

```text
OceanBed        # 넓고 잔잔한 파도, 항상 중심
NearWater       # 선체 가까이 닿는 잔물결
Wind            # 낮은 밀도의 부드러운 바람
BoatCreak       # 매우 드문 목재/선체 작은 소리
DistantNature   # 멀리 있는 새/생명체, 매우 드묾
PetFoley        # 펫 숨/기지개/작은 움직임, 낮은 빈도
MusicOptional   # 선택형, 기본 경험을 대체하지 않음
UI              # 최소한의 조용한 피드백
```

### 존재감 우선순위

`OceanBed > NearWater > Wind > BoatCreak > DistantNature/PetFoley > UI`

음악은 별도 선택 레이어로 취급합니다.

## 3. 믹스/편집 보호선

- loop seam이 들리지 않아야 합니다.
- 갑작스러운 큰 파도, 날카로운 고역, 큰 갈매기 울음, 보상 징글을 기본 soundscape에 넣지 않습니다.
- 날씨/시간대 전환은 부드러운 crossfade를 사용합니다.
- 자연스러움을 만들기 위해 음량을 크게 랜덤화하지 않습니다. 작은 variation만 사용합니다.
- 낚시 입질은 알람이 아니라 작은 물소리/줄 움직임 수준으로 표현합니다.
- UI는 소리가 없어도 이해 가능해야 하며, 소리로 플레이어를 재촉하지 않습니다.

## 4. 승인 전 Reference 후보 — 아직 미통합

아래 후보는 **REFERENCE / CC0 확인용**입니다. 실제 다운로드 후에는 파일 자체의 license metadata와 출처를 다시 readback한 뒤 승인해야 합니다.

### OceanBed 후보 A — Gentle Ocean Waves Loop

- Source: Freesound `kkenny101 / 852826`
- URL: https://freesound.org/people/kkenny101/sounds/852826/
- Description: 21.769초, seamless loop, very gentle ocean waves
- License shown by source: Creative Commons 0
- Size shown by source: 약 3.0 MB
- Decision: **TEST FIRST** — 작은 파일과 seamless loop 특성 때문에 첫 기술/청취 후보

### OceanBed 후보 B — WATER OCEAN WAVES 01.wav

- Source: Freesound `sengjinn / 174581`
- URL: https://freesound.org/people/sengjinn/sounds/174581/
- Description: 약 1분 59초, 밤의 gentle sea waves
- License shown by source: Creative Commons 0
- Decision: **REFERENCE / A-B LISTENING** — 긴 자연 variation 비교용

### Boat/NearWater 후보 C — Ammersee Sailboat Cabin

- Source: Freesound `myLoop / 851577`
- URL: https://freesound.org/people/myLoop/sounds/851577/
- Description: 선체 가까운 물결 + 부드러운 cabin creak + 먼 바람, seamless loop
- License shown by source: Creative Commons 0
- Decision: **REFERENCE ONLY** — 선체 근접 레이어의 질감 참고. 바다/갑판 시점과 맞는지는 별도 청취 필요

## 5. 자산 파일 규칙

실제 승인 파일은 다음처럼 저장합니다.

```text
assets/audio/ambient/ocean_bed_<name>.ogg
assets/audio/ambient/near_water_<name>.ogg
assets/audio/ambient/wind_<name>.ogg
assets/audio/boat/creak_<name>.ogg
assets/audio/nature/distant_<name>.ogg
assets/audio/pet/<pet>_<action>.ogg
assets/audio/ui/<action>.ogg
```

가능하면 source WAV/FLAC은 외부 원본/작업 보관소에서 관리하고, 게임 repo에는 최적화한 runtime asset을 둡니다.

각 승인 자산은 Notion Asset Library 또는 별도 license ledger에 다음을 기록해야 합니다.

- source URL
- creator/source id
- license
- downloaded/verified date
- original filename/hash
- edited runtime filename/hash
- loop/edit 처리 여부
- Human listening result

## 6. Human Listening Gate

실제 자연 오디오 통합 후 아래를 직접 확인하기 전에는 `AUDIO_REST_PASS`를 주장하지 않습니다.

1. 눈을 감고 30초 들어도 편안한가?
2. 5분 동안 loop 반복이 거슬리지 않는가?
3. 파도보다 음악/UI/갈매기/효과음이 더 전면에 나오지 않는가?
4. 갑작스러운 큰 소리나 날카로운 고역이 없는가?
5. 헤드폰·일반 스피커·모바일 스피커에서 모두 지나치게 피곤하지 않은가?
6. 음악 OFF에서도 공간이 비어 보이지 않는가?

현재 상태: **TECH_AUDIO_WIRING PASS / PRODUCTION AUDIO NOT_INTEGRATED / HUMAN LISTENING NOT_RUN**
