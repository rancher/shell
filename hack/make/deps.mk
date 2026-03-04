# renovate: datasource=github-release-attachments depName=rancher/helm
HELM_VERSION := v3.20.0-rancher1

# renovate-local: kubectl-amd64
KUBECTL_VERSION := v1.35.2
# renovate-local: kubectl-arm64=v1.35.2
KUBECTL_SUM_arm64 := cd859449f54ad2cb05b491c490c13bb836cdd0886ae013c0aed3dd67ff747467
# renovate-local: kubectl-amd64=v1.35.2
KUBECTL_SUM_amd64 := 924eb50779153f20cb668117d141440b95df2f325a64452d78dff9469145e277

# renovate-local: kustomize-amd64
KUSTOMIZE_VERSION := v5.6.0
# renovate-local: kustomize-arm64=v5.6.0
KUSTOMIZE_SUM_arm64 := ad8ab62d4f6d59a8afda0eec4ba2e5cd2f86bf1afeea4b78d06daac945eb0660
# renovate-local: kustomize-amd64=v5.6.0
KUSTOMIZE_SUM_amd64 := 54e4031ddc4e7fc59e408da29e7c646e8e57b8088c51b84b3df0864f47b5148f

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.50.18
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.18
K9S_SUM_arm64 := d3dcc051d6be26ee911c00f583412802ebe203a189e51bc079332cb410c83b38
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.18
K9S_SUM_amd64 := 0b697ed4aa80997f7de4deeed6f1fba73df191b28bf691b1f28d2f45fa2a9e9b

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) \
			  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) --build-arg KUSTOMIZE_SUM_arm64=$(KUSTOMIZE_SUM_arm64) --build-arg KUSTOMIZE_SUM_amd64=$(KUSTOMIZE_SUM_amd64) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64)
