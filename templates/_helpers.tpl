{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-simple-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "k8s-simple-app.fullname" -}}
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
Full domain, including optional subdomain
*/}}
{{- define "k8s-simple-app.fullDomain" -}}
    {{- if .Values.ingress.subdomain -}}
        {{- printf "%s.%s" .Values.ingress.subdomain (required "Domain is mandatory" .Values.ingress.domain) -}}
    {{- else -}}
        {{- required "Domain is mandatory" .Values.ingress.domain -}}
    {{- end -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "k8s-simple-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "k8s-simple-app.labels" -}}
helm.sh/chart: {{ include "k8s-simple-app.chart" . }}
{{ include "k8s-simple-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "k8s-simple-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k8s-simple-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "k8s-simple-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "k8s-simple-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{/* TODO check https://helm.sh/docs/chart_template_guide/functions_and_pipelines/#using-the-default-function */}}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a default TLS secret name.
*/}}
{{- define "k8s-simple-app.tlsSecretName" -}}
{{- if .Values.ingress.tlsSecretName }}
{{- .Values.tlsSecretName | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name "ingress-tls" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
