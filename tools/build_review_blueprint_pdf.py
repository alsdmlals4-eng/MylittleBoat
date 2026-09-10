# 현재 GDD와 후보 자산을 읽어 승인 전 사람용 블루프린트를 출판한다.
from pathlib import Path
import hashlib
import json
import re
from xml.sax.saxutils import escape
from reportlab.pdfgen import canvas
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Image, PageBreak, KeepTogether, KeepInFrame, Flowable
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.colors import HexColor
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from PIL import Image as PILImage

ROOT = Path(__file__).resolve().parents[1]
GDD = ROOT / 'docs/design/PROJECT_GDD.md'
OUT = ROOT / 'output/pdf/MY_LITTLE_BOAT_HUMAN_BLUEPRINT_20260911_REVIEW.pdf'
MANIFEST = ROOT / 'docs/visual/candidates/2026-09-11-blueprint/manifest.json'
W,H = 1200,800
INK, TEAL, PAPER, MIST = map(HexColor, ['#193f48','#417f88','#f8f5ed','#e8f0ed'])
pdfmetrics.registerFont(TTFont('MLB', r'C:/Windows/Fonts/malgun.ttf'))
pdfmetrics.registerFont(TTFont('MLBB', r'C:/Windows/Fonts/malgunbd.ttf'))
STYLE = ParagraphStyle('body',fontName='MLB',fontSize=16,leading=26,textColor=INK,wordWrap='CJK',spaceAfter=13)
SMALL = ParagraphStyle('small',parent=STYLE,fontSize=12,leading=18,spaceAfter=8)
CELL = ParagraphStyle('cell',parent=STYLE,fontSize=14,leading=20,spaceAfter=0)
HEAD = ParagraphStyle('head',parent=STYLE,fontName='MLBB',fontSize=29,leading=39,spaceAfter=22)
SUB = ParagraphStyle('sub',parent=STYLE,fontName='MLBB',fontSize=19,leading=28,spaceAfter=14)
images_used = {}

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def markup(s):
    s = escape(s.strip()).replace('–','-').replace('—','-')
    s = re.sub(r'\[([^\]]+)\]\((https?://[^)]+)\)',r'<link href="\2" color="#417f88">\1</link>',s)
    s = re.sub(r'\*\*([^*]+)\*\*',r'<b>\1</b>',s)
    return s.replace('`','')

def p(s,style=STYLE):
    return Paragraph(markup(s),style)

def table(rows):
    n=len(rows[0]); widths=[1080/n]*n
    if n==4: widths=[190,285,305,300]
    if n==3: widths=[215,420,445]
    t=Table([[p(x,CELL) for x in row] for row in rows],colWidths=widths,repeatRows=1,hAlign='LEFT')
    t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),MIST),('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),12),('RIGHTPADDING',(0,0),(-1,-1),12),('TOPPADDING',(0,0),(-1,-1),8),('BOTTOMPADDING',(0,0),(-1,-1),8),('LINEBELOW',(0,0),(-1,0),1,TEAL),('LINEBELOW',(0,1),(-1,-1),.4,HexColor('#cfdbd7')),('ROWBACKGROUNDS',(0,1),(-1,-1),[PAPER,HexColor('#ffffff')])]))
    return t

def section(src, title):
    m=re.search(r'^#{3,4} '+re.escape(title)+r'\s*$',src,re.M)
    if not m: raise ValueError('Missing source section: '+title)
    tail=src[m.end():]; end=re.search(r'^#{1,4} ',tail,re.M)
    return tail[:end.start()] if end else tail

def parse(body):
    lines=body.splitlines(); out=[]; i=0
    while i<len(lines):
        s=lines[i].strip()
        if not s: i+=1; continue
        if s.startswith('```'):
            code=[];i+=1
            while i<len(lines) and not lines[i].startswith('```'):
                code.append(lines[i]);i+=1
            out.append(p(' → '.join(x.strip() for x in code if x.strip()),SMALL));i+=1;continue
        if s.startswith('|'):
            rows=[]
            while i<len(lines) and lines[i].strip().startswith('|'):
                row=[x.strip() for x in lines[i].strip().strip('|').split('|')]
                if not all(re.fullmatch(r'[-: ]+',x) for x in row): rows.append(row)
                i+=1
            if any(len(r)!=len(rows[0]) for r in rows): raise ValueError('ragged table')
            out.extend([table(rows),Spacer(1,18)]);continue
        out.append(p(s[2:] if s.startswith('- ') else s));i+=1
    return out

def figure(path,w,h):
    full=ROOT/path
    if not full.is_file(): raise FileNotFoundError(full)
    images_used[path]=sha(full)
    with PILImage.open(full) as im: iw,ih=im.size
    k=min(w/iw,h/ih)
    return Image(str(full),width=iw*k,height=ih*k,hAlign='CENTER')

def header(c,d):
    c.setFillColor(PAPER);c.rect(0,0,W,H,fill=1,stroke=0)
    c.setFillColor(TEAL);c.setFont('MLBB',12);c.drawString(60,H-35,'MY LITTLE BOAT / 사람용 블루프린트')
    c.setStrokeColor(HexColor('#c7d8d3'));c.line(60,49,W-60,49)
    c.setFillColor(INK);c.setFont('MLB',10)
    c.drawString(60,28,'2026.09.11 · 검토본 / 신규 게임 적용 전 · 최종 승인 대기')
    c.drawRightString(W-60,28,f'{d.page:02d}')

class Doc(SimpleDocTemplate):
    def afterFlowable(self,flow):
        if isinstance(flow,Paragraph) and flow.style.name=='head':
            name='ch-'+str(self.page)+'-'+str(len(self.canv._doc.idToObject))
            self.canv.bookmarkPage(name)
            self.canv.addOutlineEntry(flow.getPlainText(),name,level=0)

class FlowMap(Flowable):
    """기획 상태 관계만 그리는 수정 가능한 도식이며 게임 원화를 대신하지 않는다."""
    def __init__(self):
        super().__init__();self.width=1080;self.height=360
    def draw(self):
        c=self.canv
        nodes=[(0,230,'타이틀 대기','진행 0 / 부유만'),(280,230,'항해 시작','입력 한 번'),(560,230,'나란히 쉬기','foreground 시간'),(840,230,'계속 쉬기','강제 종료 없음'),(280,55,'꾸미기 · 앨범','world 동결 / 소리 유지'),(560,55,'감상 · 둘러보기','진행·phase 유지'),(840,55,'앱 비활성','진행 동결 / catch-up 없음')]
        c.setStrokeColor(TEAL);c.setLineWidth(2)
        for x in [230,510,790]:
            c.line(x,278,x+45,278);c.line(x+45,278,x+35,283);c.line(x+45,278,x+35,273)
        c.line(395,190,955,190)
        c.line(675,190,675,230)
        c.line(675,230,670,220);c.line(675,230,680,220)
        for x in [395,675,955]:
            c.line(x,150,x,190)
            c.line(x,150,x-5,160);c.line(x,150,x+5,160)
        for x,y,title,detail in nodes:
            c.setFillColor(MIST);c.roundRect(x,y,230,95,12,fill=1,stroke=0)
            c.setFillColor(INK);c.setFont('MLBB',18);c.drawCentredString(x+115,y+58,title)
            c.setFont('MLB',12);c.drawCentredString(x+115,y+28,detail)

def build():
    src=GDD.read_text(encoding='utf-8');story=[]
    def page(title,body=None):
        if story:story.append(PageBreak())
        story.append(p(title,HEAD))
        if body:
            parts=parse(body)
            total=sum(x.wrap(1080,10000)[1]+x.getSpaceBefore()+x.getSpaceAfter() for x in parts)
            # 짧은 꼬리 문단만 다음 장에 남지 않게 제한 범위 안에서 맞춘다.
            if 575 < total <= 720:
                story.append(KeepInFrame(1080,575,parts,mode='shrink'))
            else:
                story.extend(parts)
    page('파도 위에서, 함께 쉬는 시간')
    cover='docs/visual/candidates/2026-09-10-intimate-diorama/stern-staging-no-oars-v3.png'
    story.append(Table([[figure(cover,380,550),[p('MY LITTLE BOAT',HEAD),p('목적지 없이, 작은 배에서 동반자와 쉬는 게임.'),p('전체 기획 · 화면 아틀라스 · 상세 SWOT\n시스템 · 데이터 · 분리 자산 · 모션 · 구현 지도'),p('읽기 전 중요한 구분',SUB),p('이 문서는 최종 승인 전 검토본입니다. 원화와 기획이 있다는 사실은 회전 가능한 모델·리그·실제 게임 완성을 뜻하지 않습니다.'),p('코어·후면 좌석·노 없음은 유지합니다. 새 후보 이미지의 실제 사용 규격과 미준비 항목을 아틀라스에서 구분합니다.'),p('참고 PDF는 다른 프로젝트의 구성 방식만 참고했으며, 전투·성장 체계는 가져오지 않았습니다.',SMALL)]]],colWidths=[430,650],style=[('VALIGN',(0,0),(-1,-1),'TOP')] ))
    page('화면 아틀라스 · 무엇을 어디서 하는가')
    cards=[('01 타이틀','보트 + 로고 + 항해 시작','시작 전 항해 시간 0'),('02 휴식','후면 보트 + 옆 동반자 + 바다','아무것도 하지 않아도 충분'),('03 쉬는 메뉴','사진·감상 / 꾸미기·앨범 / 설정','작은 메뉴 동안 같은 항해'),('04 둘러보기·감상','수동 각도 / 바다 중심 / 기본 시점','시간·기록·소리 유지'),('05 꾸미기','외형 / 동반자 / 장식 preview','적용 또는 취소'),('06 앨범','실제 사진 / 풍경 / 개인 기억','메인에는 기록 카드 없음'),('07 낚시','기다리기 / 낚기 / 거두기','시간 제한·실패 없음'),('08 소리·편안함','음량 / 음소거 / 모션 저감','still에서도 수동 조작 유지')]
    cells=[[p(a,SUB),p(b,CELL),Spacer(1,8),p(c,SMALL)] for a,b,c in cards]
    t=Table([cells[:4],cells[4:]],colWidths=[270]*4,rowHeights=[210,210]);t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,-1),MIST),('BOX',(0,0),(-1,-1),1,TEAL),('INNERGRID',(0,0),(-1,-1),8,PAPER),('VALIGN',(0,0),(-1,-1),'TOP'),('TOPPADDING',(0,0),(-1,-1),22),('LEFTPADDING',(0,0),(-1,-1),17)]));story.append(t)
    story.extend([Spacer(1,20),p('이 아틀라스는 수정 가능한 화면 구조도입니다. 게임 실행 캡처가 아닙니다. 각 화면의 세부 입력·복귀 규칙은 B5, 시간의 동결 규칙은 P2를 함께 읽습니다.',SMALL)])
    page('읽는 지도 · 승인할 것과 검증할 것', '경험과 전략 → 화면·시스템 → 데이터 → 아트·모션 → 저장·오류 → 구현·검수 순서로 읽습니다. PDF 왼쪽 책갈피에서 해당 장으로 이동할 수 있습니다.\n\n코어 방향은 승인됐습니다. 세부 수치는 권장 시험값입니다. 신규 이미지 후보는 최종 시각 승인 전이며, 실제 게임 적용은 전체 Blueprint 승인 후입니다.\n\n문서 정본은 PROJECT_GDD.md, 자산 파일·해시는 candidate manifest와 visual inventory, 실제 게임 상태는 CURRENT_GODOT_IMPLEMENTATION.md가 책임집니다. 이 PDF는 원본과 해시로 묶인 파생 자료입니다.\n\n최종 구현 준비의 남은 핵심은 실제 근거리 3D 모델·리그와 모션입니다. 필요한 원화만으로 이 항목을 완료 처리하지 않습니다.')
    titles=['P1. 제품 약속·세계관·플레이 범위','B1. 상세 SWOT — 지킬 강점과 강화 방식','B2. 상세 SWOT — 약점과 개선 우선순위','B3. 상세 SWOT — 기회와 위험의 실행 전략','B4. SWOT 교차 전략과 독창성','10개 벤치마크의 채택·변형·제외','P2. 화면·입력·연속성','B5. 화면 아틀라스의 책임과 입력','B6. 시스템 연결과 상태 데이터','B7. 콘텐츠·조정값 데이터 표','P4. 캐릭터·동반자·꾸미기·선택 행동','P5. 카메라·공간·아트 생산 방식']
    for title in titles:
        body=section(src,title)
        if title.startswith('P2.'):
            first,second=body.split('상태 우선순위',1)
            page(title,first)
            page('P2. 복귀·동결·중복 입력의 처리','상태 우선순위'+second)
        elif title.startswith('B7.'):
            first,second=body.split('| 기존 motif ID',1)
            page(title,first)
            page('B7. 풍경 목록 · 보트는 바다만 지난다','| 기존 motif ID'+second)
        else:page(title,body)
    page('공간 플로우맵 · 같은 배, 다른 책임')
    story.append(FlowMap())
    story.append(p('전체 overlay·앱 비활성에서 돌아올 때 새 항해를 만들지 않습니다. 완전히 종료한 뒤 재실행할 때만 타이틀로 진입하며 개인 기억과 취향을 복원합니다. 구조 설명용 도식입니다.'))
    page('시스템 책임 지도 · 진행과 표현을 분리')
    story.append(table([['층','연결 방향','멈추는 조건'],['UI / Overlay','입력 → 기능 의도 → GameState 또는 Camera','world가 멈춰도 뒤로·설정은 동작'],['진행','Start → foreground clock → record/scenery','title·full overlay·app inactive'],['공간','shared phase → water / boat / contact / distant scenery','comfort·overlay·app inactive를 함께 적용'],['동행','boat anchors → player / pet → 작은 반응','별도 random root 이동 금지'],['기억','실제 frame → PNG → metadata → Album','저장 실패는 기존 기억 보호'],['소리','독립 ocean bed → volume/mute → 출력','앱 이탈 정책. 메뉴 전환으로 restart 금지']]))
    story.extend([Spacer(1,20),p('진행 데이터, 시각 위상, 소리 연속성은 서로 다른 검사 대상입니다. 하나가 보존됐다고 나머지까지 PASS로 쓰지 않습니다.')])
    manifest=json.loads(MANIFEST.read_text(encoding='utf-8'))
    for group in manifest['atlas_groups']:
        page(group['title'])
        entries=[a for a in manifest['assets'] if a['asset_id'] in group['asset_ids']]
        row=[]
        for a in entries:
            row.append([figure(a['path'],1000/len(entries),365),Spacer(1,12),p(a['asset_id']+' · '+a['label'],SUB),p(a['purpose'],CELL),p(a['state']+' / '+a['finding'],SMALL)])
        story.append(Table([row],colWidths=[1080/len(row)]*len(row),style=[('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),12),('RIGHTPADDING',(0,0),(-1,-1),12)]))
    for title in ['B9. 자산 아틀라스와 실제 납품 계약','B10. 모션·3D 제작 패키지','P6. 모션·물·빛의 역할과 상태군','P7. 소리·문구·접근성','B8. 저장 계약과 오류 시나리오','B11. 구현 패키지별 즉시 착수 조건','B12. 검수표·추가/수정/폐기·연구 범위']:
        page(title,section(src,title))
    page('최종 검토 경계 · 무엇이 아직 남았는가')
    story.append(table([['항목','현재 이 자료가 제공하는 것','아직 완료가 아닌 것'],['기획','P1–P10 + B1–B12, 실제 owner·입력·오류·검수 연결','사용자의 전체 Blueprint 최종 승인'],['시각','분리 source/candidate, 실제 규격·해시·발견사항','모든 시간대·종·외형·모션의 새 최종 자산'],['3D / motion','접점·clip·회전·왕복 검수 명세','승인 외형의 모델·리그·변형 품질'],['게임','기존 코드·데이터와 새 구현 패키지 대응','새 production 적용·새 runtime·기기 성능'],['안전 / 품질','local-first·복구·social gate·검수 계획','Human 편안함·권리 최종 확인·공개 출시']]))
    story.extend([Spacer(1,20),p('권장 순서는 기획 검토 → 미준비 근거리 자산의 제작 가능성 해소 → 전체 시각·기획 최종 승인 → IMP-01부터 구현입니다. 준비된 문서와 실제 없는 파일을 구분한 채 진행합니다.')])
    OUT.parent.mkdir(parents=True,exist_ok=True)
    Doc(str(OUT),pagesize=(W,H),leftMargin=60,rightMargin=60,topMargin=70,bottomMargin=70,allowSplitting=1,title='MY LITTLE BOAT - Human Blueprint Review',author='My Little Boat').build(story,onFirstPage=header,onLaterPages=header)
    from pypdf import PdfReader
    snap=OUT.with_suffix('.source.md');snap.write_text(src,encoding='utf-8',newline='\n')
    receipt={'status':'REVIEW_DRAFT_NOT_FULL_ASSET_READY','artifact':OUT.relative_to(ROOT).as_posix(),'source_snapshot':snap.relative_to(ROOT).as_posix(),'gdd_sha256':sha(GDD),'snapshot_sha256':sha(snap),'generator_sha256':sha(Path(__file__)),'manifest_sha256':sha(MANIFEST),'images':images_used,'page_count':len(PdfReader(OUT).pages),'output_sha256':sha(OUT),'runtime':'NOT_RUN_NO_PRODUCTION_CHANGE','human':'NOT_RUN','final_approval':'PENDING'}
    OUT.with_suffix('.receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'pdf':str(OUT),'pages':receipt['page_count'],'image_count':len(images_used)},ensure_ascii=False))

if __name__=='__main__':build()
