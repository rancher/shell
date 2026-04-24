# renovate: datasource=github-release-attachments depName=rancher/helm
HELM_VERSION := v3.17.4-rancher1

KUBECTL_VERSION := v1.31.7
KUBECTL_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl.sha256")

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.50.0
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.0
K9S_SUM_arm64 := 2a068382b89d3c8ca49c3b0593b50601ba0d0c057bee2433d71d3aa983e69325
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.0
K9S_SUM_amd64 := 63eb225a3da358245d37e7f79904d62c1d5361e4faa9275c43fb3cdbb053dde9

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64)
