{{- define "opds-shelf.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "opds-shelf.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "opds-shelf.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "opds-shelf.labels" -}}
app.kubernetes.io/name: {{ include "opds-shelf.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "opds-shelf.selectorLabels" -}}
app.kubernetes.io/name: {{ include "opds-shelf.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "opds-shelf.ingressServiceName" -}}
{{- $ctx := .context -}}
{{- $service := .service -}}
{{- if eq $service "opdsAggregator" -}}
{{- printf "%s-opdsagg" (include "opds-shelf.fullname" $ctx) -}}
{{- else if eq $service "calibreWeb" -}}
{{- printf "%s-calibreweb" (include "opds-shelf.fullname" $ctx) -}}
{{- else if eq $service "calibre" -}}
{{- printf "%s-calibre" (include "opds-shelf.fullname" $ctx) -}}
{{- else -}}
{{- printf "%s-%s" (include "opds-shelf.fullname" $ctx) ($service | lower) -}}
{{- end -}}
{{- end -}}
