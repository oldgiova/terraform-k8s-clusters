#!/bin/bash
set -euo pipefail

kubectl cluster-info

echo -e "\n\nYou can access Prometheus on: http://localhost:9090\n\n"

kubectl \
  -n monitoring \
   port-forward svc/kube-prometheus-kube-prome-prometheus 9090

