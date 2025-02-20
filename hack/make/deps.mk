# renovate: datasource=github-release-attachments depName=rancher/helm
HELM_VERSION := v3.15.1-rancher2

KUBECTL_VERSION := v1.28.15
KUBECTL_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl.sha256")
KUBECTL_SUM_s390x ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/s390x/kubectl.sha256")

# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize extractVersion=kustomize/v(?<version>\d+\.\d+\.\d+)
KUSTOMIZE_VERSION := v5.6.0
KUSTOMIZE_SUM_arm64 := ad8ab62d4f6d59a8afda0eec4ba2e5cd2f86bf1afeea4b78d06daac945eb0660
KUSTOMIZE_SUM_amd64 := 54e4031ddc4e7fc59e408da29e7c646e8e57b8088c51b84b3df0864f47b5148f
KUSTOMIZE_SUM_s390x := e633bddd040a1d1acedac655044c2d2bcbba048481662ff6035ea1205ee9a869

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.40.5
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.40.5
K9S_SUM_arm64 := 3e3c852b3f7604c14e96dfb56b869769c2c314fdad8d4c35ab158c738c516a22
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.40.5
K9S_SUM_amd64 := 63dcf6817b2c391ccb4a8b7ee313f5990f5accfa0e55a72c769b73c303a03e01
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.40.5
K9S_SUM_s390x := 1b4ffb2fa90563eed53a59ef7a8cdc6a048cde2f18838beb0c7cc6df01c77353

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) --build-arg KUBECTL_SUM_s390x=$(KUBECTL_SUM_s390x) \
			  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) --build-arg KUSTOMIZE_SUM_arm64=$(KUSTOMIZE_SUM_arm64) --build-arg KUSTOMIZE_SUM_amd64=$(KUSTOMIZE_SUM_amd64) --build-arg KUSTOMIZE_SUM_s390x=$(KUSTOMIZE_SUM_s390x) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64) --build-arg K9S_SUM_s390x=$(K9S_SUM_s390x)
