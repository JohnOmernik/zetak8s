#!/bin/bash


echo "This script resets the CA, shuts down load balancers, and nodes and removes the prep scripts, and conf files for k8s, prep, and ca"
echo ""
echo "****************************"
echo ""
echo "Pausing for 10 seconds so you can cancel if you want"
echo ""
echo "*****************************"
echo ""
sleep 15

./zeta k8s deletelb -u

./zeta platform termnodes -u

cd ./bin
rm prepstatus.sh centos_prep1.sh centos_prep2.sh master_init_output.json worker_init_output.json master_specification.json worker_specification.json system_type.sh ubuntu_prep.sh helm kubectl
cd ..
rm -rf ./conf/k8s
rm -rf ./conf/ca
rm -rf ./conf/helm
rm ./helm
rm ./kubectl
rm ./conf/helm.conf
rm ./conf/ca.conf
rm ./conf/k8s.conf
rm ./conf/iuser.key
rm ./conf/iuser.key.pub
rm ./conf/userupdate.sh
rm ./conf/prep.conf
rm ./conf/fs.conf
