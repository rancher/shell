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
  zypper --installroot /chroot -n in bash-completion jq vim curl

RUN zypper ar -f https://rpm.rancher.io/pkgs/prime pkgs && \
  rpm --root /chroot --import https://raw.githubusercontent.com/rancher/rancher/refs/heads/main/rancher-rpm-pkgs.key && \
  zypper --installroot /chroot -n in -r pkgs \
  helm3 \
  k9s \
  kubectl-1.35

# The symbolic link target has no /chroot prefix.
RUN \
  ln -s /usr/bin/helm3        /chroot/usr/local/bin/helm && \
  ln -s /usr/bin/k9s          /chroot/usr/local/bin/k9s && \
  ln -s /usr/bin/kubectl-1.35 /chroot/usr/local/bin/kubectl

RUN zypper --installroot /chroot clean -a && \
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
COPY --chown=root:root --chmod=0755 scripts/package/helm-cmd scripts/package/welcome scripts/package/kustomize /usr/local/bin/

USER 1000

WORKDIR /home/shell
CMD ["welcome"]
