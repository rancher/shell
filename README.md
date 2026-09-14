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

`release/v2.11` still run its own copies and haven't been migrated.

## Release workflow

A release branch's `release.yml` looks like:

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  publish:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/rancher/ci-image/charts
    permissions:
      contents: read
      id-token: write   # Vault auth + OIDC for cosign in ecm-distro-tools/publish-image
    steps:
      - name: Read Secrets
        uses: rancher-eio/read-vault-secrets@0da85151ad1f19ed7986c41587e45aac1ace74b6 # v3
        with:
          secrets: |
            secret/data/github/repo/${{ github.repository }}/dockerhub/rancher/credentials username | DOCKER_USERNAME ;
            secret/data/github/repo/${{ github.repository }}/dockerhub/rancher/credentials password | DOCKER_PASSWORD ;
      - uses: actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd # v6
      - uses: rancher/shell/actions/check-semver@automation-core
        id: semver_check
      - uses: rancher/ecm-distro-tools/actions/publish-image@8821b2e4aa18f762dc334f811f54e8f215771a68 # v0.66.2
        with:
          image: shell
          tag: ${{ github.ref_name }}
          public-registry: docker.io
          public-repo: rancher
          public-username: ${{ env.DOCKER_USERNAME }}
          public-password: ${{ env.DOCKER_PASSWORD }}

  push-to-rancher:
    needs: publish
    runs-on: ubuntu-latest
    permissions:
      id-token: write
    steps:
      - uses: rancher/shell/actions/push-to-rancher@automation-core
        with:
          tag: ${{ github.ref_name }}
```
