pipeline 
{  
    parameters 
    {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev-ns', 'prod-ns'],
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
        kubernetes {
            label 'kubernetes'
            defaultContainer 'jenkins-slave'
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: helm
    image: o1egr/helm
    imagePullPolicy: Always
    command:
        - cat
    tty: true
'''
        }
    }

    stages 
    {
        stage('Clone project')
        {
            steps
            {
                echo "------------------------Clone master--------------------------"
                git credentialsId: 'github-jenkinskey', branch:'master', url:'git@github.com:asxan/kubernetes-repo.git'
                sh(script: ''' ls -la
                rm -rf pythonapp 
                mkdir pythonapp 
                mv BoozeShop pythonapp/ 
                ''')

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
                dir('build')
                {
                    script
                    {    
                        sh '''ls -lsa '''
                        dockerImage = docker.build(tagRegistry + ":${env.BUILD_ID}", "-f  Dockerfile-Python --no-cache .")   
                    }
                }
                
            }
            post
            {
                success
                {
                    dir('build')
                    {
                        echo "Successfull"
                        sh(script: """rm -rf .idea/ BoozeStore/ requirements.txt""")
                    }
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
        stage('Deploy to cluster')
        {  

            steps
            {
                container('helm')
                {
                    sh '''
                    ls -la
                    '''

                    script
                    {
                        echo "---------------Deploy------------------"
                        //kubernetesDeploy(configs: "myweb.yaml",  kubeconfigId: "Newcubernetesconfig")
                
                        if (params.ENVIRONMENT == 'dev-ns')
                        {
                            sh "helm upgrade --install --namespace ${ENVIRONMENT} ${ENVIRONMENT}-boozeshop app_manifest_chart/ --set namespace=${ENVIRONMENT},replicas=1,deployment.tag=${env.BUILD_ID}"
                        }
                        else if (params.ENVIRONMENT == 'prod-ns')
                        {
                            sh "helm upgrade --install --namespace ${ENVIRONMENT} ${ENVIRONMENT}-boozeshop app_manifest_chart/ --set namespace=${ENVIRONMENT},replicas=3,deployment.tag=${env.BUILD_ID}"
                        }
                    }
                }
            }
        }
    }
}
