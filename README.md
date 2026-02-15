# opds-shelf Helm Chart

`opds-shelf` deploys:
- Calibre (`calibre-server` + `calibredb`)
- Calibre-Web (UI + OPDS)
- OPDS Aggregator (single OPDS endpoint)
- Optional importer `CronJob` (imports files from `/ingest` into Calibre library)

## Prerequisites

- Kubernetes 1.24+
- Helm 3.10+
- Shared RWX storage for `/books` (recommended): NFS / CephFS / Longhorn RWX

## Install

```bash
helm install opds-shelf . \
  --set ingress.hosts[0].host=opds.example.com \
  --set ingress.hosts[1].host=calibreweb.example.com \
  --set library.persistence.existingClaim=books-rwx \
  --set ingest.persistence.existingClaim=ingest-rwx
```

## Upgrade

```bash
helm upgrade opds-shelf .
```

## Uninstall

```bash
helm uninstall opds-shelf
```

## Key Values

- `library.persistence.*`: main books storage (`/books`)
- `ingest.persistence.*`: importer inbox storage (`/ingest`)
- `calibre.*`: Calibre image/service/config persistence
- `calibreWeb.*`: Calibre-Web image/service/config persistence
- `opdsAggregator.*`: OPDS aggregator image/service/config/auth
- `importer.*`: cron schedule + importer container
- `ingress.*`: hosts/paths/tls for public routing

## Publish as Helm Repo (GitHub Pages)

This repository includes a GitHub Actions workflow:
- `.github/workflows/release.yml`

What it does on push to `main`/`master`:
1. Lints chart
2. Packages chart (`.tgz`)
3. Updates `gh-pages` branch (`index.yaml` + packages)
4. Copies `artifacthub-repo.yml` to `gh-pages`

Helm repo URL:

```text
https://<github-user>.github.io/<repo-name>
```

Usage after publish:

```bash
helm repo add opds-shelf https://<github-user>.github.io/<repo-name>
helm repo update
helm install opds-shelf opds-shelf/opds-shelf
```

## Artifact Hub

1. Publish chart to GitHub Pages (workflow above).
2. Add Helm repository in Artifact Hub:
   - Repository URL: `https://<github-user>.github.io/<repo-name>`
3. Update `artifacthub-repo.yml` with real owners.
4. (Optional) For ownership claim / verified publisher, set `repositoryID` from Artifact Hub.

