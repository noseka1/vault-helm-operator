# Vault Helm Operator

Scripts in this repository can build a Helm operator for deploying HashiCorp Vault on OpenShift. The operator is built using [operator-sdk](https://github.com/operator-framework/operator-sdk) and [official Vault Helm chart](https://github.com/hashicorp/vault-helm).

## Required Tools

* git
* operator-sdk
* opm
* podman

## Building the Operator

Modify [script.sh](script.sh) to fit your needs. Run the script:

```
./script.sh
```
