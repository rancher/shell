#!/bin/bash

cat <&0 > /home/shell/helm-run/all.yaml

kustomize build . && rm /home/shell/helm-run/all.yaml
