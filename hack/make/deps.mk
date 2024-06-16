# renovate: datasource=github-release-attachments depName=rancher/helm
HELM_VERSION := v3.13.3-rancher1

KUBECTL_VERSION := v1.26.15
KUBECTL_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl.sha256")
KUBECTL_SUM_s390x ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/s390x/kubectl.sha256")

# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize extractVersion=kustomize/v(?<version>\d+\.\d+\.\d+)
KUSTOMIZE_VERSION := v5.4.2
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.4.1
KUSTOMIZE_SUM_arm64 := 175af88af8a7d8d7d6b1f26659060950f0764d00b9979b4e11b61b8b212b7c22
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.4.1
KUSTOMIZE_SUM_amd64 := 881c6e9007c7ea2b9ecc214d13f4cdd1f837635dcf4db49ce4479898f7d911a3
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.4.1
KUSTOMIZE_SUM_s390x := 3724d3a711a6f06650ef31e9d6a7c8aaaed0727183d6f61b2103ffc717af68a1

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.32.5
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.32.5
K9S_SUM_arm64 := 0b6315206843de295aa0adcb172af44182cd60ba8fc34792069c993d12624a29
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.32.5
K9S_SUM_amd64 := 33c31bf5feba292b59b8dabe5547cb52ab565521ee5619b52eb4bd4bf226cea3
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.32.5
K9S_SUM_s390x := 8aea75262492a699c150833cafc65465541c74becc1b0236b4a7e368f5bd5123

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) --build-arg KUBECTL_SUM_s390x=$(KUBECTL_SUM_s390x) \
			  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) --build-arg KUSTOMIZE_SUM_arm64=$(KUSTOMIZE_SUM_arm64) --build-arg KUSTOMIZE_SUM_amd64=$(KUSTOMIZE_SUM_amd64) --build-arg KUSTOMIZE_SUM_s390x=$(KUSTOMIZE_SUM_s390x) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64) --build-arg K9S_SUM_s390x=$(K9S_SUM_s390x)
