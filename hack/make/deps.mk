HELM_VERSION := v4.2.0
HELM_SUM_arm64 := 1f8de130dfbd04de64978e7b852a7a547be1404956a366608276d2520b678670
HELM_SUM_amd64 := 97dbeb971be4ac4b27e3839976d9564c0fb35c6f3b1da89dd1e292d236af4096

# renovate-local: kubectl-amd64
KUBECTL_VERSION := v1.36.1

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.50.18

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) --build-arg HELM_SUM_arm64=$(HELM_SUM_arm64) --build-arg HELM_SUM_amd64=$(HELM_SUM_amd64) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) \
			  --build-arg K9S_VERSION=$(K9S_VERSION)
