# ios-playbook

Playbook submissions live under `playbooks/` and are reviewed automatically on every pull request.

Phase 1 is implemented:
- strict format validation based on filename-inferred playbook type
- internal repo link checks
- Markdown table checks
- trailing whitespace checks
- placeholder detection for unreplaced `{...}` content

Expected filename patterns:
- `platform-feature-<slug>.md`
- `platform-feature-<slug>-risk-<slug>.md`
- `platform-feature-<slug>-risk-<slug>-control-<slug>.md`

Run the validator locally with:

```bash
node scripts/validate-playbooks.mjs
```
