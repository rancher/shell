ARG BCI_VERSION=16.0
ARG GO_IMAGE=rancher/hardened-build-base:v1.25.11b1
FROM registry.suse.com/bci/bci-busybox:${BCI_VERSION} AS final

# Image that provides cross compilation tooling.
FROM --platform=$BUILDPLATFORM rancher/mirrored-tonistiigi-xx:1.5.0 AS xx

FROM --platform=$BUILDPLATFORM ${GO_IMAGE} AS helm

# Clone repository once, and reuse it for target archs.
ARG HELM_VERSION
ADD --keep-git-dir=true https://github.com/rancher/helm.git#${HELM_VERSION} /helm
RUN --mount=type=cache,target=/go/pkg/mod \
    cd /helm && go mod download

COPY --from=xx / /

# Cross-compile instead of emulating the compilation on the target arch.
ARG TARGETPLATFORM
RUN xx-go --wrap && mkdir -p /run/lock
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    make -C /helm

RUN xx-verify --static /helm/bin/helm

FROM --platform=$BUILDPLATFORM ${GO_IMAGE} AS kubectl

ARG KUBECTL_VERSION
ADD https://github.com/kubernetes/kubernetes/archive/refs/tags/${KUBECTL_VERSION}.tar.gz /src.tar.gz
RUN mkdir /src && tar -xzf /src.tar.gz -C /src --strip-components=1 && rm /src.tar.gz

COPY --from=xx / /
ARG TARGETPLATFORM
RUN xx-go --wrap
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    cd /src && \
    KUBE_GIT_VERSION=${KUBECTL_VERSION} \
    KUBE_GIT_COMMIT=unknown \
    KUBE_GIT_TREE_STATE=clean \
    KUBE_BUILD_PLATFORMS=$(xx-info os)/$(xx-info arch) \
    GOFLAGS="-tags=providerless" \
    CGO_ENABLED=0 \
    make WHAT=cmd/kubectl && \
    cp /src/_output/local/bin/$(xx-info os)/$(xx-info arch)/kubectl /kubectl
RUN xx-verify --static /kubectl

FROM --platform=$BUILDPLATFORM ${GO_IMAGE} AS k9s

ARG K9S_VERSION
ADD https://github.com/derailed/k9s/archive/refs/tags/${K9S_VERSION}.tar.gz /src.tar.gz
RUN mkdir /src && tar -xzf /src.tar.gz -C /src --strip-components=1 && rm /src.tar.gz

COPY --from=xx / /
ARG TARGETPLATFORM
RUN xx-go --wrap
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    cd /src && \
    CGO_ENABLED=0 go build -trimpath \
      -ldflags="-s -w -X github.com/derailed/k9s/cmd.version=${K9S_VERSION}" \
      -o /k9s .
RUN xx-verify --static /k9s

FROM registry.suse.com/bci/bci-base:${BCI_VERSION} AS zypper

# Creates the based dir for the target image, and hydrates it with the
# original contents of the final image.
RUN mkdir /chroot
COPY --from=final / /chroot/

# The final image does not contain zypper, --installroot is used to
# install all artefacts within a dir (/chroot) that can then be copied
# over to a scratch image.
RUN zypper --non-interactive refresh && \
    zypper --installroot /chroot -n rm busybox-vi busybox-links && \
    zypper --installroot /chroot -n in bash-completion jq vim curl && \
    zypper --installroot /chroot clean -a && \
    rm -rf /chroot/var/cache/zypp/* /chroot/var/log/zypp/* /chroot/etc/zypp/ /chroot/run/zypp.pid


RUN echo 'shell:x:1000:1000:shell,,,:/home/shell:/bin/bash' > /chroot/etc/passwd && \
        echo 'shell:x:1000:' > /chroot/etc/group && \
        mkdir -p /chroot/home/shell/.kube /chroot/home/shell/helm-run && \
        echo '. /etc/profile.d/bash_completion.sh' >> /chroot/home/shell/.bashrc && \
        echo 'alias k="kubectl"' >> /chroot/home/shell/.bashrc && \
        echo 'alias ks="kubectl -n kube-system"' >> /chroot/home/shell/.bashrc && \
        echo 'source <(kubectl completion bash)' >> /chroot/home/shell/.bashrc && \
        echo 'complete -o default -F __start_kubectl k' >> /chroot/home/shell/.bashrc && \
        echo 'LANG=en_US.UTF-8' >> /chroot/home/shell/.bashrc && \
        echo 'PS1="> "' >> /chroot/home/shell/.bashrc && \
        mkdir -p /chroot/tmp && \
        chmod 1777 /chroot/tmp && \
        chown -R 1000:1000 /chroot/home/shell

FROM scratch

COPY --from=zypper /chroot /
COPY --chown=root:root --chmod=0755 --from=helm /helm/bin/helm /usr/local/bin/
COPY --chown=root:root --chmod=0755 --from=kubectl /kubectl /usr/local/bin/
COPY --chown=root:root --chmod=0755 --from=k9s /k9s /usr/local/bin/
COPY --chown=root:root --chmod=0755 package/helm-cmd package/welcome package/kustomize /usr/local/bin/

USER 1000

WORKDIR /home/shell
CMD ["welcome"]
