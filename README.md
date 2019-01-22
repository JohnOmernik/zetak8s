# zetak8s
Zeta running in K8s
--------
# Quick Note about Auto scripts
------
There are two scripts included to automate cluster creation
- auto_start.sh       # This script can only be run if platform.conf is setup and ready to go. If not, it will fail and you will have no cluster
- auto_reset.sh       # This script terminates everything to the best of it's ability and removes all conf files EXCEPT platform.conf.  (So you can quickly start and stop things)

--------
# Order to get a K8s Cluster Running
-------
## Platform Scripts
---------
This sets up the platform being using.  Right now automated setup of platform is limited to AWS.  To use another platform, you need to have servers setup in a way that allows you to connect with a key. 

(More information to come)

This is the first thing you must do either for manual, or for the auto_start.sh. The following step MUST BE DONE. 

### Platform conf
```
./zeta platform
```
------
This creates the platform.conf file for interacting with the platform of choice. 



## CA Scripts
------
In order to be secure with K8s, and in general we create a local CA.  At this time only a local CA is supported, although, I could see us being able to integrate to enterprise CAs if needed. 

We use cfssl to create the CA and use it.  

------
### Note
------
This is where the auto_start.sh script starts, it doesn't call ./zeta platform at this time


### CA conf
```
./zeta ca 
```
------
This creates the ca.conf file for creating the CA. 

If you run this with -u it runs unattended and uses some defaults for CA values.  If you want to run with -u and pass your own values in as defaults you may

- -u      # Unattended
- -c      # Country
- -st     # State
- -l      # Location
- -o      # Organization
- -ou     # Organizational Unit
- -cn     # Common Name
- -algo   # Algorithm used
- -ks     # Key size

If you run this without -u it will ask you these questions. All resulsts are stored in ./conf/ca.conf

### Create the CA
```
./zeta ca createca 
```
----
This actually instantiates your CA based on the values in ca.conf


## Back to Platform
-----
The following two steps actually uses the platform library to start up the nodes automatically if supported
-----
### Start the nodes
-----
Start the nodes given the count and types in the platform.conf
```
./zeta platform startnodes
```

### Check Node status
-----
Display the status of the nodes
```
./zeta platform status 
````

## K8s Configuration and setup
-----
Now that you've defined your platform and started some nodes, we run through the k8s conf setup to help with setup later on

### Create the K8s conf
-----
The conf is created now so that we can reference your setup in the future steps
```
./zeta k8s
```
### Create Load Balancer
----
This is a platform specific setup that allows you to connect to all the nodes easily. If on prem, there may not be a load balancer, so it will just ensure there is local network connectivity. 
```
./zeta k8s createlb
```

## Prep the nodes
----
These scripts do some basic install based on the OS as well as installing the non-root admin user
### Run the prep.conf install
-------
Asks some questions about the setup.  If you want this to be truly automated, you do need to create a password file in the ./conf directory.  The default is iuser.pass put the password on the first line. 

Note: chmod 600 this file for better security. If you want to use a different file you can specify it's location. 

```
./zeta prep
```

### Install prep items
-----
Installs the users, software, and settings on all nodes (-a) based on the requirements of the OS
```
./zeta prep install -a
```

### Display prep status
-----
Shows all the nodes and the status of the prep work
```
./zeta prep status 
```

###########################################################################################
10. ./zeta k8s initk8scerts 

This generates the client and server scripts

11. ./zeta k8s initk8sconf

This generates the K8s conf files and distributes them to the appropriate node

12 ./zeta k8s genenc

This gnerates the K8s Encryption Key

13. ./zeta k8s etcdinstall 

This bootstraps etcd on all the nodes.

14. ./zeta k8s etcdstatus

This shows the status of etcd. It should all list started

14. ./zeta k8s k8scontrollerinstall

This installs the controller/master services on the cluster. 

15 ./zeta k8s k8scontrollerstatus

Check the status of the controller plane. scheduler and controller-manager should show ok for all nodes, and etc instances should show health:true

16. ./zeta k8s configrbac

Applies and installs Role Based Access Controls (rbac) to the cluster. 

17. ./zeta k8s k8sworkerinstall

Installs worker nodes

18. ./zeta k8s k8sworkerstatus 

Shows the status of the installed nodes (SHould all be ready)

19. ./zeta k8s installnetwork

Installs the Networking per the selected network in k8s.conf

20. ./bin/kubectl --kubeconfig ./conf/k8s/admin/admin_ext.kubeconfig get pods -n kube-system

Show the running pods (including network pods)

