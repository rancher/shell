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
K9S_VERSION := v0.40.10
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.40.10
K9S_SUM_arm64 := b1f12af342fbd21d466463132fd57eb9175b40ab98b5c711d3b249d3f507fc91
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.40.10
K9S_SUM_amd64 := 490bbfcb9314e59c0b1396e1d896786dc944fa9f83062296f454fef97aee0a54
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.40.10
K9S_SUM_s390x := 7a4952955866eafbb7172af015c0f00976c5f789355175c238a77a31d9cbb576

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) --build-arg KUBECTL_SUM_s390x=$(KUBECTL_SUM_s390x) \
			  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) --build-arg KUSTOMIZE_SUM_arm64=$(KUSTOMIZE_SUM_arm64) --build-arg KUSTOMIZE_SUM_amd64=$(KUSTOMIZE_SUM_amd64) --build-arg KUSTOMIZE_SUM_s390x=$(KUSTOMIZE_SUM_s390x) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64) --build-arg K9S_SUM_s390x=$(K9S_SUM_s390x)
