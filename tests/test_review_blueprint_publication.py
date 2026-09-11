# 새 검토용 PDF의 원본 결속·아틀라스·증거 경계를 검사한다.
import hashlib
import json
from pathlib import Path
import unittest
from PIL import Image
from pypdf import PdfReader

ROOT=Path(__file__).resolve().parents[1]
PDF=ROOT/'output/pdf/MY_LITTLE_BOAT_HUMAN_BLUEPRINT_20260911_REVIEW.pdf'
MANIFEST=ROOT/'docs/visual/candidates/2026-09-11-blueprint/manifest.json'

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

class ReviewBlueprintTests(unittest.TestCase):
    def test_receipt_binds_exact_sources(self):
        r=json.loads(PDF.with_suffix('.receipt.json').read_text(encoding='utf-8'))
        self.assertEqual(r['output_sha256'],sha(PDF))
        self.assertEqual(r['snapshot_sha256'],sha(ROOT/r['source_snapshot']))
        # Historical publication binds its immutable GDD snapshot, not later gameplay edits.
        self.assertEqual(r['gdd_sha256'],sha(ROOT/r['source_snapshot']))
        self.assertEqual(r['manifest_sha256'],sha(MANIFEST))
        for path,digest in r['images'].items():self.assertEqual(digest,sha(ROOT/path))

    def test_atlas_real_files_and_no_false_approval(self):
        m=json.loads(MANIFEST.read_text(encoding='utf-8'))
        for path,meta in m['files'].items():self.assertEqual(meta['sha256'],sha(ROOT/path))
        self.assertEqual(len(m['assets']),len({x['asset_id'] for x in m['assets']}))
        for a in m['assets']:
            self.assertEqual(a['sha256'],sha(ROOT/a['path']))
            self.assertEqual(a['approval'],'FINAL_PENDING')
            with Image.open(ROOT/a['path']) as im:self.assertEqual(list(im.size),a['dimensions'])
        self.assertTrue(m['missing'])

    def test_real_alpha_and_aseprite_roundtrip(self):
        folder=MANIFEST.parent
        with Image.open(folder/'island-rgba-v1.png') as a,Image.open(folder/'island-sheet.png') as b:
            self.assertEqual(a.mode,'RGBA')
            self.assertEqual(a.tobytes(),b.convert('RGBA').tobytes())
            alpha=a.getchannel('A');self.assertEqual(alpha.getextrema(),(0,255))
            self.assertEqual(alpha.getpixel((0,0)),0)
        data=json.loads((folder/'island-sheet.json').read_text(encoding='utf-8'))
        self.assertEqual(len(data['frames']),1)

    def test_reader_scope_coverage(self):
        reader=PdfReader(PDF); text='\n'.join(p.extract_text() for p in reader.pages)
        for label in ['SWOT','SO','WO','ST','WT','화면 아틀라스','자산 아틀라스','시스템','저장','모션','B11.','BLOCKED_UNVERIFIED','최종 승인']:
            self.assertIn(label,text)
        self.assertGreaterEqual(len(reader.pages),25)
        self.assertGreaterEqual(len(reader.outline),20)
        r=json.loads(PDF.with_suffix('.receipt.json').read_text(encoding='utf-8'))
        self.assertEqual(len(reader.pages),r['page_count'])
        self.assertEqual(r['human'],'NOT_RUN')
        self.assertEqual(r['final_approval'],'PENDING')

    def test_pdf_text_stays_on_page(self):
        try:import pymupdf
        except ImportError:self.skipTest('Optional PDF geometry inspector unavailable')
        with pymupdf.open(PDF) as doc:
            for i,page in enumerate(doc):
                self.assertGreater(len(page.get_text()),80)
                for block in page.get_text('dict')['blocks']:
                    for line in block.get('lines',[]):
                        for span in line['spans']:
                            x0,y0,x1,y1=span['bbox']
                            self.assertTrue(0<=x0<=x1<=1200 and 0<=y0<=y1<=800,(i+1,span))

if __name__=='__main__':unittest.main()
