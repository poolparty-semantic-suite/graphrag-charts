{{- define "graphrag.url" -}}
  {{- tpl .Values.global.graphrag.url . | trimSuffix "/" -}}
{{- end -}}

{{- define "graphrag.keycloak.url" -}}
  {{- tpl .Values.global.graphrag.keycloak.url . | trimSuffix "/" -}}
{{- end -}}
