# renovate: datasource=github-release-attachments depName=rancher/helm
HELM_VERSION := v3.14.3-rancher2

KUBECTL_VERSION := v1.26.9
KUBECTL_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl.sha256")
KUBECTL_SUM_s390x ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/linux/s390x/kubectl.sha256")

# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize extractVersion=kustomize/v(?<version>\d+\.\d+\.\d+)
KUSTOMIZE_VERSION := v5.4.1
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.4.1
KUSTOMIZE_SUM_arm64 := 123b9ce38e04a03de5907153ef7f16979027bad16d0763a304e59dcf69ac6d30
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.4.1
KUSTOMIZE_SUM_amd64 := 3d659a80398658d4fec4ec4ca184b432afa1d86451a60be63ca6e14311fc1c42
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize versioning=regex:^kustomize/v(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$ digestVersion=kustomize/v5.4.1
KUSTOMIZE_SUM_s390x := 670330c1d02b5978f63e892ce0ff26dd2efc069b82737962f74a1d07071e7ef8

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.32.4
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.32.4
K9S_SUM_arm64 := adfbe3de1ffd3f119ff27d76d9a493e08adb2536f9b79d08fa245ddb75a5fe52
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.32.4
K9S_SUM_amd64 := d62611d9be2c35b782a765e98421500196acbf8be844cd3d9e32d4fa7846da05
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.32.4
K9S_SUM_s390x := 29ae8a00a01a9108473dea0fd4d60e472496ec6203060f06629f402ac6211750

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) --build-arg KUBECTL_SUM_s390x=$(KUBECTL_SUM_s390x) \
			  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) --build-arg KUSTOMIZE_SUM_arm64=$(KUSTOMIZE_SUM_arm64) --build-arg KUSTOMIZE_SUM_amd64=$(KUSTOMIZE_SUM_amd64) --build-arg KUSTOMIZE_SUM_s390x=$(KUSTOMIZE_SUM_s390x) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64) --build-arg K9S_SUM_s390x=$(K9S_SUM_s390x)
