SHELL := /bin/bash

# HELP
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# TASKS
terrastar-formatter: ## Terra[grunt|form] formatter
	terraform fmt -recursive .
	terragrunt hclfmt -recursive .

grafana-port-forward: ## Start Grafana port-forward
	./.utils/grafana_port_forward.sh

alertmanager-port-forward: ## Start Alertmanager port-forward
	./.utils/alertmanager_port_forward.sh

prometheus-port-forward: ## Start Prometheus port-forward
	./.utils/prometheus_port_forward.sh

