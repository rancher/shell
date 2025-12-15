# renovate: datasource=github-release-attachments depName=rancher/helm
HELM_VERSION := v3.18.4-rancher1

# renovate-local: kubectl-amd64
KUBECTL_VERSION := v1.33.7
# renovate-local: kubectl-arm64=v1.33.5
KUBECTL_SUM_arm64 := 6db7c5d846c3b3ddfd39f3137a93fe96af3938860eefdbf2429805ee1656e381
# renovate-local: kubectl-amd64=v1.33.5
KUBECTL_SUM_amd64 := 6a12d6c39e4a611a3687ee24d8c733961bb4bae1ae975f5204400c0a6930c6fc

# renovate-local: kustomize-amd64
KUSTOMIZE_VERSION := v5.6.0
# renovate-local: kustomize-arm64=v5.6.0
KUSTOMIZE_SUM_arm64 := ad8ab62d4f6d59a8afda0eec4ba2e5cd2f86bf1afeea4b78d06daac945eb0660
# renovate-local: kustomize-amd64=v5.6.0
KUSTOMIZE_SUM_amd64 := 54e4031ddc4e7fc59e408da29e7c646e8e57b8088c51b84b3df0864f47b5148f

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.50.13
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.13
K9S_SUM_arm64 := 52610fd5bcb3d0e998965f6d600d5a7bf5ef5971ce66ccb43dff16a7d10f1985
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.13
K9S_SUM_amd64 := fceab00e9f7b47d5f3fcccccc2ffd5a15090fdb2345d45938828a1f6114e9a5e

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) \
			  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) --build-arg KUSTOMIZE_SUM_arm64=$(KUSTOMIZE_SUM_arm64) --build-arg KUSTOMIZE_SUM_amd64=$(KUSTOMIZE_SUM_amd64) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64)
