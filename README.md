# zetak8s
Zeta running in K8s

--------
# Order to get a K8s Cluster Runngin

1. ./zeta platform 
   
This asks some questions on what platform, what type of nodes, etc. Right now we only have AWS

2. ./zeta ca 

This asks some questions on your CA. It.s stored in ./conf/ca 

3. ./zeta ca createca 

This actually instantiates your CA

4.  ./zeta platform startnodes

4.5. ./zeta platform status # Optional show status of nodes

This runs your platform startup, gets you 5 nodes (You can check this with ./zeta platform status)

5. ./zeta k8s

This asks some questions for your K8s Cluster based on your started nodes in 4

6. ./zeta k8s createlb

Creates a LB for us to use

7. ./zeta prep

Initializes the prep scripts 

8. ./zeta prep install -a

Installs the new users and docker on all nodes. Also creates /opt/k8s and works to patch. 

9. ./zeta prep status 

This shows the status of the nodes, they should be up and running and good with docker. 

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

