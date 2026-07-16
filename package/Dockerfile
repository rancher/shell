ARG BCI_VERSION=16.0
FROM registry.suse.com/bci/bci-busybox:${BCI_VERSION} AS final

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

# Add repo and packages made by Rancher in OBS.
RUN zypper addrepo --refresh https://download.opensuse.org/repositories/isv:/Rancher:/dependencies/pkgs rancher-obs-deps && \
    zypper --gpg-auto-import-keys refresh --force && \
    zypper --installroot /chroot -n in --from rancher-obs-deps helm k9s kubectl1.36

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
COPY --chown=root:root --chmod=0755 package/helm-cmd package/welcome package/kustomize /usr/local/bin/
RUN ln -s /usr/bin/kubectl1.36 /usr/bin/kubectl

USER 1000

WORKDIR /home/shell
CMD ["welcome"]
