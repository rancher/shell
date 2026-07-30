# automation-core

Single source of truth for `rancher/shell`'s GitHub Actions workflows.

The workflows under `.github/workflows` on this branch are `workflow_call` reusable workflows — they aren't triggered directly. Each active branch (`main`, `release/v2.12`, `release/v2.13`, `release/v2.14`) keeps a thin wrapper with the real trigger that calls out to the matching workflow here, e.g.:

```yaml
on:
  push:
    tags: ['v*']

jobs:
  call-workflow:
    uses: rancher/shell/.github/workflows/release.yml@automation-core
```

Updating CI logic — bumping an action pin, changing a build step — means editing the workflow once here instead of forward-porting the same change across every branch.

Workflows hosted here:

- `fossa.yml` — FOSSA license scanning
- `head-build.yml` — prerelease image builds off `main`
- `tests.yml` — PR validation and build tests
- `release.yml` — tag-triggered image publishing

`release/v2.11` still run its own copies and haven't been migrated.
