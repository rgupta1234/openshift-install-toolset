#!/bin/bash

ansible-playbook /home/ec2-user/openshift-install-toolset/pre-install/setup.yml -e rhsm_username=rgupta@redhat.com -e rhsm_pool=8a85f98b6200c40c0162016c23aa0b53 "$@"
