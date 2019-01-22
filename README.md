# zetak8s
Zeta running in K8s
--------
This repo is designed first and foremost to help me learn how to create a Kubernetes cluster. I wanted to see what it took to put together a reasonably secure, HA, starter cluster and by creating this repo, I have documented how that is done. 

How it's laid out made sense to me, but my brain is weird and I accept that. Another reason for laying it all out, was to learn, if you see something you think should be better, put it in an issue. Opinions on ways to do things will be heard, but maybe not acted on. Things that make this less secure will likely be addressed quickly. 

Note: I realize kubeadm can do most of this. When I started down this path, I wanted to better understand what was happening. I felt A. kubeadm hid alot of that. and B. At the time, (and still to today I believe) creating a HA cluster, either was supported or was in early beta. Hence my zetak8s

In learning how to create a cluster and document it this way, I have also realized that some of the things I make plugable "libraries" for like the CNI and/or the CRI, allow me to quickly create clusters with documented specs for testing.  Thus all items can be scripts to build a cluster without any interaction. Variables can be defaults, or they can passed in on the command line. This is pretty cool. 


## Notes/Conventions
----
- When I say aws in here, I am still installing Kubernetes from scratch, not getting pre provisioned aws kubernetes cluster
- Big shout out to Mike Bland who right go-script-bash which this is based: https://mike-bland.com/2017/10/08/go-script-bash-v1.7.0.html
  - I am using a relatively old verion, may try with a new version here to get things up to date. 
- Shout out to kelseyhightower who's repo: https://github.com/kelseyhightower/kubernetes-the-hard-way  is what this is loosly based on. It's how I learned to do the Kubernetes
- 

## Instructions
----
[Instructions for getting this working with AWS can be found here](INSTRUCTIONS.md)


## Todo
----
There are number of things I haven't done or considered yet. 

- Different Platforms. Right now there is only libawsplatform. For doing all of the aws things. I'd like others
  - libbaremetalplatform - To install on a server farm and have it work as well as possible. Things like how to replace or ignore the aws loadbalancer needs to be considered
  - libgcpplatform - Google Cloud Platform. 
  - libazureplatform - Run on Azure
  - I will take other suggestions too. The next platform I right I will document better what needs to be involved
- Different Contain Runtimes. Right now We only support libcridocker (Docker).  I'd like to support others just so I can swap them out and do testing. It shouldn't be hard, just need to do it. 
- Different Network runtimes. I have a few CNIs already working, but could use more. 
  - libcnicalico  - Working
  - libcniweave   - Working
  - libcniflannel - Working
- Right now, only Ubuntu 18.04 from aws is working. I'd like to get the scripts for prep working better with other OS so we can quickly test those. I may even use lib?
- More documentation of the individual scripts. I'd like help screens on all of them, just need to write them, or have someone help me with that. 
- ?



