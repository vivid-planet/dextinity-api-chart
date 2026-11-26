{{/*
Expand the name of the chart.
*/}}
{{- define "dextinity-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dextinity-api.fullname" -}}
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
{{- define "dextinity-api.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dextinity-api.labels" -}}
helm.sh/chart: {{ include "dextinity-api.chart" . }}
{{ include "dextinity-api.selectorLabels" . }}
  {{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
  {{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dextinity-api.selectorLabels" -}}
app: {{ include "dextinity-api.fullname" . }}
app.kubernetes.io/name: {{ include "dextinity-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector matchLabels
*/}}
{{- define "dextinity-api.selectorMatchLabels" -}}
app.kubernetes.io/name: {{ include "dextinity-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "dextinity-api.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create }}
{{- default (include "dextinity-api.fullname" .) .Values.serviceAccount.name }}
  {{- else }}
{{- default "default" .Values.serviceAccount.name }}
  {{- end }}
{{- end }}

{{/*
Parse a 1Password secret reference (op://vault/item/[section/]field, optionally wrapped in
{{ }}) into its vault, item and field, plus the derived OnePasswordItem itemPath and a
deterministic Kubernetes Secret name for the item (shared by all fields of the same item).
*/}}
{{- define "dextinity-api.opRef.parse" -}}
  {{- $raw := trim . -}}
  {{- if and (hasPrefix "{{" $raw) (hasSuffix "}}" $raw) -}}
    {{- $raw = $raw | trimPrefix "{{" | trimSuffix "}}" | trim -}}
  {{- end -}}
  {{- if not (hasPrefix "op://" $raw) -}}
    {{- fail (printf "invalid 1Password secret reference %q, expected op://vault/item/[section/]field" $raw) -}}
  {{- end -}}
  {{- $ref := trimPrefix "op://" $raw -}}
  {{- $parts := splitList "/" $ref -}}
  {{- if lt (len $parts) 3 -}}
    {{- fail (printf "invalid 1Password secret reference %q, expected op://vault/item/[section/]field" $raw) -}}
  {{- end -}}
  {{- $vault := index $parts 0 -}}
  {{- $item := index $parts 1 -}}
  {{- $field := index $parts (sub (len $parts) 1) -}}
  {{- $secretName := printf "op-%s" (regexReplaceAll "[^a-z0-9-]+" (lower $item) "-" | trunc 40 | trimSuffix "-") -}}
  {{- dict "vault" $vault "item" $item "field" (lower $field) "itemPath" (printf "vaults/%s/items/%s" $vault $item) "secretName" $secretName | toJson -}}
{{- end -}}
