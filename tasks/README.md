cd tasks
ansible-galaxy install -r requirements.yml --roles-path=galaxy
ansible-playbook -i ./.applier/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml
