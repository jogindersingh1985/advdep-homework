#!/usr/bin/env bash

oc new-project tasks-build

oc new-app jenkins-persistent --param ENABLE_OAUTH=true --param MEMORY_LIMIT=2Gi --param VOLUME_CAPACITY=4Gi --param DISABLE_ADMINISTRATIVE_MONITORS=true -n tasks-build

#oc new-app --image-stream=redhat-openjdk18-openshift:1.2 https://github.com/redhat-cop/container-pipelines.git --context-dir=basic-spring-boot

oldwrkdir=${PWD}
mkdir $HOME/tempwrkdir
cd $HOME/tempwrkdir
git clone https://github.com/redhat-cop/container-pipelines.git
cd container-pipelines/basic-spring-boot/


oc new-project tasks-dev --display-name "Tasks Development"
oc policy add-role-to-user edit system:serviceaccount:tasks-build:jenkins -n tasks-dev
oc new-project tasks-test --display-name "Tasks Test"
oc policy add-role-to-user edit system:serviceaccount:tasks-build:jenkins -n tasks-test
oc new-project tasks-prod --display-name "Tasks Prod"
oc policy add-role-to-user edit system:serviceaccount:tasks-build:jenkins -n tasks-prod

