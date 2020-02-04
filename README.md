# Vault Helm Operator

Scripts in this repository can build a Helm operator for deploying HashiCorp Vault on OpenShift. The operator is built using [operator-sdk](https://github.com/operator-framework/operator-sdk) and [official Vault Helm chart](https://github.com/hashicorp/vault-helm).

## Requirements

* git
* operator-sdk
* opm
* podman

## Building the Operator

Modify [build.sh](build.sh) to fit your needs. Run the script:

```
$ ./build.sh
```

Deploy the operator on OpenShift and create a vault instance:

```
$ oc new-project vault
$ oc apply --kustomize deploy
$ oc apply --filename vault-helm-operator/deploy/crds/charts.helm.k8s.io_v1alpha1_vault_cr.yaml
```

Optionally, create a TLS edge-terminated route:

```
$ oc create route edge vault --port 8200 --service example-vault
```
