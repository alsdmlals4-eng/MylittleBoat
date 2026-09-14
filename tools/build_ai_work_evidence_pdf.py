# 실제 저장소 기록과 검증 자산으로 월별 AI 활용 증빙집을 발행한다.
"""September reviewed case edition, not a generic automatic activity classifier.

Re-read and update the case prose against its owners before each new edition.
Git indexing and hashes are automatic; AI attribution and verification are not.
Derived evidence never certifies AI usage time or expense eligibility.
"""
import argparse
from collections import defaultdict
from datetime import datetime, timezone, timedelta
import hashlib
import json
from pathlib import Path
import subprocess
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Image, PageBreak

ROOT = Path(__file__).resolve().parents[1]
KST = timezone(timedelta(hours=9))
SOURCE_PATHS = [
    'docs/design/PROJECT_GDD.md',
    'docs/superpowers/plans/2026-09-14-remaining-implementation.md',
    'docs/evidence/2026-09-13-water-heading/REVIEW.md',
    'docs/evidence/2026-09-14-recoverable-save/REVIEW.md',
    'docs/visual/candidates/2026-09-11-blueprint/manifest.json',
    'docs/evidence/2026-09-13-water-heading/runtime/voyage-10s.png',
    'docs/evidence/2026-09-13-water-heading/views/look-left-5s.png',
    'docs/visual/candidates/2026-09-11-blueprint/island-rgba-v1.png',
    'docs/evidence/2026-09-14-recoverable-save/photo-runtime/voyage-photo.png',
    'docs/evidence/2026-09-14-recoverable-save/photo-runtime/album-photo.png',
]

def git(*args):
    return subprocess.check_output(['git', '-C', str(ROOT), *args], encoding='utf-8').strip()

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def verify_receipt(receipt_path):
    """Check publication and original bytes, accepting recorded checkout CRLF only."""
    receipt = json.loads(Path(receipt_path).read_text(encoding='utf-8'))
    pdf_path = Path(str(receipt_path).replace('.sources.json', '.pdf'))
    if digest(pdf_path) != receipt['pdf_sha256']:
        raise ValueError('Published PDF hash mismatch')
    checked = []
    for entry in receipt['sources']:
        blob = subprocess.check_output(['git', '-C', str(ROOT), 'cat-file', 'blob',
                                       receipt['source_head']+':'+entry['path']])
        representations = {'git_blob': blob}
        if Path(entry['path']).suffix in ('.md', '.json'):
            representations['checkout_crlf'] = blob.replace(b'\r\n', b'\n').replace(b'\n', b'\r\n')
        matches = [name for name, data in representations.items()
                   if hashlib.sha256(data).hexdigest() == entry['sha256']]
        if not matches:
            raise ValueError('Historical source byte mismatch: '+entry['path'])
        checked.append(dict(path=entry['path'], matched_representation=matches[0]))
    return checked

def source_snapshot():
    result = []
    for relative in SOURCE_PATHS:
        path = ROOT / relative
        if not path.is_file():
            raise ValueError(f'Missing evidence: {relative}')
        blob = subprocess.check_output(['git', '-C', str(ROOT), 'cat-file', 'blob', 'HEAD:'+relative])
        candidates = [blob]
        if path.suffix in ('.md', '.json'):
            candidates.append(blob.replace(b'\r\n', b'\n').replace(b'\n', b'\r\n'))
        if path.read_bytes() not in candidates:
            raise ValueError('Commit reviewed evidence before publication: '+relative)
        result.append(dict(path=relative, sha256=digest(path), bytes=path.stat().st_size,
                           last_commit=git('log', '-1', '--format=%H|%aI|%cI', '--', relative)))
    return result

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--verify', type=Path)
    parser.add_argument('--output-dir', type=Path)
    parser.add_argument('--version')
    parser.add_argument('--change-reason')
    args = parser.parse_args()
    if args.verify:
        print(json.dumps(verify_receipt(args.verify), ensure_ascii=False))
        return
    if not all((args.output_dir, args.version, args.change_reason)):
        parser.error('Publication requires --output-dir, --version and --change-reason')
    if not args.version.replace('.', '').isalnum():
        raise ValueError('Version must be alphanumeric with optional dots')
    now = datetime.now(KST)
    if now.strftime('%Y-%m') != '2026-09':
        raise ValueError('September source scope must be reviewed before a different month')
    name = f'my little boat_2026-09_AI활용_작업일지_증빙집_v{args.version}'
    pdf_path, source_path = (args.output_dir / (name + ext) for ext in ('.pdf', '.sources.json'))
    if pdf_path.exists() or source_path.exists():
        raise FileExistsError('Published version exists; choose a new version and correction reason')
    sources = source_snapshot()
    commits = []
    for line in git('log', '--first-parent', '--format=%H%x09%aI%x09%cI%x09%s').splitlines():
        sha, authored, committed, subject = line.split('\t', 3)
        date = datetime.fromisoformat(committed).astimezone(KST)
        if date.strftime('%Y-%m') == '2026-09' and date <= now:
            commits.append(dict(sha=sha, authored_at=authored, committed_at=committed, subject=subject))
    commits.reverse()
    days = defaultdict(list)
    for entry in commits:
        days[datetime.fromisoformat(entry['committed_at']).astimezone(KST).strftime('%m-%d')].append(entry)
    assets = json.loads((ROOT / SOURCE_PATHS[4]).read_text(encoding='utf-8'))['assets']
    island = next(a for a in assets if a['asset_id'] == 'MLB-NEW-ROCK-001')
    if digest(ROOT / island['path']) != island['sha256']:
        raise ValueError('Island provenance mismatch')
    snapshot = dict(schema_version=1, project='my little boat', month='2026-09',
                    publication_at=now.isoformat(), record_written_at=now.isoformat(),
                    retrospective=True, source_head=git('rev-parse', 'HEAD'),
                    source_branch=git('branch', '--show-current'),
                    change_reason=args.change_reason, submission_status='NOT_SUBMITTED',
                    account_identity='UNVERIFIED', payment_evidence='NOT_REVIEWED',
                    ai_usage_time='NOT_INFERRED_FROM_GIT', sources=sources, commits=commits)
    pdfmetrics.registerFont(TTFont('MLB', 'C:/Windows/Fonts/malgun.ttf'))
    pdfmetrics.registerFont(TTFont('MLBB', 'C:/Windows/Fonts/malgunbd.ttf'))
    ink, teal = colors.HexColor('#203e47'), colors.HexColor('#347b83')
    body = ParagraphStyle('body', fontName='MLB', fontSize=10, leading=16,
                          wordWrap='CJK', textColor=ink, spaceAfter=10)
    small = ParagraphStyle('small', parent=body, fontSize=8, leading=12, spaceAfter=6)
    heading = ParagraphStyle('heading', parent=body, fontName='MLBB', fontSize=21, leading=29, spaceAfter=18)
    sub = ParagraphStyle('sub', parent=body, fontName='MLBB', fontSize=13, leading=20, spaceAfter=12)
    story = []
    def p(text, style=body):
        return Paragraph(escape(str(text)).replace('\n', '<br/>'), style)
    def add(text, style=body):
        story.append(p(text, style))
    def page(title):
        if story:
            story.append(PageBreak())
        add(title, heading)
    def table(rows, widths):
        obj = Table([[p(v, small) for v in row] for row in rows], colWidths=widths, repeatRows=1, hAlign='LEFT')
        obj.setStyle(TableStyle([('VALIGN',(0,0),(-1,-1),'TOP'),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e2eeeb')),
                                ('BOTTOMPADDING',(0,0),(-1,-1),7),('TOPPADDING',(0,0),(-1,-1),7),
                                ('LINEBELOW',(0,0),(-1,-1),.3,colors.HexColor('#cedbd9'))]))
        story.append(obj)
        story.append(Spacer(1, 12))
    def picture(relative, max_width=490, max_height=355):
        from PIL import Image as PILImage
        with PILImage.open(ROOT / relative) as im:
            w, h = im.size
        scale = min(max_width/w, max_height/h)
        story.append(Image(str(ROOT / relative), width=w*scale, height=h*scale))
        story.append(Spacer(1, 12))
    page('my little boat\nAI 활용 작업일지·증빙집')
    add('2026년 9월 / 확인 가능한 기록의 사후 정리', sub)
    add('목적지 없이 동반자와 잔잔한 바다를 떠다니는 힐링 게임의 기획·제작·검증 기록입니다. 블루프린트와 별개인 활용 증빙 보조자료이며 게임 기획 정본이나 협회 지정 정산 양식을 대체하지 않습니다.')
    table([['항목','이번 발행의 범위'],['기록 범위',f'2026-09-01부터 발행 시점까지의 현재 branch Git 기록 {len(commits)}건. 건수는 AI 이용 횟수나 완성 진척이 아닙니다.'],
           ['발행·사후 정리 시각',now.strftime('%Y-%m-%d %H:%M:%S KST')],['기준 코드',snapshot['source_head']],
           ['상태','검토용 v'+args.version+' / 미제출 / 계정·결제·비용 인정 미확인'],['발행 사유',args.change_reason]], [110,385])
    add('중요한 읽기 기준', sub)
    add('Git 작성·커밋 시각은 저장소 메타데이터입니다. AI 작업 시각을 독립적으로 인증하지 않습니다. 이 PDF에 오늘 넣은 과거 화면을 오늘 새로 제작한 화면으로 표시하지 않습니다. AI 입력·출력 원본과 계정별 화면 증빙이 부족한 항목은 제출 보완 대상으로 남깁니다.')
    add('상세 기록 안내. 3쪽 이미지 후보 / 4쪽 수면 방향 교정 / 5쪽 저장 보호 / 6쪽 실제 사진·앨범 / 7쪽 운영 지시 / 8쪽 증빙 공백 / 9쪽 이후 원본 색인.', small)
    page('01 / 날짜별 변경 기록 색인')
    add('아래 날짜는 KST로 변환한 Git 커밋 날짜입니다. 해당 날짜의 모든 변경이 AI로 수행되었다거나 원래 AI 작업일이 같다는 주장은 하지 않습니다. 전체 SHA·작성 시각·커밋 시각·제목은 동봉 sources.json에 보존합니다.', small)
    rows = [['Git 날짜','기록 수','대표 변경 제목 / 찾아보기']]
    for day, entries in days.items():
        selected = [entries[0]] if len(entries)==1 else [entries[0], entries[-1]]
        rows.append([day,str(len(entries)), '\n'.join(e['subject'] for e in selected)])
    table(rows, [62,48,385])
    add('AI 서비스별 찾아보기. Codex 작업 검토는 4~7쪽. 이미지 모델 프롬프트와 후보 결과는 3쪽. 과거 생성 모델의 정확한 서비스/계정은 manifest만으로 확인할 수 없으므로 미확인입니다. 결제 내역은 이 보고서의 근거로 검토하지 않았습니다.', small)
    page('02 / 분리형 섬 이미지 후보 - MLB-A01')
    add('원본 분류일 2026-09-11 / 실제 생성 시각 미확인 / 이번 발행 시 사후 정리', small)
    add('작업 전. 투명 배경 요청이 체크무늬 RGB로 나온 문제가 기록되어 있습니다. 섬·하늘·바다를 분리해야 항해 화면에서 각 요소를 독립적으로 배치하고 움직일 수 있습니다.')
    add('이번 기록의 결과. manifest에는 단색 #FF00FF 배경과 기존 크로마키 shader를 이용한 추출 교정, 실제 alpha·여백·Aseprite 왕복 검사 통과가 기록되어 있습니다. 얇은 가장자리 색 번짐과 각도 적용은 미검증이며 FINAL_PENDING입니다. 신규 승인 또는 새 runtime 적용으로 높이지 않습니다.')
    picture(island['path'], max_height=190)
    add('과거 생성 후보 결과. 지금 생성한 이미지나 실제 게임 실행 캡처가 아닙니다.', small)
    add('저장된 입력 프롬프트 원문 발췌 - 화면 캡처가 아님', sub)
    add(island['prompt'], small)
    add('원본. '+SOURCE_PATHS[4]+' / asset_id MLB-NEW-ROCK-001', small)
    page('03 / 수면의 항로 방향 연결 - MLB-C01')
    add('기록 문서 분류일 2026-09-13 / 작업일은 연결된 Git 기록과 대조 / 캡처 시각은 원본 telemetry 기준, 이 문서에서 별도 시각 인증하지 않음', small)
    add('작업 전. 카메라·섬은 실제 공간을 이동하지만 수면은 상대 yaw와 화면 아래 고정 방향을 사용했습니다. 변경. 실제 카메라 축과 세계 +Z 항로를 기존 수면 shader에 연결했습니다. Start 이후 항해 중 둘러보기·감상에서도 방향 관계를 유지하는 것이 목적입니다.')
    picture(SOURCE_PATHS[5], max_height=330)
    add('기존 실행 캡처 재수록. voyage-10s.png. 새 촬영이 아니며, 정지 화면 하나만으로 이동 품질을 증명하지 않습니다.', small)
    add('기록된 검증. 30.012초 / 151프레임, GPU 시점 8개 표본, headless 62개와 Python 20개. Windows RTX 3050 / Vulkan Mobile 기록이며 모바일 실기기 검증은 아닙니다. 근경 6.12 px/s와 원경 7.07 px/s 측정은 원하는 원근 속도 순서를 입증하지 못합니다. 세계 수면·모델 전체 전환과 Human 검증은 남았습니다.', small)
    add('입력 원본 화면은 이번 수록 자료에 없음. 실제 변경과 검증은 water-heading/REVIEW.md 및 runtime telemetry·motion-analysis.json을 대조해야 합니다.', small)
    page('04 / 복구 가능한 저장 연결 - MLB-C02')
    add('Git 기록 2026-09-14 / 본문은 발행 시점 사후 정리 / 게임 새 화면 캡처 없음', small)
    add('작업 전. 저장 오류를 성공처럼 처리하거나 손상 데이터를 기본값으로 덮을 위험이 있었습니다. 변경. 공용 RecoverableConfigStore와 comfort, 꾸미기, 외형, 함께한 시간, 풍경 기억, 개인 기록 owner를 연결했습니다. 정상 확정·미확정·복구 필요 상태를 구분하며 읽기 단계는 원본을 수정하지 않습니다.')
    table([['구간','변경 및 근거'],['R07a','3724c67 읽기 무쓰기 / 4773c68 최초 저장 원본 상태 보존 / 70f2e07 테스트 sidecar 정리'],
           ['R07b1','b07f8b8 다섯 owner 연결 / 6f6f716 미지원 꾸미기 ID와 복구 우선순위 / 02e5a256 중복 fallback 공통화'],
           ['정본 연결','9c1e89e 조사·GDD·실행 계획·검증 증거 연결']], [92,403])
    add('확인한 검증', sub)
    add('검증 기록에는 b07f8b8 범위의 격리된 headless 64개 통과가 있습니다. 마지막 02e5a256에서는 관련 8개를 변경 전후 확인했고, game Scene 시작 smoke와 Python 20개를 확인했습니다. 최종 head의 전체 64개를 다시 실행했다고 쓰지 않습니다. 실제 전원 차단·모바일·Human QA는 미검증입니다.')
    add('남은 연결', sub)
    add('첫 사용량 제한 시점의 R07b2 미구현 기록은 v1.0의 역사적 상태입니다. 이후 854fdce에서 사진 목록/PNG 저장과 경로 경계, 실제 Album 소비 연결을 구현했습니다. 저장 성공 후 모든 게임 상태 확정과 플레이어용 복구 UI는 후속 R07b3로 남아 있습니다. 사용자 세이브를 삭제하거나 자동 초기화하지 않았습니다.')
    add('AI 및 입력 근거. 이번 Codex 작업의 변경·검증 기록은 확인했지만 계정 식별정보·원문 프롬프트 화면은 이 PDF에 수록하지 않았습니다. 커밋 작성자 이름을 AI 서비스 계정으로 대신 사용하지 않습니다.', small)
    page('05 / 실제 사진 저장·앨범 연결 - MLB-C03')
    add('실행·캡처 2026-09-14 22:55:51 KST / 코드 854fdce / 이 PDF는 이후 사후 정리', small)
    add('작업 전. 사진 목록의 경로를 앨범이 직접 읽었고, PNG와 목록 사이의 중단 및 복구 경계가 부족했습니다. 변경. 검증된 owner 경로로만 읽으며 원본·unknown 필드를 보존하고 COMMITTED 뒤에만 저장 성공을 반환합니다. 과도한 크기는 읽기와 쓰기에서 같은 기준으로 거부합니다.')
    picture(SOURCE_PATHS[9], max_height=300)
    add('이번 실제 실행 캡처. 격리된 게임의 촬영 버튼 → PNG/목록 저장 → 같은 항해의 Album overlay. 작은 카드의 사진은 실제 viewport이며 단색 테스트 이미지가 아닙니다. 최종 아트·이동감·Human 승인을 의미하지 않습니다.', small)
    add('검증. 854fdce의 headless 65개 실패 0. Windows junction 차단·손상 PNG 원본 보존·Album 정상/위조 경로를 검사했습니다. 실제 촬영 PNG 567,869 bytes를 3회 읽은 비용은 이 Windows/RTX 3050 GL Compatibility에서 136.498ms였습니다. 서로 다른 사진 3장이나 모바일의 성능 합격 판정은 아닙니다.', small)
    add('입력 근거는 현재 대화의 “남은작업 확인하고 작업 계속해”, “작업재개”입니다. 원문 화면 캡처를 재현하지 않았습니다. 상세 교정·최종 검토 및 플랫폼 제한은 저장 보호 REVIEW.md를 따릅니다. 이 화면만으로 모든 저장 실패 UI·사진 상세가 완성되었다고 판단하지 않습니다.', small)
    page('06 / 이번 운영 지시 반영 - MLB-D01')
    add('현재 대화에서 제공된 사용자 요청을 발행 시점에 기록. 과거 작업일로 소급하지 않음.', small)
    add('입력 원문 발췌 - 대화에서 제공된 텍스트이며 화면 캡처가 아님', sub)
    add('“작업재개,그리고 앞으로 이미지 생성시 크로마키 배경으로 만든 후 배경제거해.”')
    add('“C:\\Users\\user\\Documents\\증빙서류\\9월 증빙서류 에 해당 프로젝트 이름으로 PDF를 추가로 만들거야.”')
    add('반영 1. 독립 요소는 이미지 모델의 단색 크로마키 원본에서 RGBA를 추출하고 실제 alpha·가장자리 색 번짐·내부 색 보존·상태별 pivot·실제 합성을 확인하도록 프로젝트 지침에 연결했습니다. 하늘과 바다 배경은 별도 불투명 레이어입니다. 이번 작업에서 새 게임 이미지를 생성하지 않았습니다.')
    add('반영 2. 기존 기록으로 월간 PDF와 원본 hash 색인을 만드는 발행기를 추가했습니다. 이미 존재하는 발행 버전을 덮어쓰지 않습니다. 영수증이나 전체 대화 내용을 자동 복사하지 않습니다.')
    add('사용 예. 다음 검증 단위를 마친 뒤 원래 코드·검증 owner를 갱신하고, 새 버전 번호와 변경 사유로 다시 발행합니다. 별도의 매일 장문 기획 문서를 만들지 않습니다. PDF 발행은 구현·승인·제출과 별개입니다.')
    add('참고 텍스트의 한계. 사용자가 붙여준 메일·협약 설명은 문서 운영 참고입니다. 원본 메일·협약서·신청서와 대조하지 않았고 지원금·시작일·법적 의무·비용 인정 여부를 확정하지 않았습니다.')
    page('07 / 제출 전 증빙 공백과 상태 구분')
    table([['항목','현재 상태','보완할 실제 자료'],['AI 계정·서비스','미확인','해당 솔루션 계정 식별정보. 비밀번호·결제 전체 번호 제외'],
           ['입력과 결과 화면','일부 manifest 입력·후보만 확인','실제 요청 화면과 결과 화면 또는 원본 로그 발췌. 재현 화면으로 과거를 위장하지 않기'],
           ['작업 시각','Git 메타데이터 / 사후 정리','당시 원본 대화·자동 로그의 시각. 없으면 작업일 미확인 유지'],
           ['결제 연결','미검토·미합산','월간 영수증 ID 하나를 여러 작업이 참조. 같은 결제 중복 합산 금지'],
           ['협회 양식·인정 범위','확인하지 않음','협회 지정 양식 및 비용 인정 안내. PDF로 대체하지 않기'],
           ['인간 검수·최종 승인','별도 미실시','사용자가 선언할 때 실제 플레이·최종 아트 검수 기록'],
           ['제출','NOT_SUBMITTED','개인정보 검토 뒤 사용자가 제출. 자동 메일·서명 없음']], [94,120,281])
    add('문서 검수 / 코드 자동검사 / 실행 화면 / 기기 검증 / Human UX / 사용자 승인 / 출시를 별개로 관리합니다. 이 문서는 현재 증거의 색인으로 사용할 수 있지만 계정별 입력·결과 화면과 정산 요건을 모두 갖춘 제출 완결본은 아닙니다.')
    add('보안·정정 원칙. 전체 대화 로그와 결제 원본은 자동 수록하지 않았습니다. 제출한 버전에서 오류를 발견하면 기존 파일을 남기고 새 정정본·이유를 기록합니다. 월중 새 작업을 추가하는 발행도 새 버전을 사용합니다.')
    page('08 / 원본 위치와 해시 색인')
    add('저장소 기준 경로. '+str(ROOT), small)
    add('상세 JSON은 같은 이름의 .sources.json 파일입니다. 전체 Git 목록과 작성/커밋 시각, 발행일, source head, 파일 크기와 SHA-256을 포함합니다. 해시는 동일 파일 확인 수단이며 파일 제작일의 공인 인증이 아닙니다.', small)
    for source in sources:
        add(source['path'], sub)
        add('SHA-256 '+source['sha256']+'\n마지막 관련 Git 기록 '+source['last_commit'], small)
    add('기존 Blueprint 원본은 docs/design/PROJECT_GDD.md 및 기존 PDF 발행 경로를 따릅니다. 본 보고서는 게임 기획 전체나 블루프린트를 복제하지 않습니다.', small)
    def footer(canvas, doc):
        canvas.setFont('MLB', 8)
        canvas.setFillColor(teal)
        canvas.drawString(44, 27, 'my little boat | AI 활용 작업일지·증빙집 | 사후 정리·미제출')
        canvas.drawRightString(551, 27, str(doc.page))
    args.output_dir.mkdir(parents=True, exist_ok=True)
    SimpleDocTemplate(str(pdf_path), pagesize=(595,842), leftMargin=50,rightMargin=50,
                      topMargin=45,bottomMargin=48,title='my little boat - AI 활용 작업일지·증빙집',
                      author='my little boat project').build(story,onFirstPage=footer,onLaterPages=footer)
    snapshot['pdf_sha256'] = digest(pdf_path)
    with source_path.open('x', encoding='utf-8') as stream:
        json.dump(snapshot, stream, ensure_ascii=False, indent=2)
    print(json.dumps({'pdf':str(pdf_path),'sources':str(source_path),'commits':len(commits),'sha256':snapshot['pdf_sha256']},ensure_ascii=False))

if __name__ == '__main__':
    main()
