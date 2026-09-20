# 프로젝트 adapter의 실제 경로와 모듈 채택 증거 연결을 검사한다.
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADAPTER = ROOT / "docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json"


class BaseAdapterContractTests(unittest.TestCase):
    def adapter(self):
        self.assertTrue(ADAPTER.is_file(), "project adapter route has no owner")
        return json.loads(ADAPTER.read_text(encoding="utf-8"))

    def test_owner_and_conditional_routes_resolve_inside_project(self):
        adapter = self.adapter()
        paths = adapter["project_owner_paths"] + [
            route["project_owner"] for route in adapter["conditional_routes"]
        ]
        for relative in paths:
            with self.subTest(path=relative):
                path = (ROOT / relative).resolve()
                self.assertTrue(path.is_relative_to(ROOT))
                self.assertTrue(path.is_file(), f"missing route target: {relative}")

    def test_fun_binding_resolves_to_existing_owner_and_section(self):
        binding = self.adapter()["fun_verification"]
        source = (ROOT / binding["path"]).read_text(encoding="utf-8")
        self.assertIn(binding["source_id"], source)
        self.assertIn(binding["section"], source)
        for relative in binding["legacy_consumers"]:
            self.assertTrue((ROOT / relative).is_file(), relative)

    def test_shared_sources_use_explicit_revision_not_floating_main(self):
        policy = self.adapter()["operating_policy_adoption"]
        self.assertRegex(policy["source_commit"], r"^[0-9a-f]{40}$")
        for source in policy["selected_sources"]:
            self.assertEqual(source["url"],
                f"https://github.com/alsdmlals4-eng/Base/blob/{policy['source_commit']}/{source['path']}")

    def test_enabled_module_cannot_claim_missing_adoption_or_consumer(self):
        manifest = json.loads((ROOT / "docs/base-reuse-adoption.json").read_text(encoding="utf-8"))
        for key, module in manifest["modules"].items():
            if module["state"] != "enabled":
                continue
            with self.subTest(module=key):
                for field in ("destination", "adoption_lock", "consumer", "verification"):
                    relative = module.get(field)
                    self.assertIsInstance(relative, str, f"{key}: missing {field}")
                    path = (ROOT / relative).resolve()
                    self.assertTrue(path.is_relative_to(ROOT))
                    self.assertTrue(path.is_file(), f"{key}: missing {field} file")


if __name__ == "__main__":
    unittest.main()
