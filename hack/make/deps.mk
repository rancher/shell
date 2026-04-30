HELM_VERSION := v3.20.2
HELM_SUM_arm64 := 5ea2d6bc2cda3f8edf985e028809f5a9278f404fb8ab24044de9b7cb9b79a691
HELM_SUM_amd64 := 258e830a9e613c8a7a302d6059b4bb3b9758f2f3e1bb8ea0d707ce10a9a72fea

# renovate-local: kubectl-amd64
KUBECTL_VERSION := v1.36.0
# renovate-local: kubectl-arm64=v1.35.2
KUBECTL_SUM_arm64 := cd859449f54ad2cb05b491c490c13bb836cdd0886ae013c0aed3dd67ff747467
# renovate-local: kubectl-amd64=v1.35.2
KUBECTL_SUM_amd64 := 924eb50779153f20cb668117d141440b95df2f325a64452d78dff9469145e277

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.50.18
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.18
K9S_SUM_arm64 := d3dcc051d6be26ee911c00f583412802ebe203a189e51bc079332cb410c83b38
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.18
K9S_SUM_amd64 := 0b697ed4aa80997f7de4deeed6f1fba73df191b28bf691b1f28d2f45fa2a9e9b

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) --build-arg HELM_SUM_arm64=$(HELM_SUM_arm64) --build-arg HELM_SUM_amd64=$(HELM_SUM_amd64) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64)
