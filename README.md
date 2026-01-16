# shell

The `rancher/shell` image is used:

- When you install a chart in Rancher (Helm Chart or Rancher Chart)
- When you use `Kubectl Shell` when managing a cluster in Rancher

---
## Branches and Releases
This is the current branch strategy for `rancher/shell`, it may change in the future.

| Branch          | Tag      | Rancher                |
|-----------------|----------|------------------------|
| `main`          | `head`   | `main` branch (`head`) |
| `release/v2.12` | `v0.5.x` | `v2.12.x`              |
| `release/v2.11` | `v0.4.x` | `v2.11.x`              |
| `release/v2.10` | `v0.3.x` | `v2.10.x`              |
| `release/v2.9`  | `v0.2.x` | `v2.9.x`               |

### Branch Info Overview

Each shell branch must constrain itself to use versions compatible with the respective Rancher releases.
Specifically to ensure maximum possible compatibility with the k8s versions that the Rancher release it targets supports.

Always refer to the [Support Compatability Matrix](https://www.suse.com/suse-rancher/support-matrix/) (or internal docs for future releases) as an official to ensure compatability.
That said, here a quick visual reference (Aug 2024):


| Rancher Version | k8s min | k8s max |
|-----------------|---------|---------|
| 2.14.x          | 1.33    | 1.35    |
| 2.13.x          | 1.32    | 1.34    |
| 2.12.x          | 1.31    | 1.33    |
| 2.11.x          | 1.30    | 1.32    |
| 2.10.x          | 1.28    | 1.31    |