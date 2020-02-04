#!/bin/bash

OPERATOR_SOURCE_REPO=https://github.com/hashicorp/vault-helm.git
OPERATOR_SOURCE_REF=v0.3.3
OPERATOR_SOURCE_DIR=vault-helm

OPERATOR_VERSION=0.0.0
OPERATOR_NAME=vault-helm-operator

OPERATOR_IMAGE_BUILDER=podman

IMAGE_REPO=quay.io/noseka1
OPERATOR_IMAGE_REPO=$IMAGE_REPO/$OPERATOR_NAME
OPERATOR_BUNDLE_IMAGE_REPO=$IMAGE_REPO/$OPERATOR_NAME-bundle
OPERATOR_REGISTRY_IMAGE_REPO=$IMAGE_REPO/$OPERATOR_NAME-registry

# The 1.5.6 image works with opm 1.5.8, images 1.5.7 and 1.5.8 don't work
REGISTRY_BUILDER_IMAGE_REPO=quay.io/operator-framework/upstream-registry-builder:v1.5.6

git clone $OPERATOR_SOURCE_REPO \
  --branch $OPERATOR_SOURCE_REF

operator-sdk new $OPERATOR_NAME \
  --type helm \
  --helm-chart $OPERATOR_SOURCE_DIR

cp templates/* $OPERATOR_NAME/helm-charts/vault/templates

pushd $OPERATOR_NAME

operator-sdk build $OPERATOR_IMAGE_REPO \
  --image-builder $OPERATOR_IMAGE_BUILDER

podman push $OPERATOR_IMAGE_REPO

operator-sdk generate csv \
  --csv-version $OPERATOR_VERSION \
  --update-crds

operator-sdk bundle create $OPERATOR_BUNDLE_IMAGE_REPO \
  --directory ./deploy/olm-catalog/$OPERATOR_NAME/$OPERATOR_VERSION \
  --image-builder $OPERATOR_IMAGE_BUILDER

podman push $OPERATOR_BUNDLE_IMAGE_REPO

opm index add \
  --bundles $OPERATOR_BUNDLE_IMAGE_REPO \
  --tag $OPERATOR_REGISTRY_IMAGE_REPO \
  --binary-image $REGISTRY_BUILDER_IMAGE_REPO

popd

sed vault-helm-operator-catalogsource.yaml.in \
  --expression "s#@@OPERATOR_NAME@@#$OPERATOR_NAME#" \
  --expression "s#@@OPERATOR_REGISTRY_IMAGE_REPO@@#$OPERATOR_REGISTRY_IMAGE_REPO#" \
  > vault-helm-operator-catalogsource.yaml
