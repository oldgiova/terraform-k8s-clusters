#!/bin/bash
set -euo pipefail

kubectl cluster-info

echo -e "\n\nYou can access Alertmanager on: http://localhost:9093\n\n"

kubectl \
  -n monitoring \
   port-forward svc/kube-prometheus-kube-prome-alertmanager 9093 

