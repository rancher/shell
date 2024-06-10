ARG BCI_VERSION=15.6
FROM registry.suse.com/bci/bci-busybox:${BCI_VERSION} as final

# Image that provides cross compilation tooling.
FROM --platform=$BUILDPLATFORM rancher/mirrored-tonistiigi-xx:1.3.0 as xx

FROM --platform=$BUILDPLATFORM registry.suse.com/bci/golang:1.22 as helm

# Clone repository once, and reuse it for target archs.
ARG HELM_VERSION
ADD --keep-git-dir=true https://github.com/rancher/helm.git#${HELM_VERSION} /helm
RUN cd /helm && go mod download

COPY --from=xx / /

# Cross-compile instead of emulating the compilation on the target arch.
ARG TARGETPLATFORM
RUN xx-go --wrap && mkdir -p /run/lock
RUN make -C /helm

RUN xx-verify --static /helm/bin/helm

FROM --platform=$BUILDPLATFORM registry.suse.com/bci/bci-base:${BCI_VERSION} AS build
RUN zypper -n install curl gzip tar

# Define build arguments
ARG KUBECTL_VERSION KUSTOMIZE_VERSION KUSTOMIZE_SUM_arm64 KUSTOMIZE_SUM_amd64 KUSTOMIZE_SUM_s390x \
    K9S_VERSION K9S_SUM_arm64 K9S_SUM_amd64 K9S_SUM_s390x

ARG TARGETARCH
# Stage kubectl into build
ENV KUSTOMIZE_SUM="KUSTOMIZE_SUM_${TARGETARCH}"
RUN curl --output /tmp/kustomize.tar.gz -sLf "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${TARGETARCH}.tar.gz" && \
    echo "${!KUSTOMIZE_SUM}  /tmp/kustomize.tar.gz" | sha256sum -c - && \
    tar -xvzf /tmp/kustomize.tar.gz -C / kustomize

# Stage k9s into build
ENV K9S_SUM="K9S_SUM_${TARGETARCH}"
RUN curl --output /tmp/k9s.tar.gz -sLf "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${TARGETARCH}.tar.gz" && \
    echo "${!K9S_SUM}  /tmp/k9s.tar.gz" | sha256sum -c - && \
    tar -xvzf /tmp/k9s.tar.gz -C / k9s

FROM --platform=$BUILDPLATFORM mallardduck/rancher-kuberlr:v2.0.0-rc.4 as kuberlr
FROM registry.suse.com/bci/bci-base:${BCI_VERSION} as zypper

# Creates the based dir for the target image, and hydrades it with the
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
    rm -rf /chroot/var/cache/zypp/* /chroot/var/log/zypp/* /chroot/etc/zypp/
    

RUN echo 'shell:x:1000:1000:shell,,,:/home/shell:/bin/bash' > /chroot/etc/passwd && \
        echo 'shell:x:1000:' > /chroot/etc/group && \
        mkdir /chroot/home/shell && \
        echo '. /etc/profile.d/bash_completion.sh' >> /chroot/home/shell/.bashrc && \
        echo 'alias k="kubectl"' >> /chroot/home/shell/.bashrc && \
        echo 'alias ks="kubectl -n kube-system"' >> /chroot/home/shell/.bashrc && \
        echo 'source <(kubectl completion bash)' >> /chroot/home/shell/.bashrc && \
        echo 'complete -o default -F __start_kubectl k' >> /chroot/home/shell/.bashrc && \
        echo 'LANG=en_US.UTF-8' >> /chroot/home/shell/.bashrc && \
        echo 'PS1="> "' >> /chroot/home/shell/.bashrc && \
        mkdir /chroot/home/shell/.kube && \
        mkdir /chroot/home/shell/.kuberlr && \
        touch /chroot/home/shell/.kuberlr/kuberlr.conf && \
        echo "AllowDownload = false" >> /chroot/home/shell/.kuberlr/kuberlr.conf && \
        echo 'SystemPath = "/usr/bin"' >> /chroot/home/shell/.kuberlr/kuberlr.conf && \
        echo "Timeout = 6" >> /chroot/home/shell/.kuberlr/kuberlr.conf && \
        chown -R 1000:1000 /chroot/home/shell && \
        chmod 700 /chroot/run

FROM scratch

COPY --from=zypper /chroot /
COPY --chown=root:root --chmod=0755 --from=helm /helm/bin/helm /usr/local/bin/
COPY --chown=root:root --chmod=0755 --from=build /k9s /kustomize* /usr/local/bin/
COPY --chown=root:root --chmod=0755 --from=kuberlr /usr/bin/kubectl* /usr/bin/
COPY --chown=root:root --chmod=0755 --from=kuberlr /bin/kuberlr /bin/kubectl /bin/
COPY --chown=root:root --chmod=0755 package/helm-cmd package/welcome /usr/local/bin/
COPY --chown=1000:1000 --chmod=0755 package/kustomize.sh /home/shell/

USER 1000

WORKDIR /home/shell
CMD ["welcome"]
