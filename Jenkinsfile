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

    environment
    {
        tagRegistry = "asxan/${env.IMAGE_N}"
        regCredentials = 'dockerhublogin'
        dockerImage =''
    }

    options
    {
        timeout(time: "${BUILD_TIMEOUT}", unit: 'MINUTES')
    }

    agent 
    {
        podTemplate(yaml: """
        apiVersion: v1
        kind: Pod
        metadata:
            name: jenkins-agent
        spec:
            containers:
            - name: kaniko
              image: gcr.io/kaniko-project/executor:latest
              imagePullPolicy: Always
              workDir:/home/jenkins
              command:
              - /busybox/pwd
              tty: true
              restartPolicy: Never
              resources:
                requests:
                    memory: "256Mi"
                    cpu: "100m"
                limits:
                    memory: "256Mi"
                    cpu: "100m"
            """)
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
        stage('Clone manifest')
        {
            steps
            {
                git url: 'https://github.com/asxan/kubernetes-repo.git', branch:'app_manifest'
            }
        }
        stage('Deploy to cluster')
        {
            steps
            {
                script
                {
                    echo "---------------Deploy------------------"
                    //kubernetesDeploy(configs: "myweb.yaml",  kubeconfigId: "Newcubernetesconfig")
               
                    if (params.ENVIRONMENT == 'dev')
                    {
                        echo "Dev env"
                    }
                    else if (params.ENVIRONMENT == 'prod')
                    {
                        echo "Prod env"
                    
                    }
                }
            }
        }
    }
}