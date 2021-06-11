FROM golang:1.13 AS helm
RUN git -C / clone --branch v3.3.3-rancher3 --depth=1 https://github.com/rancher/helm
RUN make -C /helm

FROM alpine:3.12 AS build
ARG ARCH=amd64
RUN apk add -U curl xz
ENV KUBECTL_VERSION v1.20.7
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl && \
    chmod +x kubectl
RUN if [ "${ARCH}" = "amd64" ]; then ARCH=x86_64; fi && \
    curl -L https://github.com/derailed/k9s/releases/download/v0.20.2/k9s_Linux_${ARCH}.tar.gz | tar xvzf -

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
COPY --from=build /kubectl /k9s /usr/local/bin/
COPY package/helm-cmd package/welcome /usr/local/bin/
USER 1000
WORKDIR /home/shell
CMD ["welcome"]
