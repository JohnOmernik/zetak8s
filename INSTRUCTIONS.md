# zetak8s Instructions
-----
### Quick Note about Auto scripts
------
There are two scripts included to automate cluster creation
- auto_start.sh       # This script can only be run if platform.conf is setup and ready to go. If not, it will fail and you will have no cluster
- auto_reset.sh       # This script terminates everything to the best of it's ability and removes all conf files EXCEPT platform.conf.  (So you can quickly start and stop things)

--------
# Script sections
-------
Prior to going into an order of how to work things, a simple description of the parts of the install is here. 

Following this section we will review the steps to just get it running.  All of the scripts can use a -u option and defaults will likely work (on aws)

If you want to specify certain options, you may need to run with options (or not run in unattended mode).  Also, you can change the .conf files located in ./conf after each section. 


## Platform Scripts
---------
This sets up the platform being using.  Right now automated setup of platform is limited to AWS.  To use another platform, you need to have servers setup in a way that allows you to connect with a key. 

(More information to come)

This is the first thing you must do either for manual, or for the auto_start.sh. The following step MUST BE DONE. 

## CA Scripts
------
In order to be secure with K8s, and in general we create a local CA.  At this time only a local CA is supported, although, I could see us being able to integrate to enterprise CAs if needed. 

We use cfssl to create the CA and use it.  

## K8s Scripts
-----
Now that you've defined your platform and started some nodes, we run through the k8s conf setup to help with setup later on

## Prep Scripts
-----
These scripts do basic things like update the OS, install a non-root admin user, and ensure proper keys are utilized. 

## Helm Scripts
-----
These scripts install both helm and tiller for doing deployments. 

## fs Scripts
----
This is an example install of a Docker Registry. It could potentially be used for storing the filesystem images (before the filesystem is bootstrapped)

That said, it's not used at this time other than to show an example install

------
# Install Order
-----
These instructions go over each script briefly. After the initial configuration of ./zeta platform, all scripts are also in the auto_start.sh script for reuse. 

### Platform conf
```
./zeta platform
```
------
This creates the platform.conf file for interacting with the platform of choice.  Highly recommend you review this. It will install the awscli on your machine, however, you will have to edit ~/.aws/config and ~/.aws/credentials  

This is needed to auto create nodes!

For ~/.aws/config I use the following. Most of the Defaults are around us-west-2 if you want to change it make sure you know your aws stuff.
```
[default]
region = us-west-2
```

For ~/.aws/credentials I use the following:
```
[default]
aws_access_key_id = %YOURACCESSKEYID%
aws_secret_access_key = %YOURACCESSKEYSECRET%
```

Note: You will also need a private key for the nodes that is registered with AWS. I probably could automate that, but not today.  I default to the key name zeta.pem, however, you have the option to change it later

------
## Note
------
This is where the auto_start.sh script starts, it doesn't call ./zeta platform at this time, and the reset resets it to just after platform.conf is created, this is so you can you spin up and spin down faster

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

If you run this without -u it will ask you these questions. All results are stored in ./conf/ca.conf

### Create the CA
```
./zeta ca createca 
```
----
This actually instantiates your CA based on the values in ca.conf. There is no user input here, so -u doesn't do anything. 

### Start the nodes
```
./zeta platform startnodes
```
-----
Start the nodes given the count and types in the platform.conf This is automated, no user input

### Check Node status
```
./zeta platform status 
````
-----
Display the status of the nodes. No user input

### Create the K8s conf
```
./zeta k8s
```
-----
The conf is created now so that we can reference your setup in the future steps. It reads from aws to see what nodes are running and puts them into play. 

If you use -u it uses some pretty decent defaults. Checkout the ./scripts/k8s.d/createconf for tunables. 

This script is also a script only, meaning, you can run it, and change most things before next steps. One exception is the kubernetes version. If you use -u, it picks a version and downloads kubectl for that version. This doesn't change later


### Create Load Balancer
```
./zeta k8s createlb
```
----
This is a platform specific setup that allows you to connect to all the nodes easily. If on prem, there may not be a load balancer, so it will just ensure there is local network connectivity. 


### Run the prep.conf install
```
./zeta prep
```
-------
Asks some questions about the setup.  If you want this to be truly automated, you do need to create a password file in the ./conf directory.  The default is iuser.pass put the password on the first line. 

Note: chmod 600 this file for better security. If you want to use a different file you can specify it's location. 


### Install prep items
```
./zeta prep install -a
```
-----
Installs the users, software, and settings on all nodes (-a) based on the requirements of the OS

### Display prep status
```
./zeta prep status 
```
-----
Shows all the nodes and the status of the prep work


### Create Kubernetes Certificates
```
./zeta k8s initk8scerts 
```
-----
This command creates all the certificates required for Kubernetes, etcd, etc from the CA created above

### Create Kubernetes Configurations
```
./zeta k8s initk8sconf
````
----
This generates the K8s conf files and distributes them to the appropriate nodes

### Create Kubernetes Encryption Key
```
./zeta k8s genenc
```
-----
This gnerates the K8s Encryption Key

### Install EtcD on the Master Nodes
```
./zeta k8s etcdinstall 
```
-----
This bootstraps etcd on all the nodes.

### Check the EtcD Status
```
./zeta k8s etcdstatus
```
-----
This shows the status of etcd. It should all list started

### Install the master services
```
./zeta k8s k8scontrollerinstall
```

This installs the controller/master services on the cluster. 

### Check the Master Services status
```
./zeta k8s k8scontrollerstatus
```
------
Check the status of the controller plane. scheduler and controller-manager should show ok for all nodes, and etc instances should show health:true

### Configure Role Based Access Controls
```
./zeta k8s configrbac
```
------
Applies and installs Role Based Access Controls (rbac) to the cluster. 

### Install Kubernetes Workers
```
./zeta k8s k8sworkerinstall
```
-----
Installs worker nodes

### Check the Kubernetes Worker Status
```
./zeta k8s k8sworkerstatus 
```
-----
Shows the status of the installed nodes (Should all be ready)

### Install the Selected CNI Network
```
./zeta k8s installnetwork
```
----
Installs the CNI Networking Software per the selected network in k8s.conf

### Install CoreDNS
```
./zeta k8s k8scoredns
```
-----
Install Core DNS services to be running on the network for service discovery


### Configure Helm
```
./zeta helm 
```
----
Create the helm.conf file. This works quite well with ./zeta helm -u

### Install Helm
```
./zeta helm installhelm
```
----
Download the Helm binaries per the version helm.conf

### Install Tiller
```
./zeta helm installtiller
```
----
Install Tiller onto the cluster based on the version in helm.conf

### Config fs 
```
./zeta fs
```
----
This is not the full fs config. That comes later. This is just to create a simple, not HA docker registry running on the cluster in case you want to run the filesystem bootstrap from here. 

It's also just a demo test deploy of a docker registry, not backed by a distributed filesystem i.e. if the node that you push your images to is gone, so are your images. 

-u works great here (Not to many selectables)

### Install fsdocker
```
./zeta fs fsdocker
```
----
Actually install the fsdocker service
