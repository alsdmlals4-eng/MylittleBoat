# 기존 월간 PDF 누적 갱신의 원본 보존과 중복·제출 방지를 검사한다.
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from reportlab.pdfgen import canvas
from pypdf import PdfReader
from tools import build_ai_work_evidence_pdf as evidence


@unittest.skipUnless(Path('C:/Windows/Fonts/malgun.ttf').is_file(), 'Korean publication font unavailable')
class AppendEvidenceTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.pdf = self.root / 'monthly.pdf'
        c = canvas.Canvas(str(self.pdf))
        c.drawString(50, 700, 'ORIGINAL RECORD')
        c.save()
        self.before = self.pdf.read_bytes()
        self.receipt = self.root / 'monthly.sources.json'
        self.receipt.write_text(json.dumps(dict(pdf_sha256=hashlib.sha256(self.before).hexdigest(),
            sources=[], source_head='unused', submission_status='NOT_SUBMITTED')), encoding='utf-8')
        (self.root / 'log.md').write_text('<!-- DAILY_BEGIN -->\n### 2026-09-16\n오늘 기록.\n<!-- DAILY_END -->', encoding='utf-8')
        for args in [('init',), ('add', 'log.md'), ('-c', 'user.name=Test', '-c', 'user.email=test@example.invalid', 'commit', '-m', 'fixture')]:
            subprocess.run(['git', '-C', str(self.root), *args], check=True, capture_output=True)
        self.root_patch = patch.object(evidence, 'ROOT', self.root)
        self.root_patch.start()

    def tearDown(self):
        self.root_patch.stop()
        self.tmp.cleanup()

    def append(self):
        return evidence.append_summary(self.receipt, 'log.md', 'DAILY', self.root / 'backup')

    def test_append_preserves_pages_backup_and_verifiable_sources(self):
        self.append()
        pages = PdfReader(self.pdf).pages
        self.assertEqual(len(pages), 2)
        self.assertIn('ORIGINAL RECORD', pages[0].extract_text())
        self.assertIn('2026-09-16', pages[1].extract_text())
        self.assertEqual((self.root / 'backup' / 'monthly.pdf').read_bytes(), self.before)
        self.assertEqual(len(evidence.verify_receipt(self.receipt)), 1)

    def test_duplicate_append_refuses_without_changing_current_file(self):
        self.append()
        before = self.pdf.read_bytes()
        with self.assertRaisesRegex(ValueError, 'already appended'):
            self.append()
        self.assertEqual(self.pdf.read_bytes(), before)

    def test_submitted_report_refuses_without_creating_backup(self):
        data = json.loads(self.receipt.read_text())
        data['submission_status'] = 'SUBMITTED'
        self.receipt.write_text(json.dumps(data))
        with self.assertRaisesRegex(ValueError, 'NOT_SUBMITTED'):
            self.append()
        self.assertEqual(self.pdf.read_bytes(), self.before)
        self.assertFalse((self.root / 'backup').exists())

    def test_dirty_source_refuses_before_writes(self):
        (self.root / 'log.md').write_text('changed', encoding='utf-8')
        with self.assertRaisesRegex(ValueError, 'Commit'):
            self.append()
        self.assertEqual(self.pdf.read_bytes(), self.before)
        self.assertFalse((self.root / 'backup').exists())


if __name__ == '__main__':
    unittest.main()
