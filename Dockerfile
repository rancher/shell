# syntax=docker/dockerfile:1
ARG BCI_VERSION=16.1
ARG USERNAME=shell
ARG UID=1000
ARG GID=1000

FROM registry.suse.com/bci/bci-busybox:${BCI_VERSION} AS final
FROM registry.suse.com/bci/bci-base:${BCI_VERSION} AS builder

ARG USERNAME
ARG UID
ARG GID
ARG TARGETPLATFORM
ARG TARGETARCH

# Creates the based dir for the target image, and hydrates it with the
# original contents of the final image.
RUN mkdir /chroot
COPY --from=final / /chroot/

# The final image does not contain zypper, --installroot is used to
# install all artefacts within a dir (/chroot) that can then be copied
# over to a scratch image.
# CACHE_KEY (commit + tags) is declared here, not at the top, so a change
# invalidates the cache from the first RPM install onward and picks up newer
# packages, while the layers above stay cached.
ARG CACHE_KEY
RUN zypper --non-interactive refresh && \
    zypper --installroot /chroot -n rm busybox-vi busybox-links && \
    zypper --installroot /chroot -n in bash-completion jq vim curl

RUN zypper ar -f https://rpm.rancher.io/pkgs/prime pkgs && \
    rpm --root /chroot --import https://raw.githubusercontent.com/rancher/rancher/refs/heads/main/rancher-rpm-pkgs.key && \
    zypper --installroot /chroot -n in -r pkgs helm4 k9s kuberlr

COPY kubectl-versions.txt /kubectl-versions.txt
RUN while read -r version; do \
        zypper --installroot /chroot -n in -r pkgs kubectl-${version} && \
        ln -sf kubectl-${version} /chroot/usr/bin/kubectl${version}; \
    done < /kubectl-versions.txt

# The symbolic link target has no /chroot prefix.
RUN ln -s /usr/bin/helm4   /chroot/usr/local/bin/helm && \
    ln -s /usr/bin/k9s     /chroot/usr/local/bin/k9s && \
    ln -s /usr/bin/kuberlr /chroot/usr/local/bin/kubectl

# Cleanup Zypper
RUN zypper --installroot /chroot clean -a && \
    rm -rf /chroot/var/cache/zypp/* /chroot/var/log/zypp/* /chroot/etc/zypp/ \
              /chroot/usr/share/doc /chroot/usr/share/man

# Setup kubrlr and kubectl configs
COPY scripts/package/bash.bashrc /chroot/etc/bash.bashrc
RUN chroot /chroot /usr/bin/kuberlr completion bash \
        > /chroot/etc/kuberlr-completion.bash && \
    chroot /chroot /usr/local/bin/kubectl completion bash \
            > /chroot/etc/kubectl-completion.bash

# Setup user and perms
RUN groupadd -g "${GID}" "${USERNAME}" && \
    useradd -m -u "${UID}" -g "${GID}" -s /bin/bash "${USERNAME}"
COPY --chown=${UID}:${GID} scripts/package/kuberlr.conf /home/${USERNAME}/.kuberlr/kuberlr.conf

RUN mkdir -p /chroot/home/${USERNAME}/.kube /chroot/home/${USERNAME}/helm-run /chroot/home/${USERNAME}/.kuberlr && \
        mkdir -p /chroot/tmp && chmod 1777 /chroot/tmp

FROM scratch
ARG USERNAME
ARG UID
ARG GID

COPY --from=builder /chroot /
COPY --from=builder /etc/passwd /etc/group /etc/shadow /etc/

RUN install -d -o ${UID} -g ${GID} -m 0750 /home/${USERNAME}
COPY --from=builder --chown=${UID}:${GID} /home/${USERNAME} /home/${USERNAME}
COPY --chown=root:root --chmod=0755 scripts/package/helm-cmd scripts/package/welcome scripts/package/kustomize /usr/local/bin/

USER ${UID}:${GID}
WORKDIR /home/${USERNAME}
ENV HOME=/home/${USERNAME}
CMD ["welcome"]
