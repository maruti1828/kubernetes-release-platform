
#!/usr/bin/env bash
set -Eeuo pipefail

NAMESPACE="release-platform"
DEPLOYMENT="service-health-dashboard"
CONTAINER="dashboard"
IMAGE_REPOSITORY="ghcr.io/maruti1828/kubernetes-release-platform"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <image-tag>"
  exit 1
fi

IMAGE_TAG="$1"

if [[ ! "$IMAGE_TAG" =~ ^[a-zA-Z0-9_][a-zA-Z0-9_.-]{0,127}$ ]]; then
  echo "Error: Invalid image tag: ${IMAGE_TAG}"
  echo "Use letters, numbers, dots, underscores, or hyphens."
  exit 1
fi

IMAGE="${IMAGE_REPOSITORY}:${IMAGE_TAG}"

echo "Deploying image: ${IMAGE}"

kubectl set image \
  "deployment/${DEPLOYMENT}" \
  "${CONTAINER}=${IMAGE}" \
  --namespace "${NAMESPACE}"

kubectl rollout status \
  "deployment/${DEPLOYMENT}" \
  --namespace "${NAMESPACE}" \
  --timeout=120s

kubectl port-forward \
  --namespace "${NAMESPACE}" \
  "service/${DEPLOYMENT}" 18081:80 \
  >/tmp/kubernetes-release-platform-port-forward.log 2>&1 &
PF_PID=$!

cleanup() {
  kill "${PF_PID}" 2>/dev/null || true
}
trap cleanup EXIT

for i in $(seq 1 15); do
  if curl --fail --silent http://127.0.0.1:18081/health; then
    echo
    echo "Release successful: ${IMAGE}"
    exit 0
  fi
  sleep 2
done

echo "Health check failed for ${IMAGE}"
cat /tmp/kubernetes-release-platform-port-forward.log
exit 1

