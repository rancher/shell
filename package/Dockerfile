ARG BCI_VERSION=16.0
FROM registry.suse.com/bci/bci-busybox:${BCI_VERSION} AS final

FROM --platform=$BUILDPLATFORM registry.suse.com/bci/bci-base:${BCI_VERSION} AS build
RUN zypper -n install curl gzip tar

# Define build arguments
ARG KUBECTL_VERSION KUBECTL_SUM_arm64 KUBECTL_SUM_amd64 \
    HELM_VERSION HELM_SUM_arm64 HELM_SUM_amd64 \
    K9S_VERSION K9S_SUM_arm64 K9S_SUM_amd64

ARG TARGETARCH
# Stage kubectl into build
ADD --chown=root:root --chmod=0755 \
    "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" \
    /kubectl

ENV KUBECTL_SUM="KUBECTL_SUM_${TARGETARCH}"
RUN echo "${!KUBECTL_SUM}  /kubectl" | sha256sum -c -

# Stage helm into build
ADD "https://get.helm.sh/helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" \
    /tmp/helm.tar.gz
ENV HELM_SUM="HELM_SUM_${TARGETARCH}"
RUN echo "${!HELM_SUM}  /tmp/helm.tar.gz" | sha256sum -c - && \
    tar -xvzf /tmp/helm.tar.gz --strip-components=1 -C / "linux-${TARGETARCH}/helm"

# Stage k9s into build
ADD "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${TARGETARCH}.tar.gz" \
    /tmp/k9s.tar.gz
ENV K9S_SUM="K9S_SUM_${TARGETARCH}"
RUN echo "${!K9S_SUM}  /tmp/k9s.tar.gz" | sha256sum -c - && \
    tar -xvzf /tmp/k9s.tar.gz -C / k9s

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
COPY --chown=root:root --chmod=0755 --from=build /kubectl /helm /k9s /usr/local/bin/
COPY --chown=root:root --chmod=0755 package/helm-cmd package/welcome package/kustomize /usr/local/bin/

USER 1000

WORKDIR /home/shell
CMD ["welcome"]
