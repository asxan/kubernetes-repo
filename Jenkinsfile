pipeline 
{
    parameters 
    {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'prod'],
            description: 'Choice environment variable ENV'
        )
    }
    agent {label 'master'}
//     {  
//         kubernetes
//         { 
//             yaml '''
// apiVersion: v1
// kind: Pod
// metadata:
//     labels:
//         job: build-service
//     name: build-service
// spec:
//   securityContext:
//     runAsUser: 1000
//     runAsGroup: 1000
//     fsGroup: 1000 
//   containers:
//   - name: jenkins-pode
//     image: docker:18.09.2  //  jenkins/jnlp-slave:latest
//     imagePullPolicy: Always
//     command: ["/bin/sh"]
//     args: ["${computer.jnlpmac} ${computer.name}"]
//     tty: true
//     volumeMounts:
//     - name: docker-sock
//       mountPath: /var/run/docker.sock
//   volumes:
//   - name: docker-sock
//     hostPath:
//       path: /var/run/docker.sock     
// '''
//         }
//     }


    environment
    {
        tagRegistry = "asxan/${env.IMAGE_N}"
        regCredentials = 'dockerhublogin'
        dockerImage =''
    }
    stages 
    {
        stage('Clone project')
        {
            steps
            {
                sh(script: """echo "-------Clone project boozeshop---------" """)
                git url:'https://github.com/asxan/kubernetes-repo.git', branch:'boozshop'
                sh(script: ''' rm -rf pythonapp
                mkdir pythonapp 
                mv BoozeShop pythonapp/ 
                ''')
                echo "---------------------Clone build scripts------------------------"
                git url: 'https://github.com/asxan/kubernetes-repo.git', branch:'build_scripts'
            }
            post
            {
                success
                {
                    echo "Successfull"
                }
            }
        }
        stage('Copy project')
        {
            steps
            {
                sh(script: """ echo "----------Build stage---------" 
                cp -rf  pythonapp/BoozeShop/Store/.  build/
                """)
            }
            post
            {
                success
                {
                    echo "Successfull"
                }
                failure
                {
                    echo "Failure"
                }
            }
        }
        stage('Build')
        {
            steps
            {
                script
                {    
                    dockerImage = docker.build(tagRegistry + ":${env.BUILD_ID}", "-f  build/Dockerfile-Python --no-cache .")   
                }
            }
            post
            {
                success
                {
                    echo "Successfull"
                    sh(script: """rm -rf .idea/ BoozeStore/ requirements.txt""")
                }
                failure
                {
                    echo "Failure"
                }
            }
        }
        stage('Push')
        {
            steps
            {
                script
                {
                    docker.withRegistry('', "${env.regCredentials}")
                    {
                        //dockerImage.Push()
                        dockerImage.push("latest")
                        dockerImage.push("${env.BUILD_ID}")
                    }
                }
            }
        }
        stage('Delete image')
        {
            // Remove unused docker image
            steps
            {
                sh "docker rmi $tagRegistry:$BUILD_ID"
            }
        }
        stage('Deploy to cluster')
        {
            steps
            {
                script
                {
                    echo "---------------Deploy------------------"
                }
            }
        }
    }
}