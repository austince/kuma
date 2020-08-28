{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kuma-metrics.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kuma-metrics.fullname" -}}
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
{{- define "kuma-metrics.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kuma-metrics.labels" -}}
helm.sh/chart: {{ include "kuma-metrics.chart" . }}
{{ include "kuma-metrics.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kuma-metrics.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kuma-metrics.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kuma-metrics.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kuma-metrics.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
params: { image: { registry?, repository, tag? }, root: $ }
returns: formatted image string
*/}}
{{- define "kuma.formatImage" -}}
{{- $img := .image }}
{{- $root := .root }}
{{- $registry := ($img.registry | default $root.Values.global.image.registry) -}}
{{- $repo := ($img.repository | required "Must specify image repository") -}}
{{- $defaultTag := ($root.Values.global.image.tag | default $root.Chart.AppVersion) -}}
{{- $tag := ($img.tag | default $defaultTag) -}}
{{- printf "%s/%s:%s" $registry $repo $tag -}}
{{- end -}}
