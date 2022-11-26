
resource "kubectl_manifest" "alertmanager_integration" {
  count              = var.oncall_enabled ? 1 : 0
  override_namespace = "monitoring"
  yaml_body          = <<YAML
apiVersion: monitoring.coreos.com/v1alpha1
kind: AlertmanagerConfig
metadata:
  name: alertmanager-grafanaoncall-config
  labels:
    alertmanagerConfig: grafanaoncall
spec:
  route:
    groupBy: ['alertname']
    groupWait: 30s
    groupInterval: 5m
    repeatInterval: 12h
    receiver: 'grafana_oncall'
  receivers:
  - name: 'grafana_oncall'
    webhookConfigs:
    - url: "http://oncall-engine:8080/integrations/v1/alertmanager/rRogFTcFO2VONXcmbsg6bEqm5/"
      sendResolved: true
YAML
}

