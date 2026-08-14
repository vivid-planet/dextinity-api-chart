# dextinity-api-chart

Helm chart for a Dextinity API Microservice.

## Installation

The chart is published as an OCI artifact:

```bash
helm install my-release oci://ghcr.io/vivid-planet/charts/dextinity-api --version 1.0.0
```

As a dependency of an umbrella chart:

```yaml
dependencies:
    - name: dextinity-api
      version: "1.0.0"
      repository: "oci://ghcr.io/vivid-planet/charts"
```

There is no `helm repo add` step — the `oci://` repository is resolved directly.

## Branches

Every major version has its own branch. `v1.x` carries the 1.x line and is the default
branch; a breaking change opens a `v2.x` branch next to it, so older majors keep receiving
fixes.

## Versioning

Versioning is handled by [changesets](https://github.com/changesets/changesets). Add a
changeset to a pull request with `npx changeset`. Merging the resulting release pull
request bumps `Chart.yaml` and `package.json`, updates the changelog and publishes the
chart to the registry.

## Origin

This chart continues `comet-api` 3.3.0 from
[comet-charts](https://github.com/vivid-planet/comet-charts) and restarts at `1.0.0`.
Besides the renaming, the templates are unchanged.
