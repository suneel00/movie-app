pipeline {
  agent any

  environment {
    DOCKER_IMAGE = 'suneel00/movie-app'
    DOCKER_TAG = 'v2'
  }

  stages {

    stage('Clone Repo') {
      steps {
        git credentialsId: 'ec2-deploy-key', branch: 'main', url: 'https://github.com/suneel00/movie-app.git'
      }
    }

    stage('Build and Tag Docker Image') {
      steps {
        sh '''
          docker build -t movie-app:latest .
          docker tag movie-app:latest $DOCKER_IMAGE:$DOCKER_TAG
        '''
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-c', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $DOCKER_IMAGE:$DOCKER_TAG
            docker logout
          '''
        }
      }
    }

    stage('Deploy on EC2') {
      steps {
        sshagent(['ec2-deploy-key']) {
          sh '''
ssh -o StrictHostKeyChecking=no ubuntu@34.230.42.38 <<EOF
docker stop movie-app || true
docker rm movie-app || true
PID=$(lsof -t -i:8083) && [ -n "$PID" ] && kill -9 $PID || true
docker run -d -p 8083:8083 --name movie-app suneel00/movie-app:v1
EOF
          '''
        }
      }
    }

  }
}