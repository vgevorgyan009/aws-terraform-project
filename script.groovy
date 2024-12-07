def buildJar() {
    echo 'building the application...'
    sh 'mvn package'
} 

def buildImage() {
    echo 'building the docker image...'
    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        sh 'docker build -t vgevorgyan009/demo-app:19 .'
        sh 'echo $PASS | docker login -u $USER --password-stdin'
        sh 'docker push vgevorgyan009/demo-app:19'
    }
} 

return this
