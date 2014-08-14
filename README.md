dd-agent-omnibus
================

## Use omnibus locally

* Clone the dd-agent-omnibus repo

* Install necessary vagrant plugins
```
vagrant plugin install vagrant-cachier --plugin-version=0.7.2
vagrant plugin install vagrant-berkshelf --plugin-version=2.0.1
vagrant plugin install vagrant-omnibus --plugin-version=1.4.1
```
* Build one package
```
AGENT_VERSION=5.0.0 BUILD_NUMBER=1 AGENT_BRANCH=leo/memorylimit PKG_TYPE=deb ARCH=x64 vagrant reload debian-x64 --provision
```

PKG_TYPE should be "deb" or "rpm".

ARCH should be "i386" or "x64".

You can use `AGENT_LOCAL_REPO` variable and set it to a path on your host machine to use your repo.

