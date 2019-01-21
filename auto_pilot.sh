#!/bin/bash


echo "Creating CA Conf and defaults"

./zeta ca -u

echo "Creating CA"

./zeta ca createca

echo "Starting Nodes"

./zeta platform startnodes
echo ""
echo "Waiting 60 seconds then showing status"
echo ""
sleep 60
./zeta platform status
echo ""
echo "Starting k8s install with defaults"

./zeta k8s -u

echo "Provisioning Loadbalancer"

./zeta k8s createlb
echo ""
sleep 20

echo "Setting up provisioned prep"

./zeta prep -u

echo "Prepping Nodes"

./zeta prep install -a -u

echo "Waiting 60 seconds"

sleep 60

echo "Prep Status"

./zeta prep status

echo "Create Certificates"

 ./zeta k8s initk8scerts

echo "Create conf files"

 ./zeta k8s initk8sconf

echo "Create enc key"

./zeta k8s genenc

echo "Install EtcD"

./zeta k8s etcdinstall 

sleep 5

echo "EtcD Status"

./zeta k8s etcdstatus

sleep 5

echo "Install Controllers"

./zeta k8s k8scontrollerinstall

sleep 5

./zeta k8s k8scontrollerstatus


echo "Install Role Based Access Controlle"

./zeta k8s configrbac

echo "Install Workers"

./zeta k8s k8sworkerinstall

sleep 5

./zeta k8s k8sworkerstatus

sleep 2

echo "Installing network"

./zeta k8s k8snetwork

echo "Installing core-dns"

./zeta k8s k8scoredns

sleep 20

echo "Installing Helm"

./zeta helm -u

./zeta helm installhelm

sleep 10

./zeta helm installtiller

sleep 5

./zeta fs -u

sleep 2

./zeta fs fsdocker

sleep 5

