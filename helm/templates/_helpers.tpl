{{/*
Expand the name of the chart.
*/}}
{{- define "appDeploy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "appDeploy.fullname" -}}
{{- include "appDeploy.name" . }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "appDeploy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "appDeploy.labels" -}}
helm.sh/chart: {{ include "appDeploy.chart" . }}
{{ include "appDeploy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "appDeploy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "appDeploy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Values.deploymentEnvironment }}
environment: {{ .Values.deploymentEnvironment }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "appDeploy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "appDeploy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the namespace to use.
*/}}
{{- define "appDeploy.namespace" -}}
{{- if .Values.namespace }}
{{- .Values.namespace }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end -}}
