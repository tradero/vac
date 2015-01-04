Vagrant Helper Scripts
===

Those are few scripts created to help with quick and easy VMs management. Whenever they can scripts should work with VMs in parallel which should speed up the whole process.

What is what
=====

We're using few vagrant plugins here, so let's ensure that we have all of them installed

```
./scripts/setup.sh
```

Bring up VMs cluster - without provisioning to be sure that setting up base system will be fast even if we wont be able to work in parallel

```
./scripts/up.sh
```

To run provisioning on all of VMs at the same time

```
./scripts/provision.sh
```

After launching cluster is done, let's snapshot the whole thing, to make it even faster with reverting to "clean" state

```
./scripts/snapshot.sh
```

When things go wrong, let's revert everything to snapshot

```
./scripts/revert.sh
```

When "wrong" is not even close to describe how badly You're screwed ;-)

*NOTE: please take a look inside of recreate.sh script - it's just a wrapper for other scripts (destroy, up, provision, snapshot)*

```
./scripts/recreate.sh
```

If You don't need your cluster anymore, just go with

```
./scripts/destroy.sh
```
