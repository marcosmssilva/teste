#!/bin/sh

invalid() {
    echo "Error: Invalid parameters!"
    echo
}

usage() {
    echo "$ create-app.sh"
    echo
    echo "ENV"
    echo
    echo "   BASE_PROJECT_NAME: Nome base do projeto a ser criado / atualizado"
    echo "   APP_NAME:          Nome da aplicacao a ser criada"
    echo "   GIT_REPO_URL:      Repositório GIT"
    echo "   GIT_REPO_PIPELINE: Repositório Pipelines GIT"
    echo
}

if [ "$BASE_PROJECT_NAME" == "" ]; then
    invalid
    usage
    exit 1
fi

if [ "$APP_NAME" == "" ]; then
    invalid
    usage
    exit 1
fi

if [ "$GIT_REPO_URL" == "" ]; then
    invalid
    usage
    exit 1
fi

if [ "$GIT_REPO_PIPELINE" == "" ]; then
    invalid
    usage
    exit 1
fi

echo "------------------------------------------------------------------------------------"
echo "- ADICIONANDO POLICIES ADICIONAIS AOS PROJETOS                                     -"
echo "------------------------------------------------------------------------------------"

oc adm policy add-role-to-user system:image-puller \
    system:serviceaccount:"${BASE_PROJECT_NAME}:${APP_NAME}" -n "${BASE_PROJECT_NAME}-dev"

oc adm policy add-role-to-user system:image-puller \
    system:serviceaccount:"${BASE_PROJECT_NAME}:${APP_NAME}" -n "${BASE_PROJECT_NAME}-hml"

oc adm policy add-role-to-user system:image-puller \
    system:serviceaccount:"${BASE_PROJECT_NAME}:${APP_NAME}" -n "${BASE_PROJECT_NAME}"

echo "------------------------------------------------------------------------------------"
echo "- ADICIONANDO PIPELINES                                                            -"
echo "------------------------------------------------------------------------------------"

oc process -f ../templates/springboot-pipeline-dev.yml -n openshift \
    -p BASE_PROJECT_NAME=$BASE_PROJECT_NAME \
    -p APP_NAME=$APP_NAME \
    -p GIT_REPO_URL=$GIT_REPO_URL \
    -p GIT_REPO_PIPELINE=$GIT_REPO_PIPELINE \
    | oc apply -n "${BASE_PROJECT_NAME}-dev" -f -

oc process -f ../templates/springboot-pipeline-hml.yml -n openshift \
    -p BASE_PROJECT_NAME=$BASE_PROJECT_NAME \
    -p APP_NAME=$APP_NAME \
    -p GIT_REPO_PIPELINE=$GIT_REPO_PIPELINE \
    | oc apply -n "${BASE_PROJECT_NAME}-hml" -f -

oc process -f ../templates/springboot-pipeline-prd.yml -n openshift\
    -p BASE_PROJECT_NAME=$BASE_PROJECT_NAME \
    -p APP_NAME=$APP_NAME \
    -p GIT_REPO_PIPELINE=$GIT_REPO_PIPELINE \
    | oc apply -n "$BASE_PROJECT_NAME" -f -
