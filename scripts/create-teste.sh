#!/bin/sh

BASE_PROJECT_NAME=redhat

# source ./create-projects.sh

APP_NAME=sample
GIT_REPO_URL=https://github.com/openshift-s2i/s2i-go.git
GIT_REPO_PIPELINE=https://github.com/marcosmssilva/teste.git

source ./create-app.sh

#docker-registry.default.svc:5000/openshift/jenkins-agent-maven-35-rhel7:v3.11
#registry.redhat.io/openshift3/jenkins-agent-maven-35-rhel7:v3.11