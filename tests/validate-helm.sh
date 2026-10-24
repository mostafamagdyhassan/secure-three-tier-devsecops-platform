#!/usr/bin/env bash

set -Eeuo pipefail

CHART_DIR="deployment/helm/secure-platform"
RENDERED_FILE="$(mktemp)"

cleanup() {
  rm -f "$RENDERED_FILE"
}
trap cleanup EXIT

echo "==> Validating Helm chart structure"

docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  alpine/helm:3.17.3 \
  lint "$CHART_DIR"

echo "==> Rendering Kubernetes manifests"

docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  alpine/helm:3.17.3 \
  template secure-platform "$CHART_DIR" > "$RENDERED_FILE"

echo "==> Validating rendered Kubernetes manifests"

docker run --rm -i \
  ghcr.io/yannh/kubeconform:v0.6.7 \
  -strict \
  -summary \
  < "$RENDERED_FILE"

echo "==> Helm and Kubernetes manifest validation passed"
