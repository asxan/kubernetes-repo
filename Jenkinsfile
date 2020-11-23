pipeline 
{
    agent {label '!master'}

    stages 
    {
        stage('Clone project')
        {
            steps
            {
                sh(script: """
                mkdir pythonapp
                cd pythonapp  
                """)
                git url:'https://github.com/asxan/kubernetes-repo.git', branch:'boozshop'
                sh(script: """ 
                ls -la
                cd ..
                pwd """)
            }
        }       
    }
}
