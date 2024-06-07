# shell

The `rancher/shell` image is used:

- When you install a chart in Rancher (Helm Chart or Rancher Chart)
- When you use `Kubectl Shell` when managing a cluster in Rancher

---
## Branches and Releases
This is the current branch strategy for `rancher/shell`, it may change in the future.

| Branch         | Tag      | Rancher           |
|----------------|----------|-------------------|
| `master`       | `v0.1.x` | `v2.7.x`,`v2.8.x` |
| `release/v2.9` | `v0.2.x` | `v2.9.x`          |

### v0.1.x Branch
This branch supports Rancher 2.7/2.8 and spans supporting k8s 1.23 through 1.28.  
Here are the current component versions and their k8s support:

| Component   | Version | Supported K8s               |
|-------------|---------|-----------------------------|
| `kubectl`   |`v1.26.x`| `1.25`,`1.26`,`1.27`        |
| `kustomize` |`v5.4.x` |             n/a            |
| `helm`      |`v3.13.3-rancher1`| `1.25`,`1.26`,`1.27`,`1.28` |
| `k9s`       |`v0.32.4`| Uses `client-go` v0.29.3           |

### v0.2.x Branch
This branch supports Rancher 2.9 and spans supporting k8s 1.27 through 1.30.  
Here are the current component versions and their k8s support:

| Component   | Version            | Supported K8s              |
|-------------|--------------------|----------------------------|
| `kubectl`   | `v1.28.x`          | `1.27`,`1.28`,`1.29`       |
| `kustomize` | `v5.4.x`           |             n/a            |
| `helm`      | `v3.14.3-rancher1` | `1.26`,`1.27`,`1.28`,`1.29`|
| `k9s`       | `v0.32.4`          | Uses `client-go` v0.29.3   |
