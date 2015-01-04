VAC
===

VAC setup is designed with three types/roles of virtual machines

Controller
=====

Main VAC VM which at this moment hosts only Nginx + Varnish to provide full featured forwarding proxy that can be utilized by other VAC virtual machines. The reason why proxy is installed on separate VM is actually only one and it's pretty simple. When something goes wrong during development process (on master or on nodes) and we would like to anihilate all VMs to start from scratch we would lose whole cache after wipeing everything out - if proxy was a part ie. master node. But... by keeping proxy on separate machine, we can speed this process up and keep all cached files for later use.

TODO:

- really simple internal DNS to help communicate between VMs and LAN using real hosts instead of patching /etc/hosts all over the place

Master
=====

CBSD master node - ansible based setup

Node
=====

CBSD node(s) - ansible based setup
