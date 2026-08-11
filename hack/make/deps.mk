HELM_VERSION := v4.2.0

# renovate-local: kubectl-amd64
KUBECTL_VERSION := v1.36.1

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.51.0

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) \
			  --build-arg K9S_VERSION=$(K9S_VERSION)
