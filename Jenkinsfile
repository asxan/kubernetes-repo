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
                sh(script: """echo "----------Build stage---------" 
                cp -r  pythonapp/BoozeShop/Store/.  $PWD/build/
                cd  build/ 
                """)
                docker.build "$IMAGE_N" + ":$BUILD_NUMBER", "-f --no-cache Dockerfile-Python . "
                
                //sh(script: """rm -rf .idea/ BoozeStore/ requirements.txt""")
                
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
