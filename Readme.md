# Smasher chart ⎈💢🕷

Demo helm chart for deploying [Smasher Backend](https://github.com/casimon-rh/smasher-backend) on Openshift 🔴

## Demos 🕹

1. 🌀 Quarkus: [github](https://github.com/elsony/devfile-sample-code-with-quarkus) & [s2i image](registry.redhat.io/openjdk/openjdk-11-rhel7)
2. ♦️🟥 Ruby: [github](https://github.com/sclorg/ruby-ex) & [s2i image](registry.access.redhat.com/ubi8/s2i-base:1-288)

## Technologies 📱

* 🌐 Openshift Service Mesh©
* 🪠 Openshift Pipelines©

## Openshift Objects 🛠

* Configmap(s)
* Deployment
* Pipeline
* Service Account + Role Binding
* Route / Gateway
* Service + Virtual Service
* Secret(s)

## Needed config ⚙️

```yaml
# values-smasher.yaml
---
image:
  repository: "" # change img (default quay)
...
env:
  - name: SELF_TAG
    value: "" # change app tag (chartname + nameOverride)
...

configmaps:
  create: true
  list:
  - name: keys
    data:
      key.pem: ""  # set custom privkey (rsa)
      pubkey.pem: "" # set custom pubkey (rsa)
...

secrets:
  create: true
  list:
  - name: quay
    type: kubernetes.io/dockerconfigjson
    data:
      .dockerconfigjson: "" # credentials for img repository
``` 

```yaml
# demos/{env}/values-{quarkus,ruby}.yaml
---
image:
  repository: "" # change img (default quay)
...

secrets:
  create: true
  list:
  - name: quay
    type: kubernetes.io/dockerconfigjson
    data:
      .dockerconfigjson: "" # credentials for img repository
```

## Deployment ⬆️

```bash
helm install smasher smasher -f values-smaser.yaml
helm install smasher smasher -f demos/...
```

## Manual Steps ✍️

In case of deployment via **Argo CD** there's a missing feature around the [lookup](https://helm.sh/docs/chart_template_guide/functions_and_pipelines/#using-the-lookup-function) function, so there are some **override** values:

```yaml
overrideApiDomain: ""
overrideSecretName: ""
```
See also: https://github.com/argoproj/argo-cd/issues/3640

For running the pipeline it need to be assigned the secret (img repo credentials) to the _pipeline_ service account.

## Next steps 🚶‍♂️

* Pipeline triggers
* More demos
* Argo Appsets

## Main integration 🔮

> [🦄 Ubiquitous Journey 🔥](https://github.com/rht-labs/ubiquitous-journey)
