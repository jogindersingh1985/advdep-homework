#!/usr/bin/sh
oc get users
oc login -u amy -p r3dh4t1!
oc login -u andrew -p r3dh4t1!
oc login -u brian -p r3dh4t1!
oc login -u betty -p r3dh4t1!
oc login -u system:admin
oc get users

oc label user/amy client=alpha
oc label user/andrew client=alpha
oc label user/brian client=beta
oc label user/betty client=beta

exit 0
