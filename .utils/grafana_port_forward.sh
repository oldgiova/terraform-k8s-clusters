#!/bin/bash
set -euo pipefail

kubectl cluster-info

echo -e "\n\nYou can access Grafana on: http://localhost:3000\n\n"

kubectl \
  -n monitoring \
   port-forward deploy/kube-prometheus-grafana 3000 

