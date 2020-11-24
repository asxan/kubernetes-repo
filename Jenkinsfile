pipeline 
{
    agent {label '!master'}

    environment
    {
        PASS =credentials('password')
        dockerImage = ''
    }
    stages 
    {
        stage('Clone project')
        {
            steps
            {
                sh(script: """echo "-------Clone project boozeshop---------" """)
                git url:'https://github.com/asxan/kubernetes-repo.git', branch:'boozshop'
                sh(script: """ mkdir pythonapp && mv BoozeShop pythonapp/ """)
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
                cp -r  pythonapp/BoozeShop/Store/.  build/
                """)
            }
            post
            {
                success
                {
                    echo "Successfull"
                    sh '''cd  build/ '''
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
                    docker.build("${env.IMAGE_N}:${env.BUILD_NUMBER}", "-f --no-cache Dockerfile-Python . ")   
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

    }
}
