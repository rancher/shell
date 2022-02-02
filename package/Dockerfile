FROM golang:1.17.6 AS helm
RUN git -C / clone --branch release-v3.8.0 --depth=1 https://github.com/rancher/helm
RUN make -C /helm

FROM alpine:3.12 AS build
ARG ARCH=amd64
RUN apk add -U curl xz
ENV KUBECTL_VERSION v1.21.8
ENV K9S_VERSION v0.25.3
ENV KUSTOMIZE_VERSION v4.4.1
ENV KUSTOMIZE_URL=https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${ARCH}.tar.gz
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl && \
    chmod +x kubectl
RUN if [ "${ARCH}" = "amd64" ]; then ARCH=x86_64; fi && \
    curl -sfL https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${ARCH}.tar.gz | tar xvzf -
RUN if [ "${ARCH}" = "amd64" ] || [ "${ARCH}" = "arm64" ] || [ "${ARCH}" = "s390x" ]; then \
    curl -sLf ${KUSTOMIZE_URL} | tar -xzf - && chmod +x kustomize; \
  fi

FROM alpine:3.12
RUN apk add -U --no-cache bash bash-completion jq
RUN echo 'shell:x:1000:1000:shell,,,:/home/shell:/bin/bash' > /etc/passwd && \
    echo 'shell:x:1000:' > /etc/group && \
    mkdir /home/shell && \
    echo '. /etc/profile.d/bash_completion.sh' >> /home/shell/.bashrc && \
    echo 'alias k="kubectl"' >> /home/shell/.bashrc && \
    echo 'alias ks="kubectl -n kube-system"' >> /home/shell/.bashrc && \
    echo 'source <(kubectl completion bash)' >> /home/shell/.bashrc && \
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
