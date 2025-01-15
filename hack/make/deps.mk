# renovate: datasource=github-release-attachments depName=rancher/helm
HELM_VERSION := v3.15.1-rancher2

KUBECTL_VERSION := v1.28.15
KUBECTL_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl.sha256")
KUBECTL_SUM_s390x ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/s390x/kubectl.sha256")

# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize extractVersion=kustomize/v(?<version>\d+\.\d+\.\d+)
KUSTOMIZE_VERSION := v5.6.0
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.5.0
KUSTOMIZE_SUM_arm64 := b4170d1acb8cfacace9f72884bef957ff56efdcd4813b66e7604aabc8b57e93d
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.5.0
KUSTOMIZE_SUM_amd64 := 6703a3a70a0c47cf0b37694030b54f1175a9dfeb17b3818b623ed58b9dbc2a77
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.5.0
KUSTOMIZE_SUM_s390x := 37dcd2429ef93886319b39671071b2e1c5307993cdb6a5c097cfefc97177d296

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.32.7
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.32.7
K9S_SUM_arm64 := b890a7a212a3fc69e6ea4b2a29d59f80ed501a27ad654c819a155cc7c3c6aa8d
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.32.7
K9S_SUM_amd64 := 03934727bfbf39b1e61a74d8e045796cda2de14f8ce4c01df27f43d4494021de
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.32.7
K9S_SUM_s390x := 742981297b18dbd0f4e5a6d1306eef32dd70c2e0a3dc4894ccc59cf7ce628b06

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) --build-arg KUBECTL_SUM_s390x=$(KUBECTL_SUM_s390x) \
			  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) --build-arg KUSTOMIZE_SUM_arm64=$(KUSTOMIZE_SUM_arm64) --build-arg KUSTOMIZE_SUM_amd64=$(KUSTOMIZE_SUM_amd64) --build-arg KUSTOMIZE_SUM_s390x=$(KUSTOMIZE_SUM_s390x) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64) --build-arg K9S_SUM_s390x=$(K9S_SUM_s390x)
