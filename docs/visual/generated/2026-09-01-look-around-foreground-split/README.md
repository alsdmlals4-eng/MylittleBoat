# Look Around foreground 분리 lock·production source · 2026-09-01

**상태:** `USER_LOCKED → CANON_REGISTERED → ASSET_READY`

## 목적

`port`·`starboard`·`aft`·`overhead`의 이전 원화는 보트, 캐릭터, 동반자, 하늘, 바다와 젤리피시가 한 장에 합쳐져 있었다. 사용자는 이 보드 방향을 2026-09-01 `권장안대로 진행해`로 `LOCK`했다. 그 결정에 따라 네 방향의 보트·캐릭터·동반자 foreground를 current `MLB-BG-SPLIT-001..008`의 시간대별 고정 하늘·흐르는 바다 위에 얹는 production family로 만들었다.

## 후보 파일

| file | SHA-256 | dimensions | role |
| --- | --- | --- | --- |
| `look-around-foreground-board-candidate-v1.png` | `81B4EAE37E0BFA3B64307D31B655044B9046B1B1159C491F7FA2A276E2F2A106` | `1254 × 1254` | user-locked port / starboard / aft / overhead style and silhouette reference |
| `final/port-foreground-source.png` | `E2BF044E985951C8FE74CC7457B9C540B8CB589AF71C78CC2D970DF30B032D72` | `1254 × 1254` | `MLB-LOOK-FG-001`, `port` source and canonical runtime pair |
| `final/starboard-foreground-source.png` | `BA54F756B81C23C8DB789E7688A88BC42E5B9C2D3E91AABE5106B372B9479CAC` | `1254 × 1254` | `MLB-LOOK-FG-002`, `starboard` source and canonical runtime pair |
| `final/aft-foreground-source.png` | `3A536C0BBE2A438D1A6489F599E1D197AE533F962F98355E6DEB46EE3F249E0D` | `1254 × 1254` | `MLB-LOOK-FG-003`, `aft` source and canonical runtime pair |
| `final/overhead-foreground-source.png` | `1437F3A7CCE7921619F3083E002BE871AAC796C07987400BE8280CE9937145FF` | `1254 × 1254` | `MLB-LOOK-FG-004`, `overhead` source and canonical runtime pair |

## 생성 경계

- Built-in image model로 보드와 개별 production source를 생성했다. 외부 원본은 `C:\Users\user\.codex\generated_images\01a04af3-d9a2-7c92-be5c-ce99e4d55cdc`에 보존한다. repository provenance 복사본은 이 폴더의 `final/`이며 canonical runtime 복사본은 `assets/images/runtime/voyage/look_around/foreground_split/`다. 각 source와 runtime pair의 SHA-256은 동일하다.
- Reference: user-locked board와 이전 `MLB-LOOK-CHIBI-TRN-001..004`의 캐릭터·강아지·청록 보트·랜턴·쿠션·화분·컵·각도 정보다. 보드 밖에 별도 캐릭터·경제·저장·reward 의미를 추가하지 않았다.
- 이미지 모델이 RGBA alpha가 아닌 opaque magenta technical matte를 출력하는 현재 도구 제약은 숨기지 않는다. `look_around_foreground_chroma_key.gdshader`가 이 matte만 runtime alpha로 분리하며, `SkyBackdrop`와 flowing `SeaBackdrop`는 독립적으로 계속 보인다. OpenGL runtime capture는 별도 evidence receipt에서 확인한다.
- `MLB-LOOK-FG-001..004`는 `LookAroundPresentationRouter`와 `LookAroundForeground`에서만 소비한다. 기존 `MLB-LOOK-CHIBI-TRN-001..004` whole-composite route는 superseded cleanup 대상으로 전환했고, source·consumer 검색과 regression verification 뒤에만 제거한다.
