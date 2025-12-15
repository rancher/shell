# renovate: datasource=github-release-attachments depName=rancher/helm
HELM_VERSION := v3.19.0-rancher1

# renovate-local: kubectl-amd64
KUBECTL_VERSION := v1.34.3
# renovate-local: kubectl-arm64=v1.33.1
KUBECTL_SUM_arm64 := d595d1a26b7444e0beb122e25750ee4524e74414bbde070b672b423139295ce6
# renovate-local: kubectl-amd64=v1.33.1
KUBECTL_SUM_amd64 := 5de4e9f2266738fd112b721265a0c1cd7f4e5208b670f811861f699474a100a3

# renovate-local: kustomize-amd64
KUSTOMIZE_VERSION := v5.6.0
# renovate-local: kustomize-arm64=v5.6.0
KUSTOMIZE_SUM_arm64 := ad8ab62d4f6d59a8afda0eec4ba2e5cd2f86bf1afeea4b78d06daac945eb0660
# renovate-local: kustomize-amd64=v5.6.0
KUSTOMIZE_SUM_amd64 := 54e4031ddc4e7fc59e408da29e7c646e8e57b8088c51b84b3df0864f47b5148f

# renovate: datasource=github-release-attachments depName=derailed/k9s
K9S_VERSION := v0.50.16
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.16
K9S_SUM_arm64 := 7f3b414bc5e6b584fbcb97f9f4f5b2c67a51cdffcbccb95adcadbaeab904e98e
# renovate: datasource=github-release-attachments depName=derailed/k9s digestVersion=v0.50.16
K9S_SUM_amd64 := bda09dc030a08987fe2b3bed678b15b52f23d6705e872d561932d4ca07db7818

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg HELM_VERSION=$(HELM_VERSION) \
			  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) --build-arg KUBECTL_SUM_arm64=$(KUBECTL_SUM_arm64) --build-arg KUBECTL_SUM_amd64=$(KUBECTL_SUM_amd64) \
			  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) --build-arg KUSTOMIZE_SUM_arm64=$(KUSTOMIZE_SUM_arm64) --build-arg KUSTOMIZE_SUM_amd64=$(KUSTOMIZE_SUM_amd64) \
			  --build-arg K9S_VERSION=$(K9S_VERSION) --build-arg K9S_SUM_arm64=$(K9S_SUM_arm64) --build-arg K9S_SUM_amd64=$(K9S_SUM_amd64)
