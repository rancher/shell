# renovate: datasource=github-release-attachments depName=rancher/helm
HELM_VERSION := v3.16.1-rancher1

KUBECTL_VERSION := v1.29.9
KUBECTL_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl.sha256")
KUBECTL_SUM_s390x ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/s390x/kubectl.sha256")

# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize extractVersion=kustomize/v(?<version>\d+\.\d+\.\d+)
KUSTOMIZE_VERSION := v5.4.3
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.4.3
KUSTOMIZE_SUM_arm64 := 1b515578b0af12c15d9856720066ce2fe66756d63785b2cbccaf2885beb2381c
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.4.3
KUSTOMIZE_SUM_amd64 := 3669470b454d865c8184d6bce78df05e977c9aea31c30df3c669317d43bcc7a7
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.4.3
KUSTOMIZE_SUM_s390x := c575eba2f46c4701d1897a9b27c422d42d6381adb679435bc3e0d7c0da5abe44

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
