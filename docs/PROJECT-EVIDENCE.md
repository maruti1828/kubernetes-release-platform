
# Project Evidence — Kubernetes Release Platform

## Project Status

The core application and release workflow have been tested successfully.

## Verified Capabilities

- Docker image builds successfully.
- GitHub Actions builds and health-checks the Docker image.
- Images are published to GitHub Container Registry.
- Kubernetes runs two application replicas.
- Readiness and liveness probes are configured.
- The deployment script waits for rollout completion and verifies the `/health` endpoint.
- The dashboard and health endpoint respond successfully.
- The README is committed to the GitHub repository.

## Environment

- Application: Nginx Service Health Dashboard
- Orchestration: Kubernetes using kind
- CI: GitHub Actions
- Container registry: GitHub Container Registry
- Namespace: `release-platform`
- Deployment: `service-health-dashboard`
- Service: `service-health-dashboard`

## Commands for Verification

```bash
kubectl get deployment service-health-dashboard -n release-platform
kubectl get pods -n release-platform
kubectl get service service-health-dashboard -n release-platform
kubectl rollout history deployment/service-health-dashboard -n release-platform
```

## Evidence Screenshots

Screenshots can be added to `docs/screenshots/` when available. No screenshot is claimed to be included until the image file has been committed.

## Future Improvements

- Automated deployment from GitHub Actions.
- Verified rollback when a release fails.
- Container image vulnerability scanning.
- Separate staging and production environments.
