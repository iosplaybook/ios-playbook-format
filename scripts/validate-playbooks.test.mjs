import test from "node:test";
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import path from "node:path";

const repoRoot = process.cwd();
const scriptPath = path.join(repoRoot, "scripts", "validate-playbooks.mjs");

test("feature fixtures do not require a post-demonstration risk section", () => {
  const result = runValidator(["examples/clarity/vague-steps/platform-feature-01.md"]);

  assert.equal(result.status, 0);
  assert.match(result.stdout, /feature\.demo_steps/);
  assert.doesNotMatch(result.stdout, /feature\.risk_/);
});

test("required table structure accepts two rows and proceeds to the next feature check", () => {
  const result = runValidator(["examples/pass/platform-feature-01.md"]);

  assert.equal(result.status, 0);
  assert.match(result.stdout, /The configuration table uses the approved header/);
  assert.match(result.stdout, /The configuration table includes a separator row/);
  assert.doesNotMatch(result.stdout, /includes at least one data row/);
  assert.match(result.stdout, /feature\.steps_intro/);
});

test("each numbered demonstration step is validated for a feature playbook", () => {
  const result = runValidator(["examples/pass/platform-feature-01.md"]);

  assert.equal(result.status, 0);
  assert.match(result.stdout, /Numbered list item 1 passed the 'feature\.demo_steps'/);
  assert.match(result.stdout, /Numbered list item 2 passed the 'feature\.demo_steps'/);
});

function runValidator(filePaths) {
  return spawnSync(process.execPath, [scriptPath, "--stdin"], {
    cwd: repoRoot,
    input: `${filePaths.join("\n")}\n`,
    encoding: "utf8",
  });
}
