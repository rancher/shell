FROM ubuntu:18.04 AS build
RUN apt update && \
    apt install -y curl xz-utils
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kubectl && \
    chmod +x kubectl
RUN curl -L https://github.com/scop/bash-completion/releases/download/2.10/bash-completion-2.10.tar.xz | tar xvJf - --strip-components=1
RUN curl -L https://github.com/derailed/k9s/releases/download/v0.20.2/k9s_Linux_x86_64.tar.gz | tar xvzf -
RUN curl -L https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz | tar xvzf - --strip-components=1
RUN curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 > /jq && \
    chmod +x /jq

FROM alpine:3.12
RUN apk add -U --no-cache bash
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
COPY --from=build /bash_completion /etc/
COPY --from=build /kubectl /k9s /jq /helm /usr/local/bin/
COPY helm-cmd /usr/local/bin
COPY welcome /usr/local/bin
USER 1000
WORKDIR /home/shell
CMD ["welcome"]
