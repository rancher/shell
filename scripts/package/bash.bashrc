[ -r /etc/profile.d/bash_completion.sh ] && . /etc/profile.d/bash_completion.sh
[ -r /etc/kuberlr-completion.bash ] && . /etc/kuberlr-completion.bash
[ -r /etc/kubectl-completion.bash ] && . /etc/kubectl-completion.bash
alias k=kubectl
alias ks='kubectl -n kube-system'
complete -o default -F __start_kubectl k
PS1='> '