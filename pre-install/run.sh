#!/bin/bash

ansible-playbook /home/ec2-user/openshift-install-toolset/pre-install/setup.yml -e rhsm_username=$RSHM_USER -e rhsm_pool=$RHSM_POOL "$@"
