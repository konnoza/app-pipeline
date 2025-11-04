{{/*
Expand the name of the chart.
*/}}
{{- define "appdeploy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "appdeploy.fullname" -}}
{{- include "appdeploy.name" . }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "appdeploy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "appdeploy.labels" -}}
helm.sh/chart: {{ include "appdeploy.chart" . }}
{{ include "appdeploy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "appdeploy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "appdeploy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Values.deploymentEnvironment }}
environment: {{ .Values.deploymentEnvironment }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "appdeploy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "appdeploy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the namespace to use.
*/}}
{{- define "appdeploy.namespace" -}}
{{- if .Values.namespace }}
{{- .Values.namespace }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end -}}
