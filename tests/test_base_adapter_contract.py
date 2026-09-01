# 프로젝트용 Base adapter와 재사용 모듈 상태를 검증한다.
from __future__ import annotations

import json
import unittest
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]
ADAPTER_PATH = PROJECT_ROOT / "docs" / "operations" / "MY_LITTLE_BOAT_BASE_ADAPTER.json"
REUSE_MANIFEST_PATH = PROJECT_ROOT / "docs" / "base-reuse-adoption.json"
AGENTS_PATH = PROJECT_ROOT / "AGENTS.md"
DOCUMENTATION_MAP_PATH = PROJECT_ROOT / "docs" / "DOCUMENTATION_MAP.md"
HANDOFF_PATH = PROJECT_ROOT / "docs" / "handoffs" / "CURRENT_GODOT_IMPLEMENTATION.md"


def load_json(path: Path) -> dict[str, object]:
    return json.loads(path.read_text(encoding="utf-8"))


class BaseAdapterContractTests(unittest.TestCase):
    def test_adapter_pins_v944_and_existing_project_owners(self) -> None:
        adapter = load_json(ADAPTER_PATH)
        self.assertEqual(adapter["schema_version"], 1)

        release = adapter["base_release"]
        self.assertEqual(release["version"], "9.4.4")
        self.assertEqual(
            release["release_commit"],
            "210ec78292fa12ed7563ba743b322dd36103ae4a",
        )
        self.assertEqual(
            release["release_evidence_commit"],
            "bb61e68dc3028421b60c11b87ba2abd297ee6f78",
        )
        self.assertEqual(
            release["finalization_commit"],
            "5adc196c0185951f50e49ab5e51586eff8d60886",
        )

        for owner in adapter["project_owner_paths"]:
            self.assertTrue(
                (PROJECT_ROOT / owner).is_file(),
                f"adapter owner path is missing: {owner}",
            )

    def test_enabled_reuse_module_has_a_real_project_destination(self) -> None:
        manifest = load_json(REUSE_MANIFEST_PATH)
        for module_id, configuration in manifest["modules"].items():
            if configuration["state"] != "enabled":
                continue
            destination = configuration.get("destination")
            self.assertIsInstance(destination, str, f"{module_id} needs a destination")
            self.assertTrue(
                (PROJECT_ROOT / destination).is_file(),
                f"{module_id} is enabled without a real consumer destination: {destination}",
            )

    def test_current_routes_link_to_the_project_adapter(self) -> None:
        adapter_reference = "docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json"
        for path in (AGENTS_PATH, DOCUMENTATION_MAP_PATH, HANDOFF_PATH):
            self.assertIn(adapter_reference, path.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
