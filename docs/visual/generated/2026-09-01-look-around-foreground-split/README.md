# Look Around foreground 분리 후보 · 2026-09-01

**상태:** `GENERATED_CANDIDATE`

## 목적

`port`·`starboard`·`aft`·`overhead` Look Around의 기존 원화는 보트, 캐릭터, 동반자, 하늘, 바다와 젤리피시가 한 장에 합쳐져 있다. 이 후보는 네 방향의 보트·캐릭터·동반자 foreground만 투명 레이어로 분리하는 다음 asset family의 시각 방향을 확인하기 위한 2×2 보드다. 이는 현행 `MLB-BG-SPLIT-001..008`의 시간대별 고정 하늘·흐르는 바다 위에 얹는 구성을 전제로 한다.

## 후보 파일

| file | SHA-256 | dimensions | intended role |
| --- | --- | --- | --- |
| `look-around-foreground-board-candidate-v1.png` | `81B4EAE37E0BFA3B64307D31B655044B9046B1B1159C491F7FA2A276E2F2A106` | `1254 × 1254` | port / starboard / aft / overhead foreground style and silhouette reference |

## 생성 경계

- Built-in image model로 생성했다. Source: `C:\Users\user\.codex\generated_images\01a04af3-d9a2-7c92-be5c-ce99e4d55cdc\exec-9ee38fa6-81a3-459c-b291-5329bfa75b66.png`.
- Reference: 현재 승인된 `MLB-LOOK-CHIBI-TRN-001..004` 원화. 캐릭터·강아지·청록 보트·랜턴·쿠션·화분·컵과 네 방향 구도만 참고했다.
- 후보는 평면 중립 배경 위의 스타일 보드다. runtime texture, canonical asset, Scene consumer, save data, reward, or camera code에는 아직 연결되지 않았다.
- 다음 단계는 사용자 `LOCK / REVISE / REJECT`다. `LOCK` 후에만 네 개의 개별 transparent foreground candidate와 actual Scene routing package를 준비한다.
