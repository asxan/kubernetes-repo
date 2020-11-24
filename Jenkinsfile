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
        stage('Build')
        {
            steps
            {
                script
                {
                    echo "----------Build stage---------"
                    cp -r  pythonapp/BoozeShop/Store/.  build/
                    cd  build/  
                    docker.build("${env.IMAGE_N}:${env.BUILD_NUMBER}", "-f --no-cache Dockerfile-Python . ")
                    rm -rf .idea/ BoozeStore/ requirements.txt
                }
            }
            post
            {
                success
                {
                    echo "Successfull"
                }
            }
        }

    }
}
