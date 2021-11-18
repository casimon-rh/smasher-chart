{{/*
Expand the name of the chart.
*/}}
{{- define "smasher.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "smasher.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "smasher.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "smasher.labels" -}}
helm.sh/chart: {{ include "smasher.chart" . }}
{{ include "smasher.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "smasher.selectorLabels" -}}
app.kubernetes.io/name: {{ include "smasher.fullname" . }}
app: {{ include "smasher.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}

{{- end }}
{{- define "smasher.meshLabels"}}
{{- if .Values.servicemesh.create }}
sidecar.istio.io/inject: "true"
version: {{ .Values.image.tag }}
{{- end }}
{{- end }}
{{/*
Create the name of the service account to use
*/}}
{{- define "smasher.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "smasher.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "smasher.apiDomain" -}}
{{- $ingress := (lookup "config.openshift.io/v1" "Ingress" "" "cluster") }}
{{- if $ingress}}
value: {{ $ingress.spec.domain | default .Values.overrideApiDomain | replace "apps." "https://api." }}:6443
{{- end}}
{{- end }}

