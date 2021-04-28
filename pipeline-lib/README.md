
# Como fazer uso das funções auxiliares

No início do arquivo do pipeline deve-se declarar que será feito uso de bibliotecas auxiliares da seguinte forma:

````
#!groovy

@Library('funcoes-auxiliares') _

node('master') {

  stage('Checkout') {
    git branch: 'master',
        url: 'http://gogs-cicd.apps.rh-consulting-br.com/samples/app-s2i.git'
  }

  stage('Variaveis') {
    def groupId    = getGroupIdFromPom()
    def artifactId = getArtifactIdFromPom()
    def version    = getVersionFromPom()

    echo "Artifact ID: ${artifactId} - Group ID: ${groupId} - Version: ${version}"
  }
}
````
