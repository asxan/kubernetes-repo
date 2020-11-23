pipeline 
{
    agent {label '!master'}

    stages 
    {
        stage('Clone project')
        {
            steps
            {
                sh(script: """echo "-------Clone project ---------" """)
                git url:'https://github.com/asxan/kubernetes-repo.git', branch:'boozshop'
                sh(script: """ 
                mkdir pythonapp 
                mv BoozeShop pythonapp/
                ls -la pythonapp/BoozeShop/
                """)
            }
        }       
    }
}
