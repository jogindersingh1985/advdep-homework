#!/usr/bin/env bash

oc new-project tasks-build --display-name="Spring Rest App - Build"

oc new-app jenkins-persistent --param ENABLE_OAUTH=true --param MEMORY_LIMIT=2Gi --param VOLUME_CAPACITY=4Gi --param DISABLE_ADMINISTRATIVE_MONITORS=true -n tasks-build

cd $HOME/advdep-homework/tasks 
ansible-galaxy install -r requirements.yml --roles-path=galaxy 
ansible-playbook -i ./.applier/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml
cd -
