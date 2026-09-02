from __future__ import annotations

import hashlib
import json
import re
import unittest
from pathlib import Path

from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[1]
GDD = ROOT / "docs/design/PROJECT_GDD.md"
POINTER = ROOT / "docs/design/PROJECT_AI_PRODUCTION_SPEC.md"
MAP = ROOT / "docs/DOCUMENTATION_MAP.md"
HANDOFF = ROOT / "docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md"
BLUEPRINT_BUILDER = ROOT / "tools/build_human_blueprint_pdf.py"

STALE_PDF = "exports/my-little-boat_MASTER_PRODUCTION_GDD_20260829.pdf"
HISTORICAL_PDF = "exports/my-little-boat_MASTER_PRODUCTION_GDD_20260828.pdf"
CURRENT_BLUEPRINT_PDF = "output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.pdf"
CURRENT_BLUEPRINT_RECEIPT = "output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.receipt.json"
TITLE_IDLE_CAPTURE = "docs/evidence/2026-08-31-title-boat-flow/bright_title_idle_00_540x960.png"


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8") if path.is_file() else ""


class HumanGameBlueprintProfileTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.gdd = read(GDD)
        cls.pointer = read(POINTER)
        cls.doc_map = read(MAP)

    def test_current_master_and_source_bound_publication_boundaries(self) -> None:
        self.assertIn("CURRENT_HUMAN_FACING_GDD", self.gdd)
        self.assertIn("SUPERSEDED_AS_CURRENT_GDD", self.pointer)
        self.assertIn("PROJECT_GDD.md", self.doc_map)
        self.assertIn("PROJECT_AI_PRODUCTION_SPEC.md", self.doc_map)
        self.assertIn("SUPERSEDED_POINTER_NOT_EDITING_MASTER", self.doc_map)
        self.assertTrue((ROOT / STALE_PDF).is_file())
        self.assertTrue((ROOT / HISTORICAL_PDF).is_file())
        self.assertTrue((ROOT / CURRENT_BLUEPRINT_PDF).is_file())
        self.assertTrue((ROOT / CURRENT_BLUEPRINT_RECEIPT).is_file())
        self.assertTrue(BLUEPRINT_BUILDER.is_file())
        self.assertIn(
            f"`{CURRENT_BLUEPRINT_PDF}` = `CURRENT_SOURCE_BOUND_DERIVED_PUBLICATION`",
            self.gdd,
        )
        self.assertIn(
            f"`{HISTORICAL_PDF}` = `HISTORICAL_DERIVED_NOT_CURRENT_SOURCE`",
            self.gdd,
        )
        self.assertIn(
            f"`{STALE_PDF}` = `HISTORICAL_STALE_PUBLICATION_NOT_CURRENT_SOURCE`",
            self.gdd,
        )
        self.assertIn("CURRENT_BLUEPRINT_PLAYER_FACING_SELECTION", self.gdd)
        self.assertIn("CURRENT_SOURCE_BOUND_DERIVED_PUBLICATION", self.doc_map)
        self.assertNotIn("PDF_REISSUE_DEFERRED", self.gdd)
        handoff = read(HANDOFF)
        self.assertIn("BLUEPRINT_PUBLICATION_RECOVERY_20260902", handoff)
        self.assertIn("five complete review loops", handoff)

    def test_publication_receipt_binds_current_gdd_and_exact_visual_inputs(self) -> None:
        receipt_path = ROOT / CURRENT_BLUEPRINT_RECEIPT
        self.assertTrue(receipt_path.is_file())
        if not receipt_path.is_file():
            return
        receipt = json.loads(receipt_path.read_text(encoding="utf-8"))
        self.assertEqual(receipt["gdd_sha256"], sha256_file(GDD))
        self.assertEqual(receipt["generator_sha256"], sha256_file(BLUEPRINT_BUILDER))
        self.assertEqual(receipt["page_count"], 10)
        self.assertIn(TITLE_IDLE_CAPTURE, receipt["images"])
        self.assertEqual(receipt["images"][TITLE_IDLE_CAPTURE], sha256_file(ROOT / TITLE_IDLE_CAPTURE))
        self.assertEqual(receipt["output_sha256"], sha256_file(ROOT / CURRENT_BLUEPRINT_PDF))
        self.assertTrue(receipt["source_revision"].startswith("content-bound:"))

    def test_published_blueprint_selects_current_player_facing_route(self) -> None:
        pdf_path = ROOT / CURRENT_BLUEPRINT_PDF
        self.assertTrue(pdf_path.is_file())
        if not pdf_path.is_file():
            return
        publication_text = "\n".join((page.extract_text() or "") for page in PdfReader(str(pdf_path)).pages)
        for token in ("타이틀 대기", "항해 시작", "하늘은 고정", "바다만 흐름", "Human / Device NOT_RUN"):
            self.assertIn(token, publication_text)
        self.assertNotIn("구현 전", publication_text)
        self.assertNotIn("8.1.1 Preimplementation", publication_text)

    def test_layered_route_status_and_cards(self) -> None:
        tokens = (
            "HUMAN_GAME_BLUEPRINT_GDD_LAYERED_PROFILE",
            "NO_SEPARATE_BLUEPRINT_ARTIFACT",
            "PROJECT_PLAYER_LAYER",
            "SYSTEM_LAYER",
            "CONTENT_UX_PRESENTATION_LAYER",
            "PRODUCTION_EVIDENCE_LAYER",
            "3-MINUTE PROJECT / PLAYER READ",
            "10-MINUTE SYSTEM + CONTENT / UX / PRESENTATION READ",
            "DETAIL READ",
            "IMPLEMENTATION READ",
            "VERIFICATION READ",
            "STATE_AND_EVIDENCE_LEGEND",
            "REUSABLE_FLOW_AND_SYSTEM_CARDS",
            "LAYERED_TRACEABILITY_REQUIRED",
        )
        for token in tokens:
            self.assertIn(token, self.gdd)
        for token in tokens[:11]:
            self.assertIn(token, self.doc_map)
        positions = [self.gdd.index(token) for token in tokens[6:11]]
        self.assertEqual(positions, sorted(positions))

    def test_first_five_is_nominal_and_extended_stay_is_optional(self) -> None:
        self.assertIn("FIRST_5_MINUTES_NOMINAL_SESSION_HYPOTHESIS", self.gdd)
        self.assertIn("actual-device calmness `NOT_RUN`", self.gdd)
        self.assertIn(
            "FIRST_15_30_MINUTES_CONDITIONAL_OPTIONAL_EXTENDED_STAY_NOT_FORCED_MILESTONES",
            self.gdd,
        )
        first_contract = self.gdd.split("### 첫 5·15·30분 truth table", 1)[1].split(
            "## 4.", 1
        )[0]
        self.assertRegex(first_contract, r"\| 첫 5분 \|.*명목상.*\|.*NOT_RUN.*\|")
        self.assertRegex(first_contract, r"\| 첫 15분 \|.*선택적.*\|.*NOT_RUN.*\|")
        self.assertRegex(first_contract, r"\| 첫 30분 \|.*선택적.*\|.*NOT_RUN.*\|")
        self.assertNotIn("required milestone", first_contract.lower())

    def test_evidence_ceiling_keeps_relationship_and_device_unknown(self) -> None:
        self.assertIn("### Blueprint evidence ceiling", self.gdd)
        evidence = self.gdd.split("### Blueprint evidence ceiling", 1)[1].split(
            "## 8.", 1
        )[0]
        required = (
            "Direct boat entry | `IMPLEMENTED_AND_GPU_CAPTURED`",
            "Real-time atmosphere | `IMPLEMENTED_AND_TESTED`; GPU capture exists",
            "Foreground scenery | `IMPLEMENTED_AND_GPU_CAPTURED`",
            "Ambient memory | `IMPLEMENTED_AND_TESTED`",
            "Relationship/shared-time expression | `IMPLEMENTED_AND_TESTED`; Album GPU capture exists",
            "Device first 30 seconds / 5 minutes | `NOT_RUN`",
            "Touch / audio / notification intensity | `NOT_RUN`",
        )
        for row in required:
            self.assertIn(row, evidence)
        self.assertNotIn("HUMAN_PASS", evidence)
        self.assertNotIn("DEVICE_PASS", evidence)

    def test_future_packages_require_final_approval_without_retroactive_rollback(self) -> None:
        lifecycle = (
            "PLAN -> REQUIRED_IMAGE_AND_MATERIAL_PREPARATION -> "
            "BLUEPRINT_REVIEW_PUBLICATION -> USER_FINAL_REVIEW_APPROVAL -> IMPLEMENTATION"
        )
        tokens = (
            lifecycle,
            "NO_IMPLEMENTATION_BEFORE_USER_FINAL_APPROVAL",
            "PROSPECTIVE_ONLY_EXISTING_IMPLEMENTATION_EVIDENCE_PRESERVED",
            "PROSPECTIVE_ONLY_PREEXISTING_EXACT_USER_APPROVED_IMPLEMENTATION_AUTHORITY_PRESERVED",
            "EXACT_APPROVED_SCOPE_AND_REVISION_ONLY",
            "SCOPE_EXPANSION | SUCCESSOR_PACKAGE | INFERRED_BLANKET_APPROVAL",
            "IMAGE_MODEL_REQUIRED_FOR_IMAGE_CREATION_OR_EDITING",
            "TEXT_NATIVE_EXACT_DIAGRAMS",
            "STRUCTURED_INFORMATION_ARTIFACTS_REMAIN_TEXT_NATIVE",
        )
        for owner in (self.gdd, self.doc_map):
            for token in tokens:
                self.assertIn(token, owner)


if __name__ == "__main__":
    unittest.main()
