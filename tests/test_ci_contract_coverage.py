# Godot CI가 현재 headless 계약 전체를 소비하도록 보장한다.
from __future__ import annotations

from pathlib import Path
import json
import unittest


PROJECT_ROOT = Path(__file__).resolve().parents[1]
WORKFLOW_PATH = PROJECT_ROOT / ".github" / "workflows" / "godot-validation.yml"
README_PATH = PROJECT_ROOT / "README.md"
HANDOFF_PATH = PROJECT_ROOT / "docs" / "handoffs" / "CURRENT_GODOT_IMPLEMENTATION.md"
RECOVERY_RECORD_PATH = PROJECT_ROOT / "docs" / "PROJECT_WORK_REUSE_HANDOFF.json"


class CiContractCoverageTests(unittest.TestCase):
    def test_workflow_discovers_current_contracts_with_one_display_only_exception(self) -> None:
        workflow = WORKFLOW_PATH.read_text(encoding="utf-8")
        all_contracts = sorted((PROJECT_ROOT / "tests").glob("test_*.gd"))
        display_only_contract = "test_chibi_normal_chroma_material_proof.gd"
        expected_all_contract_count = len(all_contracts)
        expected_headless_contract_count = expected_all_contract_count - 1

        self.assertIn(
            f"EXPECTED_ALL_CONTRACT_COUNT={expected_all_contract_count}", workflow
        )
        self.assertIn(
            f"DISPLAY_ONLY_CONTRACT={display_only_contract}",
            workflow,
        )
        self.assertIn("find tests -maxdepth 1 -type f -name 'test_*.gd'", workflow)
        self.assertIn(
            f"EXPECTED_HEADLESS_CONTRACT_COUNT={expected_headless_contract_count}",
            workflow,
        )

    def test_documentation_keeps_headless_ci_and_display_renderer_evidence_separate(self) -> None:
        readme = README_PATH.read_text(encoding="utf-8")
        handoff = HANDOFF_PATH.read_text(encoding="utf-8")
        record = json.loads(RECOVERY_RECORD_PATH.read_text(encoding="utf-8"))
        recovery = record["merge_integrity_recovery_2026_08_31"]
        coverage = recovery["ci_contract_coverage_2026_08_31"]
        expected_headless_contract_count = len(
            list((PROJECT_ROOT / "tests").glob("test_*.gd"))
        ) - 1

        self.assertIn(f"{expected_headless_contract_count}개", readme)
        self.assertIn("headless CI", handoff)
        self.assertIn("test_chibi_normal_chroma_material_proof.gd", handoff)
        self.assertEqual(
            coverage["headless_contract_count"], expected_headless_contract_count
        )
        self.assertEqual(
            coverage["display_only_contract"],
            "test_chibi_normal_chroma_material_proof.gd",
        )
        self.assertEqual(
            coverage["selected_approach"],
            "SORTED_DISCOVERY_WITH_EXACT_COUNT_AND_EXCLUSION_GUARDS",
        )


if __name__ == "__main__":
    unittest.main()
