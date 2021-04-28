#!/bin/sh

BASE_PROJECT_NAME=redhat

# source ./create-projects.sh

APP_NAME=sample
GIT_REPO_URL=http://gogs-cicd-tools.apps.brazil01.lab.upshift.rdu2.redhat.com/desenv/app-s2i.git
GIT_REPO_PIPELINE=http://gogs-cicd-tools.apps.brazil01.lab.upshift.rdu2.redhat.com/infra/pipelines.git

source ./create-app.sh

#docker-registry.default.svc:5000/openshift/jenkins-agent-maven-35-rhel7:v3.11
#registry.redhat.io/openshift3/jenkins-agent-maven-35-rhel7:v3.11