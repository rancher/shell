# renovate: datasource=github-release-attachments depName=rancher/helm
HELM_VERSION := v3.13.3-rancher1

KUBECTL_VERSION := v1.26.9
# curl -L "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/arm64/kubectl.sha256"
KUBECTL_SUM_arm64 := f945c63220b393ddf8df67d87e67ff74b7f56219a670dee38bc597a078588e90
# curl -L "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256"
KUBECTL_SUM_amd64 := 98ea4a13895e54ba24f57e0d369ff6be0d3906895305d5390197069b1da12ae2
# curl -L "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/s390x/kubectl.sha256"
KUBECTL_SUM_s390x := 6c3f1cac8d70286eb4a661d783558101b9e4891e7997f744183506466a03625f

# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize
KUSTOMIZE_VERSION := v5.3.0
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize digestVersion=v5.3.0
KUSTOMIZE_SUM_arm64 := a1ec622d4adeb483e3cdabd70f0d66058b1e4bcec013c4f74f370666e1e045d8
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize digestVersion=v5.3.0
KUSTOMIZE_SUM_amd64 := 3ab32f92360d752a2a53e56be073b649abc1e7351b912c0fb32b960d1def854c
# renovate: datasource=github-release-attachments depName=kubernetes-sigs/kustomize digestVersion=v5.3.0
KUSTOMIZE_SUM_s390x := 0b1a00f0e33efa2ecaa6cda9eeb63141ddccf97a912425974d6b65e66cf96cd4

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.31.7
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.31.7
K9S_SUM_arm64 := 7310ca3d6d8f359457baeda2b0bc62571b7a0e068fe07275a774e7b2a9b54243
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.31.7
K9S_SUM_amd64 := 10a01834fca8a1c6613ae3ed17ce22575e1d2f4ffb1dd344866df533ed2d2539
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.31.7
K9S_SUM_s390x := 9c6b7537777b428346e72c8f9666bbdb320a71d981052b8750af60e740db98d8

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) --build-arg KUBECTL_SUM_s390x=$(KUBECTL_SUM_s390x) \
			  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) --build-arg KUSTOMIZE_SUM_arm64=$(KUSTOMIZE_SUM_arm64) --build-arg KUSTOMIZE_SUM_amd64=$(KUSTOMIZE_SUM_amd64) --build-arg KUSTOMIZE_SUM_s390x=$(KUSTOMIZE_SUM_s390x) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64) --build-arg K9S_SUM_s390x=$(K9S_SUM_s390x)
