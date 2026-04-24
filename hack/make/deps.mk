HELM_VERSION := v3.20.2
HELM_SUM_arm64 := 5ea2d6bc2cda3f8edf985e028809f5a9278f404fb8ab24044de9b7cb9b79a691
HELM_SUM_amd64 := 258e830a9e613c8a7a302d6059b4bb3b9758f2f3e1bb8ea0d707ce10a9a72fea

# renovate-local: kubectl-amd64
KUBECTL_VERSION := v1.36.0
# renovate-local: kubectl-arm64=v1.36.0
KUBECTL_SUM_arm64 := 9f9d9c44a7b5264515ac9da5991584e2395bd50662e651132337e7b4d0c56f8f
# renovate-local: kubectl-amd64=v1.36.0
KUBECTL_SUM_amd64 := 123d8c8844f46b1244c547fffb3c17180c0c26dac9890589fe7e67763298748e

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
