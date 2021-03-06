{{/*
Expand the name of the chart.
*/}}
{{- define "krwordcloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "krwordcloud.fullname" -}}
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
{{- define "krwordcloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "krwordcloud.app.labels" -}}
helm.sh/chart: {{ include "krwordcloud.chart" . }}
{{ include "krwordcloud.app.matchLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "krwordcloud.api.labels" -}}
helm.sh/chart: {{ include "krwordcloud.chart" . }}
{{ include "krwordcloud.api.matchLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "krwordcloud.ingress.labels" -}}
helm.sh/chart: {{ include "krwordcloud.chart" . }}
{{ include "krwordcloud.ingress.matchLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "krwordcloud.app.matchLabels" -}}
app.kubernetes.io/name: {{ include "krwordcloud.name" . }}-app
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "krwordcloud.api.matchLabels" -}}
app.kubernetes.io/name: {{ include "krwordcloud.name" . }}-api
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "krwordcloud.ingress.matchLabels" -}}
app.kubernetes.io/name: {{ include "krwordcloud.name" . }}-ingress
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "krwordcloud.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "krwordcloud.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Call a template from the context of a subchart.

Usage:
  {{ include "subchart" (list . "<subchart_name>" "<subchart_template_name>") }}
*/}}
{{- define "subchart" }}
{{- $dot := index . 0 }}
{{- $subchart := index . 1 | splitList "." }}
{{- $template := index . 2 }}
{{- $values := $dot.Values }}
{{- range $subchart }}
{{- $values = index $values . }}
{{- end }}
{{- include $template (dict "Chart" (dict "Name" (last $subchart)) "Values" $values "Release" $dot.Release "Capabilities" $dot.Capabilities) }}
{{- end }}
