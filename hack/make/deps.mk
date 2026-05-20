HELM_VERSION := v4.2.0
HELM_SUM_arm64 := 1f8de130dfbd04de64978e7b852a7a547be1404956a366608276d2520b678670
HELM_SUM_amd64 := 97dbeb971be4ac4b27e3839976d9564c0fb35c6f3b1da89dd1e292d236af4096

# renovate-local: kubectl-amd64
KUBECTL_VERSION := v1.36.0
# renovate-local: kubectl-arm64=v1.36.0
KUBECTL_SUM_arm64 := 9f9d9c44a7b5264515ac9da5991584e2395bd50662e651132337e7b4d0c56f8f
# renovate-local: kubectl-amd64=v1.36.0
KUBECTL_SUM_amd64 := 123d8c8844f46b1244c547fffb3c17180c0c26dac9890589fe7e67763298748e

# renovate-local: kustomize-amd64
KUSTOMIZE_VERSION := v5.7.1
# renovate-local: kustomize-arm64=v5.7.1
KUSTOMIZE_SUM_arm64 := 4261a040217df3bd6896597c3986d1465925726e4f22a945304b5233a4dcdbda
# renovate-local: kustomize-amd64=v5.7.1
KUSTOMIZE_SUM_amd64 := ea375e7372f9aa029129d4b2d16c66b7750b7f1213c4f66f910d981c895818d8

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.50.18
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.18
K9S_SUM_arm64 := d3dcc051d6be26ee911c00f583412802ebe203a189e51bc079332cb410c83b38
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.18
K9S_SUM_amd64 := 0b697ed4aa80997f7de4deeed6f1fba73df191b28bf691b1f28d2f45fa2a9e9b

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) --build-arg HELM_SUM_arm64=$(HELM_SUM_arm64) --build-arg HELM_SUM_amd64=$(HELM_SUM_amd64) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) \
			  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) --build-arg KUSTOMIZE_SUM_arm64=$(KUSTOMIZE_SUM_arm64) --build-arg KUSTOMIZE_SUM_amd64=$(KUSTOMIZE_SUM_amd64) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64)
