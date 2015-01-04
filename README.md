VAC
===

VAC setup is designed with three types/roles of virtual machines

Vagrantfile
=====

Comments in config section of Vagrantfile should explain everything. Just for sake of clarity:

```
// ---------------------------------------------------------------------------------------
// Number of nodes to provision
numNodes = 2

ctrlAddr   = "10.0.1.5"
masterAddr = "10.0.1.6"

// IP Address Base for private network
ipAddrBase = "10.0.1.10"

// list of zones
// zones = ["alpha", "bravo", "charlie", "delta", "echo", "foxtrot"]
zones = ["alpha", "bravo"]
// ---------------------------------------------------------------------------------------
```

*NOTE: zones are just a simple way to group VMs, You probably wont use it anyway - perhaps i should put two Vagrantfiles here, one with zones and one without them*

BEWARE! Math with zones is simple but it's also simple to overlook things if You're one of those people who run code first - then look inside of files.

```
numNodes * zones.length = number_of_launched_virtual_machines
```

So if we have numNodes = 2 here and we have 2 zones set, we will have 4 nodes + controller and master. So it's 6 virtual machines in total.

Controller
=====

Main VAC VM which at this moment hosts only Nginx + Varnish to provide full featured forwarding caching proxy that can be utilized by other VAC virtual machines. The reason why proxy is installed on separate VM is actually only one and it's pretty simple. When something goes wrong during development process (on master or on nodes) and we would like to anihilate all VMs to start from scratch we would lose whole cache after wipeing everything out - if proxy was a part of ie. master node. But... by keeping proxy on separate machine, we can speed this process up and keep all cached files for later use.

TODO:

- really simple internal DNS to help communicate between VMs and LAN using real hosts instead of patching /etc/hosts all over the place

Master
=====

CBSD master node - ansible based setup

Node
=====

CBSD node(s) - ansible based setup
