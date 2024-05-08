#!/bin/bash

cat <&0 > /home/shell/helm-run/all.yaml

kubectl kustomize . && rm /home/shell/helm-run/all.yaml
