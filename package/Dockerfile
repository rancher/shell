FROM alpine:3.12 AS build
ARG ARCH=amd64
RUN apk add -U curl xz
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kubectl && \
    chmod +x kubectl
RUN if [ "${ARCH}" = "amd64" ]; then ARCH=x86_64; fi && \
    curl -L https://github.com/derailed/k9s/releases/download/v0.20.2/k9s_Linux_${ARCH}.tar.gz | tar xvzf -
RUN curl -L https://get.helm.sh/helm-v3.2.4-linux-${ARCH}.tar.gz | tar xvzf - --strip-components=1

FROM alpine:3.12
RUN apk add -U --no-cache bash bash-completion jq
RUN echo 'shell:x:1000:1000:shell,,,:/home/shell:/bin/bash' > /etc/passwd && \
    echo 'shell:x:1000:' > /etc/group && \
    mkdir /home/shell && \
    echo '. /etc/bash_completion' >> /home/shell/.bashrc && \
    echo 'alias k="kubectl"' >> /home/shell/.bashrc && \
    echo 'alias ks="kubectl -n kube-system"' >> /home/shell/.bashrc && \
    echo 'source <(kubectl completion bash)' >> /home/shell/.bashrc && \
    echo 'PS1="> "' >> /home/shell/.bashrc && \
    mkdir /home/shell/.kube && \
    chown -R shell /home/shell && \
    chmod 700 /run
COPY --from=build /kubectl /k9s /helm /usr/local/bin/
COPY package/helm-cmd package/welcome /usr/local/bin/
USER 1000
WORKDIR /home/shell
CMD ["welcome"]
