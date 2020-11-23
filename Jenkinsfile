pipeline 
{
    agent {label '!master'}

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
                git url: 'https://github.com/asxan/kubernetes-repo.git', branch:''
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
