    #!/bin/sh

    JENKINS_PROJECT_NAME=cicd-tools

    invalid() {
        echo "Error: Invalid parameters!"
        echo
    }

    usage() {
        echo "$ create-build.sh <base-project-name>"
        echo
        echo "Argumentos:"
        echo
        echo "   base-project-name:  Nome base do projeto a ser criado / atualizado"
        echo
    }

    if [ "$BASE_PROJECT_NAME" == "" ]; then
        invalid
        usage
        exit 1
    fi

    echo "------------------------------------------------------------------------------------"
    echo "- VERIFICANDO PROJETOS                                                             -"
    echo "------------------------------------------------------------------------------------"

    oc get project "${BASE_PROJECT_NAME}-dev" > /dev/null

    if [ "$?" == "1" ]; then
        echo "Criando projeto de DEV"
        oc new-project "${BASE_PROJECT_NAME}-dev" > /dev/null
    fi

    oc get project "${BASE_PROJECT_NAME}-hml" > /dev/null

    if [ "$?" == "1" ]; then
        echo "Criando projeto de HML"
        oc new-project "${BASE_PROJECT_NAME}-hml" > /dev/null
    fi

    oc get project "${BASE_PROJECT_NAME}" > /dev/null

    if [ "$?" == "1" ]; then
        echo "Criando projeto de PRD"
        oc new-project "${BASE_PROJECT_NAME}" > /dev/null
    fi

    echo "------------------------------------------------------------------------------------"
    echo "- ADICIONANDO POLICIES AOS PROJETOS                                                -"
    echo "------------------------------------------------------------------------------------"

    oc adm policy add-role-to-user admin \
        system:serviceaccount:"${JENKINS_PROJECT_NAME}:jenkins" -n "${BASE_PROJECT_NAME}"-dev

    oc adm policy add-role-to-user admin \
        system:serviceaccount:"${JENKINS_PROJECT_NAME}:jenkins" -n "${BASE_PROJECT_NAME}"-hml

    oc adm policy add-role-to-user admin \
        system:serviceaccount:"${JENKINS_PROJECT_NAME}:jenkins" -n "${BASE_PROJECT_NAME}"

    # oc adm policy add-role-to-user view dfarias -n "${BASE_PROJECT_NAME}-dev"

    # oc adm policy add-role-to-group view <LDAP_DEV_GRUPO> -n "${BASE_PROJECT_NAME}-hml"

    # oc adm policy add-role-to-group view <LDAP_DEV_GRUPO> -n "${BASE_PROJECT_NAME}"

    echo "------------------------------------------------------------------------------------"
    echo "- ANOTANDO PROJETOS                                                                -"
    echo "------------------------------------------------------------------------------------"

    # oc annotate ns "${BASE_PROJECT_NAME}-dev" openshift.io/node-selector='region=dev' \
    #     -o yaml --overwrite > /dev/null

    # oc annotate ns "${BASE_PROJECT_NAME}-hml" openshift.io/node-selector='region=hml' \
    #     -o yaml --overwrite > /dev/null

    # oc annotate ns "${BASE_PROJECT_NAME}" openshift.io/node-selector='region=prd' \
    #     -o yaml --overwrite > /dev/null

    echo "------------------------------------------------------------------------------------"
    echo "- CRIANDO SECRET PARA PULL DE IMAGEM - CASO NECESSARIO                             -"
    echo "------------------------------------------------------------------------------------"
    # Baixar o yaml da secret aqui: https://access.redhat.com/terms-based-registry/

    oc create -f 6340056_dfarias-secret.yaml -n "${BASE_PROJECT_NAME}"-dev
    oc secrets link default 6340056-dfarias-pull-secret --for=pull -n "${BASE_PROJECT_NAME}"-dev
    oc secrets link builder 6340056-dfarias-pull-secret -n "${BASE_PROJECT_NAME}"-dev
