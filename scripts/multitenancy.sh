#!/usr/bin/sh

export GUID=`hostname | cut -d"." -f2`

ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd amy r3dh4t1!'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd andrew r3dh4t1!'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd brian r3dh4t1!'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd betty r3dh4t1!'

oc adm groups new alpha-grp amy andrew
oc adm groups new beta-grp brian betty
oc annotate clusterrolebinding.rbac self-provisioners 'rbac.authorization.kubernetes.io/autoupdate=false' --overwrite
oc patch clusterrole self-provisioner -p '{ "metadata": { "annotations": { "openshift.io/reconcile-protect": "true" } } }'
oc adm policy remove-cluster-role-from-group self-provisioner alpha-grp beta-grp || oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth

for OCP_USERNAME in amy andrew brian betty; do

oc create clusterquota clusterquota-$OCP_USERNAME \
 --project-annotation-selector=openshift.io/requester=$OCP_USERNAME \
 --hard pods=30 \
 --hard requests.memory=5Gi \
 --hard requests.cpu=5 \
 --hard limits.cpu=30  \
 --hard limits.memory=60Gi \
 --hard configmaps=30 \
 --hard persistentvolumeclaims=30  \
 --hard services=30

done

pwd=`pwd`
export pwd=$pwd/project-template.yaml
echo "Create template from ${pwd}"
oc create -f $pwd -n default || oc replace -f $pwd -n default

ansible masters -m shell -a "sed -i 's/projectRequestTemplate.*/projectRequestTemplate\: \"default\/project-request\"/g' /etc/origin/master/master-config.yaml"
#ansible masters -m shell -a'systemctl restart atomic-openshift-node; /usr/local/bin/master-restart api; /usr/local/bin/master-restart controllers'

exit 0
