from __future__ import annotations

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GDD = ROOT / "docs/design/PROJECT_GDD.md"
POINTER = ROOT / "docs/design/PROJECT_AI_PRODUCTION_SPEC.md"
MAP = ROOT / "docs/DOCUMENTATION_MAP.md"

CURRENT_PDF = "exports/my-little-boat_MASTER_PRODUCTION_GDD_20260829.pdf"
HISTORICAL_PDF = "exports/my-little-boat_MASTER_PRODUCTION_GDD_20260828.pdf"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8") if path.is_file() else ""


class HumanGameBlueprintProfileTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.gdd = read(GDD)
        cls.pointer = read(POINTER)
        cls.doc_map = read(MAP)

    def test_current_master_and_publication_boundaries(self) -> None:
        self.assertIn("CURRENT_HUMAN_FACING_GDD", self.gdd)
        self.assertIn("SUPERSEDED_AS_CURRENT_GDD", self.pointer)
        self.assertIn("PROJECT_GDD.md", self.doc_map)
        self.assertIn("PROJECT_AI_PRODUCTION_SPEC.md", self.doc_map)
        self.assertIn("SUPERSEDED_POINTER_NOT_EDITING_MASTER", self.doc_map)
        self.assertTrue((ROOT / CURRENT_PDF).is_file())
        self.assertTrue((ROOT / HISTORICAL_PDF).is_file())
        self.assertIn(
            f"`{CURRENT_PDF}` = `TRACKED_LATEST_PUBLICATION_SOURCE_BINDING_UNVERIFIED`",
            self.gdd,
        )
        self.assertIn(
            f"`{HISTORICAL_PDF}` = `HISTORICAL_DERIVED_NOT_CURRENT_SOURCE`",
            self.gdd,
        )
        self.assertIn("PDF_REISSUE_DEFERRED", self.gdd)

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
            "Relationship/shared-time expression | `CONFIRMED_NOT_IMPLEMENTED`",
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
