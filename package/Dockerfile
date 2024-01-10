FROM registry.suse.com/bci/golang:1.21 AS helm
RUN zypper -n install git
RUN git -C / clone --branch release-v3.12.3 --depth=1 https://github.com/rancher/helm
RUN make -C /helm

FROM registry.suse.com/bci/bci-base:15.5 AS build
ARG ARCH=amd64
RUN zypper -n install curl gzip tar
ENV KUBECTL_VERSION v1.26.9
ENV K9S_VERSION=v0.31.2
ENV KUSTOMIZE_VERSION=v5.2.1
ENV KUSTOMIZE_URL=https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${ARCH}.tar.gz
RUN curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl && \
    chmod +x kubectl
RUN curl -sfL https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${ARCH}.tar.gz | tar xvzf -
RUN if [ "${ARCH}" = "amd64" ] || [ "${ARCH}" = "arm64" ]; then \
    curl -sLf ${KUSTOMIZE_URL} | tar -xzf - && chmod +x kustomize; \
    fi

FROM registry.suse.com/bci/bci-base:15.5
RUN zypper -n update && \
    zypper -n install bash-completion gzip jq tar unzip vim wget && \
    zypper clean -a && rm -rf /tmp/* /var/tmp/* /usr/share/doc/packages/* /usr/share/doc/manual/* /var/log/*
RUN echo 'shell:x:1000:1000:shell,,,:/home/shell:/bin/bash' > /etc/passwd && \
    echo 'shell:x:1000:' > /etc/group && \
    mkdir /home/shell && \
    echo '. /etc/profile.d/bash_completion.sh' >> /home/shell/.bashrc && \
    echo 'alias k="kubectl"' >> /home/shell/.bashrc && \
    echo 'alias ks="kubectl -n kube-system"' >> /home/shell/.bashrc && \
    echo 'source <(kubectl completion bash)' >> /home/shell/.bashrc && \
    echo 'complete -o default -F __start_kubectl k' >> /home/shell/.bashrc && \
    echo 'PS1="> "' >> /home/shell/.bashrc && \
    mkdir /home/shell/.kube && \
    chown -R shell /home/shell && \
    chmod 700 /run
COPY --from=helm ./helm/bin/helm /usr/local/bin/
COPY --from=build /kubectl /k9s ./kustomize* /usr/local/bin/
COPY package/helm-cmd package/welcome /usr/local/bin/
COPY kustomize.sh /home/shell/
USER 1000
WORKDIR /home/shell
CMD ["welcome"]
